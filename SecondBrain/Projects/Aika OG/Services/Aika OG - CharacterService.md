---
tags:
  - project/aika-og
  - service
  - character
updated: 2026-07-06
---

# Aika OG - CharacterService

Relacionado: [[Aika OG - MOC]], [[Aika OG - ItemService]], [[Aika OG - PacketDispatcher e Protocolo]]

Arquivo: `GameServer/Application/Services/CharacterService.cs`

## Responsabilidade

`CharacterService` agora e uma facade de compatibilidade. A criacao inicial, a montagem de pacotes e a orquestracao de entrada/movimento foram separadas em services menores.

## Funcoes importantes

- `CharacterCreationService`: le dados do `PacketStream`, valida slot, nome, classe, cabelo e posicao inicial, e delega persistencia para `CharacterRepository`.
- `CharacterPacketFactory`: monta pacotes `0x901`, `0x925`, `0x301`, `0x117`, `0x103`, `0x109`, `0x108`, `0x10A`, `0x984`, `0x305` e `0xF86`. O `0x131` permanece removido do fluxo atual.
- `CharacterRefreshService`: envia o conjunto completo de refresh visual do personagem: `0x103` HP/MP, `0x109` atributos, `0x10A` status e `0x108` level/EXP.
- `CharacterStatusService`: recalcula status runtime base + equips antes de enviar personagem ao mundo ou HP/MP.
- `CharacterWorldService`: orquestra selecao de personagem, envio para o mundo, teleporte, self spawn, visibilidade inicial e envio de equips/inventario.
- `CharacterWorldService.ReviveCharacter/RevivePlayer`: resolve revive manual `0x303`; usa `savedPositionX/savedPositionY` quando existem, senao cidade padrao `3450,690`, revive com HP/MP maximos, limpa visibilidade e remove threat dos mobs.
- `CharacterLevelService`: aplica ganho de level/pontos no padrao Delphi.
- `CharacterRuntimeStateService`: salva estado runtime antes de trocar personagem, desconectar ou apos respawn.
- `CharacterRegenerationService`: roda tick de 1 segundo e regenera HP/MP somente depois de 10 segundos sem ataque enviado ou recebido.
- `CharacterMovementService`: trata rotacao, movimento, atualizacao de `WorldGrid`, broadcast para visiveis e refresh de mobs/NPCs.
- `ChatCommandService`: separa parsing de chat/comandos debug do handler. Comandos de desenvolvimento atuais: `.item <id> [quantidade]`, `.title <id>` e `.effect <skillDataId>`.

## Dependencias

- `CharacterRepository` para persistencia.
- `ItemPacketWriter` para escrever equips/inventario em ordem.
- `PacketFactory`, `PacketPool`, `PacketStream` para montagem.
- `EncDec.Encrypt` para criptografar resposta.

## Invariantes

- Slots validos de personagem: `0..2`.
- Nome: ate 14 chars, comeca com letra, depois letras/numeros.
- Classe valida: `10..69`.
- Hair valido: `7700..7731`.
- Inventario inicial: 126 slots, incluindo bolsas em `120..125`.
- Equips iniciais: 16 slots.

## Estado runtime

