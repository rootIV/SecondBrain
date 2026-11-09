---
tags:
  - project/aika-og
  - verification
  - reverse-engineering
updated: 2026-10-14
---
# Aika OG - Sistemas Nativos 2026-10-14

Relacionado: [[Aika OG - MOC]], [[Aika OG - NPC Skills Patrulha 2026-10-13]], [[Aika OG - NPC Titulos e Menus 2026-10-10]], [[Knowledge Debt]].

Fonte da verdade: [relatório e roteiro](C:/Projetcts/aika-og/docs/operations/NATIVE-SYSTEMS-2026-10-14.md). Migração `20261013_native_systems.sql` aplicada em `aikaria`, runtimes atualizados e bootstrap confirmado, após backup SQL/binários em `artifacts/native-systems/activation-20261014-003042`. Extensão registrada em `catalog_extensions`, não na tabela mencionada pelo texto genérico do CLI.

Coletor agora ignora movimento de mobs, preserva aparições/atributos/mapa/status e arquiva rotas antigas. TCP bruto continua evidência; não inferir spawn/patrulha oficial de uma posição observada.

Títulos usam Type+Index nativos como chave de evento, Goal numérico e tier possuído. Category é UI. Login inclui lista/seleção e aparência508 com título504/tier505; Pran/NPC têm outros offsets no mesmo tamanho. Seleção aguarda persistência; contadores têm recibo idempotente. Casts/requisitos diretos integrados, DG/quest/PvP têm hooks sem fingir sistemas já existentes.

Cash e armazenamento usam transação conjunta itens+saldo, locks conta→personagem, publicação após commit e reconciliação por recibo. Resultado incerto bloqueia mutações. Produto cash usa rowPI e composição congelada. Temporários rejeitados antes do débito até ciclo de ativação/expiração. Guild exige vínculo SQL/permissão e lease exclusiva2min; não confiar em GuildIndex do personagem.

Pran: duas por conta, item de vínculo com dono, nome/XP/comida/equipamento/inventário, aparição/follow e hooks de evolução. Skills são100bits unários (10famílias×10níveis); não reutilizar índice^4 legado. 0x9071280,0x96B16 com personalidade13/comida14/devoção15;BYTE12 desconhecido. Login6380 preservado. Quests, recusa por fome e algumas passivas ainda não completas.

ItemEffect68/IDDWORD64 e EFDesc96 corrigidos. Controles, resistências, DOT/HOT, anticura compartilhada e dano físico/mágico ampliados. Choque151 é bônus de dano; congelamento235 é bloqueio de movimento. PvP ofensivo, escudos genéricos e ações especiais permanecem lacunas.

Verificado:625testesGameServer aprovados/1ignorado,103Studio aprovados; cinco SQLStudio bloqueados pela manutenção após iniciarGameServer. Antes da ativação cincoSQLnativos/noveSQLesquema-economia passaram. DoisPython, UI de painéis conferida sem erroJS; buildsapps limpos, solução34warningsxUnit existentes. Revisão local corrigiu achados; segunda passagem parcial por limite. Operador vai testar gameplay; equivalência de cada skill não comprovada.
