---
title: Checkout Mercado Pago
updated: 2026-09-18
tags:
  - lotojogo
  - pagamentos
---

# Checkout Mercado Pago

Relacionado: [[LotoJogo - MOC]], [[Dashboard Redesign]], [[Backend]], [[Tests]], [[Known Issues]].

## Decisão e escopo

Por solicitação do usuário, “Assinar” no rail abre `?aba=assinar` e substitui a área visível de `dashboard-layout`. O conteúdo operacional permanece montado e oculto para preservar rascunhos. Checkout incorporado, sem Checkout Pro nem redirecionamento externo: nome, CPF e endereço, Pix com QR Code/copia e cola, crédito e débito via Payment Brick. Confirmação bancária usa Status Screen Brick incorporado quando o provedor retorna 3DS.

O usuário escolheu salvar cartões no Mercado Pago para pagamentos futuros. A tela pede consentimento explícito com checkbox; a API guarda apenas `User.MercadoPagoCustomerId` e obtém referências de cartão da conta autenticada. Não persiste CPF, endereço, token, número de cartão ou CVV no banco local. Erro ao salvar um cartão não transforma pagamento aceito em nova tentativa de cobrança.

O catálogo oferece somente Pro/R$29 e Bolao/R$59, limites efetivos da API, um mês por pagamento e sem renovação automática. Salvar cartão não autoriza recorrência. Plus/benefícios ilimitados da landing ainda precisam ser reconciliados com o contrato da API.

## Contratos e arquivos

- Frontend: `src/features/billing`, `src/services/billing.service.ts`, `src/styles/features/billing/SubscriptionCheckout.scss`, integração em `DashboardPage` e `DashboardMobile`.
- Backend: `Controllers/BillingController.cs`, `Services/Billing`, `Models/BillingOrder.cs`, `Config/MercadoPagoOptions.cs`.
- Rotas autenticadas: `GET /Billing/catalog`, `GET /Billing/cards`, `POST /Billing/checkout`, `GET /Billing/orders/{id}`. Webhook valida HMAC e consulta o pagamento no provedor.
- Idempotência por pedido (`requestId` = chave no Mercado Pago). Preço e e-mail vêm do servidor. Confirmação exige BRL, valor, collector e ambiente corretos. Consulta e atualização não aceitam dados de pagamento enviados no corpo do webhook.
- `EffectivePlan` combina concessão administrativa com compras aprovadas não expiradas. Status antigos não desfazem atualização posterior; estorno/contestação revogam benefício comprado.

## Ativação pendente

> [!important]
> Código implementado e testes locais aprovados; não houve cobrança real, configuração de credenciais nem aplicação de migration. Não tratar como integração homologada no Mercado Pago.

A migration `20260919000412_AddEmbeddedBilling` precisa ser aplicada antes de executar esta versão da API, inclusive com billing desativado: a leitura de usuário consulta `BillingOrders`. Usar `--context AppDbContext` porque há mais de um contexto EF.

API: configurar `MercadoPago__Enabled`, `Sandbox`, `PublicKey`, `AccessToken`, `WebhookSecret`, `CollectorId`, `NotificationUrl` HTTPS. Segredos ficam apenas no servidor. Manual completo e fontes oficiais em `C:\Projetcts\Lotojogo\lotojogo-api\docs\mercado-pago-checkout.md`.

Validação local em navegador usou API e SDK simulados: Pix, CPF inválido, aprovação, cartões salvos, consentimento, débito, 3DS e navegação. Layout verificado em 320/360/390/430/768/1024/1440 px. Ainda validar com credenciais reais de teste: tokenização, cartão salvo/reutilizado, débito, Pix, webhook e estorno.
