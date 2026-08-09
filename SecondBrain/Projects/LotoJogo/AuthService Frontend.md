# AuthService Frontend

Relacionado: [[Frontend]], [[Auth]], [[ApiService Frontend]], [[AuthService]].

Arquivos:

- `lotojogo/src/services/auth.service.ts`
- `lotojogo/src/hooks/useAuthActions.ts`
- `lotojogo/src/hooks/useUser.tsx`
- `lotojogo/src/contexts/AuthContext.tsx`
- `lotojogo/src/routes/ProtectedRoute.tsx`

## Responsabilidade

Organiza as chamadas e estado de auth no frontend.

## Fluxo atual

- Login chama `POST /Auth/login`.
- Google login chama `POST /Auth/google`.
- Register chama `POST /Auth/register`.
- Logout chama `POST /Auth/logout`.
- `useUser` chama `GET /Auth/me`.
- `AuthContext` calcula `isAuthenticated` a partir da query `["me"]`.
- `AuthProvider` fica dentro do `BrowserRouter` para poder ler a rota atual e nao chamar `/Auth/me` em `/login`, `/loginPage`, `/register` e `/registerPage`; sem isso a tela publica de login gera `401` esperado no console antes de existir cookie de sessao.
- `ProtectedRoute` redireciona para `/loginPage` quando nao autenticado.

## Ponto de atencao

`auth.service.ts` declara `LoginResponse { token: string }`, mas o backend retorna `{ success: true }` e usa cookie HTTP-only. Preferir alinhar esse tipo ao contrato real.
