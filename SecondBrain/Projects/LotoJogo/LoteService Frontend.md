# LoteService Frontend

Relacionado: [[Frontend]], [[LoteService]], [[ApiService Frontend]], [[DTOs]].

Arquivos:

- `lotojogo-front-end/src/services/lote.service.ts`
- `lotojogo-front-end/src/hooks/useLotes.ts`
- `lotojogo-front-end/src/hooks/useLoteDetail.ts`
- `lotojogo-front-end/src/hooks/useLoteMutations.ts`

## Responsabilidade

Encapsula endpoints de lotes e apostas no frontend e integra com React Query.

## Endpoints

- `GET /Lotes`
- `GET /Lotes/{loteId}`
- `POST /Lotes/{loteId}/bets/{betId}/regenerate`
- `DELETE /Lotes/{loteId}/bets/{betId}`
- `DELETE /Lotes/{loteId}/bets/{betId}?permanent=true`
- `POST /Lotes/{loteId}/bets/{betId}/restore`
- `DELETE /Lotes/{loteId}/trash`
- `DELETE /Lotes/{loteId}`

## Cache

- `lotesKey = ["lotes"]`
- `loteDetailKey(loteId)`
- Mutacoes invalidam lista e detalhe.
- Delete de lote remove a query de detalhe.
