# AuthService

Relacionado: [[Auth]], [[Backend]], [[UserRepository]], [[GoogleAuthService]], [[TokenProtectorService]], [[DTOs]].

Arquivo: `lotojogo-back-end/Services/AuthService.cs`.

## Responsabilidade

Implementa os casos de uso de autenticacao e emissao de tokens.

## Dependencias

- `IUserRepository`
- `IOptions<JwtSettings>`
- [[GoogleAuthService]]
- `ITokenProtector` via [[TokenProtectorService]]
- `TimeProvider`

## Fluxos

### Register

- Normaliza e-mail.
- Verifica existencia por [[UserRepository]].
- Gera hash BCrypt da senha.
- Persiste `User`.
- Retorna `null` quando o e-mail ja existe.
- Trata corrida de indice unico de e-mail como fluxo neutro, retornando `null`.

### Login

- Normaliza e-mail.
- Busca usuario por e-mail.
- Trata usuario inexistente ou Google-only como falha.
- Usa BCrypt para validar senha.
- Emite access token JWT e refresh token via `IssueTokensAsync`.

### Refresh

- Recebe refresh token bruto vindo do cookie.
- Calcula SHA-256.
- Busca usuario com hash e expiracao valida.
- Emite novo par de tokens, rotacionando refresh token.

### Logout

- Limpa `RefreshTokenHash` e `RefreshTokenExpiry` do usuario.

### Login com Google

- Usa [[GoogleAuthService]] para trocar `code` por tokens e validar `id_token`.
- Exige e-mail verificado.
- Cria usuario novo ou vincula `GoogleId`.
- Criptografa tokens do Google com [[TokenProtectorService]].
- Emite cookies por meio do controller.

## Claims do access token

- `sub`
- `ClaimTypes.NameIdentifier`
- `ClaimTypes.Name`
- `ClaimTypes.Email`

## Observacoes

- Refresh token e armazenado como hash SHA-256, nao em texto puro.
- Tokens do Google sao armazenados criptografados em `UserGoogleTokens`.
- O service usa `TimeProvider`; o controller ainda usa `DateTime.UtcNow` para expiracao de cookie.
