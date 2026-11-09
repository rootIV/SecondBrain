---
title: Aika OG - Client - Assembly e Funcoes
tags:
  - project/aika-og
  - client
  - assembly
updated: 2026-10-22
---

# Aika OG - Client - Assembly e Funcoes

Mapa das rotinas identificadas no cliente de SHA-256 `e1104cbb8d313ec9b07e18c5529ac6865d1eda92e429355185617a4f805ff002`, definido em [[Aika OG - Client - Documentacao Oficial]]. Os endereços abaixo são VAs preferenciais. Para uma sessão com ASLR, somar o RVA à base carregada do módulo.

Os nomes de responsabilidade e aliases C/C++ são identificadores de documentação. Nomes originais de source/PDB não fazem parte deste contrato.

## Navegacao pelo assembly

1. Selecionar o módulo cuja identidade corresponde à documentação.
2. Usar o RVA para localizar a rotina na base carregada.
3. Conferir instruções, tamanhos e referências ao produtor/consumidor ao trabalhar com um campo.
4. Consultar [[Aika OG - Client - Protocolo e Sistemas]] para layouts e [[Aika OG - Client - Formatos e Recursos]] para strides e arquivos.
5. Registrar alterações na evidência da região afetada.

Projeto de análise: `C:\Projetcts\aika-og\artifacts\ghidra-projects\AikaOGClient.gpr`, acompanhado do diretório `AikaOGClient.rep`. O projeto de análise deve ser preservado como conjunto. A identidade da imagem efetivamente analisada orienta o uso de seus exports; a evidência de correspondência com o executável atual está em [[Aika OG - Client - Verificacao e Pendencias]].

## Secoes PE

Estrutura lida do executável instalado. Tamanhos são em bytes; endereços de seção são RVAs.

| Seção | RVA | Tamanho virtual | Offset no arquivo | Bytes no arquivo |
|---|---|---:|---|---:|
| `.text` | `0x1000` | 3131814 | `0x400` | 3131904 |
| `.rdata` | `0x2fe000` | 255415 | `0x2fce00` | 255488 |
| `.data` | `0x33d000` | 46473308 | `0x33b400` | 31232 |
| `_RDATA` | `0x2f90000` | 2016 | `0x342e00` | 2048 |
| `.rsrc` | `0x2f91000` | 111776 | `0x343600` | 112128 |
| `.reloc` | `0x2fad000` | 121916 | `0x35ec00` | 122368 |

## Transporte cenas consumidores e loaders

As 53 regiões desta tabela foram confrontadas byte a byte com a imagem instalada. A coluna de bytes informa o comprimento contínuo conferido a partir da entrada, obtido do inventário de funções. Essa conferência vincula a região ao build documentado; não constitui execução completa de cada funcionalidade.

