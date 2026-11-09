---
tags:
  - project/aika-og
  - quests
  - aika-studio
updated: 2026-10-23
---

# Aika OG - Diamantes Catharina e Modo Teste 2026-10-23

Relacionado: [[Aika OG - MOC]], [[Aika OG - Client - Documentacao Oficial]].

## Causa e contrato

A missão 1522, **50 Diamantes de Lakia**, da Catharina Piero (NPC 2113, índice nativo 66), tinha `Gameplay = null` por recompensa tipo 60 não implementada. O modo teste local estava ativo, mas só ignorava condições de disponibilidade. A mensagem “aguarda validação” não indicava aprovação manual pendente.

As variantes 1521–1524 agora reconhecem estritamente o registro conhecido: 10/50 unidades dos itens 8403 ou 8423 e recompensa de 10%/50% da XP do nível 50. O tipo 60 é porcentagem do intervalo entre os limiares de experiência do nível, não uma quantidade fixa de XP nem uma recompensa de itens. Fonte estática: cliente SHA256 `e1104cbb8d313ec9b07e18c5529ac6865d1eda92e429355185617a4f805ff002`, VA `0x00418460`; cálculo nativo identificado em evidência REA `ev_087db49dde165377579f3fcc97c7724ccaba79fe0e05a6a5b74054be2cac3833`.

A base local de 50% é 2.554.027 XP. O servidor aplica a taxa global existente e limita a XP a 100% do nível 50, sem promover. O limite vem do diálogo nativo 7784; o cálculo de exibição foi decompilado, mas isso não comprova o comportamento do servidor oficial. Nível diferente de 50, tabela ausente, XP no limite ou itens insuficientes rejeitam a entrega sem consumir diamantes. Modo teste não fornece os itens nem dispensa a condição própria da recompensa.

Overrides antigos preservam a regra percentual ao recarregar. O Studio mostra a porcentagem em consulta; outros tipos/parâmetros desconhecidos continuam pendentes. Mantida a proteção existente contra recompensa já recebida; não foi implementada repetição automática.

## Evidência e ativação

Relatório no repositório: `C:/Projetcts/aika-og/docs/operations/DIAMOND-QUESTS-2026-10-23.md`. Evidência/snapshot REA em `artifacts/diamond-quest-20261023/` e capturas do Studio em `output/playwright/diamond-quest-*.png`.

Primeira verificação: 77 testes focados de missões, 3 do Studio, um teste de persistência/rollback, build e lint do frontend passaram. Reiniciar GameServer e Studio com o novo build e recarregar o navegador. Gameplay real e semântica do servidor oficial ainda exigem homologação, registrada em [[Knowledge Debt]].

Verificação final: 207 testes de missões passaram, sem falhas ou testes ignorados, incluindo MySQL e rollback; TRX no relatório do repositório. Interface verificada em desktop e 390 px, com recompensa percentual e console sem erros/avisos. Nenhuma edição de teste foi efetivada no catálogo. A instância isolada do Studio foi usada para inspeção; os processos de jogo do usuário não foram reiniciados.
