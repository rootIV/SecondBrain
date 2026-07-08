---
tags:
  - project/aika-og
  - protocol
  - packets
updated: 2026-07-05
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
| `0x302` | `CombatHandler.AttackTarget` |
| `0x303` | `CharacterHandler.RevivePlayer` |
| `0x30F` | `NpcHandler.OpenNpc` |
| `0x313` | `NpcShopHandler.BuyItem` |
| `0x314` | `NpcShopHandler.SellItem` |
| `0x31C` | `SkillHandler.LearnSkill` |
| `0x31E` | `SkillHandler.ChangeItemBar` |
| `0x329` | `SkillHandler.RemoveBuff` |
| `0x305` | `CharacterHandler.UpdateRotation` |
| `0x306` | `CharacterHandler.UpdateCharInfo` |
| `0x32C` | `ItemHandler.DeleteItem` |
| `0x332` | `ItemHandler.AgroupItem` |
| `0x333` | `ItemHandler.UngroupItem` |
| `0x348` | `NpcHandler.CloseNpc` |
| `0x39D` | ignorado |
| `0x668` | `CharacterHandler.ChangeChar` |
| `0x685` | `CharacterHandler.SelectedNation` |
| `0x70F` | `ItemHandler.MoveItem` |
| `0xF02` | `CharacterHandler.SendToWorld` |
| `0xF0B` | `CharacterHandler.SendToWorldSends` |
| `0xF93A` | `CharacterHandler.RequestServerPing` |
| `0xF86` | `CharacterHandler.ChatMessage` |
| `0x3E04` | `CharacterHandler.CreateChar` |

## Regras sensiveis

- Nao alterar `EncDec` e keys sem teste com cliente.
- Nao alterar bytes de padding ou campos `Unk` sem registrar a descoberta.
- Ao adicionar opcode, atualizar esta nota e `Opcodes.txt`.

## OpCodes de saida relevantes

- `0x102`: pacote de dano PvE basico (`TRecvDamagePacket`) com atacante, alvo, tipo de dano, dano aplicado, HP atual do alvo e posicao. Para mob -> player, sender/attacker usam `mob.ClientId`, `TargetID` usa client id do personagem, `Animation=6` e `MobAnimation=26`.
- `0x1002`: efeito visual de skill/dano baseado no AikaEmu `UpdateWithSkillEffect`; usado como complemento para exibir dano vermelho recebido do mob.
- `0x106`: lista de skills `Others[0..39]`; quando aberto por NPC usa `NPCIndex` e `SendType=0x000B`. Tambem e o pacote Delphi de loja comum (`TShowShopPacket`): `Index = npc.ClientId`, `DefByte = 0x000C`, `Items[40]`.
- `0x107`: `SkillList[60]`, pontos de skill e `0xCCCC`.
- `0x112`: opcao de NPC com sender `0x3575`; `Show` e cor ARGB. As opcoes sao lidas de `TNPCHeader.Options[0..9]` nos `.npc`; textos vem de `NPCOptionsText.bin`. Fechar usa opcao `8` e cor `0xFFEB5A5A`; menu `21` usa `0xFF7FC1F4`; demais usam `0xFFFFFFFF`.
- `0x31E`: refresh/confirmacao de barra de skill/item com sender `0x7535`, campos `DestSlot`, `SrcType`, `SrcIndex`.
- `0x348`: entrada de fechamento de NPC/opcao (`TSignalData`), limpa estado aberto e responde com sinal `0x10F`.
- `0x361` / `0x3061`: ativacao de titulo. O servidor aceita os dois formatos de entrada; a resposta Delphi usa `0x361` com `TitleIndex: DWORD` e `TitleLevel: DWORD`.
- `0x329`: entrada `TRemoveBuffPacket`; payload `DWORD Buff`. O servidor remove o buff ativo do proprio personagem por `SkillData.Id` ou `SkillData.Index`, persiste a remocao em `active_buffs`, envia `0x16E` e full refresh. Se o buff ja expirou ou nao existe, e tratado como no-op.
- `0x31F`: animacao do personagem (`Anim`, `Loop`) enviada em ataques/skills.
- `0x349`: spawn/representacao de personagem e NPC de servico. Para NPC, `NpcService` usa `IsService = 1` e sender igual ao client id do NPC.
- `0x101`: remocao de mob/NPC visivel. Para NPC, `NpcService` usa sender fixo `0x7535` e payload com o client id removido, conforme a rotina Delphi.
- `0xF93A`: entrada de ping do client. Na Delphi chama `RequestServerPing` e responde com texto "`N ms.`"; ate agora nao apareceu como heartbeat obrigatorio de conexao, mas deve ser roteado para nao cair como opcode desconhecido.
- `0x1086`: lista compactada de titulos do personagem. O formato segue o AikaEmu: 128 bytes, dois titulos por byte, usando bit flag `1 << level` para o titulo par e `1 << (level + 4)` para o titulo impar.
- `0xCCCC`, `0x3A2`, `0x3A6`, `0x186`, `0x33D`, `0x12C`, `0xF0E`, `0x11F`, `0x94C`, `0x3A5`, `0xD41`, `0x227`, `0x128`, `0x138`, `0x357`, `0x3F34`, `0x3F38`, `0xF0B`, `0x3F1B`: pacotes auxiliares de compatibilidade do fluxo Delphi/tcpdump de entrada no mundo. A sequencia usada antes/depois do `0x925` reduz inconsistencias de reentrada, flicker e estado visual incompleto. O pacote `0x131` continua removido por decisao anterior.
- `0x310`: `SendData` para abrir interfaces especiais de NPC; exemplos Delphi: bigorna `4`, reforco/refinacao `5`, encantar `6`, transfer/change app `7`, nivelamento `8`, reparar `0xE/0xF`, desmontar `0x11`, agros `0x15`, mount enchant `0x17`, auction `0x1A`, pran enchant `0x23`.
- Loja comum usa o pacote Delphi `0x106 TShowShopPacket`: `Index = npc.ClientId`, `DefByte = 0x000C`, `Items[40]`, seguido de `0x10F` para fechar o dialogo. `0x1006/0x3010` ficam como referencia AikaEmu/compatibilidade futura, nao como fluxo normal atual.

