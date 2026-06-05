# ApiService Frontend

Relacionado: [[Frontend]], [[Auth]], [[AuthService Frontend]], [[LoteService Frontend]].

Arquivo: `lotojogo-front-end/src/services/api.service.ts`.

## Responsabilidade

Wrapper HTTP central do frontend.

## Comportamento

- Usa `VITE_API_BASE_URL` ou fallback `https://127.0.0.1:7178`.
- Sempre envia `credentials: include`.
- Define `Content-Type: application/json`.
- Em 401 fora de `/Auth/me`, tenta `POST /Auth/refresh`.
- Reexecuta a request original depois do refresh.
- Se refresh falha ou a segunda tentativa retorna 401, redireciona para `/loginPage`.
- Em `/Auth/me`, 401 vira erro `Not authenticated` sem refresh loop.
- Em 204, retorna `undefined`.
- Generics agora usam `unknown` por padrao; chamadas que sabem o contrato devem passar o tipo esperado, como `api.get<AuthUser>("/Auth/me")`.

## API exposta

- `api.get`
- `api.post`
- `api.put`
- `api.patch`
- `api.delete`

## Pontos de atencao

- O refresh e compartilhado por `refreshPromise` para evitar multiplas chamadas simultaneas.
