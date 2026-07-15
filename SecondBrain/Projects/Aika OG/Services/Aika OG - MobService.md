---
tags:
  - project/aika-og
  - service
  - mob
updated: 2026-07-11
---

# Aika OG - MobService

Relacionado: [[Aika OG - CharacterService]], [[Aika OG - SessionManager]], [[Aika OG - WorldDataService]]

Arquivo: `GameServer/Application/Services/MobService.cs`

## Responsabilidade

`MobService` agora e uma facade de compatibilidade. Montagem de packets, visibilidade e spawn debug foram separados.

## Funcoes importantes

- `MobPacketFactory`: monta `0x349`, `0x35E`, `0x101` e `0x301`.
- `MobVisibilityService`: sincroniza mobs carregados por range usando `VisibleMobs`.
- `MobDebugSpawnService`: mantem o spawn manual/debug usado por comando.
- `MobAiService`: tick PvE basico para patrulha com wait/jitter, aggro, perseguicao, ataque, retorno/reset com cura, morte e respawn.
- `MobThreatService`: mantem ameaca por mob; dano soma threat, proximidade acorda o mob, threat decai e o alvo e o maior threat vivo.
- `WorldEntitySpatialIndex`: indice espacial de mobs/NPCs por celula; `MobVisibilityService` usa o indice para buscar mobs proximos e remover stale ids sem scan global.
- `DropDataService` / `MobDropService`: carrega `Data/Drops` e entrega drop direto no inventario do killer nesta etapa.
- NPCs de servico ficam em `NpcService`, com `NpcPacketFactory` e `NpcVisibilityService`.

## Dependencias

- `CharacterEntity`
- `MobEntity`
- `WorldDataService`
- `ItemTemplateService`
- `ItemPacketWriter`
- `PacketFactory`, `PacketPool`, `PacketStream`
- `EncDec.Encrypt`

## Invariantes

- `CreateCharacterMobPacket` usa nome com 16 bytes ASCII e equips de lobby.
- Buffs e buff timers ainda sao escritos como zeros.
- `CreateSpawnMobPacket` usa `mob.ClientId` quando carregado do mundo; para mobs manuais antigos ainda cai em `mob.Index + 3048`.
- A morte de mob continua usando `0x102` com `MobAnimation = 30`.
- Drops v1 nao criam item no chao; entram direto no inventario desbloqueado do atacante/killer.
- Drops usam um roll global de 20% por kill antes de avaliar candidatos; se falhar, a kill nao dropa item e ainda concede XP.
- Drops `.txt` usam chance padrao de 15%; CSV respeita a coluna de chance. Depois do roll global, cada entrada faz roll independente.
- O drop por kill e limitado a no maximo 2 itens, entregues direto no inventario desbloqueado do killer. O segundo drop exige um roll extra raro de 10%.
- O anuncio de drop deve ser `Adquiriu "Nome do Item"`, sem prefixo de quantidade, mesmo quando o item vem com stack/refine maior que 1. O nome e normalizado para ASCII porque o client nao lida bem com acentos/caracteres especiais.
- XP por kill tem minimo de 1 quando o mob nao tem `ExpReward` explicito ou quando a diferenca de level e grande (`<= -8` ou `>= 6`).
- Patrulha usa os campos Delphi ja carregados de `MonsterListCSV.csv`: `InitialMoveWait`, `DestinationMoveWait`, posicao inicial/destino e `MoveSpeed`.
- `InitialMoveWait` e `DestinationMoveWait` se aplicam somente a patrulha idle. Em `Returning`, o mob anda continuamente a cada tick de 500 ms, ignora threat de proximidade e usa `MoveSpeed` configurado no packet de retorno.
- Mobs melee usam speed 70 apenas durante perseguicao/agro; patrulha continua com a velocidade configurada. Se a corrida coloca o mob dentro do range de ataque no mesmo tick, ele ataca imediatamente respeitando cooldown.
- Mobs melee hostis entram em threat por proximidade no raio Delphi `<= 8`, desde que nao sejam service, mutant, static/boss-like ou nome contendo `Max`. Esse lure nao propaga chain aggro para mobs fora do proprio raio.
- Cooldown basico de ataque melee esta mais curto que ranged/magic (`~1.2s`) para manter pancadas constantes apos aproximar; ranged/magic preserva o cooldown padrao atual.
- Mobs estaticos/boss-like nao patrulham quando destino real e igual ao spawn, quando `IsMutant`, quando `IsService`, ou quando nao existe rota valida.
- Ao perder alvo, morrer alvo, sair da area de perseguicao ou afastar demais do spawn, o mob limpa threat, volta ao spawn e restaura `CurrentHealth = InitialHealth`.
- Proximidade so cria threat automaticamente para mobs hostis (`MobType > 1024`) e nao cria para `IsService`, `IsMutant` ou `MobType = 1024`. Mobs passivos ainda atacam normalmente depois que recebem threat explicito por dano.
- AI de mobs usa batch round-robin quando ha muitos mobs ativos, evitando `OrderBy(Random)` por tick.
- O loop de AI busca candidatos por `WorldGrid` ao redor do mob e preserva alvos ja presentes na threat table via indice de sessao.
- Quando mob move, reseta ou respawna, `WorldEntitySpatialIndex.UpsertMob` precisa ser chamado para manter visibilidade correta.
- Movimento/dano/spawn de mob reutilizam pacote `byte[]` quando o payload e identico para multiplos destinatarios.
- `MobThreatService` agora suporta alvo forcado com expiracao para Incitar Multidao/Travar Alvo. O alvo forcado vence threat numerica enquanto valido e cai para threat normal ao expirar, morrer ou sair da party/sessao relevante.
- Root em mob impede movimento e retorno, mas nao impede ataque se o alvo ja esta dentro do range. Stun continua bloqueando movimento e ataque.
- A Atracao Divina reposiciona mob valido para 1.5m do caster, chama `WorldEntitySpatialIndex.UpsertMob` e aplica root por 3s. Service/static/mutant/dead nao devem ser puxados.

## Pontos de cuidado

- Muitos campos ainda sao `Unk` e devem ser tratados como contrato observado.
- Alterar ordem ou tamanho dos blocos de buff/title pode quebrar renderizacao do cliente.
- `MobService` deve continuar apenas como facade enquanto chamadas antigas ainda existirem.
- IA v1 nao implementa pathfinding avancado, skills complexas de mob, party loot, dungeon loot rules completas nem coleta visual de item no chao.
- Aggro segue a decisao inspirada no Nevers Aika: proximidade inicia ameaca baixa, dano aumenta ameaca, cura futura deve usar somente HP realmente recuperado, ameaca decai com tempo e o mob reseta ao sair da area de perseguicao.
- Evitar scans de `SessionManager.GetAllSessions` dentro de AI/visibilidade/broadcast; usar `WorldGrid`, `WorldEntitySpatialIndex` e `GetSessionByCharId`.
