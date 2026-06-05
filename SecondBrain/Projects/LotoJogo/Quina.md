# Quina

Relacionado: [[LotteryStrategies]], [[LotteryDraws]], [[DTOs]], [[Known Issues]].

## Contexto

Modalidade de loteria modelada no LotoJogo com universo numerico de 80 dezenas.

## Pontos de atencao

- O limite defensivo backend `SecurityLimits.MaxNumbersUniverse` deve aceitar universo acima de 60 para cobrir esta modalidade.
- Validacoes de `GenerateRequest.MaxNumbers` e `StrategyOptimizationRequest.MaxNumbers` nao devem assumir Mega-Sena como teto global.

## Lacunas

- Confirmar se o backend deve validar `maxNumbers` exatamente por categoria em vez de usar apenas teto global.
