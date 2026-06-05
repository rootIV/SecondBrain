# LotoJogo - MOC

Mapa de conhecimento do projeto LotoJogo, atualizado a partir do codigo em `C:\Users\Vitor\Documents\Projects\lotojogo`.

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

- [[Dashboard Redesign]]
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
- O frontend usa React Query, hooks e services, mas ainda usa SCSS global em vez de SCSS modules.
- `poolSize` tem contrato inconsistente: a UI exibe "disponiveis", enquanto o backend calcula combinacoes para varias estrategias.
