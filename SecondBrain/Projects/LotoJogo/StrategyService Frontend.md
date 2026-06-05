# StrategyService Frontend

Relacionado: [[Frontend]], [[LotteryStrategies]], [[GenerateService]], [[DTOs]].

Arquivos:

- `lotojogo-front-end/src/services/strategy.service.ts`
- `lotojogo-front-end/src/strategies/Schema.ts`
- `lotojogo-front-end/src/strategies/StrategyRegistry.ts`
- `lotojogo-front-end/src/types/Strategy.ts`
- `lotojogo-front-end/src/features/strategies/strategyFactory.ts`
- `lotojogo-front-end/src/features/strategies/strategyTemplates.ts`
- `lotojogo-front-end/src/features/strategies/strategyValidation.ts`
- `lotojogo-front-end/src/services/strategyTemplate.service.ts`

## Responsabilidade

Representa as estrategias disponiveis no frontend, seus schemas e componentes de configuracao.
Tambem concentra chamadas HTTP relacionadas a strategies:

- `generateBets` envia estrategias para `/generate`.
- `strategyService.listSavedStrategies` chama `GET /api/strategies`.
- `strategyService.getSavedStrategy` chama `GET /api/strategies/{id}`.
- `strategyService.createSavedStrategy` chama `POST /api/strategies`.
- `strategyService.updateSavedStrategy` chama `PUT /api/strategies/{id}`.
- `strategyService.deleteSavedStrategy` chama `DELETE /api/strategies/{id}`.
- `strategyTemplateService.list/create/update/delete` chama o CRUD `/StrategyTemplates`.
- `api.service.ts` lança erro para respostas HTTP nao-2xx usando `message` ou `title` do backend quando existir.

## Tipos modelados

- `random`
- `sum`
- `odd_even`
- `most_frequent`
- `less_frequent`
- `high_low`
- `fixed_number`
- `exclude_number`
- `manual`
- `prime_count`
- `multiple_count`
- `ending_digit`
- `range_count`
- `f1f2f3`

## Regras extraidas

- `strategyFactory.ts`: cria `StrategyInstance`, clona estrategias e transforma apostas manuais em estrategia `manual`.
- `strategyTemplates.ts`: monta payloads de templates, preserva configuracoes e converte estrategias `manual` entre template e apostas manuais.
- `strategyValidation.ts`: valida configuracoes client-side antes de `generateBets`.
- `StrategyRegistry.ts` tipa os componentes dinamicos sem `React.ComponentType<any>`.

## Ponto de atencao

Nem todo tipo do frontend tem algoritmo correspondente no backend. Ver [[LotteryStrategies]] e [[GenerateService]].
O editor inicial de estrategias salvas usa JSON para `items`; uma UI estruturada deve reaproveitar os minicards existentes numa fase futura.