## Fluxo de entrada capturado 2026-07-05

A captura descriptografada anexada ao PacketTool mostrou uma sequencia de 55 pacotes no login/entrada do mundo. A source passou a seguir o nucleo dinamico dessa sequencia em `CharacterWorldService.BuildEnterWorldPackets`:

`0xCCCC`, `0x03A2`, `0x0186`, `0x0186`, `0x0186`, `0x0131`, `0x0925`, `0x012C`, `0x0F0E`, `0x0117`, `0x0F0E`, `0x0117`, `0x011F`, `0x094C`, `0x010A`, `0x0109`, `0x03A5`, `0x0108`, `0x0D41`, `0x0227`, `0x0128`, refresh completo (`0x0103`, `0x0109`, `0x010A`, `0x0108`), `0x0138`, `0x0357`, `0x0108`, `0x3F38`, `0x3F34`, `0x3F38`, `0x0F0B`, `0x3F1B`.

Os campos de personagem continuam dinamicos. Nao fazer replay literal dos bytes capturados; usar a captura apenas para ordem, tamanho e layout minimo ate mapear a semantica completa.

## PvE, sets e titulos 2026-07-05

- Matar mob agora concede EXP por `mob.ExpReward`, aplica o ajuste Delphi por diferenca de level e multiplica por 4 fora de dungeon quando a EXP nao e 1.
- Drop continua direto no inventario nesta etapa; quando um item e entregue, o servidor envia mensagem de sistema `0x984` com o item dropado. Inventario cheio gera log/aviso sem derrubar sessao.
- `SetItem.bin` e `Conjunts.bin` alimentam `ItemSetTemplateService`. O calculo de status soma efeitos de conjunto por quantidade de pecas equipadas; efeitos como `EF_CON` passam a refletir em constituicao efetiva e HP maximo.
- `Title.bin` alimenta `TitleTemplateService`. O titulo ativo aplica efeitos no mesmo coletor usado por equips/sets e dispara refresh completo de HP, atributos, status e EXP quando alterado.
- Regen de HP/MP continua proporcional, mas fica bloqueada enquanto algum mob vivo/ativo ainda tiver threat/target real no personagem.

## EncDec do client 2026-07-01

