---
tags:
  - motioninbet
  - roadmap
updated: 2026-06-06
---

# Roadmap

## P0 - Seguranca e producao

- Rotacionar credenciais de MySQL, Gmail, Mercado Pago e JWT.
- Mover segredos para variaveis de ambiente.
- Adicionar guardrail para atalhos de teste: logs sensiveis, token vazio, `_userLoginPreset`, audiencia JWT, preco de teste e webhook simplificado nao podem passar para producao sem revisao.
- Remover logs de tokens e payloads sensiveis antes de producao.
- Corrigir bypass de login no bot antes de producao.
- Corrigir fluxo de token do bot para usar `result.Token` na sessao atual antes de producao.
- Reativar validacao de audiencia JWT antes de producao.
- Validar origem/assinatura do webhook Mercado Pago antes de producao.
- Corrigir preco de `1dia` na API ou remover plano de teste antes de producao.

## P1 - Contratos e dominio

- Centralizar catalogo de planos na API.
- Website e bot devem consumir os planos da API.
- Extrair regras de pagamento e serial key dos controllers para services.
- Persistir `paymentId` e `external_reference` em entidade propria de pagamento.
- Adicionar indices/constraints para `Username`, `ConfirmationToken` e serial key.
- Adicionar testes de unidade para plano, expiracao e renovacao.

## P2 - Frontend

- Corrigir 7 erros de lint.
- Remover `any` dos fluxos de login/status/preco.
- Separar `useAuth` de `AuthContext.tsx` ou ajustar regra de Fast Refresh.
- Remover inline styles.
- Migrar Sass `@import` para `@use` quando viavel.
- Atualizar dependencias com vulnerabilidades, especialmente `vite` e `rollup`.

## P3 - Bot desktop

- Remover senha bruta de `preset.cjob`.
- Trocar AES com chave fixa por DPAPI/ProtectedData.
- Cancelar loops/tarefas infinitas quando browser/form fechar.
- Reduzir `Thread.Sleep` e centralizar waits Selenium.
- Evitar esconder excecoes sem log minimo.

## P4 - Knowledge graph

- Recriar grafo sem artefatos gerados.
- Considerar grafo por subprojeto: API, bot e website.
- Criar nota de arquitetura baseada no grafo limpo.

## Phase 1 Active Work

- Add explicit testing shortcut config in API and bot.
- Add production guardrails for unsafe shortcuts.
- Record verification baseline.
- Prepare Graphify cleanup before deeper module refactors.
- Keep API base `appsettings` shortcuts false and Development shortcuts true.
- Guard API test prices with `UseTestPlanPrices`; invalid `PlanId` returns `BadRequest`.
- Gate bot bypass with `AllowBotBypass` plus `DEBUG` through `CanUseBotBypass`.
- Keep bot HTTP clients on `ApiBaseUrl`; do not restore `ConnectionString` config.
