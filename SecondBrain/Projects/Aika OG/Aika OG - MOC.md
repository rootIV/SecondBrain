---
tags:
  - project/aika-og
  - architecture
  - game-server
updated: 2026-05-10
---

# Aika OG - MOC

Servidor open source otimizado para Aika, dividido em `GameServer`, `TokenServer`, `Shared` e `PacketTool`.

## Notas principais

- [[Aika OG - Arquitetura Atual]]
- [[Aika OG - Sistema de Auth]]
- [[Aika OG - CharacterService]]
- [[Aika OG - ItemService]]
- [[Aika OG - MobService]]
- [[Aika OG - SessionManager]]
- [[Aika OG - PacketDispatcher e Protocolo]]
- [[Aika OG Development Skill]]

## Regras sensiveis

- Nao alterar `GameServer/Network/EncDec.cs`, `PacketTool/EncDec.cs` nem as keys de criptografia sem validacao binaria com cliente real.
- Preservar o contrato do `GameProtocol`: conexao, recebimento, descriptografia, dispatch e fechamento de sessao.
- Evitar mudar opcodes e layout de pacote sem documentar em `Opcodes.txt` e nas notas de protocolo.

## Codigo fonte

- Projeto: `C:\Users\Vitor\Documents\Projects\aika_og`
- Solucao: `AikaOG.sln`
- Build de verificacao: `dotnet build AikaOG.sln`
