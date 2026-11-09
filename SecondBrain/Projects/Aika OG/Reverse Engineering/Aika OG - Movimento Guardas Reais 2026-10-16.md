---
type: reverse-engineering
project: Aika OG
created: 2026-10-16
status: verified-with-gaps
---

# Movimento dos Guardas Reais — 16/10/2026

Relacionado: [[Aika OG - MOC]], [[Aika OG - Expansao Mundo 2026-10-15]], [[Aika OG - Referencias Externas AikaEmu e Delphi]].

Investigação somente leitura: 23 atores de guardas/166 segmentos no snapshot aplicado; 11 são Guardas Reais, em Regenshein (6748/6959), Verband (3420/3430/3429), Amarkand (3472/12718) e Sigmund (10748/10793/8164/6077). IDs são runtime capturados, não IDs SQL. Speed bruto 25, exceto 6077 com 65. Destinos revisitados tornam patrulha plausível, mas não provam ciclo completo nem causa do deslocamento. Não transformar aparições/envelope em waypoints.

Rafinha `Src/Threads/UpdateThreads.pas:3388–3579` tem detecção de inimigo, perseguição e retorno, sem patrulha ociosa nessa rotina. `Random(4)` escolhe vizinho do alvo. TheMu tem chamada comentada e mistura `DevirGuards`/`RoyalGuards`; não copiar. O coletor mantém movimentos NPC e continua descartando movimentos de mobs. Pacote de movimento não informa o estado de IA.

Sem alteração de IA, NPCs, mobs, cliente ou banco. Relatório com tabela, linhas, SHA-256 e recomendações: `C:/Projetcts/aika-og/docs/reverse-engineering/ROYAL-GUARD-MOVEMENT-2026-10-16.md`. Snapshot: `artifacts/world-expansion/2026-10-15/ready-final/capture-source.json` SHA-256 `553b3dda658f54ed2b2e55492af93e3344d27457bde7642c3f3b22fe521066f7`.

Pendente: captura contínua sem combate por dois ciclos e correlação de alvo/dano para distinguir patrulha, perseguição e retorno. Nenhuma confirmação via assembly nesta investigação.