| VA preferencial | RVA | Responsabilidade identificada | Bytes conferidos |
|---|---|---|---:|
| `0x00464C30` | `0x64c30` | Recepção, framing, decrypt e estados de validação | 576 |
| `0x00464EE0` | `0x64ee0` | Encrypt e enfileiramento de envio | 378 |
| `0x0040A340` | `0xa340` | Bombeamento para a cena ativa | 469 |
| `0x004BFC40` | `0xbfc40` | Dispatcher de pacotes da cena de mundo | 2650 |
| `0x005A90B0` | `0x1a90b0` | Dispatcher da cena de login | 524 |
| `0x005C0D00` | `0x1c0d00` | Dispatcher da seleção de personagem | 716 |
| `0x0049E650` | `0x9e650` | Consumidor de remoção de entidade, 0x0101 | 1079 |
| `0x0049FA40` | `0x9fa40` | Consumidor de resultado de dano, 0x0102 | 34 |
| `0x0049FD10` | `0x9fd10` | Consumidor de HP/MP, 0x0103 | 1829 |
| `0x004A7A60` | `0xa7a60` | Consumidor do snapshot de skills, 0x0107 | 171 |
| `0x004A9EE0` | `0xa9ee0` | Consumidor do snapshot de buffs, 0x016E | 230 |
| `0x004A9FD0` | `0xa9fd0` | Consumidor da atualização de buffs, 0x016F | 175 |
| `0x004AA080` | `0xaa080` | Consumidor da variante tripla de buffs, 0x0170 | 200 |
| `0x004AA150` | `0xaa150` | Aplicação do estado normalizado de buffs | 10315 |
| `0x00499F90` | `0x99f90` | Recepção do snapshot de cooldowns, 0x012C | 134 |
| `0x004B6B10` | `0xb6b10` | Atualização do texto de cash, 0x0139 | 169 |
| `0x004B6AD0` | `0xb6ad0` | Recepção do inventário Premium, 0x0138 | 49 |
| `0x00580760` | `0x180760` | Abertura da interface Premium | 262 |
| `0x00589710` | `0x189710` | Recepção de saldo/estado de compras, 0x03AE | 62 |
| `0x004A5230` | `0xa5230` | Recepção das páginas de NPCs no mapa, 0x033D | 122 |
| `0x0051E330` | `0x11e330` | Desenho dos NPCs no mapa | 3183 |
| `0x0049B290` | `0x9b290` | Consumo do spawn 0x0349 e marcador do NPC | 13220 |
| `0x00425270` | `0x25270` | Preço-base de venda com durabilidade | 116 |
| `0x004252F0` | `0x252f0` | Dedução tributária da venda | 77 |
| `0x004437A0` | `0x437a0` | Loader de ItemList | 755 |
| `0x00443EF0` | `0x43ef0` | Loader de SkillData | 673 |
| `0x004434D0` | `0x434d0` | Loader de PI | 644 |
| `0x00444740` | `0x44740` | Loader de Quest | 200 |
| `0x00444670` | `0x44670` | Loader de Dialog | 200 |
| `0x005357F0` | `0x1357f0` | Leitura pontual de um registro Dialog | 435 |
| `0x00444810` | `0x44810` | Loader de MakeItems | 132 |
| `0x004448A0` | `0x448a0` | Carregamento de Recipe/RecipeRate | 230 |
| `0x00444B70` | `0x44b70` | Loader de Reinforce2 | 132 |
| `0x00443AD0` | `0x43ad0` | Loader de SetItem | 644 |
| `0x0044B730` | `0x4b730` | Loader de RandItem | 74 |
| `0x0044B780` | `0x4b780` | Loader de PackItem | 74 |
| `0x00415A70` | `0x15a70` | Loader de nomes MN | 182 |
| `0x0044AAA0` | `0x4aaa0` | Loader de MM | 91 |
| `0x0044A270` | `0x4a270` | Loader de MobPos | 91 |
| `0x004433E0` | `0x433e0` | Carregamento de strings localizadas | 159 |
| `0x0042E8A0` | `0x2e8a0` | Loader de Title | 110 |
| `0x00443DA0` | `0x43da0` | Loader da estrutura EXP | 223 |
| `0x004F4530` | `0xf4530` | Conclusão de cast e construção de 0x0302 | 342 |
| `0x004F4690` | `0xf4690` | Outro caminho de conclusão de cast | 775 |
| `0x004F5460` | `0xf5460` | Construção de início de cast, 0x0320 | 170 |
| `0x004F5510` | `0xf5510` | Outro produtor de início de cast | 1100 |
| `0x004E5F20` | `0xe5f20` | Construção do cancelamento, 0x0327 | 671 |
| `0x00522170` | `0x122170` | Produtor de operação de item, 0x032D | 154 |
| `0x004A30F0` | `0xa30f0` | Consumidor de resultado de item, 0x032E | 650 |
| `0x004B0D40` | `0xb0d40` | Consumidor do fluxo de criação de guilda, 0x0341 | 244 |
| `0x00569FB0` | `0x169fb0` | Produtor de solicitação de criação de guilda | 653 |
| `0x00444C90` | `0x44c90` | Loader da tabela Easing | 132 |
| `0x0056FEB0` | `0x16feb0` | Elegibilidade e preview de redução | 521 |

A presença do consumidor de `0x0170` documenta suporte no cliente; a integração dessa variante no servidor está nas pendências. A integridade do conteúdo MakeItems também tem pendência própria.

## Funcoes de atributos

Estas 23 entradas têm localização e corpo registrados para o build atual. O nome documental identifica a reconstrução de referência; a semântica detalhada está em [[Aika OG - Client - Atributos e Combate]].

