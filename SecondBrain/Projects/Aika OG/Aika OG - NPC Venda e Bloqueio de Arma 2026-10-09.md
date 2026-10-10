---
title: Aika OG - NPC Venda e Bloqueio de Arma 2026-10-09
date: 2026-10-09
tags:
  - aika-og
  - debugging
  - protocol
status: ativado-aguardando-gameplay
---

# Venda ao NPC e Bloqueio de arma

Relacionadas: [[Aika OG - MOC]], [[Aika OG - ItemService]], [[Aika OG - SkillService]], [[Aika OG - Auditoria Servidor Client 2026-10-09]].

## Contrato corrigido de preços

No client atual, ItemList tem stride 464 e preços DWORD em honra 284, medalha 288, ouro 292 e venda 296. A atribuição anterior de venda ao offset 292, herdada de outro struct Delphi, estava incorreta para esta build. O DWORD 280 e o DelayUse 276 não foram auditados nesta correção.

Misteim ID 2545: compra-base 59.250 e venda-base 11.850. Funções nativas 00425270/004252F0 usam preço de venda direto, divisão inteira de durabilidade e dedução tributária inteira. Com 180/180 e visitante de 15%: 11.850 − floor(11.850×15/100) = 10.073 gold. Client aberto confirmou taxas 10%/15%, personagem nação 0 em canal de nação 1. O operador informou mais de 12 mil recebidos, sem saldo antes/depois; source anterior calcula 11.850 e não comprova esse delta aproximado.

Parser e campos compartilhados do editor corrigidos; venda usa preço nativo, imposto e proteção contra overflow. Taxas de venda e pacote 0x128 compartilham constantes. Não houve alteração do BIN do client, criptografia ou layout/opcode de pacote.

## Bloqueio de arma

Família 33–48, Index 19, efeito 221=1, duração 60 segundos. JSON e SQL anteriores marcavam Attack/Enemy/Target mesmo com dano/alcance zero. SkillService procurava mob para o alvo 1 e rejeitava antes de aplicar buff.

Classificação local corrigida para Buff/Self/Caster. BuffService inicializa uma carga; CombatModifierService bloqueia primeiro dano positivo dentro da duração, consome carga e remove o buff; miss não consome. MobAiService preserva o tipo modificado Block no pacote e atualiza buffs consumidos, usando a persistência existente.

Uma carga é interpretação da descrição/efeito usando o modelo da source, ainda sem confirmação em gameplay após ativação. Não alterar cooldown bruto 12000 ou assumir equivalência completa com servidor oficial. Teste isolado do hook PvP não prova implementação de PvP completo.

## Verificação e ativação

378 testes aprovados, zero falhas, dois ignorados na suíte final; execução em banco temporário e outputs isolados. Migração SQL corrige quatro preços de 16.471 dos 19.530 itens SQL e comportamento dos 16 níveis, com guards dos valores anteriores. Aplicação, idempotência e rollback validados em clone temporário.

GameCatalogBootstrapService prioriza SQL. Migração aplicada em aikaria em 2026-10-10 01:50 UTC: 16.487 linhas, 16.471 preços verificados sem divergências e 16 comportamentos Buff/Self/Caster confirmados antes do commit. Servidor/Studio recompilados e reiniciados; suíte ampliada com criação/títulos/chat: 422 aprovações, zero falhas, dois skips condicionais. Backup completo novo: `C:\Projetcts\aika-og\artifacts\backups\gameplay-fixes-20261009\database.sql\database.sql`. Manifesto: `artifacts/gameplay-migration-applied.json`.

Relatório e scripts SQL/rollback: `C:\Projetcts\aika-og\docs\reverse-engineering\NPC-SELL-WEAPON-GUARD-2026-10-09.md`. Logs de testes e verificação: `artifacts/shop-buff-tests` no projeto.

> [!todo] Validação operacional
> Correção ativada; falta medir saldo antes/depois de vender Misteim 180/180 no canal atual, conferir tooltip/delta 10.073, usar Bloqueio de arma, observar MP/ícone, primeiro golpe bloqueado e segundo golpe normal. Taxas especiais de castelo/Karena e venda realtime de stacks permanecem fora desta prova. Ver também [[Aika OG - Criacao Titulos Chat e Studio 2026-10-09]].
