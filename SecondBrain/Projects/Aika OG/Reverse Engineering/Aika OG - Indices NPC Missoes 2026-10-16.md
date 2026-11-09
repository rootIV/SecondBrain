---
type: reverse-engineering
project: Aika OG
created: 2026-10-16
status: verified-with-gaps
---

# Índices de NPC de missões — 16/10/2026

Relacionado: [[Aika OG - MOC]], [[Aika OG - Missoes Verificadas Ativas 2026-10-15]], [[Aika OG - Referencias Externas AikaEmu e Delphi]].

O índice StartNPC/EndNPC de Quest não é NameValue/MN nem ID de conexão. Oficial `UI/npcpos.bin`: DWORD limite1018 e2048 registros de12bytes `<III` (NameValue, X inteiro, Y inteiro),505 preenchidos/426 nomes.209 de210 UnitData AikaEmu confirmam índice NpcIdX→nome NpcId. Exceção474/name2500 legado está zerada no oficial. Não usar offset linear: índice17→Name48; mesmo Name43 tem índice3/local2050 e34/local2081 em posições distintas.

Gerador `tools/build_quest_npc_bindings.py` escreve `Data/Quest/NpcQuestBindings.json` (461 índices confiáveis) e `artifacts/quest-npc-map/2026-10-16/mapping-audit.json` (todos505,44 sem correspondência e hashes). Nome+posição até1unidade é regra primária. Fallback exige identidade explícita UnitData índice/nome/clientId ou mesmo índice/nome com posição OG comprovada quando oficial mudou. Nunca ligar todos os NPCs com mesmo nome. Seis testes passaram.

OG e BR npcpos diferem em16 registros:13 novos e3 posições. Dois NPCs locais preservam posição OG: índice175/name847/local2210 e248/name2016/local2280; binding `SourceOGNpcPosIdentity`. Recomendar manter essas coordenadas locais ao preparar npcpos do cliente de teste para o guia não apontar ao lugar errado. Nenhum cliente/banco foi modificado por esta investigação.

Detalhes, tabela e fontes: `C:/Projetcts/aika-og/docs/reverse-engineering/QUEST-NPC-INDEX-MAPPING-2026-10-16.md`. Fontes oficiais SHA256 `51b01c39866ceb386135f79748bd63307834139313712912d03f0d1b92543ec0`, OG `1aa087dae39b4f5ad40e2051c015694d71f1f42979e13f96bd4d2f0cd03da13b`.
