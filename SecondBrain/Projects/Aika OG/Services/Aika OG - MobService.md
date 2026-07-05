---
tags:
  - project/aika-og
  - service
  - mob
updated: 2026-07-04
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
- `DropDataService` / `MobDropService`: carrega `Data/Drops` e entrega drop direto no inventario do killer nesta etapa.
- `Create131Packet`: monta pacote `0x131` com dois `DWORD` de payload, `0xFFFFFFFF` e `0x00000000`.
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
- Patrulha usa os campos Delphi ja carregados de `MonsterListCSV.csv`: `InitialMoveWait`, `DestinationMoveWait`, posicao inicial/destino e `MoveSpeed`.
- Mobs estaticos/boss-like nao patrulham quando destino real e igual ao spawn, quando `IsMutant`, quando `IsService`, ou quando nao existe rota valida.
- Ao perder alvo, morrer alvo, sair da area de perseguicao ou afastar demais do spawn, o mob limpa threat, volta ao spawn e restaura `CurrentHealth = InitialHealth`.
- Proximidade so cria threat automaticamente para mobs hostis (`MobType > 1024`) e nao cria para `IsService`, `IsMutant` ou `MobType = 1024`. Mobs passivos ainda atacam normalmente depois que recebem threat explicito por dano.

## Pontos de cuidado

- Muitos campos ainda sao `Unk` e devem ser tratados como contrato observado.
- Alterar ordem ou tamanho dos blocos de buff/title pode quebrar renderizacao do cliente.
- `MobService` deve continuar apenas como facade enquanto chamadas antigas ainda existirem.
- IA v1 nao implementa pathfinding avancado, skills complexas de mob, party loot, dungeon loot rules completas nem coleta visual de item no chao.
- Aggro segue a decisao inspirada no Nevers Aika: proximidade inicia ameaca baixa, dano aumenta ameaca, cura futura deve usar somente HP realmente recuperado, ameaca decai com tempo e o mob reseta ao sair da area de perseguicao.
