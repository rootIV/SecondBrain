# LotteryStrategies

Relacionado: [[LotoJogo - MOC]], [[GenerateService]], [[LoteService]], [[DTOs]], [[Frontend]], [[LotteryDraws]].

## Base historica

[[LotteryDraws]] guarda sorteios anteriores das modalidades suportadas. A base e usada para insights e otimizacao estatistica, mas ainda nao substitui os algoritmos centrais de geracao.

Uso atual:

- `StrategyOptimizerService` usa percentis/faixas de soma, paridade, altos/baixos, primos, multiplos, finais, F1/F2/F3 e frequencia de dezenas para sugerir campos especificos das estrategias.
- A otimizacao nao trata sorteios anteriores como unica fonte de verdade: ela combina distribuicoes historicas com uma gama mais ampla de alternativas validas para evitar sugestoes repetidas demais.
- `BetInsightService` calcula estatisticas de uma aposta gerada: frequencia media das dezenas no historico, comparacao com o ultimo sorteio e se a combinacao ja cobriu algum sorteio anterior.
- A UI apresenta essas estatisticas como apoio de leitura, nao como garantia de resultado. O painel de otimizacao tambem mostra detalhes da base analisada e da configuracao sugerida.

## Estrategias atuais

Backend `GenerateService` suporta:

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

Frontend tambem modela:

- `most_frequent`
- `less_frequent`

Essas duas aparecem no frontend, mas nao possuem case especifico no `GenerateService`; o backend agora rejeita tipos desconhecidos em vez de gerar `random`.

## Contrato de config

O frontend define configs em `src/types/Strategy.ts` e schemas em `src/strategies/Schema.ts`.

O backend recebe:

```text
GenerateRequest
  Category
  MaxNumbers
  Strategies: List<StrategyConfig>

StrategyConfig
  Type
  Config: JsonElement
```

## Estrategias salvas

- Backend agora tambem possui templates de estrategia em `/StrategyTemplates`.
- `StrategyTemplate` persiste nome, categoria e uma lista ordenada de estrategias.
- `StrategyTemplateStrategy` persiste `type`, `config_json` e `sortOrder`, sem gerar apostas por si so.
- Templates sao separados por usuario autenticado e podem ser usados pela UI para recarregar `StrategyInstance[]`.

## Combinacoes de estrategias

- `config.combinations` permite adicionar filtros em modo E sobre a mesma aposta.
- Backend combina estrategia principal com `fibonacci`, `exclude_number`, `max_sequence`, `prime_count`, `multiple_count`, `ending_digit` e `range_count`.
- `fibonacci` usa incidencia exata: por exemplo `sum = 200` com `fibonacci.incidence = 3` gera apostas cuja soma e 200 e que contem exatamente 3 numeros de Fibonacci.
- `prime_count`, `multiple_count` e `ending_digit` tambem usam contagem exata.
- `range_count` usa minimo/maximo de incidencias dentro de uma faixa.
- `f1f2f3` usa tres faixas sequenciais com incidencia exata por faixa.
- Nao e permitido combinar uma estrategia com outra do mesmo tipo.
- Nao e permitido repetir o mesmo tipo de combinacao na mesma estrategia.
- `manual` nao pode ser usada como filtro combinado.
- Apostas manuais podem ser salvas em templates como estrategias `manual`.
- Regenerar uma aposta `sum` usa [[GenerateService]] com busca randomizada, mantendo a soma/filtros validos e permitindo novas combinacoes para o mesmo lote.
- Estrategias combinadas devem retornar exatamente a quantidade de apostas solicitada. Se a intersecao dos filtros nao permite uma aposta fiel aos parametros, [[GenerateService]] retorna erro de configuracao em vez de uma lista vazia ou parcial.

## Validacoes de consistencia

- Frontend valida antes de chamar `/Generate`; a regra fica em `features/strategies/strategyValidation.ts`.
- Backend valida novamente em [[GenerateService]] e retorna erro 400 para configuracoes impossiveis.
- `StrategyRequestValidator` rejeita tipo desconhecido, config JSON grande/profunda e `bets` acima do limite antes de chamar a geracao.
- Validacoes cobrem dezenas/apostas zeradas, soma impossivel para a quantidade de dezenas, contagens exatas maiores que o universo disponivel, exclusoes que deixam poucas dezenas, faixas invalidas e combinacoes repetidas.
- Exemplo bloqueado: `sum = 200` com `numbers = 1`, porque uma dezena unica nunca pode somar 200 na modalidade.
- Exemplo bloqueado: `sum = 9` em universo `1..5` com exclusao de `[4, 5]`, porque a unica combinacao de soma 9 com 2 dezenas deixa de existir depois do filtro.

## Saved Strategies legado/planejado

- Saved Strategies persistem uma lista de `items`, cada item com `type`, `config`, `sortOrder` e `isEnabled`.
- O frontend carrega essas configs para o estado local do `HomeTab` como `StrategyInstance[]`.
- O modo salvo atual usado pela UI e `independent`.
- `combined` em Saved Strategies ainda depende de integracao com a UI; a geracao combinada por `config.combinations` ja existe no fluxo de gerar apostas.

## Templates locais no frontend

- O painel do `load-strategy-button` foi conectado ao CRUD backend `/StrategyTemplates`.
- A montagem do payload de templates fica em `features/strategies/strategyTemplates.ts`.
- Templates locais podem salvar/restaurar estrategias regulares e apostas manuais convertidas em estrategia `manual`.
- `StrategyTemplates` e `StrategyTemplateStrategies` continuam sendo as tabelas efetivas para presets de estrategia, incluindo quantidade de dezenas e apostas dentro de cada `config`.

## poolSize

`LoteService.ComputePoolSize` calcula combinacoes possiveis para varias estrategias.

Para estrategias combinadas, se o espaco de busca bruto ultrapassar o limite seguro de enumeracao, o backend retorna `int.MaxValue` para evitar travar CPU contando combinacoes uma a uma.

Inconsistencia atual:

- UI exibe `poolSize` como "disponiveis".
- Um teste ainda espera `25 - excluidos`.
- Backend atual retorna combinacoes, por exemplo `C(20, 15) = 15504` em `exclude_number`.

Decisao pendente: renomear UI para "combinacoes" ou voltar `poolSize` para "numeros disponiveis".