| VA | RVA | Identificador documental |
|---|---|---|
| `0x00422420` | `0x00022420` | `Char_GetSkillBaseStat` |
| `0x00422490` | `0x00022490` | `Char_CheckItemClassReq` |
| `0x00422510` | `0x00022510` | `Char_HasRaceClass` |
| `0x00422e20` | `0x00022e20` | `Char_CountSetEquipped` |
| `0x00422fb0` | `0x00022fb0` | `Char_BuildSetList` |
| `0x00423170` | `0x00023170` | `Char_CalcEquipStat` |
| `0x00423350` | `0x00023350` | `Char_GetEquipBonusStat` |
| `0x004234c0` | `0x000234c0` | `Char_GetBuffBonusStat` |
| `0x004237e0` | `0x000237e0` | `Char_FindEquipSameGroup` |
| `0x004238d0` | `0x000238d0` | `Char_FindFirstEquipWithStat` |
| `0x00423970` | `0x00023970` | `Char_GetEquipBonusStat_Neg` |
| `0x00423bb0` | `0x00023bb0` | `Char_GetSkillBonusStat` |
| `0x00423c40` | `0x00023c40` | `Char_GetClassBonusStat` |
| `0x00423ed0` | `0x00023ed0` | `Char_CalcTotalStat` |
| `0x00423f50` | `0x00023f50` | `Char_FindSkillItemByStat` |
| `0x004240a0` | `0x000240a0` | `Char_CalcCombatStat_C` |
| `0x004242a0` | `0x000242a0` | `Char_CalcCombatStat_D` |
| `0x00424410` | `0x00024410` | `Char_CalcCombatStat_E` |
| `0x00424590` | `0x00024590` | `Char_CalcCombatStat_F` |
| `0x00425340` | `0x00025340` | `Char_CountEmptyEquipSlots` |
| `0x00425680` | `0x00025680` | `Char_CountPassiveSkills` |
| `0x004256e0` | `0x000256e0` | `Char_CalcCombatStat_A` |
| `0x00425830` | `0x00025830` | `Char_CalcCombatStat_B` |

## Funcoes de BattleZone

As 11 entradas abaixo pertencem ao cliente. Sua identificação não corresponde à implementação integral do sistema de BattleZone no servidor.

| VA | RVA | Identificador documental |
|---|---|---|
| `0x00544530` | `0x00144530` | `BattleZone_StartBattle` |
| `0x005447d0` | `0x001447d0` | `BattleZone_StopBattle` |
| `0x005448e0` | `0x001448e0` | `BattleZone_SendPacket` |
| `0x00546ca0` | `0x00146ca0` | `Combat_UpdateTimerDisplay` |
| `0x00546d30` | `0x00146d30` | `Combat_UpdateTier` |
| `0x00546eb0` | `0x00146eb0` | `Combat_ResetBattle` |
| `0x00546ff0` | `0x00146ff0` | `Combat_UpdateKillCount` |
| `0x00547080` | `0x00147080` | `Combat_UpdateBossTimer` |
| `0x00547120` | `0x00147120` | `Combat_ResetBossTimer` |
| `0x0054a7b0` | `0x0014a7b0` | `Combat_ShowKillMessage` |
| `0x0054b210` | `0x0014b210` | `BattleZone_ConfirmBattle` |

O manifesto de atributos contém os intervalos de corpo e Evidence IDs de cada entrada: `D:\aika\aika-cliente-reverse-engineer\audit-2026-10-22\function-manifest.json`. O endereço `0x0057FC44` está dentro da função em `0x0057ECA0`; para navegar até sua entrada, usar esta última.

## Rotas de entrada do servidor

Relação obtida da tabela atual de `GameServer/Presentation/Packets/PacketDispatcher.cs`. Ela registra o caminho de entrada C→S. A coluna de estado distingue registro implementado de rota deliberadamente indisponível; homologação no jogo é tratada em [[Aika OG - Client - Verificacao e Pendencias]].

