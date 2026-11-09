---
tags:
  - project/aika-og
  - tools
  - verification
updated: 2026-11-01
---

# Aika OG - Aika Studio Web

Central local em `C:\Projetcts\aika-og\AikaStudio`, iniciada por `AikaStudio.cmd`, em `http://127.0.0.1:3388`. ASP.NET Core .NET 8 serve React/TypeScript e SCSS Modules compilados pelo Vite. O WinForms permanece disponível. Ver `AikaStudio/README.md` para operação e limites.

## Contratos

- NPCs e Mobs adicionados em 2026-10-11: [[Aika OG - Studio NPCs e Mobs 2026-10-11]]. Mapas nativos, loja esparsa de 40 slots, diálogos, patrulhas e atributos compartilhados; 29 testes Studio com MySQL temporário aprovados. Ver a nota para limites de associação de missões, unidades nativas e calibração.
- Bins reutilizam `BinaryDocument`, `TableSchema` e `JitImage` do editor existente. Campos conhecidos, busca de arquivos/registros, rascunhos, desfazer, slots livres, hexadecimal avançado e JSON conservam as validações nativas. Gravação usa backup `.bak`, validação de layout e detecção de alterações externas. Arquivos desconhecidos mantêm os bytes e o último bloco parcial; não se presume cifra, checksum ou IDs. Alterar client não sincroniza automaticamente o catálogo SQL.
- Drops usam o catálogo real do MySQL e o mesmo resolver de listas do `DropDataService`. Chances inteiras independentes por item, rolagem global de 20%, segundo drop com 10%, limite de dois itens. Não normalizar para 75/24/1 das imagens. Lista vazia pode acionar fallback. SQL exige manutenção, snapshot concorrente, motivo, InnoDB, transação e backup JSON antes da gravação. Reiniciar GameServer após salvar; CSVs de Data não são atualizados automaticamente.
- GM reutiliza `GmDatabase`, com revisão antes/depois e auditoria na mesma transação. Instalação de `masterToolAudit` explícita. Contas, personagens e inventário consultáveis; hashes de senha e tokens não chegam ao browser. Status, perfil e cash são as operações disponíveis; não confundir com implementação dos opcodes GM de rede.
- API exclusivamente loopback, Host/Origin exatos, antiforgery e sem CORS. Detecção local de manutenção verifica processos chamados GameServer; dotnet DLL, remoto ou renomeado depende do operador. Rascunhos são voláteis e fechamento da página avisa sobre alterações.

## Auditoria de opcodes

`tools/audit_opcodes.py` compara `Opcodes.txt`, handlers registrados e construtores de headers, com evidência arquivo/linha e fluxo de chamadas estáticas. Relatórios `docs/reverse-engineering/OPCODE-AUDIT.md` e `.json`; viewer na central.

223 linhas, 222 opcodes únicos, duplicação de `0x31F`: 28 entradas implementadas, 38 saídas alcançadas, 153 ausentes, três construtores sem fluxo e uma entrada sem ação (`0x306`, UpdateCharInfo vazio). Há cinco entradas adicionais na source. `0x685` corresponde a SelectedNation; nomes genéricos da lista não comprovam a semântica. Nenhum opcode/layout foi modificado. A análise estática não comprova gameplay.

## Verificação inicial — 2026-10-09

361 testes .NET aprovados na solution, um teste legado MySQL ignorado; AikaStudio com nove testes aprovados, incluindo HTTP e SQL em banco GUID temporário. Três testes CSV e três testes de parser de opcodes aprovados. Build e lint do frontend aprovados. Browser validado de 320 a 1440 pixels, sem overflow horizontal da página nem erros de console; importação, rascunho/desfazer, revisão de bins, modo bruto parcial, GM e filtros de opcodes. Nenhuma conta ou bin real foi gravado nesta validação.

Graphify atualizado por AST: 3381 nodes, 9353 edges; configuração JSON sem nodes permanece fora do grafo. Screenshots em `output/playwright/`.

## Criador de contas e trava de zoom — 2026-10-11

