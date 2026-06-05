# LotteryDraws

Relacionado: [[Backend]], [[Repositories]], [[LotteryStrategies]], [[Decision Log]], [[Known Issues]].

## Objetivo

`LotteryDraws` armazena resultados historicos importados das planilhas de sorteios, para uso futuro em estatisticas e estrategias baseadas em combinacoes anteriores.

## Schema

- `LotteryDraws`: `game_type`, `contest_number`, `draw_order`, `draw_date`, `numbers_json`, `numbers_sorted_json`, `source`, `created_at`.
- `LotteryDrawExtras`: `lottery_draw_id`, `key`, `value`.

`draw_order` e `1` por padrao. Em [[Dupla Sena]], guarda `1` e `2` para representar os dois sorteios do mesmo concurso.

## Extras atuais

- `lucky_month`: usado em [[Dia de Sorte]].
- `heart_team`: usado em [[Time Mania]].

## Importacao

O seed fica em `lotojogo-back-end/Data/Seed/lottery-draws.seed.json`.

`LotteryDrawSeedService` importa o JSON de forma idempotente usando a chave logica:

```text
game_type + contest_number + draw_order
```

O seed e executado no startup depois de `db.Database.Migrate()`.
