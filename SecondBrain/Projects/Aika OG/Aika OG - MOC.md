---
tags:
  - project/aika-og
  - architecture
  - game-server
updated: 2026-10-09
---

# Aika OG - MOC

## Referencias

- [[Aika OG - Referencias Externas AikaEmu e Delphi]]

Servidor open source otimizado para Aika, dividido em `GameServer`, `TokenServer`, `Shared` e `PacketTool`.

## Notas principais

- [[Aika OG - Arquitetura Atual]]
- [[Aika OG - Sistema de Auth]]
- [[Aika OG - CharacterService]]
- [[Aika OG - ItemService]]
- [[Aika OG - MobService]]
- [[Aika OG - SkillService]]
- [[Aika OG - NPC Spawn]]
- [[Aika OG - WorldDataService]]
- [[Aika OG - SessionManager]]
- [[Aika OG - PacketDispatcher e Protocolo]]
- [[Aika OG - AIKA.exe Win32 Dialogs]]
- [[Aika OG - Cliente OG 2026-10-09]]
- [[Aika OG - Auditoria Servidor Client 2026-10-09]]
- [[Aika OG - Depuracao Realtime x64dbg]]
- [[Aika OG - BinEditor Sessoes e Seguranca]]
- [[Aika OG - AikaMasterTool Central e GM]]
- [[Aika OG Development Skill]]

## Regras sensiveis

- Nao alterar `GameServer/Network/EncDec.cs`, `PacketTool/EncDec.cs` nem as keys de criptografia sem validacao binaria com cliente real.
- Preservar o contrato do `GameProtocol`: conexao, recebimento, descriptografia, dispatch e fechamento de sessao.
- Evitar mudar opcodes e layout de pacote sem documentar em `Opcodes.txt` e nas notas de protocolo.

## Codigo fonte

- Projeto atual verificado: `C:\Projetcts\aika-og` (caminho legado: `C:\Users\Vitor\Documents\Projects\aika_og`).
- Solucao: `AikaOG.sln`
- Build de verificacao: `dotnet build AikaOG.sln`