- GM & contas ganhou Criar conta, com usuário ASCII 3–32, senha/confirmar senha 8–128, motivo e manutenção. A conta começa com status 1, perfil 0 e cash zero; selecionada após sucesso. GmDatabase.CreateAccount reforça o digest UTF-8 usado no TokenServer com AccountCredentials/PBKDF2. Conta e masterToolAudit usam a mesma transação; auditoria/DTO não incluem senha/hash/token. Colisão de username (inclusive caixa diferente) é rejeitada pelo índice único; falha de auditoria desfaz o INSERT da conta.
- Role GM recebeu INSERT somente de username/passwordHash/tokenCreationTime/accountStatus em least-privilege.sql; aplicada ao MySQL local. SQL de criação e moderação validado com usuários restritos em schemas descartáveis.
- NPCs/Mobs abrem WorldMapView com zoomLocked=true. Roda do mouse, +/− e Ajustar mapa exigem Desbloquear zoom; Bloquear zoom preserva a escala atual. Troca de mapa/versão remonta a vista e bloqueia em 100%. Pan e edição de trajetória continuam disponíveis; estado não é salvo.
- Browser confirmou senha divergente, criação com auditoria e seleção automática em banco descartável, zoom bloqueado/desbloqueado/rebloqueado e troca de mapa; layouts 320/768/1024/1440 sem overflow e sem erros de console. Screenshots em output/playwright/studio-account-320.png e studio-zoom-1440.png.
- Build isolado e suites Studio passaram; build no diretório padrão ficou bloqueado pelas DLLs do AikaStudio.exe em execução (PID 26840). Fechar a instância atual e reabrir AikaStudio.cmd recompila e ativa a nova API. Não houve criação de contas no aikaria de operação.

Verificação final: 53 testes Studio distintos aprovados (52 gerais + cadastro SQL habilitado separadamente), incluindo 12/12 no recorte final de validação/cadastro/API. Regressão SQL GM aprovada. Três integrações SQL antigas do Studio não foram habilitadas nesta execução. Host de teste 3389 e schema aika_catalog_tests_studio_* removidos ao finalizar.

Graphify atualizado após a inclusão: 4190 nodes, 11500 edges, 225 comunidades. Aviso de parser SQL ausente permanece; SQL foi executado nos testes e os caches AST rastreados foram preservados.

## Diagnóstico de cadastro com API antiga — 2026-10-11

- Confirmado `POST /api/gm/accounts/create` com HTTP 404 na instância antiga da porta 3388 (PID 26840). A DLL padrão era anterior à inclusão da rota; o inicializador reutiliza qualquer instância que responda `/api/session`, enquanto os assets do frontend podem ter sido atualizados separadamente.
- Build isolado da API atual em `artifacts/studio-account-api/` aprovado sem erros ou warnings. Probe na porta temporária 3389 retornou HTTP 400 de manutenção, confirmando a rota sem gravar conta. Host temporário encerrado ao final.
- Recorte API/cadastro: 11 testes aprovados e uma integração MySQL desabilitada. `BinaryCatalogTests.cs`, criado durante a investigação e ainda sem implementação correspondente, impediu a compilação inicial; excluído somente da compilação desse recorte por parâmetro MSBuild, sem alterar o arquivo.
- Encerramento da instância antiga negado pelo Windows. Resolvido em 2026-10-12 após o operador encerrar a instância elevada: build padrão aprovado sem warnings/erros, nova API ativa na porta 3388 e rotas de cadastro/lote responderam HTTP 400 de validação/manutenção em probes sem gravação. Recarregar o browser sozinho não atualiza a API; procedimento registrado no README do Studio.

## Troca de pasta com rascunho binário não restaurável — 2026-11-01

- `BinaryWorkspace.SetRoot` passa a bloquear somente documentos abertos com alterações reais. Rascunhos binários que não puderam ser restaurados pertencem à pasta anterior, já permanecem no `StudioDrafts` indexado pela pasta e deixam de impedir a troca para outra instalação do client.
- Após validar a nova pasta, a sessão limpa documentos e os avisos de restauração pendentes; não grava nem descarta o registro persistido da pasta anterior. A proteção contra perder alterações efetivamente abertas permanece.
- Regressão coberta por `StudioDraftTests.CleanBinarySessionAlsoSurvivesRestartAndUnresolvedEditsArePreserved`; 31 testes Studio relacionados passaram, com uma integração MySQL opt-in ignorada. A API local em execução não foi reiniciada nesta validação.

## Pendências

Perfil 10 encontrado em conta existente, fora do enum 0–5 da source; valor preservado e sinalizado. Atlas de ícones e enum completo de raridade ainda inferidos; valores nativos são exibidos. Captura do client e comprovação dos opcodes em sessão continuam pendentes.

## Lote de edição — 2026-10-12

[[Aika OG - Studio NPCs e Mobs 2026-10-11#Lote em manutenção e marcadores — 2026-10-12]] registra a aplicação atômica de várias lojas/patrulhas/atributos em uma manutenção, o botão Efetivar mudanças, Esc sem perder rascunhos e os marcadores compensados pelo zoom. 69 testes Studio aprovados, uma integração opt-in não habilitada, QA de browser sem gravação em produção. API padrão recompilada e reiniciada; gameplay após o lote permanece pendente.

## Relações

- [[Aika OG - AikaMasterTool Central e GM]]
- [[Aika OG - BinEditor Sessoes e Seguranca]]
- [[Aika OG - PacketDispatcher e Protocolo]]
- [[Aika OG - Depuracao Realtime x64dbg]]
- [[Aika OG - MOC]]
- [[Aika OG - Studio NPCs e Mobs 2026-10-11]]
