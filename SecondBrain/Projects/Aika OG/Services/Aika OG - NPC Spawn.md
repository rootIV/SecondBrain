---
tags:
  - project/aika-og
  - service
  - npc
updated: 2026-07-04
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
- `0x1006`: abre a lista de loja com `NpcClientId`, `StoreType` e 40 slots de item.
- `0x3010`: reservado para interfaces especiais como banco, repair e craft quando forem portadas; loja normal e skill shop nao usam esse pacote no fluxo atual.
- Ao selecionar loja normal ou skill shop, o dialogo e fechado primeiro (`0x10F`), depois o servidor envia apenas `0x1006`, e marca `OpenedShopNpc/OpenedShopType` no personagem.
- Se o NPC tem opcao de loja mas nao possui `StoreItems`, o servidor registra aviso com `NpcId`, `ClientId`, opcao e tipo de loja, e nao abre uma loja vazia silenciosamente.
- Giovanni/benção usa opcoes `35` e `65` como fluxo inicial de buff runtime: fecha dialogo, aplica flag `HasGiovanniBlessing`, recalcula status e dispara full refresh visual. Persistencia completa de buffs fica fora desta etapa.

## Cuidados

- Se `WorldDataService` nao encontrar dados, `NpcService` ainda tem seeds de fallback para desenvolvimento.
- `EncDec` nao foi alterado; os pacotes seguem a criptografia de transporte existente.
