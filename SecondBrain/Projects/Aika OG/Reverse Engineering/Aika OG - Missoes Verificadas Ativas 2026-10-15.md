---
type: implementation
project: Aika OG
created: 2026-10-15
status: activated-gameplay-pending
---

# Missões verificadas ativas

Relacionado: [[Aika OG - MOC]], [[Aika OG - Expansao Mundo 2026-10-15]], [[Aika OG - Captura Paineis NPC 2026-10-15]], [[Knowledge Debt]].

- Captura nova confirmou IN e OUT para quests 1, 5 e 7; a terceira missão relatada é ID 7. Objetivos, pré-requisitos e recompensas coincidem com o quest.bin OG, SHA `a210b329c013e223f9311511f1ce0d05ed54c4cd31ef2887667683fe94e94e77`. Sem equivalência automática de todos os IDs BR/OG.
- 1: matar cinco Max, NameValue 1; recompensa 30 XP/30 gold, 3×4350 e 5×21107. 5: opção 12 do NPC 2054/NameValue 47 após entregar 1 e atingir nível 3; 150 XP/150 gold e 5×21107. 7: matar um Max Mutante, NameValue 183, após 5; 200 XP/600 gold e escolha de luva. Escolha é índice 0..5; captura [7,5] entrega item 2200.
- NameValue do objetivo difere de template_id local: 1→0 e 183→62. O gancho de morte usa NameValue, sem modificar IA, atributos ou spawns dos mobs.
- `Data/Quest/VerifiedQuests.json` habilita somente essas três missões. Catálogo legado continua consultável; outras missões, abandono, grupos de objetivos e recompensas especiais permanecem sem execução liberada.
- `character_quests` e `character_quest_events` instaladas por `Database.dll install-quests`, aditivas e idempotentes. Aceitar/progredir/entregar/reconectar persistem. Progresso de morte divide a transação/receipt do drop; itens, gold, XP e claimed dividem a transação de inventário. Não há sucesso antes do commit confirmado nem recompensa duplicada por replay.
- Revisão independente encontrou e corrigiu restauração indevida de HP/MP de snapshot antigo durante entrega. Testes injetam dano e morte antes de commit. Ganho de nível cura somente personagem real ainda vivo. Spawn e update de marcador usam o mesmo consumidor nativo FUN_005fad90, com estados 3/4 e disponibilidade 8/9 conforme tipo.
- Ativação concluída junto com o catálogo de mundo: GameServer e Studio publicados e iniciados; tabelas InnoDB conferidas; runtime vinculou as três quests ao NPC 2048. Verificação final: 755 testes GS, 108 Studio e 43 Python aprovados; 16 testes ignorados. Os 24 dedicados de quests/nativo passaram, inclusive SQL isolado e rollback.
- Backup de SQL/NPCs/binários em `C:/Projetcts/aika-og/artifacts/world-expansion/2026-10-15/backup-20261015-221854`. Rollback de binários deve conservar progresso/claimed/receipts/inventário; não apagar provas de entrega para tentar repetir recompensas.
- Referências e uso: `docs/operations/QUESTS-IMPLEMENTED-2026-10-15.md` e `WORLD-QUEST-ACTIVATION-2026-10-15.md`. Gameplay e renderização visual ainda pendentes. Graphify atualizado para os novos módulos.
