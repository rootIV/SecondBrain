---
tags:
  - project/aika-og
  - references
  - graphify
updated: 2026-07-04
---

# Aika OG - Referencias Externas AikaEmu e Delphi

## Graphify

- Delphi `Aika TheMu New`: `C:\Users\Vitor\Documents\Projects\aika\Aika TheMu New\graphify-out\graph.json`
- AikaEmu: `C:\Users\Vitor\Documents\Projects\aika\AikaEmu-master\graphify-out\graph.json`
- Global Graphify: `C:\Users\Vitor\.graphify\global-graph.json`
- Tags globais registradas:
  - `Aika TheMu New Delphi`
  - `AikaEmu-master`

## AikaEmu - pacotes relevantes

- Opcodes em `src\AikaEmu.GameServer\Network\GameOpcode.cs`:
  - `SendToWorld = 0x1825`
  - `UpdateExperience = 0x1008`
  - `UpdateAttributes = 0x1009`
  - `UpdateStatus = 0x100A`
  - `UpdateHpMp = 0x1003`
  - `UpdatePosition = 0x30BF`
  - `UpdateWithSkillEffect = 0x1002`
- O login em `RequestToken.cs` envia `SendToWorld(character)`, depois `UpdateStatus()`, `UpdateAttributes(character)` e `UpdateExperience(character)`. Mais adiante tambem reenvia `UpdateHpMp`, `UpdateAttributes`, `UpdateHpMp` e `UpdateStatus`.
- `UpdateExperience.cs` escreve: `Level`, dois bytes `CC`, `Experience` como `ulong`, `ushort 1`, seis bytes `CC` e `long 0`.
- `UpdateStatus.cs` usa valores hardcoded, mas confirma a posicao do campo de velocidade no refresh de status: apos dano/defesa/paddings, escreve `ushort 70` como move speed.
- `UpdatePosition.cs` tambem tem speed separado no pacote de movimento: construtor default `byte speed = 50`, e no payload escreve `state` seguido de `_speed`. Teleporte usa state `1`; movimento usa state `0`.
- `SendToWorld.cs` escreve `Experience` dentro do personagem e escreve `Skills.WriteSkills()` + `SkillsBar.WriteSkillsBar()` no bloco final. A implementacao tem varios TODOs/hardcodes, entao e referencia auxiliar, nao fonte final de layout.
- `UpdateWithSkillEffect.cs` e uma referencia util para dano visual: opcode `0x1002`, sender = connection id, escreve skill, posicao, attacker id, target id, tipo de dano, animacao, dano e HP restante.

## Pontos para aplicar no GameServer C#

- Ao investigar XP/status no cliente, comparar o fluxo de login com AikaEmu: `0x925`, depois refreshes `0x10A`, `0x109`, `0x108` e HP/MP.
- Se a velocidade ficar travada em `40`, conferir dois lugares:
  - `CharacterStatusService.SpeedMove` e serializacao em `CreateSendStatusPacket` (`0x10A`);
  - pacote de movimento/teleporte (`0x301` no servidor atual), que tambem carrega velocidade/estado para outros clientes.
- Para dano flutuante, verificar se o packet usado pelo client espera o formato equivalente ao `UpdateWithSkillEffect` (`0x1002` no AikaEmu) alem do `0x102` Delphi ja portado.

