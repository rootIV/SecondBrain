# Clean Architecture

Relacionado: [[Architecture]], [[Backend]], [[Repositories]], [[DTOs]].

## Estado atual no LotoJogo

O projeto aplica Clean Architecture de forma pragmatica em um unico projeto .NET.

Separacoes atuais:

- Controllers fazem adaptacao HTTP.
- Services concentram casos de uso.
- Application/Interfaces define contratos de repositorio.
- Infrastructure/Repositories implementa persistencia EF Core.
- Data contem `AppDbContext`.

## Limites atuais

- Entidades, DTOs e requests ainda vivem juntos em `Models`.
- Interfaces de repositorio retornam entidades concretas usadas pelo EF.
- Migration e seed rodam em `Program.cs` com acesso direto ao `AppDbContext`.

## Proximo nivel

Separar projetos ou pastas mais rigidas:

- Domain
- Application
- Infrastructure
- Api