| Opcode | Handler atual | Estado da rota |
|---|---|---|
| `0x81` | `AccountHandler.AccountLogin` | Implementado |
| `0x209` | `NativeInventoryHandler.BuyCash` | Implementado |
| `0x20A` | `NativeInventoryHandler.CashInventory` | Implementado |
| `0x3AE` | `NativeInventoryHandler.CashBalance` | Implementado |
| `0x359` | `EventItemHandler.Receive` | Implementado |
| `0x3BD` | `CharacterHandler.RequestDetailInfo` | Implementado |
| `0x23FE` | `CharacterHandler.RequestDetailedAttributes` | Implementado |
| `0xF59` | `NativeInventoryHandler.TransferGold` | Implementado |
| `0xF2F` | `NativeInventoryHandler.CloseGuildStorage` | Implementado |
| `0x302` | `CombatHandler.AttackTarget` | Implementado |
| `0x303` | `CharacterHandler.RevivePlayer` | Implementado |
| `0x304` | `CharacterHandler.Emote` | Implementado |
| `0x3F33` | `CharacterHandler.RequestDeletionToken` | Implementado |
| `0x603` | `CharacterHandler.DeleteCharacter` | Implementado |
| `0x3E01` | `CharacterHandler.DeleteCharacter` | Implementado |
| `0x30F` | `NpcHandler.OpenNpc` | Implementado |
| `0x336` | `RelicHandler.Collect` | Implementado |
| `0x33A` | `RelicHandler.CancelCollection` | Implementado |
| `0xE51` | `RelicHandler.Move` | Implementado |
| `0x64E` | `RelicHandler.UnavailableUpgrade` | Pendente / sem operação de gameplay |
| `0x64F` | `RelicHandler.UnavailableUpgrade` | Pendente / sem operação de gameplay |
| `0x650` | `RelicHandler.UnavailableUpgrade` | Pendente / sem operação de gameplay |
| `0x32D` | `NpcItemHandler.ChangeItem` | Implementado |
| `0x341` | `GuildHandler.Create` | Implementado |
| `0x32F` | `QuestHandler.Abandon` | Implementado |
| `0x330` | `QuestHandler.RewardChoice` | Implementado |
| `0x313` | `NpcShopHandler.BuyItem` | Implementado |
| `0x314` | `NpcShopHandler.SellItem` | Implementado |
| `0x31C` | `SkillHandler.LearnSkill` | Implementado |
| `0x31D` | `ItemHandler.UseItem` | Implementado |
| `0x31E` | `SkillHandler.ChangeItemBar` | Implementado |
| `0x320` | `SkillHandler.UseSkill` | Implementado |
| `0x322` | `PartyHandler.Invite` | Implementado |
| `0x323` | `PartyHandler.AnswerInvite` | Implementado |
| `0x324` | `PartyHandler.Kick` | Implementado |
| `0x325` | `PartyHandler.DestroyOrLeave` | Implementado |
| `0x326` | `PartyHandler.ChangeAllocation` | Implementado |
| `0x327` | `SkillHandler.CancelCast` | Implementado |
| `0x329` | `SkillHandler.RemoveBuff` | Implementado |
| `0x338` | `PartyHandler.SendPosition` | Implementado |
| `0x34B` | `PartyHandler.GiveLeader` | Implementado |
| `0x38F` | `PartyHandler.CreateSolo` | Implementado |
| `0x301` | `CharacterHandler.MoveChar` | Implementado |
| `0x305` | `CharacterHandler.UpdateRotation` | Implementado |
| `0x306` | `CharacterHandler.IgnoreOpcode0306` | Pendente / sem operação de gameplay |
| `0x32C` | `ItemHandler.DeleteItem` | Implementado |
| `0x332` | `ItemHandler.AgroupItem` | Implementado |
| `0x333` | `ItemHandler.UngroupItem` | Implementado |
| `0x361` | `CharacterHandler.UpdateActiveTitle` | Implementado |
| `0x348` | `NpcHandler.CloseNpc` | Implementado |
| `0x3061` | `CharacterHandler.UpdateActiveTitle` | Implementado |
| `0x668` | `CharacterHandler.ChangeChar` | Implementado |
| `0x685` | `CharacterHandler.AuthenticateGameConnection` | Implementado |
| `0x70F` | `ItemHandler.MoveItem` | Implementado |
| `0xF02` | `CharacterHandler.SendToWorld` | Implementado |
| `0xF05` | `ChannelTransferService.Request` | Implementado |
| `0xF06` | `ChannelTransferService.Login` | Implementado |
| `0xF0B` | `CharacterHandler.CompleteWorldEnter` | Implementado |
| `0xF93A` | `CharacterHandler.RequestServerPing` | Implementado |
| `0xF86` | `CharacterHandler.ChatMessage` | Implementado |
| `0x22D` | `ItemChatLinkService.Handle` | Implementado |
| `0x3E04` | `CharacterHandler.CreateChar` | Implementado |
| `0x3E02` | `PranHandler.Rename` | Implementado |

`0x039D` pertence à lista explícita de entradas ignoradas e está pendente de semântica. O protocolo conserva esse tratamento.

## Ligacao com a implementacao

- Header e dispatch: `GameServer/Presentation/Packets/PacketDispatcher.cs` e contratos de packets.
- Transporte: `GameServer/Network/EncDec.cs` e sequência de envio por conexão.
- Entrada no mundo: `GameServer/Application/Services/Characters/CharacterWorldService.cs`.
- Status/atributos: `GameServer/Application/Services/Characters/CharacterPacketFactory.cs`.
- Buffs: `GameServer/Application/Services/Skills/BuffPacketFactory.cs`.
- Itens: `GameServer/Application/Services/Items/ItemTemplateParser.cs`.
- Redução: `GameServer/Application/Services/Items/ItemReductionService.cs`.

A lista é um mapa das regiões já identificadas e dos caminhos atuais do projeto. A recuperação semântica integral do executável é uma pendência de engenharia reversa.

