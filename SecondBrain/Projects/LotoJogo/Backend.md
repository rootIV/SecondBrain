# Backend

Relacionado: [[LotoJogo - MOC]], [[Architecture]], [[Auth]], [[Repositories]], [[DTOs]], [[Tests]].

## Stack

- .NET 8
- EF Core
- MySQL
- JWT Bearer
- Data Protection
- Rate Limiting

## Padroes

- [[Clean Architecture]]
- [[Repository Pattern]]
- DTOs em [[DTOs]]
- Controllers finos

## Camadas atuais

- `Controllers`: `AuthController`, `GenerateController`, `LotesController`, `StrategyTemplatesController`, `StrategyOptimizerController`, `BetInsightsController`.
- `Services`: [[AuthService]], [[GoogleAuthService]], [[TokenProtectorService]], [[LoteService]], [[GenerateService]], `StrategyTemplateService`, `StrategyOptimizerService`, `BetInsightService`.
- `Application/Interfaces`: `ILoteRepository`, `IUserRepository`, `IStrategyTemplateRepository`, `ILotteryDrawRepository`.
- `Infrastructure/Repositories`: [[LoteRepository]], [[UserRepository]], `StrategyTemplateRepository`, `LotteryDrawRepository`.
- `Data`: `AppDbContext`, migrations e factory.
- `Models`: entidades, requests, responses e DTOs.

## Registro de dependencias

`Program.cs` registra:

- `TimeProvider.System`
- `AppDbContext` usando `ConnectionStrings:DefaultConnection` para master/escrita.
- `ReadOnlyAppDbContext` usando `ConnectionStrings:ReadOnlyConnection` para slave/leitura, com fallback para `DefaultConnection`.
- `MemoryCache` e `RepositoryCache` para cache de consultas read-only dos repositorios.
- `ILoteRepository -> LoteRepository`
- `IStrategyTemplateRepository -> StrategyTemplateRepository`
- `IUserRepository -> UserRepository`
- `ITokenProtector -> TokenProtectorService`
- `GoogleAuthService` como typed HttpClient
- `AuthService`, `GenerateService`, `LoteService`, `StrategyTemplateService`
- `StrategyOptimizerService`, `BetInsightService`

## Templates de estrategia

- `StrategyTemplatesController` expoe CRUD autenticado em `/StrategyTemplates`.
- Templates pertencem ao usuario autenticado via `user_id`.
- `StrategyTemplate` guarda `name`, `category`, timestamps e lista de `StrategyTemplateStrategy`.
- Cada estrategia do template guarda `type`, `config_json` e `sort_order`.
- A migration `AddStrategyTemplates` cria `StrategyTemplates` e `StrategyTemplateStrategies`.
- Requests de templates usam DataAnnotations nos parametros do construtor dos records, nao nas propriedades geradas, para manter compatibilidade com validacao do ASP.NET Core.

## Sorteios historicos

- [[LotteryDraws]] armazena resultados historicos importados das planilhas em `lotojogo-data`.
- A persistencia usa `LotteryDraws` com numeros em JSON e `LotteryDrawExtras` para metadados variaveis.
- `dupla_sena` usa `draw_order` para guardar o primeiro e o segundo sorteio do mesmo concurso.
- O seed `Data/Seed/lottery-draws.seed.json` e importado de forma idempotente no startup apos migrations.
- `StrategyOptimizerService` consulta sorteios recentes para sugerir configuracoes de estrategias por faixas estatisticas.
- `BetInsightService` consulta sorteios recentes para calcular frequencia media das dezenas de uma aposta, comparacao com o ultimo sorteio e selo de combinacao vencedora.

## Middleware relevante

- CORS `AllowFrontEnd`.
- Data Protection para tokens do Google.
- JWT Bearer lendo `access_token` do cookie.
- Rate limiting: `auth` e `generate`, particionado por usuario autenticado ou IP.
- Limite global de body HTTP de 64 KB e `JsonSerializerOptions.MaxDepth = 16`.
- Headers de seguranca.
- Migrations e seed de admin no startup.

## Cache e leitura em replica

- O backend separa o contexto de escrita (`AppDbContext`) do contexto read-only (`ReadOnlyAppDbContext`).
- Queries realmente read-only usam o slave e `AsNoTracking`; fluxos que carregam entidades para mutacao continuam usando o master para preservar tracking do EF Core.
- O cache em memoria tem TTL curto de 30 segundos e e usado em consultas de resumo de lotes, lista de templates e sorteios historicos recentes.
- Qualquer `SaveChangesAsync` em repositorio invalida o grupo de cache dos repositorios via `RepositoryCache`.

## Validacao defensiva

- `StrategyRequestValidator` centraliza limites para requests de geracao e templates.
- `StrategyRequestValidator` valida `StrategyConfig.Config` por allowlist de propriedades/tipos por estrategia e combinacao. Campos numericos precisam chegar como JSON number inteiro; `numbersList` precisa ser array de inteiros; strings arbitrarias em `config` sao rejeitadas antes de gerar ou persistir.
- `SecurityLimits` define teto de body, config JSON, profundidade JSON, quantidade de estrategias, apostas por estrategia e universo numerico. O teto global de universo numerico e 100 para cobrir modalidades como [[Quina]], [[Timemania]] e [[Lotomania]].
- `GenerateController`, `StrategyTemplatesController` e endpoints publicos de [[Auth]] aplicam `RequestSizeLimit`.
- `GenerateService` rejeita tipos de estrategia desconhecidos em vez de cair para `random`.

## Observacao arquitetural

A direcao esta correta para Clean Architecture, mas ainda e uma Clean Architecture pragmatica em projeto unico. Se o projeto crescer, separar `Domain`, `Application`, `Infrastructure` e `Api` em projetos distintos deve ser o proximo passo.