- `CharacterRepository` garante a coluna `characters.isAlive` quando acessa/persiste estado runtime.
- Ao carregar personagem, `Position` deve ser montado com `positionX` e `positionY`.
- A associacao personagem-sessao no enter-world deve usar `SessionManager.BindCharacter`, nao atribuicao direta em `session.ActiveCharacter`.
- `SaveRuntimeStateAsync` persiste `currentHealth`, `currentMana`, `positionX`, `positionY`, `rotation`, `isAlive`, `activeAction` e `lastLogin`.
- `GameProtocol.OnDisconnect`, `SessionManager.RemoveSession` e `CharacterHandler.ChangeChar` acionam a persistencia para reduzir perda de vida/posicao em DC ou troca de personagem.
- `CharacterRuntimeStateService` tambem tem autosave best-effort a cada 10 segundos para sessoes ativas, alem de salvar em shutdown gracioso do `Program.cs`.
- Teleporte por comando/debug deve usar `CharacterWorldService.TeleportAndRefresh`, nao apenas `Teleport`, para atualizar `PositionX/Y`, reconstruir `VisibleMobs`/`VisibleNpcs`, atualizar o grid e evitar mobs visiveis no client mas invalidos para ataque no servidor.
- Movimento normal captura a posicao antiga, atualiza `PositionX/Y`, chama `WorldGrid.UpdateCharacterPosition`, recalcula `UpdateVisibleList` e usa `VisibilityBroadcastService` para enviar o pacote aos players visiveis.
- O combate tambem revalida o mob real por id/posicao/range quando `VisibleMobs` fica obsoleto apos teleporte ou troca de personagem, e resincroniza o alvo na lista visivel se o mob estiver valido.
- Revive manual pelo client e opcode `0x303`; morte nao deve depender de opcode desconhecido. O revive restaura HP/MP, marca `IsAlive/IsActive`, limpa alvo/visibilidade e chama o fluxo de teleporte para reconstruir o mundo visivel.
- Apos o revive, o servidor deve reenviar o spawn do proprio personagem (`0x349`) e refresh completo. O Delphi reenvia `SendCreateMob` no fluxo de login/teleporte; sem esse self spawn, o client pode renderizar o personagem sem nome ou sem barra de HP.

## Status e 0x925

