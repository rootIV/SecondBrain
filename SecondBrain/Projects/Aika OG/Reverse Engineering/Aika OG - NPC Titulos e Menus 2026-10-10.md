---
tags:
  - project/aika-og
  - reverse-engineering
  - npc
updated: 2026-10-10
---

# Aika OG - NPC Titulos e Menus 2026-10-10

Relacionadas: [[Aika OG - MOC]], [[Aika OG - NPC Spawn]], [[Aika OG - Coletor Passivo de Mundo]], [[Aika OG - Importacao Regenschein 2026-10-10]].

## Contrato nativo e regressão

OG `0x0349` usa 508 bytes, Body WORD no offset 90 e título no offset 456. O layout anterior escrevia título em 458 e truncava Body para byte. O oficial BR `0x3049` tem 512 bytes; copiar esse tamanho ao OG fez todos os NPCs desaparecerem. Após restaurar 508, operador confirmou retorno. Um WORD em 506 termina em 508 e não prova tamanho 512.

Os modelos completos e a velocidade zero são preservados no sidecar `Data/NPCs/CapturedDetails.json`, validado por ID/nome de protocolo. O banco usa Body SMALLINT UNSIGNED e `option_texts_json`. Fechar aparece uma vez ao final de todo menu principal; Dean tem a ordem oficial e Loja de Materiais. Serviços capturados 84/88 ainda indisponíveis não devem abrir uma loja por fallback.

## Auditoria aplicada

82 NPCs estáticos existentes, 77 aparências, 37 menus sem conflito, 43 lojas de itens e 962 slots, sem ID de item pendente. Não houve exclusão de NPC nem alteração de personagens/mobs/drops nesta atualização. Roze2549 e MagnusRomeo2068 já têm listas vazias na captura oficial.

Seletores 11/13 são skills, 12 é loja. Alen2051 e Sarah2052 foram separados das lojas. Item1521 da contagem anterior é skill; não tentar reparar ItemList com essa referência. Novas lojas reais: Thomas2050, Cozy2190, Nancy2200, Tubal2526.

## Pendências verificadas

- Aparências não capturadas: 2505–2509; preservadas locais.
- Menus em etapas conflitantes: MoaTimur2235/Toca2309; não achatar variantes.
- Helmut2062/Clair2112: itens capturados, mas menu oficial ausente e configuração local sem opção5. Acesso à loja ainda não comprovado.
- Seletores narrativos Catharina628/Toca6243: slot628 tem texto oficial, 6243 não tem correspondência direta; não confundir seletores com slots automaticamente.
- Aparência renderizada, mapeamento de modelos a assets, missões completas e patrulhas não foram validados em todos os casos.

## Evidência

Relatório: [auditoria NPC](C:/Projetcts/aika-og/docs/reverse-engineering/NPC-CAPTURE-AUDIT-2026-10-10.md).

Backup: `C:\Projetcts\aika-og\artifacts\npc-capture-refresh\2026-10-10-verified`, incluindo RESTORE, dump privado e auditoria por NPC. Catálogo permanece parado; backup anterior à reclassificação em `capture-before-classification`.

461 testes C#, 53 testes Python de coleta, 8 de importação e integração PowerShell aprovados. Retorno de NPCs confirmado pelo operador; essa confirmação não valida individualmente todos os títulos e menus.
