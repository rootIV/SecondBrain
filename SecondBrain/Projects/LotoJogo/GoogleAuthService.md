# GoogleAuthService

Relacionado: [[Auth]], [[AuthService]], [[TokenProtectorService]], [[Backend]].

Arquivo: `lotojogo-back-end/Services/GoogleAuthService.cs`.

## Responsabilidade

Integra com Google OAuth para login social.

## Dependencias

- `HttpClient`
- `IOptions<GoogleOAuthSettings>`
- `Google.Apis.Auth`

## Operacoes

- `ExchangeCodeAsync`: envia `authorization_code` para o endpoint de token do Google.
- `ValidateIdTokenAsync`: valida `id_token` com audiencia igual ao `ClientId` configurado.

## Erros tratados

- `InvalidGoogleCodeException`: Google retornou erro 4xx.
- `GoogleApiException`: falha HTTP, 5xx, body invalido ou resposta sem `id_token`.
- `InvalidGoogleIdTokenException`: `id_token` invalido.

## Saida

Retorna `GoogleTokenResponse` com:

- `IdToken`
- `AccessToken`
- `RefreshToken`
- `ExpiresIn`
- `Scope`
- `TokenType`
