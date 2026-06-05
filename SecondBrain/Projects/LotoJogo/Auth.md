# Auth

Relacionado: [[LotoJogo - MOC]], [[Backend]], [[Frontend]], [[AuthService]], [[GoogleAuthService]], [[TokenProtectorService]], [[UserRepository]], [[ApiService Frontend]], [[AuthService Frontend]].

## Resumo

O sistema de auth usa JWT em cookies HTTP-only, refresh tokens tambem em cookie, login por e-mail/senha e login com Google OAuth.

## Backend

Controller principal: `lotojogo-back-end/Controllers/AuthController.cs`.

Endpoints:

- `POST /Auth/register`: cria usuario quando o e-mail ainda nao existe. Sempre retorna `200` para reduzir enumeracao por status.
- `POST /Auth/login`: valida e-mail/senha, emite cookies `access_token` e `refresh_token`.
- `POST /Auth/google`: troca `code` do Google por tokens, valida `id_token`, cria/vincula usuario e emite cookies.
- `POST /Auth/refresh`: le `refresh_token` do cookie, rotaciona refresh token e emite novo access token.
- `POST /Auth/logout`: exige auth, revoga refresh token no banco e expira cookies.
- `GET /Auth/me`: exige auth e retorna `id`, `email`, `name` vindos das claims.

## Cookies

Os cookies sao criados em `AuthController.AppendAuthCookies`:

- `access_token`: JWT curto, expiracao baseada em `Jwt:ExpiryMinutes`.
- `refresh_token`: valor aleatorio, expiracao de 7 dias.
- `HttpOnly = true`.
- `Secure = true` fora de Development; em Development tambem fica seguro quando `Request.IsHttps`.
- `SameSite = Strict`.
- `Path = /`.

`Program.cs` usa forwarded headers para `X-Forwarded-For` e `X-Forwarded-Proto`, permitindo que o backend reconheca HTTPS atras de proxy reverso.

Em deploy Docker de producao, `ASPNETCORE_ENVIRONMENT=Production` usa cookies `Secure` e `SameSite=Strict`. Portanto, login/refresh exigem HTTPS real no navegador; autenticar usuarios por `http://IP` nao e suportado.

## Segredos

- `Jwt:Key`, `Google:ClientSecret`, connection strings e senha do admin seed nao devem ficar em `appsettings.json`.
- Producao recebe segredos por arquivos Docker secrets lidos pela API via chaves `*_FILE`, ou por AWS Secrets Manager, AWS SSM Parameter Store ou gerenciador externo equivalente. `.env` local deve guardar apenas caminhos/valores nao sensiveis e nunca ser versionado.
- `Google:ClientId` tambem e configurado por ambiente; ele e publico, mas evita acoplamento do build a uma credencial de projeto especifica.
- Chaves do ASP.NET Data Protection devem ficar em volume persistente para nao invalidar tokens/cookies protegidos a cada recriacao do container.
## Limites de abuso

- Endpoints publicos de auth usam `RequestSizeLimit` com o limite de [[Backend|SecurityLimits]].
- Rate limiting de `auth` e particionado por usuario autenticado ou IP.
- `LoginRequest` limita e valida e-mail/senha; `GoogleLoginRequest` limita o tamanho do `code`.
- `RateLimit:AuthPermitLimit` e `RateLimit:AuthWindowSeconds` controlam o limite de auth por ambiente.
- Em producao, usar limite conservador, por exemplo `AUTH_RATE_LIMIT_PERMIT=5`.

## Token flow

```text
Login/Register Google
  -> AuthController
  -> AuthService
  -> UserRepository
  -> TokenResponse
  -> AuthController grava cookies
  -> frontend invalida query ["me"]
```

```text
Request protegida
  -> api.service.ts envia credentials: include
  -> backend JwtBearer le access_token do cookie
  -> controller usa ControllerExtensions.GetUserId()
```

```text
Access token expirado
  -> api.service.ts recebe 401
  -> chama POST /Auth/refresh
  -> retry da request original
  -> se falhar, redireciona para /loginPage
```

## Frontend

- [[ApiService Frontend]] centraliza `credentials: include`, refresh automatico e redirect em 401.
- `useUser` consulta `/Auth/me` com `retry: false`.
- `AuthProvider` transforma `useUser` em `user`, `loading`, `isAuthenticated`.
- `AuthContext` puro fica em `contexts/authContextCore.ts`; o hook consumidor fica em `hooks/useAuth.ts`.
- `useAuthActions` executa login, Google login, register e logout com React Query.
- A tela de cadastro faz `register` e em seguida `login` com as mesmas credenciais, porque o endpoint de register preserva resposta generica e nao autentica automaticamente.
- `ProtectedRoute` bloqueia telas quando `isAuthenticated` e falso.

## Persistencia

Entidades envolvidas:

- `User`: nome, e-mail, hash BCrypt, `GoogleId`, hash/expiracao do refresh token.
- `UserGoogleTokens`: access/refresh token do Google criptografados via Data Protection.

Repositorio:

- [[UserRepository]]

## Riscos e pontos de atencao

- `auth.service.ts` tipa login como se retornasse `token`, mas o backend retorna `{ success: true }` e usa cookies.
- `AuthController` usa `DateTime.UtcNow` para cookies; [[AuthService]] usa `TimeProvider` para tokens.
- Segredos que ja apareceram em arquivos locais devem ser rotacionados no provedor correspondente; remover do codigo nao invalida credencial ja exposta.
- Auth em producao depende de HTTPS real; `http://IP` pode carregar paginas publicas, mas nao deve ser usado para fluxo autenticado.
