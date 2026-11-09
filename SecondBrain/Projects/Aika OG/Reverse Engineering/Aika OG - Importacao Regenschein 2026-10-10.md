---
tags:
  - project/aika-og
  - reverse-engineering
  - npc
updated: 2026-10-10
---

# Aika OG - Importacao Regenschein 2026-10-10

Relacionado: [[Aika OG - MOC]], [[Aika OG - Coletor Passivo de Mundo]], [[Aika OG - NPC Spawn]], [[Aika OG - WorldDataService]], [[Knowledge Debt]].

Importação aplicada ao MySQL `aikaria`, a `C:\Projetcts\aika-og\Data` e ao client local `D:\aika\Aika OG`. 68 NPCs, 40 lojas, 882 slots não vazios; IDs, índices MN, XY, rotações e ordem de itens validados contra a captura. O catálogo MySQL tem precedência: alterar apenas Data não bastaria.

Os 112 registros antigos incluíam 44 entidades com nome literal/classe zero (Prans/personagens), não NPCs confirmados. Importação usa apenas identidades numéricas MN; coletor BR corrigido para excluir esses falsos positivos. Captura original preservada, sem reinterpretar contagem antiga como 112 NPCs reais.

21 templates de itens faltantes acrescentados aos bins do servidor/client e à tabela item_templates. Nome MN 2847 (Daniel Everett) copiado do client oficial. Footer ItemList4 local anteriormente inválido corrigido com algoritmo confirmado contra ItemList6 oficial. Nenhuma alteração no protocolo/EncDec C#.

17 registros antigos ausentes da captura dentro de X=3364.40..3559.40, Y=527.40..737.40 removidos, assim como uma cópia idêntica de Lilola Hawn 2215. NPCs fora do retângulo não foram removidos. Registros adicionais não observados em outras partes do mapa não podem ser considerados inexistentes.

> [!warning] Aparência e item não resolvidos
> A captura antiga não guardou aparência/equipamentos BR. 15 NPCs sem template local de mesma identidade usam modelo provisório 2071: 2365, 2411, 2505, 2506, 2507, 2508, 2509, 2517, 2525, 2526, 2530, 2533, 2544, 2549, 2552. Precisam de nova captura dos campos de aparência para visual exato. Item 1521 de Alen Sinclair vazio também no bin oficial; ID mantido sem fabricar template. Novos NPCs sem opções capturadas recebem conversa/loja comum.

Backups/plano: `artifacts/regenschein-import/2026-10-10`, SQL completo + 129 operações com snapshots/hashes + RESTORE.md. Código: `tools/import_regenschein_capture.py` e `tools/Import-RegenscheinDatabase.ps1`, reaproveitando loaders/repositório existentes; transação limitada a IDs revisados. Banco/arquivos verificados, 34 testes coletor + 6 importação + 72 C# NPC/shop/catalog + integração PowerShell aprovados. Ainda sem validação visual do gameplay após importação. GameServer/client local precisam iniciar/reabrir para carregar dados.

Relatório completo: [REGENSCHEIN-IMPORT-2026-10-10.md](C:/Projetcts/aika-og/docs/reverse-engineering/REGENSCHEIN-IMPORT-2026-10-10.md).
