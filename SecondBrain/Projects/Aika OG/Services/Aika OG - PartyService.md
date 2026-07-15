# Aika OG - PartyService

Atualizado em 2026-07-14.

## Escopo implementado

- Party runtime de ate 6 membros com convite, aceite/rejeicao, expiracao de 30s, sair, kick, disband, transferencia de lider e alocacao EXP/item.
- Protocolo jogavel roteado no `PacketDispatcher`: `0x322`, `0x323`, `0x324`, `0x325`, `0x326`, `0x338`, `0x34B`; coordenadas de membro por `0x11D`.
- `SessionManager.RemoveSession` aciona cleanup de party antes de desassociar character, permitindo refresh para membros restantes.
- `PartyPacketFactory` escreve `0x326` fixo com capacidade maxima de 6 membros; overflow e erro de contrato.

## Integracao com templaria

- `PartyDamageService` usa `PartyService.GetPartyByCharacter` para validar Uniao Divina.
- Uniao Divina (`1217..1232`) requer membro vivo da mesma party e em range, grava `LinkedCharacterId`, aplica bonus de resistencia e redireciona 30% do dano recebido pelo aliado.
- O redirect acumula em `ActiveBuffEntity.AccumulatedValue` e para no cap runtime atual de `2680`.
- Links invalidos sao removidos no lifecycle quando o alvo sai da party, morre, desconecta ou sai de range.

## Cuidados

- Party ainda e runtime/in-memory; persistencia duravel de party nao faz parte do escopo atual.
- Packets e offsets de party seguem layout inspirado no Rafinha e devem ser tratados como contrato do cliente.
- PvP completo, loot de party e EXP de party ainda nao foram implementados.
