---
tags:
  - project/aika-og
  - protocol
  - packets
updated: 2026-05-10
---

# Aika OG - PacketDispatcher e Protocolo

Relacionado: [[Aika OG - Arquitetura Atual]], [[Aika OG - CharacterService]], [[Aika OG - Sistema de Auth]]

Arquivos:

- `GameServer/Presentation/Protocol/GameProtocol.cs`
- `GameServer/Presentation/Protocol/Packets/GamePacketProcessor.cs`
- `GameServer/Presentation/Packets/PacketDispatcher.cs`
- `GameServer/Presentation/Packets/PacketStream.cs`
- `GameServer/Presentation/Packets/PacketFactory.cs`
- `GameServer/Network/EncDec.cs`

## Responsabilidade

A camada de protocolo recebe bytes da rede, normaliza o buffer, valida tamanho, descriptografa com `EncDec`, le o cabecalho e roteia por opcode.

## Pipeline

1. `TcpGameServer.ProcessReceive` copia bytes do socket.
2. `GameProtocol.OnReceive` chama `GamePacketProcessor.ProcessAsync`.
3. `GamePacketProcessor` remove prefixo `0x11 0xF3` quando presente.
4. Valida tamanho minimo `12` e tamanho declarado nos dois primeiros bytes.
5. Chama `EncDec.Decrypt`.
6. `PacketDispatcher` le sender/opcode.
7. Handler especifico executa a acao.

## OpCodes roteados

| Opcode | Handler |
|---|---|
| `0x81` | `AccountHandler.AccountLogin` |
| `0x301` | `CharacterHandler.MoveChar` |
| `0x305` | `CharacterHandler.UpdateRotation` |
| `0x306` | `CharacterHandler.UpdateCharInfo` |
| `0x39D` | ignorado |
| `0x668` | `CharacterHandler.ChangeChar` |
| `0x685` | `CharacterHandler.SelectedNation` |
| `0xF02` | `CharacterHandler.SendToWorld` |
| `0xF0B` | `CharacterHandler.SendToWorldSends` |
| `0xF86` | `CharacterHandler.ChatMessage` |
| `0x3E04` | `CharacterHandler.CreateChar` |

## Regras sensiveis

- Nao alterar `EncDec` e keys sem teste com cliente.
- Nao alterar bytes de padding ou campos `Unk` sem registrar a descoberta.
- Ao adicionar opcode, atualizar esta nota e `Opcodes.txt`.
