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

O seed fica em `lotojogo-api/Data/Seed/lottery-draws.seed.json`.

`LotteryDrawSeedService` importa o JSON de forma idempotente usando a chave logica:

```text
game_type + contest_number + draw_order
```

No import, `game_type` e normalizado pelo `LotteryGameCatalog`. Aliases legados do seed (`loto_mania`, `time_mania`, `dia_sorte`) sao tratados como `lotomania`, `timemania` e `dia_de_sorte`; o repositorio tambem consulta aliases para preservar bancos existentes.

O seed e executado no startup depois de `db.Database.Migrate()`.

## Cobertura

`GET /Admin/lottery-draws/coverage` retorna cobertura por modalidade, quantidade de linhas existentes, maior concurso, concursos faltantes, ordens faltantes e amostras dos primeiros gaps. Em 2026-08-08, o seed local cobre de forma contigua `loto_facil`, `mega_sena`, `quina`, `lotomania`, `dupla_sena`, `dia_de_sorte` e `timemania`; o concurso 1623 da Timemania foi preenchido manualmente com numeros oficiais confirmados. `super_sete` ainda tem apenas o concurso 880 no seed e `mais_milionaria` ainda tem apenas o concurso 376.

`POST /Admin/lottery-draws/import-caixa` aceita todas as modalidades do `LotteryGameCatalog`, usa `OfficialCaixa:ContestUrlTemplate` com `{slug}` e `{contest}`, reutiliza o parser normalizado dos providers e limita cada request a 500 concursos para evitar importacoes longas demais em uma chamada.

## Pendencias de fonte externa

- Em 2026-08-08, tentativas de preencher `super_sete` 1-879 e `mais_milionaria` 1-375 pela API oficial da Caixa foram interrompidas por respostas `429` e depois `403` no edge Azion/ShieldSquare para o IP local. Nao insistir em loop de requests quando isso ocorrer; aguardar desbloqueio ou usar o endpoint oficial de download de resultados se estiver acessivel.
- A pagina oficial da Caixa usa `/api/resultados/download?modalidade=...` via `download-resultados.js`, mas o acesso local ao parametro/download tambem pode ser bloqueado pelo antibot.
