---
type: implementation
project: Aika OG
updated: 2026-10-17
status: active-awaiting-gameplay
---

# Patrulhas e símbolos de NPC — 17/10/2026

Relacionado: [[Aika OG - MOC]], [[Aika OG - Movimento Guardas Reais 2026-10-16]], [[Aika OG - Abandono Missoes 2026-10-17]].

Studio NPCs ganhou Posição e patrulha, com origem/destino, velocidade e espera em cada ponta. Tabela npc_patrols aditiva, uma configuração por NPC; nenhuma patrulha ativada automaticamente. Ida e volta em linha reta, sem pathfinding/combate novo. Estado espacial acompanha célula e envia spawn antes de movimento0x301. Operador define os poucos guardas desejados.

GlobalDefs Rafinha define verde2, vermelho8, azul9, amarelo11. Antes o Studio trocava verde/azul. Byte93 do spawn349 é marcador;5 é salvar localização (FUN_005fad90, efeito24). Byte92 não substitui93. Enviar10D após349 e fim do login restaura estado alterado pela inicialização cliente; refresh por10D não recria NPCs. Pronta4 precede disponíveis8>2>11>9, depois andamento3, save5, neutro1. Efeito50 BR preservado como outro canal.10D exige ator carregado; ícones globais fora da área não foram demonstrados por esse pacote.

Alcance visual50 da referência, sem alterar aggro/combate. Abandono032F transacional e log de conclusão pós-commit com nome/ID/NPC.780 testes GameServer e119Studio passaram. Teste SQL de patrulha aprovado em clone, incluindo migração repetida/rollback/stale/default25. Versão ativada, APIs/hashes verificados; tabela de patrulhas vazia e nenhuma rota automaticamente definida. Backup em artifacts/npc-world-20261017/backup-20261017-011715. Gameplay ainda pendente do operador.

Relatório: `C:/Projetcts/aika-og/docs/operations/NPC-PATROLS-2026-10-17.md`. Revisão achou speed_move0 em56NPCs; sugestão de patrulha corrigida para25, sem mudar velocidade persistida do NPC.
