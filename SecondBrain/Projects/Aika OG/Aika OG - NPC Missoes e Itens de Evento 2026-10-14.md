---
tags:
  - project/aika-og
  - npc
  - protocol
updated: 2026-10-14
---

# Aika OG - NPC Missoes e Itens de Evento 2026-10-14

Relacionado: [[Aika OG - NPC Spawn]], [[Aika OG - PacketDispatcher e Protocolo]], [[Aika OG - Sistemas Nativos 2026-10-14]].

- Opção 2 deve listar missões com `0x112`: opção em offset 12, ID da missão em offset 16, título em 20. Opção 21 retorna ao menu. Não usar ID do NPC como fallback para `0x111`, pois pode selecionar conversa da Pran no cliente.
- `Quests.csv` associa conexão NPC a ID da missão e nível mínimo. O campo NPC de `Quest.bin` é outro identificador. Cliente atual: registros cifrados de 2696 bytes; referência `Data/Quest.bin`: registros simples de 2332 bytes.
- A lista de NPCs contém origens com `ClientId` repetido (2707 foi confirmado). Usar agrupamento/lookup ao enriquecer o catálogo; nunca `ToDictionary(ClientId)` nem apagar a entidade de outra origem para deduplicar.
- Símbolo de missão no spawn `0x349`: byte **93**, lido em `FUN_0049b290` e renderizado em `FUN_005fad90`. Tipos 8/9/11/2 conforme missão, por personagem. Preservar glyph de salvar localização em offset 494/valor50. Não confundir o byte baixo do WORD92 com o marcador.
- Aceitar/progredir/concluir missões ainda não está implementado. O filtro atual representa somente nível mínimo, sem pré-requisitos ou conclusão; detalhes avisam a limitação. Não conceder recompensas de um catálogo parcial.
- `0x359` é coleta de itens de evento: request16, ACK sinal12. Fonte `PlayerThread.ReceiveEventItem` e `Player.GetAllEventItems`. A fila local usa `characterItem.slotType=17`, pertencente ao personagem. Transferir fila/inventário em transação, preservar identidade e vencimento, não gerar o item diário da referência sem um evento configurado.
- Commit incerto de entrega deve bloquear persistência até reconciliação. Nunca repetir entrega em memória sem prova do resultado SQL.

Relatório verificável no projeto: `docs/operations/NPC-QUESTS-EVENTS-2026-10-14.md`. Testes `NpcQuestRegressionTests` e `EventItemRegressionTests`.
