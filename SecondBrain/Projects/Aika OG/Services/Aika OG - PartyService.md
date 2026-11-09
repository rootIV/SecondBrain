# Aika OG - PartyService

Atualizado em 2026-10-21.

## Escopo implementado

- Party runtime de ate 6 membros com convite, aceite/rejeicao, expiracao de 30s, sair, kick, disband, transferencia de lider e alocacao EXP/item.
- Protocolo jogavel roteado no `PacketDispatcher`: `0x322`, `0x323`, `0x324`, `0x325`, `0x326`, `0x338`, `0x34B`, `0x38F`; coordenadas de membro por `0x11D`.
- Desde 2026-10-21, `0x38F` chama `PartyHandler.CreateSolo` e `PartyService.CreateSolo`: proprio personagem como unico membro/lider, EXP/item 1, refresh `0x326`, sem duplicar party em pedidos repetidos. Convites e saida reaproveitam o fluxo atual. Ver [[Aika OG - Grupo Solo Menus NPC 2026-10-21]].
- `SessionManager.RemoveSession` aciona cleanup de party antes de desassociar character, permitindo refresh para membros restantes.
- `PartyPacketFactory` escreve `0x326` fixo com capacidade maxima de 6 membros; overflow e erro de contrato.

## Integracao com templaria

- `PartyDamageService` usa `PartyService.GetPartyByCharacter` para validar Uniao Divina.
- Uniao Divina (`1217..1232`) requer membro vivo da mesma party e em range, grava `LinkedCharacterId`, aplica bonus de resistencia e redireciona 30% do dano recebido pelo aliado.
- O redirect acumula em `ActiveBuffEntity.AccumulatedValue` e para no cap runtime atual de `2680`.
- Links invalidos sao removidos no lifecycle quando o alvo sai da party, morre, desconecta ou sai de range.

## Cuidados

- Party ainda e runtime/in-memory; persistencia duravel de party nao faz parte do escopo atual.
- Packets e offsets de party seguem layout inspirado no Rafinha e devem ser tratados como contrato do cliente.
- PvP completo, loot de party e EXP de party ainda nao foram implementados.

## Referencias: criar grupo sozinho e buscar grupos (2026-10-20)

Consulta de fontes locais em `D:\aika`, com leitura dirigida das arvores `Src` de Rafinha, TheMu e Lore e de `src` do AikaEmu. O Graphify do Rafinha apontou um backup antigo; as evidencias abaixo foram conferidas na arvore `Src` selecionada pelo projeto, sem usar o backup como prova do fluxo atual.

### Criacao individual confirmada no codigo Delphi

- Rafinha: [PlayerThread.pas:1396](<D:/aika/Aika Rafinha Server/Src/Threads/PlayerThread.pas#L1396>) despacha `$38F` para `TPacketHandlers.AddSelfParty` (chamada na linha 1404).
- [AddSelfParty, PacketHandlers.pas:9329](<D:/aika/Aika Rafinha Server/Src/PacketHandlers/PacketHandlers.pas#L9329>) chama `TParty.CreateParty` quando `Player.PartyIndex = 0`; avisa quando ja existe grupo ou quando a criacao falha; depois atualiza o estado visual por `Player.RefreshParty`.
- [CreateParty, PartyData.pas:278](<D:/aika/Aika Rafinha Server/Src/Party/PartyData.pas#L278>) encontra um grupo vazio, define o proprio jogador como lider e adiciona apenas seu `ClientId` aos membros. Define alocacao EXP/item como 1 e associa os indices de grupo ao jogador. Nao depende de convite nem de segundo membro.
- [RefreshParty, Player.pas:6060](<D:/aika/Aika Rafinha Server/Src/Mob/Player.pas#L6060>) escreve o opcode `$326` na linha 6074.
- TheMu possui o mesmo fluxo: `Connections/ServerSocket.pas:4548` (`$38F`) e `PacketHandlers/PacketHandlers.pas:9356` (`AddSelfParty`). Lore tambem: `Server/Src/Connections/ServerSocket.pas:3253` e `Server/Src/PacketHandlers/PacketHandlers.pas:6621`. Parentesco entre forks nao constitui confirmacao independente do cliente oficial.

### Comparacao historica com o servidor C# em 2026-10-20

- Na consulta de 2026-10-20, `PacketDispatcher` ainda nao registrava `0x38F`; a criacao de party era feita durante `PartyService.Accept`.
- Esse gap foi implementado em 2026-10-21. As evidencias Delphi acima continuam sendo historico da investigacao; nao representam ausencia atual do handler.

### Busca ou recrutamento de grupos

Nao foi localizado um handler de pesquisa, listagem publica, anuncio ou recrutamento de grupos nos fontes `.pas`/`.cs` examinados. As buscas incluiram variantes de `SearchParty`, `FindParty`, `PartyList`, `GroupFinder`, `PartyMatching`, recrutamento e busca/listagem em portugues.

`AikaEmu.GameServer/Managers/PartyManager.cs:50` possui `GetParty(id)` e `GetParty(conId)`, mas seus corpos consultam o armazenamento interno por ID ou membro; nao implementam uma busca publica de grupos pelo jogador.

Limite: leitura estatica de fontes. Nao houve captura de rede, execucao do cliente ou analise de sua interface/binario nesta consulta. Ausencia de handler localizado nao prova ausencia da funcionalidade no cliente, nem determina seu opcode ou layout. Antes de implementar, confirmar a requisicao `0x38F` e o refresh no cliente alvo; para busca de grupos, ainda falta identificar um fluxo concreto.

Relacionado: [[Aika OG - Referencias Externas AikaEmu e Delphi]].
