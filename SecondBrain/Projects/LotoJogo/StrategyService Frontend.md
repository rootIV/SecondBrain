# StrategyService Frontend

Relacionado: [[Frontend]], [[LotteryStrategies]], [[GenerateService]], [[DTOs]].

Arquivos:

- `lotojogo/src/services/strategy.service.ts`
- `lotojogo/src/strategies/Schema.ts`
- `lotojogo/src/strategies/StrategyRegistry.ts`
- `lotojogo/src/types/Strategy.ts`
- `lotojogo/src/features/strategies/strategyFactory.ts`
- `lotojogo/src/features/strategies/strategyTemplates.ts`
- `lotojogo/src/features/strategies/strategyValidation.ts`
- `lotojogo/src/services/strategyTemplate.service.ts`

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

## Finais e faixas nas combinações — 2026-10-09

- `ending_digit` e `range_count` podem se repetir na lista de combinações. Outros tipos continuam únicos; combinar o mesmo tipo da estratégia principal continua bloqueado.
- O editor identifica as regras pelo final/quantidade ou pela faixa/limites. Cada configuração apresenta explicação e exemplo em um bloco com fundo `#101010` (interpretação do pedido `#10101`, que não é um hex CSS válido).
- `NumericTextInput.maxValue` limita a digitação e o estado ao máximo permitido. Para finais, o limite considera o universo da modalidade, a quantidade de dezenas e as exclusões. Lotofácil/final 4 permite até 3: 4, 14 e 24. Alterar o final também reduz a quantidade quando necessário.
- `combinationCompatibility.ts` verifica conjuntamente finais, faixas sobrepostas, exclusões e números fixos. O editor mostra conflito e `strategyValidation.ts` impede a geração quando não existe seleção compatível. Uma busca limitada a 50 mil estados preserva a responsividade; casos excessivamente complexos são rejeitados com orientação para simplificar as faixas.
- `GenerateService.ReadCombinations` libera apenas os dois tipos repetíveis. A prova de capacidade já existente no backend continua verificando todos os filtros juntos.
- Verificação: 29 testes focados do frontend; 491 testes no projeto `lotojogo-api.Tests`; lint/build; Chromium nos temas claro/escuro de 320 a 2560 px com APIs de quota simuladas. A suíte completa do frontend teve 335 testes aprovados e duas asserções antigas em `DashboardWorkQueue.test.tsx` (esperam “Estratégias configuradas”/“Pronto para gerar”; o modelo atual usa “Configuradas”/“Pronta”).

## Ponto de atencao

Nem todo tipo do frontend tem algoritmo correspondente no backend. Ver [[LotteryStrategies]] e [[GenerateService]].
O editor inicial de estrategias salvas usa JSON para `items`; uma UI estruturada deve reaproveitar os minicards existentes numa fase futura.
