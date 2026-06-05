---
tags:
  - project/aika-og
  - service
  - character
updated: 2026-05-10
---

# Aika OG - CharacterService

Relacionado: [[Aika OG - MOC]], [[Aika OG - ItemService]], [[Aika OG - PacketDispatcher e Protocolo]]

Arquivo: `GameServer/Application/Services/CharacterService.cs`

## Responsabilidade

`CharacterService` concentra criacao inicial de personagem e montagem dos principais pacotes relacionados a personagem.

## Funcoes importantes

- `GenerateInitialCharacter`: le dados do `PacketStream`, valida slot, nome, classe, cabelo e posicao inicial.
- `CreateCharacterAsync`: delega persistencia para `CharacterRepository.CreateCharAsync`.
- `CreateCharactersListPacket`: monta pacote `0x901` da lista de personagens.
- `CreateSendToWorldPacket`: monta pacote `0x925` com estado completo para entrar no mundo.
- `CreateTeleportPacket`: monta pacote `0x301` para teleporte/movimento.
- `CreateSendClientIndexPacket`: envia indice/serial do cliente.
- `SendHpMpPacket`, `CreateSendAttributesPacket`, `CreateSendLvlAndXpPacket`, `CreateSendStatusPacket`: pacotes de estado do personagem.
- `CreateChatMessagePacket`: pacote de chat `0xF86`.

## Dependencias

- `CharacterRepository` para persistencia.
- `ItemService` para escrever equips/inventario em ordem.
- `PacketFactory`, `PacketPool`, `PacketStream` para montagem.
- `EncDec.Encrypt` para criptografar resposta.

## Invariantes

- Slots validos de personagem: `0..2`.
- Nome: ate 14 chars, comeca com letra, depois letras/numeros.
- Classe valida: `10..69`.
- Hair valido: `7700..7731`.
- Inventario inicial: 60 slots.
- Equips iniciais: 16 slots.

## Pontos de cuidado

- A ordem dos campos nos pacotes e parte do contrato com o cliente.
- Muitos valores `Unk`/padding ainda sao conhecimento empirico de protocolo.
- `PacketPool.Return(packet)` acontece antes de `GetBytes()` em alguns metodos; validar se o pool nao reutiliza objeto antes da copia em cenarios concorrentes.
