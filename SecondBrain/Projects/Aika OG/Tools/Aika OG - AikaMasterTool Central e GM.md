---
tags:
  - project/aika-og
  - tools
  - gm
updated: 2026-10-09
---

# Aika OG - AikaMasterTool Central e GM

O projeto `C:\Projetcts\aika-og\PacketTool\AikaMasterTool.csproj` agora contém a central WinForms: editor do cliente, painel GM local e laboratório de pacotes. `AikaMasterTool.exe` na raiz inclui o runtime; `AikaBinEditor.exe` é uma cópia compatível da mesma central. Não há processos externos para hospedar o editor.

## Migração e contratos

- Modelos e UI completos do editor movidos para `PacketTool/Editors/`, preservando namespace para consumidores e runner. `AikaBinEditor/` referencia o projeto central e permanece como entrada compatível.
- Uma instância de cada área preserva sessões, seleção, busca e mudanças. Fechamento valida todas as sessões binárias e revisão GM.
- Contratos e limites de [[Aika OG - BinEditor Sessoes e Seguranca]] permanecem válidos; modelos binários e criptografia não foram reimplementados.
- Pacotes: IP e porta configuráveis, default loopback. O raw sniffer antigo tentava bind no IP remoto; substituído por recepção TCP enquadrada e importação Wireshark para outras conexões. EncDec e opcodes preservados.

## GM local

- Usa `Shared.Data.DatabaseConnectionFactory` e `AIKAOG_DATABASE`/`secrets/aikaog.local.env`. Nenhum novo endpoint público ou login do jogo. Permissão de administração depende das credenciais MySQL do operador local.
- Busca limitada de contas; personagens e inventário consultáveis. Atualizações de cash, accountType 0–5 e acesso 0/1/8/10.
- Gravação exige motivo, confirmação de manutenção e tabela `masterToolAudit`. Instalação dessa tabela é aditiva e explícita na UI.
- `accounts` e auditoria precisam ser InnoDB. Snapshot é comparado sob row lock; alteração e auditoria na mesma transação. Falha de auditoria reverte a atualização.
- Mudar acesso revoga token e zera banDays. Banimento temporário não foi adicionado: o servidor usa tokenCreationTime para expiração, compartilhando esse relógio com login.
- Manutenção é declaração do operador; não existe prova de ausência de sessões remotas. Não gravar com GameServer em execução. Sem edição de inventário nem comandos de sessão em tempo real.

## Verificação

- 144 checks de modelos incluindo 16 tabelas reais; 16 comparações de pixels JIT. Hashes de 15 tabelas originais do manifesto preservados.
- 21 testes xUnit, incluindo MySQL em container descartável: busca literal, snapshots antigos, moderação, revogação, auditoria e rollback quando INSERT de auditoria é negado.
- Smoke da UI conectada no banco temporário: contas, personagens, inventário, histórico e janela mínima. Smoke de sete seções na central publicada, edição/undo e navegação com alterações pendentes.
- Smoke TCP loopback verifica enquadramento fragmentado e fechamento para tamanho menor que 12 bytes; capturar InvalidDataException explicitamente (não é IOException).
- Solution Release compila; warnings preexistentes de analisadores GameServer/xUnit e targets locais Sonar ausentes. Suite completa GameServer e aceitação no jogo não executadas para esta migração.

Guia canônico: `docs/AIKA-MASTER-TOOL.md`. Build: `tools/Build-AikaMasterTool.ps1`; testes SQL: `tools/Test-AikaMasterToolGm.ps1` (não usa o banco do servidor).

## Recuperação da integração — 2026-10-09

- Falha reproduzida: AikaMasterTool com novos fontes em `PacketTool/Editors/`, mas `.csproj` antigo sem referência a AikaFileCrypto; entrypoint e arquivos da tela de pacotes revertidos ao estado anterior. Cópias do editor legado reapareceram. Resultado: quatro erros CS0246 na solution.
- Recuperadas referências, entrypoint MasterWindow, contrato PrepareClose/SmokeTest e UI/TCP da central. Modelos duplicados eram idênticos, exceto UI legada; preservados no backup e removidos da compilação antiga. Projeto de compatibilidade referencia a central.
- Corrigida também `PacketTool/PacketTool.sln`, que ainda apontava ao inexistente PacketTool.csproj e continha sufixo não numérico no VisualStudioVersion. As duas solutions agora compilam.
- Backup do estado anterior: `artifacts/recovery-20261009-144912`. Alteração preexistente em AikaFileCrypto.xUnitTest.csproj e MasterWindow.resx preservadas.
- Verificado: solution completa em Release e Debug, solution da central em Release, 21 testes com MySQL temporário e UI GM/TCP, 144 checks de modelos e smoke do executável republicado. Build Debug reportou bloqueio temporário de DLL por uma instância AikaMasterTool em execução; fechar a aplicação antes de recompilar.
- No Visual Studio abrir AikaOG.sln ou PacketTool/PacketTool.sln e selecionar AikaMasterTool como startup. A integração precisa manter juntos fontes, referências e entrypoint; recuperar apenas parte desse conjunto volta a quebrar a compilação.
