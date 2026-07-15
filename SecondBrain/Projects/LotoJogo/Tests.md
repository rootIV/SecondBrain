# Tests

## Cache e replica

- `RepositoryReadReplicaCacheTests` cobre que consulta read-only de resumo de lotes usa o contexto slave e cache.
- O mesmo arquivo cobre que `SaveChangesAsync` invalida o cache read-only antes da proxima consulta.
- A suite completa do backend foi rodada apos a mudanca e manteve o aviso conhecido de conflito de versoes do EF Core Relational.

Relacionado: [[LotoJogo - MOC]], [[Backend]], [[Frontend]], [[LotteryStrategies]].

## Backend

Projeto de testes:

```text
lotojogo-tests/lotojogo-tests.csproj
```

Comando:

```powershell
dotnet test lotojogo-tests\lotojogo-tests.csproj
```

Observacoes:

- A solution `lotojogo-back-end/lotojogo-api.sln` referencia a API e `../lotojogo-tests/lotojogo-tests.csproj`.
- O Docker dev nao monta a solution no container da API; por isso os testes podem ficar na solution sem quebrar o `dotnet watch`.
- Tambem e possivel rodar `dotnet test lotojogo-api.sln` a partir de `lotojogo-back-end`.
- Pode aparecer warning de conflito em `Microsoft.EntityFrameworkCore.Relational`.
- `StrategyTemplateServiceTests` cobre criar, listar por usuario, atualizar, excluir e bloquear acesso cruzado entre usuarios para templates de estrategia.
- `StrategyTemplateServiceTests.Request_records_keep_validation_metadata_on_primary_constructor_parameters` cobre a regressao de DataAnnotations em records MVC, garantindo que `CreateStrategyTemplateRequest.Strategies` tenha validacao no parametro do construtor.
- `GenerateServiceTests` cobre combinacoes `sum` + `fibonacci` com incidencia exata, `sum` + `exclude_number` + `max_sequence`, `sum` com todos os filtros combinados suportados, `prime_count`, `f1f2f3`, combinacao com `range_count`, rejeicao de soma impossivel e rejeicao de combinacoes invalidas como mesmo tipo ou `manual`.
- `GenerateServiceTests` tambem cobre intersecoes impossiveis entre estrategias individualmente validas, garantindo erro de configuracao em vez de aposta vazia/parcial.
- Testes de seguranca cobrem rejeicao de tipo de estrategia desconhecido, limite de `bets`, config JSON grande/profunda e corte de pool combinado gigantesco.
- `StrategyRequestValidatorTests` cobre a regressao em que `MaxNumbers = 80` para [[Quina]] era rejeitado por `GenerateRequest` e `StrategyOptimizationRequest`.
- Em 2026-06-05, `StrategyRequestValidatorTests` passou a cobrir rejeicao de payloads string/HTML/SQL-like em campos numericos, `numbersList` com itens nao numericos, propriedades extras em `config`, `mode` invalido e config invalida em combinacoes.
- `GenerateServiceTests.GenerateOne_sum_fixed_can_return_different_valid_combinations` cobre a regressao em que regenerar `sum` retornava sempre a mesma combinacao.
- Em 2026-05-13, `dotnet test .\lotojogo-tests\lotojogo-tests.csproj` passou com 60 testes, mantendo apenas o warning conhecido de EF Core Relational.
- Em 2026-05-13, `dotnet build .\lotojogo-back-end\lotojogo-api.sln` passou com o mesmo warning conhecido.
- Em 2026-06-05, `dotnet build .\lotojogo-back-end\lotojogo-api.sln` e `dotnet test .\lotojogo-tests\lotojogo-tests.csproj` passaram com 88 testes, mantendo apenas o warning conhecido de EF Core Relational.
- Em 2026-07-09, `LoteServiceTests` passou a cobrir persistencia de titulo em aposta manual e retorno do titulo no detalhe e na lixeira.
- Em 2026-07-09, `StrategyRequestValidatorTests` passou a cobrir `manual.config.title` valido e rejeicao de titulo acima de 80 caracteres.
- Em 2026-07-09, `dotnet build .\lotojogo-back-end\lotojogo-api.sln` passou com 1 warning e `dotnet test .\lotojogo-tests\lotojogo-tests.csproj` passou com 93 testes e 11 warnings conhecidos/filtrados pelo RTK.
- Em 2026-07-09, `dotnet build .\lotojogo-back-end\lotojogo-api.sln` e `dotnet test ..\lotojogo-tests\lotojogo-tests.csproj` passaram apos corrigir a descoberta da migration `AddBetTitle`; a API aplicou `Bets.title` e a replica ficou sincronizada.

