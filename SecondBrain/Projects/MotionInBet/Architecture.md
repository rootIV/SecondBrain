---
tags:
  - motioninbet
  - architecture
  - dotnet
  - react
updated: 2026-06-06
---

# Architecture

MotionInBet e um conjunto de tres projetos separados dentro de um workspace agregador.

## Componentes

### API

- Projeto: `motioninbet-api`
- Stack: .NET 8, ASP.NET Core, Entity Framework Core, Pomelo MySQL.
- Responsabilidades:
  - Cadastro e login de usuarios.
  - Confirmacao de email.
  - Emissao e validacao de JWT.
  - Criacao de Pix via Mercado Pago.
  - Webhook de pagamento.
  - Geracao e status de serial keys.

Principais arquivos:

- `Program.cs`: autenticacao, CORS, DbContext, Swagger, rate limiter.
- `Controllers/UserController.cs`: login, register, confirmacao.
- `Controllers/PixController.cs`: criacao de pagamento Pix e webhook.
- `Controllers/SerialKeyController.cs`: status de plano.
- `BetomationDbContext.cs`: entidades `Users` e `SerialKeys`.

### Bot desktop

- Projeto: `motioninbet-bot`
- Stack: .NET 8 Windows Forms, Selenium, ChromeDriver.
- Responsabilidades:
  - Login na API.
  - Verificacao de status de plano.
  - Abertura de browsers automatizados.
  - Automacao de fluxo operacional via Selenium.
  - Criacao de Pix para usuario sem plano ativo.

Principais arquivos:

- `FormLogin.cs`: login, persistencia de preset e entrada no fluxo principal.
- `FormPix.cs`: criacao e polling de Pix.
- `Services/FormMainServices.cs`: automacao Selenium.
- `Helpers/FileHelper.cs`: persistencia criptografada de arquivos locais.

### Website

- Projeto: `motioninbet-website`
- Stack: React 19, TypeScript, Vite, SCSS.
- Responsabilidades:
  - Landing/login/cadastro/status.
  - Autenticacao via JWT em `localStorage`.
  - Exibicao de status e criacao de Pix.

Principais arquivos:

- `src/context/AuthContext.tsx`: estado global de autenticacao.
- `src/pages/login.tsx`: login.
- `src/pages/status.tsx`: status de plano e Pix.
- `src/pages/price.tsx`: cards de planos.
- `src/services/AuthService.ts`: chamadas login/register.

## Fluxo de compra

1. Usuario loga pelo website ou bot.
2. API emite JWT.
3. Cliente chama `pix/create` com `PlanId` e email.
4. API cria pagamento no Mercado Pago com `external_reference`.
5. Webhook consulta o pagamento pelo id.
6. Se status e valor forem validos, API cria ou renova `SerialKey`.
7. Cliente consulta `serialkey/status`.

## Observacoes de arquitetura

- A API concentra logica de negocio nos controllers. Para evoluir, mover regras de planos, pagamentos e serial keys para services testaveis.
- Os tres projetos compartilham conceitos, mas nao contratos tipados. DTOs divergentes entre API, bot e website ja causam risco de incompatibilidade.
- O workspace raiz nao e um repositorio Git; cada subprojeto possui seu proprio `.git`.
- O grafo atual do Graphify detectou muitos artefatos gerados. Isso reduz a qualidade das comunidades e deve ser corrigido antes de usar o grafo como fonte primaria de arquitetura.

## Phase 1 Refactor Baseline

Phase 1 adds explicit configuration boundaries for test shortcuts before deeper architectural changes. The API keeps current endpoint compatibility, but unsafe shortcut behavior becomes visible through `TestingShortcuts` configuration. The base API `appsettings` keeps testing shortcuts disabled, while Development enables them.

The API test price path is now guarded by `TestingShortcuts.UseTestPlanPrices`, and invalid `PlanId` values return `BadRequest`. The bot keeps the fast test entry behavior, but it is gated by `TestingShortcuts.AllowBotBypass` and `DEBUG` through `CanUseBotBypass`. Bot configuration no longer stores `ConnectionString`; `ApiBaseUrl` is the HTTP client boundary.