O `AIKACL.exe` de `C:\Users\Vitor\Downloads\AikaCL` contem a tabela `EncDecKeys` atual no offset de arquivo `0x2EBEB0` (VA `0x006ED0B0`), com referencias principais na regiao `0x00461CDB`-`0x00462024`.

O algoritmo base do client antigo foi substituido no projeto pelo fluxo do client atual:

- key efetiva por word: `EncDecKeys[(pos & 0xFF) * 2 + 1] + seed^4`;
- `seed` e o byte `packet[3]`;
- em modo mascarado, o primeiro DWORD do pacote e XORado com `0x3F1E0A0D`;
- o decrypt tenta header normal e header desmascarado para lidar com capturas/ferramentas.

No repositorio, `PacketTool/EncDec.cs` modela esse fluxo do `AIKACL.exe` atual: `Encrypt` mascara o primeiro DWORD por padrao e aplica `seed^4`; `Decrypt` aceita pacote ja desmascarado ou pacote wire mascarado. Nao usar essa variante como prova para outros executaveis sem confirmar no Ghidra.

## Ghidra MCP - AIKA.exe 2026-07-05

Alvo analisado:

- `C:\Users\Vitor\Documents\Projects\aika\AIKAClient\AIKA.exe`
- SHA-256 `bc2c9e45a977ca605e3a763f7d2c2e971dc79d0deeb78b84f20c2bffbc337bf9`
- Projeto Ghidra: `C:\Users\Vitor\Documents\Projects\tools\ghidra-projects\AikaAIKAExe`
- Relatorio no repo: `docs/reverse-engineering/AIKA-exe-packet-recon.md`

Resultado: esse `AIKA.exe` usa a variante legada do `EncDec`, sem `XOR 0x3F1E0A0D` e sem `seed^4`. A tabela `EncDecKeys` foi encontrada em VA `0x0070efe0`; as rotinas principais sao `FUN_00464c30` (recv/decrypt) e `FUN_00464ee0` (encrypt/send queue).

Estrutura confirmada do header descriptografado:

- `0..1`: tamanho `ushort`;
- `2`: checksum;
- `3`: seed;
- `4..5`: sender/index;
- `6..7`: opcode;
- `8..11`: timestamp.

O prefixo de stream opcional e validado como DWORD `0x1f11f311`, bytes `11 f3 11 1f`; portanto a normalizacao do `GamePacketProcessor` deve remover 4 bytes somente quando o prefixo completo bate.

Implementacao em 2026-07-05: `GameServer/Presentation/Packets/AikaPacketContract.cs` registra os offsets do header, o handshake raw `11 f3 11 1f`, o ping logico `0xF93A`, os sinais header-only `0x0F0B`, `0x010F`, `0x0110`, e os tamanhos dos pacotes estranhos de compatibilidade do world-entry. `GameServer.Tests` cobre esse contrato contra os factories reais.

Heartbeat/signal: nao foi identificado heartbeat periodico obrigatorio alem do ping logico `0xF93A`. `0x0F0B` e sinal de entrada no mundo; `0x010F`/`0x0110` sao sinais de fechar/abrir dialogo NPC e nao carregam payload.

Sequencia enxuta de entrada no mundo implementada em 2026-07-05:

`03A2, 03A6, 0186, 033D, 0925, 016E, 0F0E, 0117, 0F0E, 011F, 010A, 0109, 03A5, 0D41, 0227, 033D, 0128, 0103, 0109, 010A, 0108, 0138, 0357, 3F38, 3F34, 3F38, 0F0B, 3F1B`

Removidos do `BuildEnterWorldPackets`: `0xCCCC`, repeticoes extras de `0x03A6/0x0186`, segundo `0x0117`, `0x012C`, `0x094C`, e os `0x0108` avulsos fora do full refresh. Um unico par `0x03A6 + 0x0186` permanece.

Conclusao para source C#: `GameServer/Network/EncDec.cs`, `PacketFactory`, `PacketDispatcher.ReadHeader` e o tamanho minimo de 12 bytes estao corretos para esse `AIKA.exe`. Ja `PacketTool/EncDec.cs` continua representando o fluxo do `AIKACL.exe` atual e nao deve ser usado diretamente para validar capturas desse alvo sem selecionar a variante correta.

