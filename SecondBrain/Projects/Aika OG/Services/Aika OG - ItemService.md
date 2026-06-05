---
tags:
  - project/aika-og
  - service
  - item
updated: 2026-05-10
---

# Aika OG - ItemService

Relacionado: [[Aika OG - CharacterService]], [[Aika OG - PacketDispatcher e Protocolo]]

Arquivo: `GameServer/Application/Services/ItemService.cs`

## Responsabilidade

`ItemService` busca equipamentos/inventario do personagem e escreve dados de item nos pacotes no layout esperado pelo cliente.

## Funcoes importantes

- `GetCharacterEquips`: carrega equips via `ItemRepository.GetCharEquipsAsync`.
- `GetCharacterInventory`: carrega inventario via `ItemRepository.GetCharInventoryAsync`.
- `GetInventoryOrdered`: normaliza inventario em 60 slots.
- `GetEquipsOrdered`: normaliza equips em 16 slots.
- `GetLobbyEquipsOrdered`: normaliza equips do lobby em 8 slots.
- `WriteLobbyEquipsOnPacket`: escreve `ItemId` dos equips do lobby.
- `WriteEquipsOrderedOnPacket`: escreve `ItemId` dos equips no pacote de mundo.
- `WriteInventoryOrderedOnPacket`: escreve `ItemId` do inventario.
- `WriteItemOnPacket`: escreve payload detalhado do item.

## Dependencias

- `ItemRepository`
- `PacketStream`
- `CharacterEntity`
- `ItemEntity`

## Invariantes

- Inventario: 60 slots.
- Equips: 16 slots.
- Lobby equips: 8 slots.
- Slots fora do intervalo sao ignorados.

## Pontos de cuidado

- `WriteItemOnPacket` ainda escreve efeitos como zeros; quando implementar efeitos reais, preservar ordem `effectIndex/effectValue`.
- `MinimalValue` e `MaxValue` sao convertidos para byte no pacote.
