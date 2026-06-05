# Repository Pattern

Relacionado: [[Repositories]], [[LoteRepository]], [[UserRepository]], [[Backend]].

## Estado atual no LotoJogo

Repositories escondem EF Core dos services principais.

Contratos:

- `ILoteRepository`
- `IUserRepository`

Implementacoes:

- [[LoteRepository]]
- [[UserRepository]]

## Regra pratica

Services devem depender de interfaces de repositorio quando precisam buscar ou persistir dados.

Evitar:

- injetar `AppDbContext` diretamente em service de caso de uso;
- espalhar `Include`/`ThenInclude` fora da infraestrutura;
- retornar entidades EF diretamente de controllers.
