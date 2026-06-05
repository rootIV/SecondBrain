# LoteService

Relacionado: [[Backend]], [[GenerateService]], [[LoteRepository]], [[DTOs]], [[LotteryStrategies]], [[Tests]].

Arquivo: `lotojogo-back-end/Services/LoteService.cs`.

## Responsabilidade

Orquestra os casos de uso de lotes e apostas do usuario autenticado.

## Dependencias

- `ILoteRepository`
- [[GenerateService]]
- `TimeProvider`

## Operacoes

- `GenerateAsync`: encontra ou cria o lote do dia no fuso do Brasil, gera estrategias/apostas e retorna `GenerateResponseDto`.
- `GetSummariesAsync`: lista lotes do usuario com total de apostas vivas, lixeira e categorias.
- `GetDetailAsync`: retorna estrategias vivas e lixeira de um lote.
- `RegenerateBetAsync`: gera novos numeros para uma aposta existente, exceto se estiver na lixeira.
- `SoftDeleteBetAsync`: marca aposta como lixeira.
- `RestoreBetAsync`: restaura aposta da lixeira.
- `HardDeleteBetAsync`: remove definitivamente uma aposta ja na lixeira.
- `EmptyTrashAsync`: remove todas as apostas na lixeira de um lote.
- `DeleteLoteAsync`: remove lote, estrategias e apostas.

## DTO mapping

`MapStrategy` converte `LoteStrategy` para `StrategyDto`, desserializando:

- `NumbersJson` para `int[]`;
- `ConfigJson` para `JsonElement`.

## poolSize

`ComputePoolSize` calcula combinacoes possiveis para estrategias como `random`, `sum`, `odd_even`, `high_low`, `fixed_number`, `exclude_number` e `manual`.

Para estrategias com `config.combinations`, o calculo corta buscas combinatorias acima do limite seguro e retorna `int.MaxValue`.

Ponto pendente: o nome `poolSize` e a UI ainda sugerem "disponiveis", mas o calculo atual e de combinacoes.

## Erros de dominio

Lanca:

- `LoteNotFoundException`
- `BetNotFoundException`
- `BetAlreadyTrashedException`
- `BetNotTrashedException`
