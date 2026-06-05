# UserRepository

Relacionado: [[Repositories]], [[Auth]], [[AuthService]], [[Backend]].

Arquivo: `lotojogo-back-end/Infrastructure/Repositories/UserRepository.cs`.

## Responsabilidade

Implementa `IUserRepository` usando EF Core e `AppDbContext`.

## Queries

- `ExistsByEmailAsync`
- `GetByEmailAsync`
- `GetByEmailWithGoogleTokensAsync`
- `GetByRefreshTokenHashAsync`
- `GetByIdAsync`

As queries por e-mail comparam contra o e-mail ja normalizado salvo no banco, permitindo uso do indice unico em `Users.email`.

## Comandos

- `Add`
- `SaveChangesAsync`

## Uso

Usado por [[AuthService]] para register, login, refresh, logout e login com Google.
