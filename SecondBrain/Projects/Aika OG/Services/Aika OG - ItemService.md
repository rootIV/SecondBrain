---
tags:
  - project/aika-og
  - service
  - item
updated: 2026-07-04
---

# Aika OG - ItemService

Relacionado: [[Aika OG - CharacterService]], [[Aika OG - PacketDispatcher e Protocolo]]

Arquivo: `GameServer/Application/Services/ItemService.cs`

## Responsabilidade

`ItemService` agora e uma facade/repository service. Ordenacao de slots, escrita binaria e factory de packet foram separadas para reduzir acoplamento.

Em 2026-07-03 entrou o primeiro corte do sistema de inventario/equipamento baseado na source Delphi.

## Funcoes importantes

- `GetCharacterEquips`: carrega equips via `ItemRepository.GetCharEquipsAsync`.
- `GetCharacterInventory`: carrega inventario via `ItemRepository.GetCharInventoryAsync`.
- `ItemOrderingService`: normaliza inventario em 60 slots, equips em 16 slots e lobby equips em 8 slots.
- `ItemPacketWriter`: escreve equips, inventario e payload detalhado de item no `PacketStream`.
- `ItemPacketFactory`: monta o pacote `0xF0E` de update de item por slot.
- `ItemTemplateService`: carrega `Data\ItemList.bin` e publica templates de item.
- `InitialCharacterInventoryFactory`: monta o inventario inicial de personagem novo.
- `ItemInventoryService`: aplica regras puras de mover, equipar, apagar, agrupar, desagrupar e validar bolsas.
- `ItemHandler`: permanece como entrypoint, parseia os opcodes de item e delega para o servico.

## Dependencias

- `ItemRepository`
- `PacketStream`
- `CharacterEntity`
- `ItemEntity`
- `ItemTemplateEntity`
- `PacketFactory`/`EncDec` apenas na factory de packet.

## Invariantes

- Inventario: 126 slots, incluindo bolsas em `120..125`.
- Equips: 16 slots.
- Lobby equips: 8 slots.
- Slots fora do intervalo sao ignorados/rejeitados conforme a operacao.
- Bolsas do inventario seguem a regra Delphi: `0..19` exige slot `120`, `20..39` exige `121`, `40..59` exige `122`, `60..79` exige `123`, `80..99` exige `124`, `100..119` exige `125`.
- Equip segue `TItemFunctions.GetItemEquipSlot`: `ItemType 0..16` usa o proprio slot, `50/52/102/103` usa slot `15`, `1000..1011/1019` usa slot `6`.

## Inventario inicial

- Personagem novo recebe itens iniciais nos slots `0..5`: `12513`, `12543`, `12573`, `12088`, `12483`, `12333`.
- Slot `120` recebe o marcador de bolsa `5300`, conforme `TPacketHandlers.CreateCharacter` da source Delphi.
- O item no slot `120` libera a primeira pagina da mochila (`0..19`); ele nao e item de conteudo da mochila.
- Slots `121..125` ficam vazios neste corte e serao liberados por mecanica futura.
- `CharacterRepository.CreateCharAsync` persiste tanto equips quanto inventario inicial; antes so persistia equips.
- Refresh de item por login e movimentacao de inventario/equipamento usa `notice=false`, para nao anunciar bolsa ou item ja existente no chat.

## OpCodes C2S roteados

- `0x32C`: apagar item.
- `0x332`: agrupar item.
- `0x333`: desagrupar item.
- `0x70F`: mover/equipar/desequipar item. O payload vem em ordem Delphi `DestType, DestSlot, SrcType, SrcSlot`.

## Swap e stack

- `ItemInventoryService.MoveItem` trabalha com snapshots/clones antes de alterar slots, evitando que o mesmo `ItemEntity` apareca em dois lugares durante swap.
- Inventario -> inventario ocupado:
  - se `ItemId` for igual e `ItemList.bin -> CanAgroup` permitir, agrupa ate `1000`;
  - se passar de `1000`, o destino fica com `1000` e a origem fica com o restante;
  - se nao for agrupavel, troca os dois itens de slot.
- Inventario -> equip ocupado troca o item novo para o equip e move o equip antigo para o slot de origem.
- Equip -> inventario ocupado troca somente se o item do inventario puder equipar no slot de origem.
- `ItemRepository.NormalizeActiveItemsForSave` normaliza itens por `(slotType, slot)` antes do insert, deixando a ultima entrada vencer caso exista duplicata em memoria. Isso blinda o save contra `Duplicate entry ... for key itens.PRIMARY` quando um estado antigo ou uma troca deixa slot duplicado em memoria.
- `ItemHandler.PersistAndRefresh` captura falha de banco ao salvar itens e loga o erro sem derrubar o servidor.

## Anti-spam e durabilidade

- `ItemActionThrottleService` limita spam por personagem + slot de equipamento afetado.
- Equipar/desequipar pecas diferentes do set em sequencia continua permitido.
- Repetir o mesmo slot de equipamento em menos de 1 segundo bloqueia aquele slot por 10 segundos.
- O bloqueio so vale para operacoes que envolvem `ItemSlotType.Equip`; mover inventario/inventario, agrupar, desagrupar e apagar nao entram nessa regra.
- Durabilidade do item fica em `MinimalValue`/`MaxValue`; itens criados pelo servidor usam `ItemTemplate.Durabilidade` quando ela for maior que zero.
- Equip duravel com `MaxValue > 0` e `MinimalValue == 0` e tratado como quebrado no calculo de status e nao soma bonus, ataque, defesa ou efeitos.

## Comandos de desenvolvimento

- `.item <id> [quantidade]` cria item no primeiro slot de inventario desbloqueado e vazio.
- O comando valida `ItemTemplateService.Templates`, preenche `ItemId/App`, quantidade/refine, durabilidade, persiste no banco e envia refresh `0xF0E` com `notice=false`.

## Pontos de cuidado

- `WriteItemOnPacket` ainda escreve efeitos como zeros; quando implementar efeitos reais, preservar ordem `effectIndex/effectValue`.
- `MinimalValue` e `MaxValue` sao convertidos para byte no pacote.
- `ItemList.bin` e lido a partir do offset `0`; o arquivo tem sobra no final, nao cabecalho inicial de 4 bytes.
- O layout do packet `0xF0E` foi coberto por teste de caracterizacao antes da refatoracao.
- O primeiro corte nao implementa storage, guild chest, pran, cash, uso de item, buff, compra/venda, refinamento ou drops.
