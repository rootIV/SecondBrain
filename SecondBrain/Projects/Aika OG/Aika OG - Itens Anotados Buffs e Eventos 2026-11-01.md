---
title: Aika OG - Itens Anotados Buffs e Eventos 2026-11-01
updated: 2026-11-01
tags:
  - project/aika-og
  - gameplay
  - localization
  - aika-studio
---

# Aika OG - Itens Anotados Buffs e Eventos 2026-11-01

Continuação de [[Aika OG - Descricoes Conjuntos e Avisos 2026-11-01]] e [[Aika OG - Pocoes e Consumo Seguro 2026-10-23]]. Fonte canônica atual: `C:\Projetcts\aika-og\docs\operations\ANNOTATED-ITEMS-2026-11-01.md`.

179 itens anotados da planilha do operador foram organizados por categoria. A planilha produzida mantém todos os campos originais, as 764 linhas e o resultado Testada/Funcional original; diagnóstico automatizado separado. Não confundir esses relatos com homologação atual no jogo.

## Contratos verificados

- XP 387 usa o valor real 2/4/8. O buff 9087 aplica 4x nos níveis 1–70, 3x nos níveis 71–75 e 2x nos níveis 76–85; o 9207 termina no nível 90. Os benefícios usam o maior multiplicador elegível, respeitando os limites nativos do item.
- A skill 8124 é compartilhada: a exceção de 4x pertence a 8034/8046. O item 8001 e as demais variantes de 2x continuam com 2x. A suíte completa detectou a generalização errada; a correção preservou o teste existente de cash.
- Famílias 252/253/254, 482/483 e 218/245 são mutuamente exclusivas; validar antes de iniciar a validade e remover acúmulo derivado antigo.
- 4319 e variantes aplicam dano/redução contra nações inimigas de 160. Seus consumidores foram preservados e a descrição foi reconciliada com esse comportamento.
- 24426 funciona durante incapacitação, sem remover o controle. O item 27569 recupera somente 40000 MP.
- 4408–4414 têm bênção nativa de 60 s e limite de uma unidade entre níveis; depósitos e criação por lojas/eventos/drop são proibidos. Criação por clériga e negociação entre jogadores ainda não estão implementadas.
- Novas ativações de 4505 duram 720 h. O valor de 9999 h do arquivo é legado; prazos já ativos foram preservados por falta de data confiável de ativação.

## Publicação aplicada

39 descrições e 7 nomes publicados no cliente, Data, snapshots e 7 nomes relacionais. Os 31.000 registros preservam todos os bytes fora dos dois campos de texto. Dessas descrições, 24 vêm de 14 textos de buffs explicitamente revisados, com identidade, efeitos, duração e hash. As demais correções registram Before/After e motivo, separadas das traduções que devem preservar números.

O item 8683 [30day] da imagem contém todas as faixas de 9087. O item 8687 foi corrigido para 2x e 10764 termina no nível 85, apesar do máximo legado 90 do item. O item 8034 mantém mínimo 51 e recebe descrição coerente. Conferir variantes antes de copiar textos de buffs genéricos.

Restam 1.344 descrições danificadas e o nome interno TEST10000, sem evidência integral nas duas referências. A contagem anterior de 1.370 é histórica e foi superada.

Snapshots finais: ItemList Data/client revisão 7, studio-item-categories revisão 3, potions revisão 2. Verificação física/SQL/checksum em `artifacts/annotation-review-20261101/verification.json`; backups em `artifacts/item-annotations-text-20261101-v2/`.

Categoria de eventos com 503 IDs: 502 marcadores explícitos [Evento]/[Event] e 20641 da anotação. Confirmada no Studio desktop em 1728×1080, sem overflow. A descrição de 8683 foi conferida no editor; a sessão de QA não gravou rascunhos nem edições.

## Pendências preservadas

17 itens bloqueados sem consumo: 4502/20641/25659/25660 a pedido do operador; 14255–14258 com skills de espinhos/sangramento; 21682/21683 com resistência no lugar da cura anunciada; 20130–20135/20464 são caixas de título tratadas incorretamente como recuperação. O bloqueio mitiga o problema; a recompensa ou o efeito correto permanece pendente.

Continuam pendentes: animações de 15968/26035/26038/29347, criação de água divina por skill, negociação de 22255/água divina e abertura transacional das caixas de título. A planilha registra IDs e motivos. As skills 10201/10202 pertencem ao combate e devem ser preservadas globalmente. Title.bin identifica os títulos 88–93, mas não prova, sozinho, a recompensa completa, a classe e o nível ao abrir caixas.

Homologação visual no AikaClient real ainda necessária. GameProtocol/EncDec/chaves/opcodes/layouts preservados.

## Verificação final

100 testes focados do GameServer passaram após o ajuste de 8124; mais 21 verificaram os limites de poções e o caso de cash, incluindo três novas verificações de conflito/retirada. O teste original de cash permaneceu inalterado. Studio completo: 185 passaram e 1 condicional ignorado. Scripts de texto: 22 passaram. Build da solução com 0 erros e 36 avisos de testes/nulabilidade. Planilha exportada e renderizada: todas as células originais e as 179 anotações foram preservadas.

A suíte completa do GameServer registrou 1758 aprovados, 10 condicionais ignorados e um erro de 8124 antes da correção. O erro foi corrigido e retestado; a suíte inteira não foi repetida após o ajuste. Consultar o TRX específico, sem anunciar uma nova execução integral aprovada.
