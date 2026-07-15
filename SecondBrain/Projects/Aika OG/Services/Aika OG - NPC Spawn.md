---
tags:
  - project/aika-og
  - service
  - npc
updated: 2026-07-08
---

# Aika OG - NPC Spawn

Relacionado: [[Aika OG - MobService]], [[Aika OG - SessionManager]], [[Aika OG - WorldDataService]]

## Referencia Delphi

Fonte analisada: `C:\Users\Vitor\Documents\Projects\aika\Aika TheMu New`.

- `Src\Connections\ServerSocket.pas` reserva `NPCS: ARRAY [2048 .. 2720] OF TNpc`; mobs comuns ficam em outra faixa (`3048+`).
- `Src\Mob\NPC.pas` carrega `Data\NPCs\*.npc`, copia a base para `TCustomNpc` e chama `Base.Create(@Self.Character, NPCFile.Base.Index, Channel, true)`.
- Os arquivos reais ficam em `C:\Users\Vitor\Documents\Projects\aika\Aika TheMu New\Bin\Data\NPCs`; atualmente ha 469 arquivos `.npc`.
- `Src\Mob\BaseMob.pas` compara `PlayerCharacter.LastPos` com NPCs no `DISTANCE_TO_WATCH`; quando entra no range, adiciona em `VisibleNPCS` e chama `BaseNpc.SendCreateMob(SPAWN_NORMAL, playerClientId, false)`.
- Quando sai do range, remove de `VisibleNPCS` e envia opcode `0x101` com sender fixo `0x7535` e payload com o client id removido.

## Implementacao C#

- `GameServer/Domain/Entities/Npcs/NpcEntity.cs` representa NPCs de servico.
- `GameServer/Application/Services/WorldDataService.cs` carrega os `.npc` reais e expoe `WorldDataService.Npcs`.
- Durante o load, `WorldDataService` tambem carrega `Data\NPCOptionsText.bin` para traduzir as opcoes de `TNPCHeader.Options[0..9]` em texto real no dialogo.
- Quando existir `Data\Npcs\<id>\StoreData.json` no formato do AikaEmu, `NpcStoreDataService` enriquece o `NpcEntity` com `StoreType` e ate 40 itens de loja. Se o `Data` local nao tiver esses arquivos, o loader tambem procura em `C:\Users\Vitor\Documents\Projects\aika\AikaEmu-master\src\AikaEmu.GameServer\Data\Npcs`.
- Em dados AikaEmu, `StoreData.NpcId` pode ser o id logico/pasta, enquanto o NPC visivel no jogo usa `UnitData.ConnectionId`; exemplo: pasta `57` tem `StoreData.NpcId = 57` e `UnitData.ConnectionId = 2071`. O loader deve casar primeiro por `ConnectionId`.
- `NpcFileParser` classifica capacidades iniciais a partir das opcoes reais do `.npc`: conversa, loja, buff, missao/quest, instrutor de skill, teleporte e salvar local. Essa classificacao ainda e roteamento inicial; handlers completos de loja/buff/missao entram por etapas.
- `GameServer/Application/Services/NpcService.cs` monta:
  - `0x349` para spawn de NPC usando layout de service mob/personagem, com `IsService = 1`.
  - `0x101` para remover NPC do cliente.
- `CharacterHandler.SendToWorldSends` chama `NpcService.SendVisibleNpcs` apos adicionar o personagem no `WorldGrid`.
- `CharacterHandler.MoveChar` chama `NpcService.SendVisibleNpcs` depois de atualizar a posicao, permitindo spawn/remocao conforme o range muda.
- Mobs comuns usam range de visibilidade alinhado ao ataque basico (`35`) para reduzir casos de alvo visivel no client mas rejeitado pelo servidor. Se a lista `VisibleMobs` ficar obsoleta apos teleporte/troca de personagem, `CombatService` valida o mob por id, estado e distancia real antes de rejeitar.

## Dialogo e Fluxos

- `0x10E`: abre chat com NPC e escreve o id do NPC.
- `0x10F`: fecha chat/dialogo.
- `0x111`: inicia fala/conversa usando `TalkId`; fallback atual usa o proprio client id do NPC.
- `0x112`: mostra opcoes traduzidas por `NPCOptionsText.bin`/fallbacks.
- Loja comum agora segue o tcpdump/Delphi: `0x106 TShowShopPacket`, sender `0x7535`/client id capturado, `Index = npc.ClientId`, `DefByte = 0x000C` e `Items[40]`, seguido de `0x10F` para fechar o dialogo.
- `0x1006` e `0x3010` continuam documentados como referencia AikaEmu, mas nao sao usados no fluxo normal atual de loja porque o client testado nao abriu a UI com esse par.
- Ao selecionar loja normal ou skill shop, o servidor marca `OpenedShopNpc/OpenedShopType`, envia `0x106` com ate 40 itens e fecha o dialogo com `0x10F`.
- Se o NPC tem opcao de loja mas nao possui itens cadastrados, o servidor abre mesmo assim uma loja vazia: `0x106` com 40 slots zerados, `StoreType` default `12`, e registra o NPC em `OpenedShopNpc/OpenedShopType` para compra/venda.
- `NpcStoreDataService` normaliza todas as lojas carregadas para 40 slots e loga um resumo no startup: total de lojas, lojas com itens e lojas vazias. Em 2026-07-05, com os dados atuais, o catalogo local reportou 184 NPCs loja, 63 com itens e 121 vazios.
- Compra/venda de loja usa os opcodes Delphi ja documentados:
  - `0x313 TBuyNPCItemPacket`: `Index`, `Slot`, `Quantidade` como `DWORD`.
  - `0x314 TSellNPCItemPacket`: `Index`, `Slot` como `DWORD`.
- `NpcShopService` valida que a loja esta aberta, que o NPC possui capacidade de loja, e opera apenas sobre inventario normal nesta etapa. Compra v1 usa gold, cria/agrupa no primeiro slot desbloqueado e rejeita moeda especial sem derrubar a sessao. Venda v1 soma gold conforme regra Delphi: stackable usa quantidade/refine; equipamento usa `SellPrince div 5` proporcional a `MIN/MAX` de durabilidade, rejeitando item temporario, `TypeItem = 7`, sem preco ou nao negociavel.
- Apos compra/venda, o handler persiste itens e runtime state, envia `0xF0E` para slots alterados e reenvia refresh de inventario/gold. Desde 2026-07-08, o fluxo tambem envia o refresh Rafinha correto `0x312 TRefreshMoneyPacket` (`Unk`, `InventoryGold`, `ChestGold`) com `ChestGold = 0` nesta etapa; o `0x925` continua no refresh por compatibilidade visual ja validada.
- Giovanni/benção usa opcoes `35` e `65` como fluxo inicial de buff runtime: fecha dialogo, aplica flag `HasGiovanniBlessing`, recalcula status e dispara full refresh visual. Persistencia completa de buffs fica fora desta etapa.

## Cuidados

- Se `WorldDataService` nao encontrar dados, `NpcService` ainda tem seeds de fallback para desenvolvimento.
- `EncDec` nao foi alterado; os pacotes seguem a criptografia de transporte existente.
