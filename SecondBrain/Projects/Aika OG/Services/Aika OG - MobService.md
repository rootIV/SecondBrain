---
tags:
  - project/aika-og
  - service
  - mob
updated: 2026-05-10
---

# Aika OG - MobService

Relacionado: [[Aika OG - CharacterService]], [[Aika OG - SessionManager]]

Arquivo: `GameServer/Application/Services/MobService.cs`

## Responsabilidade

`MobService` monta pacotes criptografados relacionados a mobs e representacao de personagens como mobs no mundo.

## Funcoes importantes

- `CreateCharacterMobPacket`: monta pacote `0x349` para spawn/representacao de personagem.
- `CreateSpawnMobPacket`: monta pacote `0x35E` para spawn de mob.
- `CreateMoveMobPacket`: monta pacote `0x301` para movimento.

## Dependencias

- `CharacterEntity`
- `MobEntity`
- `ItemService`
- `PacketFactory`, `PacketPool`, `PacketStream`
- `EncDec.Encrypt`

## Invariantes

- `CreateCharacterMobPacket` usa nome com 16 bytes ASCII e equips de lobby.
- Buffs e buff timers ainda sao escritos como zeros.
- `CreateSpawnMobPacket` usa `mob.Index + 3048` como identificador de pacote.

## Pontos de cuidado

- Muitos campos ainda sao `Unk` e devem ser tratados como contrato observado.
- Alterar ordem ou tamanho dos blocos de buff/title pode quebrar renderizacao do cliente.
