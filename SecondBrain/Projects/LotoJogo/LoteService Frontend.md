# LoteService Frontend

Relacionado: [[Frontend]], [[LoteService]], [[ApiService Frontend]], [[DTOs]].

Arquivos:

- `lotojogo/src/services/lote.service.ts`
- `lotojogo/src/hooks/useLotes.ts`
- `lotojogo/src/hooks/useLoteDetail.ts`
- `lotojogo/src/hooks/useLoteMutations.ts`

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
