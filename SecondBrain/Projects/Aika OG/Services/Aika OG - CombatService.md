---
tags:
  - project/aika-og
  - service
  - combat
updated: 2026-07-04
---

# Aika OG - CombatService

Relacionado: [[Aika OG - CharacterService]], [[Aika OG - MobService]], [[Aika OG - PacketDispatcher e Protocolo]]

## Responsabilidade

`CombatService` implementa combate PvE inicial: ataque basico de jogador contra mob usando entrada `0x302`, saida `0x102` e animacao `0x31F`. Em 2026-07-04 entrou o contra-ataque simples mob -> jogador, tambem usando `0x102`.

## Fluxo

1. `PacketDispatcher` roteia `0x302` para `CombatHandler.AttackTarget`.
2. `CombatPacketParser` le o layout Delphi `TSendAtkPacket`: alvo, 14 bytes nulos, animacao, skill e posicoes.
3. `CombatService` aceita `SkillId = 0` ou uma skill basica ativa do personagem, valida arma equipada, mob vivo/visivel e range inicial `35`.
4. `DamageCalculator` calcula dano fisico basico com ataque do personagem e defesa do mob.
5. `CombatPacketFactory` monta `TRecvDamagePacket` (`0x102`) e o handler envia ao cliente.
6. Se o mob sobreviver e a IA estiver em alcance, `MobAiService.AttackPlayer` calcula dano basico do mob contra o jogador.
7. Dano mob -> jogador envia `0x102` e tambem `0x1002` para efeito visual/numero vermelho quando necessario, depois atualiza HP/MP.

## Packet 0x102

- O layout segue `TRecvDamagePacket` Delphi: `SkillID`, `AttackerPos`, `AttackerID`, `Animation`, `AttackerHP`, `TargetID`, `DNType`, `MobAnimation`, `DANO`, `MobCurrHP`, `DeathPos`.
- Para dano player -> mob, `Header.Index` e `AttackerID` usam o client id/conexao do personagem, nao o id de banco do personagem.
- Para dano mob -> player, `Header.Index` e `AttackerID` usam `mob.ClientId`; `TargetID` usa o client id/conexao do personagem, nao o id de banco.
- Dano mob -> player segue a Delphi observada: `Animation = 6` e `MobAnimation = 26`.
- O client usa esses ids de protocolo junto de `DANO`, `DNType`, `MobAnimation` e `MobCurrHP` para associar e exibir o dano flutuante.
- Ataque basico e skill enviam primeiro a animacao `0x31F` e depois o dano `0x102`; essa ordem evita que o client receba dano sem o contexto visual correto.
- `0x1002` segue a referencia AikaEmu `UpdateWithSkillEffect` e e usado como complemento visual para dano recebido.

## Morte por mob

- `ReceivedDamageResult.TargetDied` indica que o HP chegou a zero.
- Na morte, o personagem fica temporariamente `IsAlive=false`, `IsActive=false`, fecha NPC/opcao aberta e limpa cooldowns runtime.
- O client pede revive com opcode `0x303`; o servidor usa local salvo (`savedPositionX/savedPositionY`) ou cidade padrao `3450,690`.
- Apos revive, o servidor envia teleporte `0x301`, refresh completo, reconstrucao de mobs/NPCs e salva o estado runtime.

## Estado de Mob

`MobEntity` agora possui estado runtime de combate:

- `CurrentHealth`;
- `IsDead`;
- `AttackerId`;
- `FirstAttackerId`.

`MobCsvParser` inicializa `CurrentHealth` com `InitialHealth`. Mobs mortos deixam de passar pelo filtro de visibilidade.

## Limites atuais

- `0x320` existe para skill PvE instantanea contra mob, reaproveitando o dano do combate.
- Retorno basico envia animacao, mas ainda nao teleporta.
- Sem PvP.
- Mob -> jogador ainda e ataque basico de IA, sem skills complexas de mob.
- Respawn de mob e drops diretos no inventario existem em v1; EXP por kill ainda nao esta completa.
- Sem buffs/debuffs, dungeons, party/guild/nation e regras especiais de cidade.
