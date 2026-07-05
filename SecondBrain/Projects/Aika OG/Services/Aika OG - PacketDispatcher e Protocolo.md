---
tags:
  - project/aika-og
  - protocol
  - packets
updated: 2026-07-04
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
| `0x31C` | `SkillHandler.LearnSkill` |
| `0x31E` | `SkillHandler.ChangeItemBar` |
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
- `0x106`: lista de skills `Others[0..39]`; quando aberto por NPC usa `NPCIndex` e `SendType=0x000B`.
- `0x107`: `SkillList[60]`, pontos de skill e `0xCCCC`.
- `0x112`: opcao de NPC com sender `0x3575`; `Show` e cor ARGB. As opcoes sao lidas de `TNPCHeader.Options[0..9]` nos `.npc`; textos vem de `NPCOptionsText.bin`. Fechar usa opcao `8` e cor `0xFFEB5A5A`; menu `21` usa `0xFF7FC1F4`; demais usam `0xFFFFFFFF`.
- `0x31E`: refresh/confirmacao de barra de skill/item com sender `0x7535`, campos `DestSlot`, `SrcType`, `SrcIndex`.
- `0x348`: entrada de fechamento de NPC/opcao (`TSignalData`), limpa estado aberto e responde com sinal `0x10F`.
- `0x31F`: animacao do personagem (`Anim`, `Loop`) enviada em ataques/skills.
- `0x349`: spawn/representacao de personagem e NPC de servico. Para NPC, `NpcService` usa `IsService = 1` e sender igual ao client id do NPC.
- `0x101`: remocao de mob/NPC visivel. Para NPC, `NpcService` usa sender fixo `0x7535` e payload com o client id removido, conforme a rotina Delphi.
- `0xF93A`: entrada de ping do client. Na Delphi chama `RequestServerPing` e responde com texto "`N ms.`"; ate agora nao apareceu como heartbeat obrigatorio de conexao, mas deve ser roteado para nao cair como opcode desconhecido.

## EncDec do client 2026-07-01

O `AIKACL.exe` de `C:\Users\Vitor\Downloads\AikaCL` contem a tabela `EncDecKeys` atual no offset de arquivo `0x2EBEB0` (VA `0x006ED0B0`), com referencias principais na regiao `0x00461CDB`-`0x00462024`.

O algoritmo base do client antigo foi substituido no projeto pelo fluxo do client atual:

- key efetiva por word: `EncDecKeys[(pos & 0xFF) * 2 + 1] + seed^4`;
- `seed` e o byte `packet[3]`;
- em modo mascarado, o primeiro DWORD do pacote e XORado com `0x3F1E0A0D`;
- o decrypt tenta header normal e header desmascarado para lidar com capturas/ferramentas.

No repositorio, `PacketTool/EncDec.cs` e `GameServer/Network/EncDec.cs` agora sao current-only: `Encrypt` gera pacote no formato do `AIKACL.exe` atual, mascara o primeiro DWORD por padrao e aplica `seed^4`; `Decrypt` aceita pacote ja desmascarado ou pacote wire mascarado. O modo legado foi removido deste branch porque o alvo e somente o client atual.

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
