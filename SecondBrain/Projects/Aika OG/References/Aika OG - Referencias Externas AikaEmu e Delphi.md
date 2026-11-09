---
tags:
  - project/aika-og
  - references
  - graphify
updated: 2026-11-03
---

# Aika OG - Referencias Externas AikaEmu e Delphi

## Referências atuais de combate e IA — 2026-11-03

- Nova: `D:\aika\AIKA Source` (`AikaServer.dpr`, 49 unidades explícitas, 58 fontes PAS em Src). BaseMob/MOB/Player/threads/handlers e dados StatusPoint investigados, sem executar o fork.
- Raízes atuais comparadas: `D:\aika\Aika Lore Community\Server`, `D:\aika\Aika Rafinha Server`, `D:\aika\Aika TheMu New`, `D:\aika\AikaEmu-master\src\AikaEmu.GameServer`; projeto atual `C:\Projetcts\aika-og`. Os caminhos Vitor abaixo são históricos, não a raiz atual.
- [[Aika OG - IA Combate e Niveis Referencias 2026-11-03]]: comparação com funções/linhas e hashes; sem multiplicador direto de delta de nível no impacto atual, efeitos indiretos por progressão, influência separada no controle/XP, IA e fórmulas próprias dos forks.
- Não adicionar automaticamente um perfil de runtime com a nova source: cadastro de referência técnica não equivale a importação de catálogos, alteração de fórmula ou ativação de gameplay.

## Criterio de uso das referencias

- Aplicar [[Preferencias de Engenharia e Reverse Engineering]]: referencias ajudam a investigar contratos e formatos, mas cada implementacao precisa de avaliacao critica de corretude, algoritmos, desempenho, seguranca e manutencao.
- Preferir uma solucao melhor quando houver justificativa tecnica; nao portar automaticamente hardcodes, TODOs ou estruturas ineficientes. Preservar layouts/opcodes/criptografia comprovados e validar alteracoes com o cliente conforme [[Aika OG - MOC]].

## Graphify

- Delphi `Aika TheMu New`: `C:\Users\Vitor\Documents\Projects\aika\Aika TheMu New\graphify-out\graph.json`
- Delphi Aika Rafinha Server: `C:\Users\Vitor\Documents\Projects\aika\Aika Rafinha Server\graphify-out\graph.json`
- AikaEmu: `C:\Users\Vitor\Documents\Projects\aika\AikaEmu-master\graphify-out\graph.json`
- GM Tool Delphi: `C:\Users\Vitor\Documents\Projects\aika\Tools\GM Tool\graphify-out\graph.json`
- MasterEditor Delphi: `C:\Users\Vitor\Documents\Projects\aika\Tools\MasterEditor\graphify-out\graph.json`
- Global Graphify: `C:\Users\Vitor\.graphify\global-graph.json`
- Tags globais registradas:
  - `Aika TheMu New Delphi`
  - `AikaEmu-master`

## GM Tool Delphi

- Projeto pequeno, mas util para packet/protocolo e memoria do client.
- Hubs do graphify:
  - `TFunctions`: envio/recebimento de packet, helpers de target/self, move speed, zoom e comandos GM.
  - `PacketsGM.pas`: records de packets GM e estruturas como `TPacketHeader`, `TSpawnMobPacket`, `TClientMessagePacket`, `TSendGoldAddRemove`.
  - `GMTOOL.dpr`: hook de `send/recv` (`n_send`, `n_recv`) e injecao/hook via `AfxCodeHook`.
- Pontos uteis para portar/comparar:
  - `TSpawnMobPacket` do GM Tool documenta um layout Delphi de spawn mob `0x35E` com equips, posicao, HP/MP, level, service flag, effects, spawn type, size/body e mob type.
  - `TFunctions.SetMoveSpeed` e enderecos como `ADDR_SPEEDMOVE` servem como referencia auxiliar para investigar speed visual no client.
  - `TFunctions.SendAddBuff/SendRemoveBuff/SendZeroAllBuff` podem ajudar a confirmar comandos/opcodes GM de buff se o GameServer precisar de ferramentas administrativas.

## MasterEditor Delphi

- Continua sendo a fonte principal para estruturas de arquivos estaticos (`ItemList.bin`, `SkillData.bin`, `Title.bin`, `SetItem.bin`, `Conjunts.bin`) e criptografia de arquivos.
- Hubs do graphify:
  - `TFunctions`: loaders/savers de arquivos, `GetSkillIndex`, `GetSkillIndexOnBar`, criacao de personagem basico, crypto Key1/Key2.
  - `FilesData.pas`: records Delphi dos dados estaticos e do `TCharacter`.
  - `MainForm`: UI de edicao das abas de item, skill, titulos e demais dados.
- Pontos uteis ja confirmados:
  - `TSkillsList` mantem `Basics[0..5]` e `Others[0..39]` como pares `Index/Level`.
  - `TStatus` confirma ordem de atributos, HP/MP, SkillPoint, dano/defesa, critico, esquiva e acerto no bloco de personagem.
  - `TItem` confirma layout de item completo: `Index`, `APP`, identificacao, 3 efeitos, `MIN/MAX`, `Refi`, `Time`.
  - `TFunctions.GetSkillIndexOnBar(SkillIndex) = (SkillIndex * 16) + 2`.
  - Crypto de arquivos usa Key1/Key2 com soma/subtracao byte-a-byte por `key[i % keyLen] + i`.

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
