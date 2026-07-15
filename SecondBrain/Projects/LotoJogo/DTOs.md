# DTOs

Relacionado: [[LotoJogo - MOC]], [[Backend]], [[Frontend]], [[Auth]], [[LoteService]], [[GenerateService]].

## Backend

DTOs e requests vivem em `lotojogo-back-end/Models`.

Arquivos principais:

- `LoteDtos.cs`
- `GenerateModels.cs`
- `StrategyTemplateDtos.cs`
- `SavedStrategyDtos.cs`
- `LoginRequest.cs`
- `RegisterRequest.cs`
- `GoogleLoginRequest.cs`
- `GoogleTokenResponse.cs`
- `TokenResponse.cs`

## Lote DTOs

- `BetDto`: `Id`, `Numbers`, `CreatedAt`, `IsMarked`, `Title`.
- `StrategyDto`: `Id`, `Category`, `MaxNumbers`, `Type`, `Config`, `PoolSize`, `Bets`.
- `TrashedBetDto`: aposta na lixeira, incluindo `Title`.
- `LoteSummaryDto`: resumo para listagem.
- `LoteDetailDto`: detalhe completo do lote.
- `GenerateResponseDto`: resposta de geracao.

## Frontend

Contratos espelhados em:

- `src/types/Lote.ts`
- `src/types/Strategy.ts`
- `src/types/SavedStrategy.ts`
- `src/types/Auth.ts`

`src/types/Strategy.ts` agora modela `StrategyCombinationInstance` em `BaseConfig.combinations`, com configs para `fibonacci`, `exclude_number`, `max_sequence`, `prime_count`, `multiple_count`, `ending_digit` e `range_count`.

Novas configs de estrategia no frontend:

- `PrimeCountConfig`: `count`, `numbers`, `bets`.
- `MultipleCountConfig`: `divisor`, `count`, `numbers`, `bets`.
- `EndingDigitConfig`: `digit`, `count`, `numbers`, `bets`.
- `RangeCountConfig`: `start`, `end`, `min`, `max`, `numbers`, `bets`.

## Saved Strategies DTOs

- `SavedStrategyDto`: detalhe com `id`, `name`, `description`, `category`, `maxNumbers`, `generationMode`, timestamps e `items`.
- `SavedStrategySummaryDto`: resumo para listagem com `itemCount`.
- `SavedStrategyItemDto`: item salvo com `type`, `config`, `sortOrder` e `isEnabled`.
- `CreateSavedStrategyRequest` / `UpdateSavedStrategyRequest`: payloads do CRUD em `/api/strategies`.
- No frontend, `generationMode` e tipado como `"independent" | "combined"`, mas a UI atual salva/carrega somente o modo `independent`.

## Strategy Template DTOs

- `StrategyTemplateDto`: `Id`, `Name`, `Category`, `CreatedAt`, `UpdatedAt` e `Strategies`.
- `StrategyTemplateStrategyDto`: item do template com `Id`, `Type`, `Config` e `SortOrder`.
- `CreateStrategyTemplateRequest` / `UpdateStrategyTemplateRequest`: payloads do CRUD em `/StrategyTemplates`.
- O contrato usa `JsonElement Config`, alinhado com `StrategyConfig` de [[GenerateService]].
- `Config` continua flexivel, mas agora passa por limite de tamanho, profundidade e allowlist de `type` antes de persistir ou gerar.
- Templates podem salvar estrategias `manual`; a UI restaura essas apostas para `manualBetsByCategory` ao aplicar o template.
- Em 2026-07-09, estrategias `manual` podem enviar `config.title` para nomear a aposta manual persistida em `Bets.title` (`varchar(80) not null default ''`).
- Em records usados como requests MVC, DataAnnotations ficam nos parametros do construtor primario com `[param: ...]`; usar `[property: ...]` em `Strategies` causa erro de metadata ignorada no ASP.NET Core.

## Limites de entrada

- `GenerateRequest.MaxNumbers` e `StrategyOptimizationRequest.MaxNumbers` aceitam no maximo 100, alinhando [[Quina]], [[Timemania]] e [[Lotomania]] ao universo numerico usado no frontend.
- `GenerateRequest.Strategies` aceita no maximo 6 estrategias.
- Templates aceitam no maximo 12 estrategias.
- Cada `StrategyConfig.Config` tem limite de 4 KB e profundidade maxima de 16 niveis.
- `StrategyConfig.Config` e `StrategyTemplateStrategyRequest.Config` continuam como `JsonElement`, mas o backend agora exige schema esperado por `type`: campos numericos devem ser JSON number inteiro, `numbersList` deve conter apenas inteiros, `mode` aceita apenas `fixed` ou `ranged`, e `combinations` aceita apenas tipos/configs suportados.
- `LoginRequest` e `GoogleLoginRequest` possuem DataAnnotations para tamanho e obrigatoriedade.

## Ponto de atencao

`TokenResponse` existe no backend, mas o frontend trabalha majoritariamente via cookies. O retorno publico de `/Auth/login`, `/Auth/google`, `/Auth/refresh` e `/Auth/logout` e `{ success: true }`, nao um token de acesso exposto ao JS.
