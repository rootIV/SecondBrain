# LoteRepository

Relacionado: [[Repositories]], [[LoteService]], [[Backend]].

Arquivo: `lotojogo-back-end/Infrastructure/Repositories/LoteRepository.cs`.

## Responsabilidade

Implementa `ILoteRepository` usando EF Core e `AppDbContext`.

## Queries principais

- `GetOrCreateForDateAsync`: busca lote do usuario/data ou cria novo. Trata corrida por unique index recarregando o lote.
- `GetByUserWithStrategiesAndBetsAsync`: lista lotes com estrategias e apostas.
- `GetDetailAsync`: carrega lote especifico com estrategias e apostas.
- `GetByUserAsync`: busca lote por owner.
- `GetBetAsync`: busca aposta garantindo lote e usuario.
- `GetStrategiesWithBetsAsync`: carrega estrategias para delecao manual em testes/InMemory.

## Comandos

- `AddStrategy`
- `RemoveBet`
- `RemoveBets`
- `RemoveStrategies`
- `RemoveLote`
- `SaveChangesAsync`

## Observacao

As queries usam `Include`/`ThenInclude`, entao o service recebe grafo de entidades pronto para mapear para DTOs.