OpCodes confirmados no executavel como constantes/branches reais: `0x0301`, `0x03A2`, `0x03A5`, `0x03A6`, `0x011F`, `0x0227`, `0x0357`, `0x0901`, `0x0925`, `0x0F0E`, `0x3F1B`, `0x3F34`, `0x3F38`. `0xCCCC` aparece, mas e ruidoso porque tambem surge como fill/debug/color.

## EncDec comparado com AikaClient antigo

Comparacao feita em 2026-07-02 entre:

- atual: `C:\Users\Vitor\Downloads\AikaCL\AIKACL.exe`;
- antigo funcional: `C:\Users\Vitor\Documents\Projects\aika\AKLASTJOURNEY\AikaClient.exe`;
- referencia anexada: `C:\Users\Vitor\Documents\Projects\aika\aika-cliente-reverse-engineer\AIKA_Cliente_dados.h`.

Resultado:

- a tabela `EncDecKeys` de 512 bytes e igual nos dois executaveis;
- o antigo funcional usa o fluxo legado, sem `XOR 0x3F1E0A0D` e sem `seed^4`;
- o atual adiciona um modo condicional quando o contexto da conexao bate com o global em `0x71D55C`;
- no encrypt atual, o seed nao e aleatorio: `seed = (lastTimestampLow * 2 + sessionByte + timestampLow) & 0xFF`; se repetir o ultimo seed, incrementa em 1;
- o client grava o timestamp em `packet[8..11]` antes de criptografar o payload;
- ao final do encrypt atual, se o modo condicional estiver ativo, o primeiro DWORD enviado no buffer de saida e XORado com `0x3F1E0A0D`.

O pacote capturado:

`2D 0A C1 C2 67 35 E6 08 BD B8 94 2C 75 FB 35 48 4F 92 3B 16 B4 35 E5 05 DE 29 7B 15 DE 9A F2 02`

descriptografa com checksum valido pelo fluxo de transporte do `AIKACL.exe` atual para:

`20 00 DF FD 01 00 01 83 7D 8E 29 44 B4 60 43 85 43 40 65 45 00 00 00 80 00 00 10 2D 04 00 00 40`

Esse resultado ainda tem opcode `0x8301`, nao `0x0301`. Nao normalizar `0x8301` para movimento; isso indica que a captura/fluxo ainda nao representa o pacote logico esperado pelo servidor antigo, ou que o pacote observado nao e o pacote C2S logico de movimento.

## PacketTool e capturas do Wireshark

Quando copiar bytes do Wireshark, o `EncDec` deve receber apenas o campo `Data` TCP do pacote Aika. Um frame completo Ethernet/IP/TCP comeca com bytes de enlace como `54 AF ... 08 00 45 00 ...`; esses bytes nao fazem parte do pacote Aika e causam falha de checksum se forem passados diretamente ao decrypt.

Em 2026-07-02, o `PacketTool` passou a aceitar tambem frames Ethernet IPv4/TCP completos colados do Wireshark. A ferramenta extrai automaticamente o payload TCP usando o tamanho dos headers Ethernet, IP e TCP, e entao chama `EncDec.Decrypt` somente no payload Aika.

O `PacketTool` tambem normaliza automaticamente dumps/copias hex do Wireshark ao clicar em Encrypt/Decrypt. O botao `Wireshark Dump` abre um arquivo exportado pelo Wireshark e carrega o hexdump normalizado no input; o mesmo carregamento funciona ao arrastar o arquivo para a janela ou para o input.

Em 2026-07-02, o `PacketTool` passou a descriptografar streams Aika concatenados no input. Isso cobre capturas coladas como uma linha unica ou payloads TCP grandes, onde o input contem varios pacotes Aika em sequencia. A ferramenta procura cada segmento criptografado por checksum do `EncDec` e so aceita o segmento quando o header descriptografado declara o mesmo tamanho; depois mostra cada pacote separadamente no resultado.

O output de descriptografia mostra somente cabecalho e `data`, sem repetir o pacote completo. Ao clicar em um pacote descriptografado, o `SelectedPacketLabel` exibe o indice, offset, tamanho e opcode; o botao `Send Data to Hex Info` copia apenas o payload `data` desse pacote para o `HexInputRichTextBox`.
