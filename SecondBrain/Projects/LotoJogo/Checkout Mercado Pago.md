---
title: Checkout Mercado Pago
updated: 2026-10-02
tags:
  - lotojogo
  - pagamentos
---

# Checkout Mercado Pago

Relacionado: [[LotoJogo - MOC]], [[Dashboard Redesign]], [[Backend]], [[Tests]], [[Known Issues]].

## Decisão e escopo

Por solicitação do usuário, “Assinar” no rail abre `?aba=assinar` e substitui a área visível de `dashboard-layout`. O conteúdo operacional permanece montado e oculto para preservar rascunhos. Checkout incorporado, sem Checkout Pro nem redirecionamento externo: nome, CPF e endereço, Pix com QR Code/copia e cola, crédito e débito via Payment Brick. Confirmação bancária usa Status Screen Brick incorporado quando o provedor retorna 3DS.

O usuário escolheu salvar cartões no Mercado Pago para pagamentos futuros. A tela pede consentimento explícito com checkbox; a API guarda apenas `User.MercadoPagoCustomerId` e obtém referências de cartão da conta autenticada. Não persiste CPF, endereço, token, número de cartão ou CVV no banco local. Erro ao salvar um cartão não transforma pagamento aceito em nova tentativa de cobrança.

O catálogo segue `Free → Plus → Pro → Bolao`, com preços mensais de R$ 0, R$ 19, R$ 39 e R$ 79. O checkout oferece somente planos acima do plano efetivo atual. Cada upgrade cobra o valor integral e, após aprovação, inicia um novo período mensal; salvar cartão não autoriza recorrência.

## Contratos e arquivos

- Frontend: `src/features/billing`, `src/services/billing.service.ts`, `src/styles/features/billing/SubscriptionCheckout.scss`, integração em `DashboardPage` e `DashboardMobile`.
- Backend: `Controllers/BillingController.cs`, `Services/Billing`, `Models/BillingOrder.cs`, `Config/MercadoPagoOptions.cs`.
- Rotas autenticadas: `GET /Billing/catalog`, `GET /Billing/cards`, `POST /Billing/checkout`, `GET /Billing/orders/{id}`. Webhook valida HMAC e consulta o pagamento no provedor.
- Idempotência por pedido (`requestId` = chave no Mercado Pago). Preço e e-mail vêm do servidor. Confirmação exige BRL, valor, collector e ambiente corretos. Consulta e atualização não aceitam dados de pagamento enviados no corpo do webhook.
- `EffectivePlan` combina concessão administrativa com compras aprovadas não expiradas. Status antigos não desfazem atualização posterior; estorno/contestação revogam benefício comprado.
- `?plano=Plus|Pro|Bolao` seleciona o upgrade no frontend; valores inválidos caem no próximo plano elegível. `pedido` continua prevalecendo ao abrir uma cobrança existente.

## Limites por plano

- Free: duas combinações por dia, somente estratégia aleatória e uma estratégia por geração.
- Plus: vinte combinações por dia e uma estratégia comum, opcionalmente acompanhada de uma aleatória; sem otimização, estatísticas avançadas ou Financeiro.
- Pro e Bolão: estratégias, otimização, estatísticas e Financeiro liberados, sujeitos aos tetos operacionais de segurança.
- Apostas manuais e automáticas consomem a mesma cota. A API conta apostas persistidas no dia de `America/Sao_Paulo`, serializa a geração por usuário e rejeita o lote inteiro quando excede o limite.
- A migration `20261001010000_RenameBasicPlanAndAddPlus` converte `Basic` para `Free` e altera o default do banco.

## Fluxo visual em duas etapas — 2026-10-02

- A tela inicial mantém os planos e mostra somente as formas de pagamento com o botão `Confirmar forma de pagamento`. Os planos ficam na coluna esquerda e as formas de pagamento na direita; o fundo usa o mesmo `--dashboard-shell-bg` preto/cinza do restante da dashboard.
- Após confirmar, a seleção inteira é substituída: dados do comprador ficam à esquerda e Pix/cartão à direita. `Voltar para planos e pagamento` retorna à primeira etapa e remove `pedido` quando necessário.
- A interface não menciona o processador de pagamentos. Pix usa `Gerar Pix` e o Brick de cartão recebe `formSubmit: "Pagar com cartão"`, sem valor no texto dos botões.
- Em desktop de 901 a 1440 px com 768 px de altura, seleção, formulário e resultado Pix cabem sem overflow horizontal ou rolagem vertical; abaixo de 901 px o fluxo volta a uma coluna.
- O checkout usa toda a área útil até `2200px`, com paddings fluidos e duas colunas que esticam o divisor até o fim da viewport. O modo compacto abaixo de `1180px` mantém a leitura em laptops sem transformar os cartões em blocos excessivamente grandes no 4K.

## Ativação pendente

> [!important]
> Código implementado e testes locais aprovados; não houve cobrança real, configuração de credenciais nem aplicação de migration. Não tratar como integração homologada no Mercado Pago.

A migration `20260919000412_AddEmbeddedBilling` precisa ser aplicada antes de executar esta versão da API, inclusive com billing desativado: a leitura de usuário consulta `BillingOrders`. Usar `--context AppDbContext` porque há mais de um contexto EF.

API: configurar `MercadoPago__Enabled`, `Sandbox`, `PublicKey`, `AccessToken`, `WebhookSecret`, `CollectorId`, `NotificationUrl` HTTPS. Segredos ficam apenas no servidor. Manual completo e fontes oficiais em `C:\Projetcts\Lotojogo\lotojogo-api\docs\mercado-pago-checkout.md`.

Validação local em navegador usou API e SDK simulados: Pix, CPF inválido, aprovação, cartões salvos, consentimento, débito, 3DS e navegação. Layout verificado em 320/360/390/430/768/901/1024/1366/1440/1920/2560 px; na faixa de 901 a 2560 px não houve overflow nem rolagem. Ainda validar com credenciais reais de teste: tokenização, cartão salvo/reutilizado, débito, Pix, webhook e estorno.
