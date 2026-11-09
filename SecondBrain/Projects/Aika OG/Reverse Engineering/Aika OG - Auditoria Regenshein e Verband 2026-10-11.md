---
type: verification
project: Aika OG
created: 2026-10-11
status: verified-with-caveats
tags:
  - aika-og
  - reverse-engineering
  - world-collector
---

# Aika OG - Auditoria Regenshein e Verband 2026-10-11

Relacionado: [[Aika OG - MOC]], [[Aika OG - Coletor Passivo de Mundo]], [[Aika OG - Lojas e Recaptura 2026-10-11]], [[Aika OG - NPC Titulos e Menus 2026-10-10]], [[Aika OG - Studio NPCs e Mobs 2026-10-11]], [[Knowledge Debt]].

Nova captura encerrada às 17:30:30 UTC: 184 atores NPC, 484 mobs de32 identidades, 40 lojas. Snapshot somente leitura de localhost:3307/aikaria às17:42:14UTC (14:42:14 Brasília); MySQL tem precedência sobre Data. GameServer estava parado. Não houve importação de mundo/preço/SQL/bins nesta auditoria.

[Relatório no repositório](C:/Projetcts/aika-og/docs/operations/WORLD-CAPTURE-ALIGNMENT-2026-10-11.md) e [evidência estruturada](C:/Projetcts/aika-og/artifacts/world-audit/2026-10-11/alignment.json).

- 83 NPCs têm identidade/ID/posição/rotação alinhados; 17 destes diferem em campos visuais. Modelos/Body/títulos 2505–2509 continuam provisórios; 11 títulos e 17 velocidades divergem no total.
- 100 identidades de atores estão ausentes de npcs: 1 nas coordenadas de Regenshein e 99 em Verband. Não converter observações históricas automaticamente em 100 spawns fixos. 16 Guardas Reais de Regenshein foram observados na entrada, em 16 posições distintas de Verband, sem identidade equivalente local. 29 outros guardas têm templates de mobs globais, mas zero spawns nas duas regiões comparadas.
- ID 2444 oficial é Moa Rigel/MN 2297; 2444 local já corresponde a Tony Kepler/MN 2300. Exige mapeamento, sem sobrescrever a identidade local.
- 31/32 identidades de mobs têm template ativo e spawns em Verband. Lakior/MN 36 falta; 3 equipamentos e 7 campos Height divergem. 392/483 observações de espécies existentes estão a até 5 unidades de algum ponto inicial local. York Faminto tem observação a 73,034 unidades do ponto mais próximo; movimento/combate não excluídos. Não inferir déficit populacional de contagens históricas.
- 20/40 lojas diferem nos slots, inclusive espaços vazios antes compactados. 849 itens distintos existem no SQL; 158 diferem em campos de preço, 142 em campos de compra e 16 apenas revenda; 72 diferem em item/quantidade de troca. Preço-base do client não comprova débito final oficial. Handler BuyItem rejeita honra/medalhas; 189 templates locais desta amostra usam essas moedas.
- 16/248 opções capturadas não estão configuradas; 71 textos presentes diferem. Menus condicionais/em etapas e seletores de diálogo ainda precisam de associação/implementação confirmada.

Captura tem172tcpGaps,858movimentos sem aparição prévia e6layouts inválidos.809candidatos desconhecidos não entram na comparação. Mapa inferido por coordenadas do Map.bin; pacote não identifica mapa/canal. Posições não provam respawn e destinos não provam patrulha. Importador antigo restrito a2048..3047/Regenshein não deve importar esta captura ampla sem mapeamento.

Studio: botão de preço estava corretamente bloqueado pelo motivo `teste` (5<8), mas sem explicar o limite. Rótulo e contador agora mostram a exigência; browser confirmou bloqueio5/8 e habilitação com motivo válido, sem gravar. Build/lint aprovados; zero erros/warnings no navegador. Consulta posterior8018permaneceu gold500.