- Escopo atual do calculo de status: atributos base, level/classe e equips carregados de `ItemList.bin`.
- Fora deste corte: buffs, pran, reliquias, conjunto completo, refine avancado e efeitos temporarios.
- `ItemTemplateParser` le campos de combate do `TItemFromList`: `ATKFis`, `DefFis`, `MagATK`, `DefMag`, `HP`, `MP`, `EF[0..2]` e `EFV[0..2]`.
- `0x925` escreve o bloco `TStatus` na ordem Delphi dentro de `TCharacter`.
- No `0x925`, `Equip[16]` e `Inventory[126]` usam `TItem` completo de 20 bytes (`Index`, `APP`, `Identific`, efeitos, `MIN`, `MAX`, `Refi`, `Time`), nao apenas `WORD` de item id.
- Offsets validados do pacote completo `0x925`: `TCharacter=16`, `CurrentScore=48`, `Exp=192`, `Level=200`, `Equip=356`, `Inventory=680`, `Gold=3200`, `SkillList=4596`, `ItemBar=4716`.
- `0x103` envia `MaxHP, CurHP, MaxMP, CurMP`.
- `0x108` envia `Level - 1`, `Unk = 0x00CC`, `Exp` como `UInt64`, depois o trailer observado no AikaEmu: `WORD 1`, seis bytes `CC` e `QWORD 0`.
- Ao entrar no mundo, apos `0x925`, o servidor envia a sequencia de compatibilidade observada em captura Delphi/current client, incluindo auxiliares como `0x12C`, `0xF0E`, `0x11F`, `0x94C`, `0x3A5`, `0xD41`, `0x227`, `0x128`, `0x138`, `0x357`, `0x3F38`, `0x3F34`, `0xF0B` e `0x3F1B`, alem de refreshes dinamicos `0x103`, `0x109`, `0x10A` e `0x108`.
- `0xD41`, `0x138`, `0x3F34`, `0x3F38` e `0x3F1B` ainda sao placeholders de compatibilidade por tamanho/sender/opcode capturados; nao possuem semantica completa mapeada e nao devem receber dados inventados.
- Personagem novo deve passar por `CharacterStatusService.Recalculate` antes de persistir e entrar com `CurrentHealth=MaxHealth` e `CurrentMana=MaxMana`, em vez de valores fixos `120/120`. Personagem carregado com HP/MP salvo valido preserva esse estado.
- Se `IsAlive=false`, `CharacterStatusService.Recalculate` mantem `CurrentHealth=0` e nao revive implicitamente.
- Regeneracao fora de combate usa `LastAttackSent` e `LastReceivedAttack`; enquanto qualquer um deles estiver dentro da janela de 10 segundos, o tick nao altera HP/MP. Quando altera, envia apenas `0x103`.
- Regeneracao fora de combate usa tick de 1 segundo e recupera HP/MP juntos com o maior valor entre o regen por atributo e 5% do maximo. Exemplo: `20k` HP recupera cerca de `1k` por tick e enche em aproximadamente 20 segundos fora de combate.
- Operacoes de item que envolvem `Equip` recalculam `CharacterStatusService` e reenviam `0x103`, `0x109`, `0x10A` e `0x108`, alem do refresh do item alterado.
- Uso de skill, benção/buff, teleporte e outras recalculagens devem usar `CharacterRefreshService.SendFullRefresh` em vez de reenviar apenas HP/MP.
- `.title <id>` concede o titulo em nivel 1 caso o personagem ainda nao possua, ativa `ActiveTitle/ActiveTitleLevel`, envia `0x361`, reenvia a lista `0x1086`, recalcula status, persiste titulos e salva runtime state.
- `.effect <skillDataId>` interpreta o id como entrada de `SkillData`/buff, aplica via `BuffService`, envia animacao `0x31F` quando `SkillData.Anim/SelfAnimation` existir, envia `0x16F` para o proprio jogador e visiveis e dispara full refresh. Nao e id bruto de `EF_*`.
- `CharacterStatusService` aplica efeitos fixos do template (`EF`/`EFV`) e efeitos randômicos salvos no item equipado; os efeitos randômicos seguem a regra Delphi de `Value * 2`.
- `CharacterStatusService` preserva atributos base do banco e calcula atributos efetivos runtime (`EffectiveStrength`, `EffectiveAgility`, `EffectiveIntelligence`, `EffectiveConstitution`, `EffectiveLuck`) com efeitos de equip/set. `0x109` e o bloco de status do `0x925` enviam os efetivos quando disponiveis.
- Equip com `MaxValue > 0` e `MinimalValue == 0` e tratado como quebrado para status: nao soma atributos, ataque, defesa, HP/MP ou efeitos.
- Efeitos atualmente aplicados no runtime: STR, DEX, INT, CON, SPI, HP, MP, dano fisico/magico, defesa fisica/magica, percentuais de dano/defesa, velocidade, critico, esquiva/parry, acerto/hit, duplo e resistencia.
- Formulas internas atuais baseadas nos screenshots de atributos: STR soma ataque fisico `2.6`, duplo `1/6.5`, dano critico `0.2` e perfuracao fisica `0.3`; AGI soma ataque fisico `2.6`, critico `0.1`, acerto `0.15` e esquiva `0.05`; INT soma ataque magico `3.325`, cura `6`, resfriamento `0.04` e perfuracao magica `0.3`; SORTE soma MP `25`, regen MP `3`, resistencia `0.1` e habilidade de ataque `5`; CON soma HP `25`, regen HP `3`, resistencia a critico `0.1` e resistencia a duplo `0.1`.
- `0x10A` segue `TSendRefreshStatus`: dano/defesa, paddings, velocidade, critico, esquiva, acerto, duplo e resistencia.
- `SpeedMove` preserva o valor carregado do banco/template quando maior que zero; o default `40` so entra quando o personagem nao tem velocidade base. Efeitos de velocidade sao aplicados sobre `BaseSpeedMove` para nao empilhar a cada recalculo.
- Ganhos de pontos por level seguem Delphi: todo level ganha `+1 SkillPoint`; levels acima de 50 ganham tambem `+2 Status`; levels acima de 50 onde `Level mod 10 = 1` ganham bonus adicional `+7 SkillPoint` e `+10 Status`. Level up recalcula status e restaura HP/MP ao maximo.

## Pontos de cuidado

- A ordem dos campos nos pacotes e parte do contrato com o cliente.
- Muitos valores `Unk`/padding ainda sao conhecimento empirico de protocolo.
- `CharacterHandler` deve continuar como entrypoint do `PacketDispatcher`; novas regras de mundo devem entrar nos services dedicados.
- A ordem dos campos nos packets foi mantida por testes de caracterizacao.
