# Repositories

Relacionado: [[LotoJogo - MOC]], [[Backend]], [[LoteRepository]], [[UserRepository]], [[LoteService]], [[AuthService]].

## Padrao atual

Contratos ficam em `lotojogo-back-end/Application/Interfaces`:

- `ILoteRepository`
- `IUserRepository`
- `IStrategyTemplateRepository`

Implementacoes EF Core ficam em `lotojogo-back-end/Infrastructure/Repositories`:

- [[LoteRepository]]
- [[UserRepository]]
- `StrategyTemplateRepository`
- `LotteryDrawRepository`
- `RepositoryCache`

## Responsabilidade

Repositories concentram queries EF, includes, adds/removes e `SaveChangesAsync`.

Services devem depender de interfaces, nao de `AppDbContext`.

## Master, slave e cache

- `AppDbContext` e o contexto master para escritas, migrations, seed e fluxos que modificam entidades carregadas.
- `ReadOnlyAppDbContext` e o contexto slave para consultas read-only.
- `LoteRepository.GetByUserWithStrategiesAndBetsAsync`, `StrategyTemplateRepository.GetByUserAsync(userId)` e `LotteryDrawRepository.GetRecentByGameTypeAsync` usam slave e cache em memoria.
- `UserRepository.ExistsByEmailAsync` usa slave para uma checagem read-only; o cadastro ainda depende do indice unico no master para resolver corrida de email duplicado.
- Metodos que retornam entidades para mutacao continuam no master, incluindo refresh/login, templates por id, bets e detalhe de lote usado por lixeira.
- `SaveChangesAsync` invalida o token do `RepositoryCache`, expirando entradas read-only sem limpar caches alheios da aplicacao.

## UserRepository

- Consultas por e-mail usam o valor normalizado salvo em `Users.email`.
- `Users.email` agora tem tamanho maximo 255 e indice unico via migration `AddUserEmailSecurityConstraints`.
- `Users.name` agora tem tamanho maximo 120.
- [[AuthService]] ainda normaliza e-mail antes de consultar/salvar e trata corrida de cadastro duplicado retornando fluxo neutro.

## LotteryDrawRepository

- Consulta chaves existentes de [[LotteryDraws]] por `game_type`, `contest_number` e `draw_order`.
- Adiciona lotes de sorteios historicos para o seed idempotente.
- Mantem `AppDbContext` restrito a infraestrutura.

## StrategyTemplateRepository

- Lista templates por `user_id`, ordenando por `UpdatedAt` decrescente.
- Carrega `StrategyTemplate.Strategies` via include para CRUD completo.
- Remove estrategias filhas explicitamente para manter compatibilidade com o provider InMemory nos testes.

## Limite arquitetural atual

As interfaces ainda retornam entidades de `Models` (`User`, `Lote`, `Bet`, `LoteStrategy`). Isso e aceitavel no estado atual do projeto, mas ainda acopla Application aos modelos persistidos.

Proximo passo se quiser uma Clean Architecture mais rigida:

- mover entidades de dominio para `Domain`;
- separar DTOs de entidades;
- fazer repositorios retornarem agregados ou modelos de dominio, nao objetos EF de infraestrutura.
