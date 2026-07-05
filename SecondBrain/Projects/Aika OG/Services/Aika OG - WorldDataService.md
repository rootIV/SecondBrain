---
tags:
  - project/aika-og
  - service
  - world-data
  - mob
  - npc
updated: 2026-07-03
---

# Aika OG - WorldDataService

Relacionado: [[Aika OG - MobService]], [[Aika OG - NPC Spawn]]

`WorldDataService` publica o estado carregado de dados de mundo vindos da pasta `Data`. Resolucao de caminho e parsing foram separados.

## Origem Delphi

- Caminho principal atual: `C:\Users\Vitor\Documents\Projects\aika_og\Data`.
- Fallback historico Delphi: `C:\Users\Vitor\Documents\Projects\aika\Aika TheMu New\Bin\Data`.
- NPCs: `Data\NPCs\*.npc`, estrutura Delphi `TNPCFile`.
- Mobs comuns: `Data\Mobs\MonsterListCSV.csv` para instancias/posicoes e `Data\Mobs\AllMobsInfo.csv` para dados estaticos do template.
- Na base local validada em 2026-07-03, foram carregados 469 NPCs e 5622 instancias de mobs comuns.

## Comportamento C#

- `Program.cs` chama `WorldDataService.Load()` antes de iniciar os sockets.
- `WorldDataPathResolver` resolve caminho:
  - caminho explicito recebido pelo loader.
  - `AIKA_WORLD_DATA`.
  - `Data` ao lado do executavel.
  - `Data` no diretorio atual.
  - `Data` na raiz da solution C#.
  - `GameServer\Data` no projeto.
  - fallback para o caminho Delphi local.
- `Program.cs` tambem chama `ItemTemplateService.Load(WorldDataService.LoadedDataPath)` para carregar `ItemList.bin` da mesma raiz de dados.
- `NpcFileParser` le `Data\NPCs\*.npc`, extrai id pelo nome `[2048] Nome.npc` e carrega `TNPCHeader.Options[0..9]` do offset `36..45`.
- `NpcOptionTextService` carrega `Data\NPCOptionsText.bin` ou `Data\NPCs\NPCOptionsText.bin` para nomear as opcoes enviadas em `0x112`.
- `MobCsvParser` le `AllMobsInfo.csv` e `MonsterListCSV.csv`, mantendo templates e instancias separados.
- Se nenhum caminho existir, o servidor inicia com listas vazias e loga aviso.
- `WorldDataService.Npcs` alimenta `NpcService`.
- `WorldDataService.Mobs` alimenta `MobService.SendVisibleMobs`.

## Limites

- Esta etapa implementa carga, registro em memoria e spawn por visibilidade.
- IA de mobs, ataque, pathing e respawn completo ainda nao foram implementados.
- `MobPos.bin` nao foi usado nesta etapa; a source Delphi atual usa principalmente os CSVs para mobs comuns.
