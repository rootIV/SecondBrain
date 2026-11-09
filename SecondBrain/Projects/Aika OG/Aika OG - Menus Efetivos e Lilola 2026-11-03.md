---
tags:
  - project/aika-og
  - npc
  - studio
updated: 2026-11-03
---

# Aika OG - Menus Efetivos e Lilola 2026-11-03

Relacionadas: [[Aika OG - MOC]], [[Aika OG - Grupo Solo Menus NPC 2026-10-21]], [[Aika OG - NPC Titulos e Menus 2026-10-10]].

O Studio lia apenas as opções/textos da tabela npcs; o jogo prioriza npc-menus para NPCs não personalizados. A projeção do Studio agora usa o menu efetivo, preservando IDs, ações, choices, filhos e ordem. Campos e prévia de menus gerenciados ficam somente leitura, evitando converter submenus/ações em um custom menu plano. Menus customizados e legados mantêm edição. Condições individuais de missões continuam dependentes do personagem no jogo.

Lilola2215: gratuita6498/6499; paga6498/6499/208/272/352/1472/5168/5200/8500; todas10800segundos. Aplicado tanto no menu efetivo quanto no legado. Preços preservados:2215custa10000Gold; legado2600/customcusta50000Gold. Opção77porhonra e bênção2442 não alteradas. Templates e fórmulas intactos; ausência de um buff continua recusando a ação sem debitar dinheiro.

Acentos corrigidos em Missão/Bênção/Armazém/Armazém da Guild/Aprimorar Relíquia, sem inventar rótulos ou serviços. Nomes de protocolo e títulos preservados: banco local2215/2442 usa842/Mago de Giovanni; CapturedDetails não comprova outro título para2215.

Publicado seletivamente no MySQL localhost3307/aikaria: cinco recursos, um texto2442, CAS/transação/auditoria; merges preservam custos e customizações. Menus/ações2→3; bênçãos/defaults/overrides1→2. Backup exato em artifacts/npc-menu-fixes/live-plan.json; replano live-after-plan.json confirmou zero alterações restantes. CLI reversível: Database patch-npc-menu-texts plan/apply/rollback. Não usar importação global para esta correção.

35 testes focados passaram, incluindo codecs Latin-1/CP1252 e publicação/reversão/concorrência em MySQL isolado. Nove testes Studio e fixture SQL isolada de menus passaram. Builds Database/frontend passaram. Novas asserções de proteção de menus gerenciados seguem na suíte integrada.

Instância Studio3388 e seus drafts preservados, sem restart: snapshots abertos permanecem antigos até recarregar/reabrir. Cliente real e homologação visual são limites separados; publicação SQL não substitui um GameServer com código antigo.

Evidência detalhada: C:\Projetcts\aika-og\docs\operations\NPC-MENUS-LILOLA-2026-11-03.md.