## Frontend

Comandos:

```powershell
npm run build
npm run lint
```

## SonarQube local

Analise gratuita local:

```powershell
.\scripts\sonar-up.ps1
$env:SONAR_TOKEN="<token>"
.\scripts\sonar-scan.ps1
```

Na primeira analise, o token precisa ser do `admin` ou de um usuario com permissao para criar projetos. Alternativa: criar `lotojogo-backend` e `lotojogo-frontend` manualmente no SonarQube antes de rodar o scan.

Projetos no SonarQube:

- `lotojogo-backend`: usa SonarScanner for .NET, `dotnet build`, `dotnet test` e cobertura OpenCover gerada por `coverlet.collector`.
- `lotojogo-frontend`: usa SonarScanner CLI em Docker com `sonar-project.properties`, limitado a `lotojogo-front-end/src`.

O scanner .NET fica fixado em `.config/dotnet-tools.json`; rodar `dotnet tool restore` quando necessario. O servidor local fica documentado em [[Docker]].

Estado observado:

- Em 2026-05-13, `npm run build` passou apos a refatoracao de responsabilidades do dashboard.
- Em 2026-05-13, `npm run lint` passou apos separar hooks de contexts, remover `any` principais e limpar parametros nao usados.
- Em 2026-05-18, `npm run build` e `npm run lint` passaram apos ajustar estado vazio da Home, motion de metal liquido do `MainCard` e glow dos `strategy-card`.
- Em 2026-05-14, `npm run build` passou apos adicionar `GenerationReviewPanel` e mover a chamada a `/Generate` para o botao de confirmacao.
- Em 2026-05-14, `npm run build` e `npm run lint` passaram apos adicionar custos de apostas no `GenerationReviewPanel` e centralizar precos em `domain/lottery/pricing.ts`.
- Em 2026-05-14, `dotnet build lotojogo-api.sln` passou apos adicionar `StrategyOptimizerController`, `BetInsightsController`, `StrategyOptimizerService` e `BetInsightService`, mantendo apenas o warning conhecido de EF Core Relational.
- Em 2026-05-14, `dotnet test lotojogo-tests\lotojogo-tests.csproj` passou com 60 testes apos os endpoints estatisticos.
- Em 2026-05-14, `npm run build` e `npm run lint` passaram apos redesenhar `GeneratedBetsCard`, adicionar custo total do lote atual e corrigir duplicacao visual dos numeros.
- Em 2026-05-14, `dotnet test lotojogo-tests\lotojogo-tests.csproj` passou com 68 testes apos corrigir templates, resumo de otimizacao e centralizacao do custo do lote, mantendo apenas o warning conhecido de EF Core Relational.
- Em 2026-05-14, `dotnet build lotojogo-back-end\lotojogo-api.sln`, `npm run build` e `npm run lint` passaram apos os mesmos ajustes.
- Smoke visual em `http://127.0.0.1:5173` abriu a home; o console mostrou CORS em `/Auth/me` para `http://localhost:5176`, provavelmente configuracao do backend local.
- Fluxo validado em browser com mock: regenerar uma aposta na aba Gerenciar atualiza somente a combinacao correspondente em `GeneratedBetsCard`.
- Em 2026-05-12, `npm run build` passou apos ajustes de metadados em `BetRow`, timezone `America/Sao_Paulo` e scrollbar transitoria acionada apenas por rolagem real.
- Em 2026-05-18, `npm run build` passou apos adicionar modo compacto/expandido em `strategy-section` e persistencia local de rascunho da aba Home.
- Em 2026-06-05, `npm run build` e `npm run lint` passaram apos trocar os inputs numericos dos cards da Home para texto numerico sanitizado.
- Em 2026-07-09, `npm run build` e `npm run lint` passaram apos adicionar titulos editaveis em apostas manuais e o fluxo contextual de exportacao CSV/PDF; o build manteve apenas o aviso de chunk grande do Vite.

## Politica

Ao mudar auth, lotes, estrategias ou repositorios:

- adicionar/ajustar testes backend;
- validar build frontend se alterar contratos DTO;
- atualizar notas Obsidian relacionadas.
