---
tags:
  - project/aika-og
  - service
  - world-data
  - mob
  - npc
updated: 2026-10-09
---

# Aika OG - WorldDataService

Relacionado: [[Aika OG - MobService]], [[Aika OG - NPC Spawn]]

`WorldDataService` publica o estado de mundo aplicado pelo catálogo. `GameCatalogBootstrapService` prioriza o MySQL não vazio; os arquivos de `Data` são fallback. Resolucao de caminho e parsing foram separados. Ver [[Aika OG - Auditoria Servidor Client 2026-10-09]].

## Origem Delphi

- Checkout/Data verificados em 2026-10-09: `C:\Projetcts\aika-og\Data`. Caminhos abaixo são referências históricas da implementação Delphi.
- Fallback historico Delphi: `C:\Users\Vitor\Documents\Projects\aika\Aika TheMu New\Bin\Data`.
- NPCs: `Data\NPCs\*.npc`, estrutura Delphi `TNPCFile`.
- Mobs comuns: `Data\Mobs\MonsterListCSV.csv` para instancias/posicoes e `Data\Mobs\AllMobsInfo.csv` para dados estaticos do template.
- Na base local validada em 2026-07-03, foram carregados 469 NPCs e 5622 instancias de mobs comuns.

## Comportamento C#

- `Program.cs` chama `GameCatalogBootstrapService.LoadAsync()` antes de iniciar os sockets. O catálogo é aplicado aos serviços; um MySQL não vazio tem precedência sobre os arquivos.
- `WorldDataPathResolver` resolve caminho:
  - caminho explicito recebido pelo loader.
  - `AIKA_WORLD_DATA`.
  - `Data` ao lado do executavel.
  - `Data` no diretorio atual.
  - `Data` na raiz da solution C#.
  - `GameServer\Data` no projeto.
  - fallback para o caminho Delphi local.
- `CatalogImportService.LoadFromFiles` carrega ItemList e os demais catálogos da raiz resolvida quando o bootstrap usa arquivos. Alterar Data isoladamente não atualiza um catálogo MySQL já importado.
- `NpcFileParser` le `Data\NPCs\*.npc`, extrai id pelo nome `[2048] Nome.npc` e carrega `TNPCHeader.Options[0..9]` do offset `36..45`.
- `NpcOptionTextService` carrega `Data\NPCOptionsText.bin` ou `Data\NPCs\NPCOptionsText.bin` para nomear as opcoes enviadas em `0x112`.
- `MobCsvParser` le `AllMobsInfo.csv` e `MonsterListCSV.csv`, mantendo templates e instancias separados.
- Se nenhum caminho existir, o servidor inicia com listas vazias e loga aviso.
- `WorldDataService.Npcs` alimenta `NpcService`.
- `WorldDataService.Mobs` alimenta `MobService.SendVisibleMobs`.
- Apos carregar mobs/NPCs, `WorldDataService.Load` chama `WorldEntitySpatialIndex.Rebuild` para preparar consultas por range sem scan global.
- Quando nenhum caminho existir, as listas ficam vazias e o indice espacial tambem e reconstruido vazio.

## Limites

- Esta etapa implementa carga, registro em memoria e spawn por visibilidade.
- Pathing avancado e skills complexas de mob ainda nao foram implementados.
- `MobPos.bin` nao foi usado nesta etapa; a source Delphi atual usa principalmente os CSVs para mobs comuns.
