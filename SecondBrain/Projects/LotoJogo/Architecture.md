# Architecture

Relacionado: [[LotoJogo - MOC]], [[Backend]], [[Frontend]], [[Repositories]], [[DTOs]], [[Auth]], [[LotteryStrategies]], [[Agent Context Rules]].

## Stack atual

- Frontend: React, TypeScript, Vite, SCSS, React Query.
- Backend: ASP.NET Core / .NET 8, EF Core, MySQL, JWT, Data Protection.
- Infra local: Docker Compose com `db`, `api` e `frontend`.

## Forma atual do repositorio

```text
lotojogo/
  lotojogo-front-end/
    src/components/
    src/contexts/
    src/domain/
    src/features/
    src/hooks/
    src/pages/
    src/routes/
    src/services/
    src/strategies/
    src/styles/
    src/types/

  lotojogo-back-end/
    Application/Interfaces/
    Controllers/
    Data/
    Infrastructure/Repositories/
    Models/
    Services/
```

## Controle de versao

- A pasta pai `C:\Users\Vitor\Documents\Projects\lotojogo` organiza os projetos, mas nao e o repositorio Git principal.
- Existem repositorios Git separados dentro de `lotojogo-front-end` e `lotojogo-back-end`.
- Ao rodar `git status`, `git diff`, commits ou branches, usar o diretorio do projeto especifico.
- Para reduzir contexto, seguir [[Agent Context Rules]] antes de pesquisar/editar arquivos.

## Backend

O backend esta em um unico projeto, mas ja separa algumas responsabilidades:

- `Controllers`: adaptadores HTTP finos.
- `Services`: casos de uso e regras de aplicacao.
- `Application/Interfaces`: contratos de repositorio.
- `Infrastructure/Repositories`: consultas e persistencia EF Core.
- `Data/AppDbContext`: mapeamento EF e schema.
- `Models`: entidades, requests e DTOs ainda misturados.

### Limite de Clean Architecture

A intencao e Clean Architecture, mas a separacao ainda nao e plena:

- Interfaces de repositorio retornam entidades EF (`Lote`, `Bet`, `User`).
- DTOs e entidades vivem juntos em `Models`.
- `Program.cs` ainda executa migration e seed diretamente com `AppDbContext`.

## Frontend

O frontend segue uma arquitetura por camadas praticas:

- `services`: chamadas HTTP.
- `hooks`: React Query, acoes de dominio e orquestracao de estado de telas.
- `contexts`: providers React; hooks de consumo ficam em `src/hooks` para preservar Fast Refresh.
- `domain`: dados e regras estaveis de dominio frontend, como categorias de loteria.
- `features`: regras de feature sem UI, como templates, validacao de estrategias e mapeamento de apostas geradas.
- `components`: UI e layout.
- `strategies`: schema/registry das estrategias.
- `types`: contratos TypeScript de API e estrategia.
- `styles`: SCSS global por area/componente.

### Dashboard frontend

Depois da refatoracao de 2026-05-13, `DashboardPage` ficou como composicao de layout. Estado e efeitos do dashboard vivem em `useDashboardState`, enquanto o fluxo de configuracao/geracao de estrategias vive em `useStrategyBuilder`.

Regras puras extraidas:

- `features/dashboard/generatedBetGroups.ts`: merge, substituicao granular por `betIds` e adaptacao de `GenerateResponseDto`.
- `features/strategies/strategyFactory.ts`: criacao, clone e conversao de apostas manuais para `manual`.
- `features/strategies/strategyTemplates.ts`: leitura/escrita de templates locais e extracao de estrategias manuais/regulares.
- `features/strategies/strategyValidation.ts`: validacao client-side antes de chamar `/generate`.

## Principais fluxos

- Auth: [[Auth]].
- Geracao e lotes: [[LoteService]] + [[GenerateService]].
- Sorteios historicos: [[LotteryDraws]].
- Persistencia: [[Repositories]].
- Contratos HTTP: [[DTOs]].

## Inconsistencias conhecidas

- As notas antigas pediam SCSS modules, mas o codigo atual usa SCSS global.
- Alguns componentes de landing ainda usam inline styles.
- Diagramas em `lotojogo-front-end/diagrams` podem estar desatualizados em relacao ao backend com repositorios.
- `poolSize` precisa de decisao de produto: quantidade de numeros disponiveis ou quantidade de combinacoes possiveis.
