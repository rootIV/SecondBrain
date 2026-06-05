# GenerateService

Relacionado: [[LoteService]], [[LotteryStrategies]], [[DTOs]], [[Tests]].

Arquivo: `lotojogo-back-end/Services/GenerateService.cs`.

## Responsabilidade

Gera listas de numeros para cada estrategia de loteria.

## Entrada

- `maxNumbers`: limite superior da categoria.
- `StrategyConfig.Type`: tipo da estrategia.
- `StrategyConfig.Config`: JSON com parametros como `numbers`, `bets`, `numbersList`, `odd`, `even`, `high`, `low`, `sum`, `min`, `max` e `combinations`.

## Estrategias suportadas

- `random`
- `sum`
- `odd_even`
- `high_low`
- `fixed_number`
- `exclude_number`
- `prime_count`
- `multiple_count`
- `ending_digit`
- `range_count`
- `f1f2f3`
- `manual`

## Operacoes

- `Generate`: gera multiplas apostas para uma lista de estrategias.
- `GenerateOne`: forca `bets = 1` e gera uma aposta para regeneracao.
- `config.combinations`: aplica filtros combinados em modo E sobre a aposta candidata.
- `ValidateStrategy`: bloqueia configuracoes sem apostas/dezenas, combinacoes repetidas e cenarios impossiveis antes da geracao.

## Observacoes

- `sum` usa busca recursiva e aceita predicado combinado para encontrar uma aposta que satisfaca a soma e todos os filtros.
- Regeneracao de `sum` randomiza a ordem de busca antes de resolver a combinacao, para que `GenerateOne` possa retornar outra aposta valida em vez de repetir sempre a primeira solucao.
- `fixed_number` remove duplicadas e filtra numeros fora do intervalo.
- `manual` retorna uma unica aposta baseada em `numbersList`.
- Tipos desconhecidos geram `InvalidStrategyConfigurationException`.
- `bets` por estrategia tem teto defensivo definido em `SecurityLimits`.
- Combinacoes suportadas: `fibonacci` com incidencia exata, `exclude_number`, `max_sequence`, `prime_count`, `multiple_count`, `ending_digit` e `range_count`.
- Combinacoes invalidas geram `InvalidStrategyCombinationException`, incluindo `manual`, tipo igual ao principal, tipos repetidos e tipos nao suportados.
- Configuracoes semanticamente invalidas geram `InvalidStrategyConfigurationException`.
- `range_count` gera por grupos com um numero de incidencias viavel, evitando depender apenas de tentativas aleatorias.

## Ponto de atencao

O frontend tem `most_frequent` e `less_frequent`, mas o backend ainda nao tem algoritmos especificos para esses tipos.
