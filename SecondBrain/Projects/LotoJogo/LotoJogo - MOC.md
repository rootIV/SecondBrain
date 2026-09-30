# LotoJogo - MOC

Mapa de conhecimento do projeto LotoJogo, atualizado a partir do codigo em `C:\Projetcts\Lotojogo`.

Workspace local:

- Coordenacao: `C:\Projetcts\Lotojogo`
- Frontend React: `C:\Projetcts\Lotojogo\lotojogo`
- Backend .NET: `C:\Projetcts\Lotojogo\lotojogo-api`
- Vault do projeto: `C:\Projetcts\SecondBrain\SecondBrain\Projects\LotoJogo`

## Visao geral

- [[Architecture]]
- [[Backend]]
- [[Frontend]]
- [[Docker]]
- [[Tests]]
- [[Agent Context Rules]]
- [[Decision Log]]
- [[Known Issues]]

## Backend

- [[Auth]]
- [[Repositories]]
- [[DTOs]]
- [[LotteryStrategies]]
- [[LotteryDraws]]
- [[AuthService]]
- [[GoogleAuthService]]
- [[TokenProtectorService]]
- [[LoteService]]
- [[GenerateService]]

## Frontend

- [[Landing Page Redesign]]
- [[Dashboard Redesign]]
- [[Checkout Mercado Pago]]
- [[ApiService Frontend]]
- [[AuthService Frontend]]
- [[LoteService Frontend]]
- [[StrategyService Frontend]]

## Modalidades

- [[Mega-Sena]]
- [[Quina]]
- [[Lotomania]]
- [[Timemania]]
- [[Time Mania]]
- [[Dia de Sorte]]
- [[Dupla Sena]]

## Observacoes atuais

- A arquitetura backend esta em transicao para Clean Architecture em um unico projeto .NET.
- O frontend usa React Query, hooks e services; desde 2026-09-01, TSX/testes seguem diretorios por componente/pagina e o SCSS BEM fica centralizado em `src/styles`, replicando `components`, `pages`, `features` e `contexts`.
- `poolSize` tem contrato inconsistente: a UI exibe "disponiveis", enquanto o backend calcula combinacoes para varias estrategias.
- O grafo Graphify existe no frontend em `lotojogo/graphify-out/graph.json`; o backend ainda nao possui grafo local.
- O Codex deve consultar este MOC e [[Agent Context Rules]] antes de varreduras amplas no codigo.
