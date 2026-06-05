# AuthService Frontend

Relacionado: [[Frontend]], [[Auth]], [[ApiService Frontend]], [[AuthService]].

Arquivos:

- `lotojogo-front-end/src/services/auth.service.ts`
- `lotojogo-front-end/src/hooks/useAuthActions.ts`
- `lotojogo-front-end/src/hooks/useUser.tsx`
- `lotojogo-front-end/src/contexts/AuthContext.tsx`
- `lotojogo-front-end/src/routes/ProtectedRoute.tsx`

## Responsabilidade

Organiza as chamadas e estado de auth no frontend.

## Fluxo atual

- Login chama `POST /Auth/login`.
- Google login chama `POST /Auth/google`.
- Register chama `POST /Auth/register`.
- Logout chama `POST /Auth/logout`.
- `useUser` chama `GET /Auth/me`.
- `AuthContext` calcula `isAuthenticated` a partir da query `["me"]`.
- `ProtectedRoute` redireciona para `/loginPage` quando nao autenticado.

## Ponto de atencao

`auth.service.ts` declara `LoginResponse { token: string }`, mas o backend retorna `{ success: true }` e usa cookie HTTP-only. Preferir alinhar esse tipo ao contrato real.
