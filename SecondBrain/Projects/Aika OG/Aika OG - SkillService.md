---
tags:
  - project/aika-og
  - game-server
  - skills
updated: 2026-07-08
---

# Aika OG - SkillService

## Escopo implementado

Sistema inicial de skills no `GameServer`: skills iniciais do personagem, uso PvE instantaneo contra mobs, buffs/debuffs PvE v1, cura simples, janela de skills via NPC e aprendizado/elevacao simples.

- Entrada: opcode `0x320`, equivalente Delphi `TSendSkillUse`.
- Layout de entrada apos header:
  - `Skill: DWORD`
  - `Index: DWORD`
  - `Pos: TPosition`
- Dados estaticos: `Data\SkillData.bin`.
- Loader: `SkillTemplateService` + `SkillTemplateParser`.
- Tamanho do record Delphi `T_SkillData`: `720` bytes.
- Persistencia: tabelas `skills` e `itembars`, criadas com `CREATE TABLE IF NOT EXISTS`.
- Modelo de personagem:
  - `CharacterSkillEntity` usa `Type=1` para `Basics[0..5]` e `Type=2` para `Others[0..39]`.
  - `CharacterSkillService.GetSkillIndex(classId, skillNumber, level)` segue a formula Delphi.
  - `CharacterSkillService.GetClassIdFromClassInfo` segue a regra Delphi por faixa: `1..9` Warrior, `10..19` Templar, `20..29` Rifleman, `30..39` Dual, `40..49` Feiticeiro e `50..59` Cleric.
  - `GetSkillIndexOnBar(skillId) = (skillId * 16) + 2`.
  - `GetFromBarSkillIndex(barValue) = (barValue - 2) / 16`.
- Defaults de personagem novo:
  - seis skills basicas em level 1;
  - `Others[0]` em level 1;
  - barra inicial: ataque, primeira skill de classe, terceira basica e retorno.
- Fluxo:
  - valida template de skill, level, MP, cooldown simples, arma equipada via combate, mob vivo/ativo e range;
  - consome `SkillData.MP`;
  - registra cooldown runtime em `CharacterEntity.SkillCooldowns`;
  - envia `0x320` criptografado com `SkillPacketFactory`;
  - envia animacao `0x31F` para o atacante e visiveis;
  - no modo compativel v1, `CastTime > 0` executa instantaneamente ate existir fila real de cast;
  - executa dano reaproveitando `CombatService` e pacote `0x102`;
  - quando a skill tem duracao e efeitos, aplica buff/debuff runtime e envia `0x16F`;
  - quando a skill e de cura simples, aumenta HP sem passar do maximo e envia refresh de HP/status.

## Buffs e debuffs PvE v1

- Modelo runtime: `ActiveBuffEntity`, usado por personagem e mob, com ate `60` slots.
- Campos principais: `SkillId`, `SkillIndex`, `StartedAt`, `EndsAt`, `SourceId`, `EffectIds[4]`, `EffectValues[4]` e flag `IsDebuff`.
- `BuffService.AddBuff` segue a ideia Delphi:
  - ignora buffs bloqueados conhecidos (`7257`, `9133`);
  - substitui buff anterior equivalente por `UniqueType` quando `UniqueType > 0`; caso contrario, por `SkillData.Index`/`SkillId`;
  - ocupa o primeiro slot livre ate o limite de `60`;
  - calcula `EndsAt` a partir de `SkillData.Duration`;
  - remove expirados via tick de `CharacterRegenerationService`/`MobAiService`.
- Packets Delphi/Rafinha:
  - `0x16E`: refresh completo, com `60` ids de buffs e `60` tempos restantes em segundos (`TSendBuffsPacket`, size `372`);
  - `0x16F`: add/update individual com `Buff: DWORD`, `RemainingSeconds: DWORD`, `Unk: DWORD` (`TUpdateBuffPacket`, size `24`).
  - Importante: o cliente interpreta o campo de tempo como duracao restante, nao como timestamp Unix absoluto. Enviar `EndsAt`/Unix time faz o cliente exibir duracoes absurdas, como centenas de meses.
- Ao aplicar buff via skill ou comando `.effect`, o servidor deve enviar animacao `0x31F` usando `SkillData.Anim/SelfAnimation`, depois `0x16F` e refresh de status.
- `CharacterStatusService` inclui os efeitos de buffs ativos no mesmo coletor usado por item, set e titulo. O acumulador agora aceita valores assinados, entao debuffs com valores negativos reduzem atributos/status e o resultado final e clampado.
- Quando um buff expira no personagem, o servidor envia `0x16E` e refresh completo (`0x103`, `0x109`, `0x10A`, `0x108`).
- Buffs runtime nao sao persistidos nesta etapa; Giovanni e buffs de NPC devem passar pelo mesmo `BuffService` quando houver `SkillData` correspondente.
- Debuff em mob fica no proprio `MobEntity.ActiveBuffs`, expira de forma isolada e nao afeta outros mobs. `MobEffectiveStatsService` aplica debuffs/buffs de ataque, defesa e velocidade no calculo PvE.

## Dialogo NPC e aprendizado

Nota de reverse engineering 2026-07-08: a janela normal de skills do jogo e controlada por pacotes (`0x106`, `0x107`, `0x31C`) e nao deve ser confundida com o recurso Win32 debug `Dialog 103 - Skill Effect` dentro de `AIKA.exe`. Esse dialog abre por patch/injecao, mas nao tem handler original encontrado; a tentativa funcional atual e um viewer read-only lendo `Effect\SkillEffect.bin`. Ver [[Aika OG - AIKA.exe Win32 Dialogs]].

- Entrada `0x30F` (`TOpenNPCPacket`): `Index`, `Type1`, `Type2` como `DWORD`.
- `Type1=0`: abre menu de NPC com `0x110`, `0x10E` e opcoes `0x112` vindas de `TNPCHeader.Options[0..9]` dos arquivos `.npc`.
- Os textos das opcoes vem de `Data\NPCOptionsText.bin`, decodificado como Windows-1252/Latin1, com fallback para opcoes comuns como `1`, `2`, `6`, `8` e `21`, alem dos overrides Delphi conhecidos para `47`, `59`, `60` e `64`.
- `Type1=6`: fecha o dialogo/opcao anterior com `0x10F`, limpa `OpenedNpc`/`OpenedOption` e envia `0x106` (`TSendSkillsPacket`) com `NPCIndex` e `SendType=0x000B` somente quando o NPC tem opcao `6`.
- NPCs comuns nao recebem mais a opcao global "Obter Skills"; a opcao de skills so aparece quando `TNPCHeader.Options[0..9]` do `.npc` contem `6`.
- `0x348`: fecha dialogo/opcao de NPC, limpa `OpenedNpc`/`OpenedOption` e envia `0x10F`.
- `SkillTrainerService` filtra a lista exibida por instrutor:
  - `2051 Alen Sinclair`: Warrior/Templar, fallback Warrior;
  - `2052 Sarah Rainer`: Rifleman/Dual, fallback Rifleman;
  - `2053 Sienna O'Connor`: Feiticeiro/Cleric, fallback Feiticeiro.
- O fallback muda apenas a lista exibida/aprendivel naquele NPC; nao altera a classe real nem os slots de skill salvos do personagem.
- Entrada `0x31C` (`TLearnSkillPacket`): `SkillIndex`, `NPCIndex` como `DWORD`.
- `SkillService.LearnSkill` valida NPC aberto/proximo, level minimo, pontos de skill, gold, classe compativel, classe permitida pelo instrutor e bloqueia `SkillData.Index = 427`.
- Compatibilidade de classe promovida e unidirecional por familia/tier: uma classe promovida aprende skills do tier anterior da mesma familia (`classInfo=12` aprende `templateClass=11`), mas o tier base nao aprende skill promovida (`classInfo=11` nao aprende `templateClass=12`). A regra vale para Warrior `1/2`, Templar `11/12`, Rifleman `21/22`, Dual `31/32`, Feiticeiro `41/42` e Cleric `51/52`.
- Ao aprender, atualiza `SkillSlots`, gasta `SkillPoint`/gold e persiste `skills`, `itembars`, `characters.skillPoint` e `characters.gold` em uma transacao. Depois fecha o dialogo com `0x10F`, reenvia `0x106` filtrado pelo instrutor, `0x107`, HP/MP, status, atributos e level/EXP.
- Regra importante da Delphi: `Others[i].Index` permanece como indice base da skill. Ao comprar/subir uma habilidade pelo NPC, o servidor incrementa `Others[i].Level`, mas nao troca o `Index` para o indice do nivel clicado. O `0x106` deve continuar mostrando o indice base; o `0x107` e que indica o nivel atual.
- A Delphi tambem percorre `Basics` antes de `Others` em `TSkillFunctions.IncremmentSkillLevel`. O C# deve permitir upgrade de skill basica/padrao da classe, como proficiencia com escudo, consumindo `SkillPoint`/gold e mantendo o indice base do slot.
- Quando `0x31C` for rejeitado, o C# loga motivo explicito (`skillPoint`, gold, classe, NPC/trainer ou slot nao encontrado) para evitar falha silenciosa com handler concluido.
- `characters.skillPoint` no banco e `int unsigned`; o C# le como valor numerico amplo e clampa para `ushort`, evitando overflow em contas antigas ou valores altos.

## Barra de skills e itens

- Entrada `0x31E` (`TChangeItemBarPacket`): `DestSlot`, `SrcType`, `SrcIndex` como `DWORD`.
- `SrcType=0`: limpa o slot da barra.
- `SrcType=2`: coloca skill aprendida/ativa usando `CharacterSkillService.GetSkillIndexOnBar(SrcIndex)`.
- A validacao aceita `SkillId` base, indice de level atual dentro do range `SkillId..SkillId+15`, e valor ja codificado da barra `(SkillId * 16) + 2`.
- `SrcType=19` (`BAR_ITEM`) e aceito defensivamente para compatibilidade de UI: quando `SrcIndex` aponta para outro slot da barra, troca o valor do slot origem com o destino; quando nao e movimento de slot, tenta resolver skill ativa ou item.
- Movimento interno da barra foi separado do fluxo de skill nova: `SrcType=19` trata `SrcIndex` como slot de origem; `SrcType=2` so cai nesse modo defensivo quando falha como skill ativa, `SrcIndex < 40`, o destino esta ocupado e o destino contem o valor codificado daquela skill. Isso evita duplicar/sumir ao trocar ataque basico com proficiencia, mas preserva o drag de skill nova para slot vazio.
- `SrcType=6`: coloca item na barra apenas se o item existir no inventario ou nos equips do personagem.
- Antes de rejeitar uma skill como inativa, `SkillBarService` garante/normaliza os slots padrao da classe atual em memoria para cobrir personagens antigos sem skills persistidas ou com skills da classe errada por mapeamento antigo.
- A resposta tambem usa opcode `0x31E`, sender `0x7535`, e ecoa `DestSlot`, `SrcType`, `SrcIndex`.
- `SkillBarService` atualiza `CharacterEntity.ItemBar` em memoria; `SkillRepository.SaveCharacterSkillsAndBarAsync` persiste imediatamente em `itembars`, entao a configuracao permanece apos relogar.
- `SkillRepository` normaliza skills antes de salvar por `(Type, Slot)`, mantendo a ultima entrada valida, e usa `INSERT ... ON DUPLICATE KEY UPDATE` em `skills` e `itembars` para impedir crash por duplicata residual em memoria.

## Catalogo auditavel de comportamento

Em 2026-07-06, o GameServer passou a carregar `Data\SkillBehaviors.json` no boot por `SkillBehaviorCatalogService`, cruzando o catalogo com `SkillData.bin`.

- O arquivo gerado contem 7.283 entradas, uma por skill nao vazia de `SkillData.bin`.
- Skills revisadas (`reviewed=true`) usam o comportamento auditado do catalogo.
- Skills nao revisadas (`reviewed=false`) com `BehaviorKind` concreto usam `MergeWithTemplate` e fallback inferido de `SkillData.bin`, restaurando ataques, ataque+debuff, buffs, debuffs e curas genericas para as classes jogaveis.
- Skills com `BehaviorKind=Unknown` continuam bloqueadas no uso e retornam falha antes de consumir MP ou cooldown.
- Entradas nao revisadas do catalogo geradas como `Attack/Enemy/Target`, mas cujo `SkillData` infere `Buff`/`Heal` por duracao+efeitos e sem dano, passam a usar o comportamento inferido do template. Isso corrige casos como `skillId=1121..1136` / `Guardiao` e `skillId=1233` / `Protecao`, que antes exigiam alvo inimigo, falhavam silenciosamente antes do `0x320`/`0x31F` e nao criavam `ActiveBuff`/`0x16F`.
- `skillId=1233` / `Protecao` foi revisada explicitamente como `Buff/Self/Caster`. O `TargetId` recebido no `0x320` nao e resolvido como mob; o cast consome MP/cooldown, usa a animacao do `SkillData` e publica o buff temporizado no `0x16F`.
- `SkillHandler.UseSkill` agora loga rejeicoes de uso com `charId`, classe, skill, alvo, MP e motivo, para evitar falhas silenciosas quando o catalogo ou validacoes bloquearem uma skill. `SkillService.UseSkill` tambem retorna motivos explicitos para contexto invalido, template ausente/invalido, level, MP, cooldown, alvo ausente/fora do range, rejeicao de buff e falha de combate.
- A primeira regra revisada e `skillId=140` / `Quebrar Armadura`: `AttackDebuff`, alvo inimigo, aplica dano e debuff somente no mob alvo; a animacao propria fica no emissor e `TargetAnimation` fica no pacote de dano/efeito do destinatario.
- `SkillService.UseSkill` agora executa via `SkillBehaviorDefinition` quando o catalogo esta configurado; sem catalogo configurado, testes e comandos internos continuam usando inferencia a partir de `SkillData`.
- Buffs/debuffs ativos passam a ter persistencia em `active_buffs` por `ActiveBuffRepository`, com `owner_type`, `owner_id`, `skill_id`, `skill_index`, `unique_type`, `is_debuff`, `started_at`, `ends_at`, `source_id`, `effect_ids` e `effect_values`.
- `CharacterRepository` reidrata buffs ativos nao expirados ao carregar personagem. O lifecycle de buff remove expirados no tick de regen e envia `0x16E` + refresh completo ao personagem afetado.
- Debuffs de mob continuam runtime no `MobEntity.ActiveBuffs`; o schema suporta `owner_type='mob'` para persistencia quando for necessario reidratar mobs.
- `0x329` (`TRemoveBuffPacket`) agora remove buff ativo do proprio personagem por `SkillData.Id` ou `SkillData.Index`, persiste a remocao em `active_buffs`, envia `0x16E` e full refresh. Pacotes de remocao para buffs ja expirados sao no-op.
- A remocao manual tambem resolve o ID recebido para o `SkillData.Index` da familia. Assim, por exemplo, `buff=1245` remove uma Protecao ativa de outro nivel com `SkillIndex=36`; nao existe lista de buffs irremoviveis nesta etapa.
- `skillId=1070` / `Proficiência com Escudo` foi revisada no catalogo: `AttackDebuff`, alvo inimigo, dano `360`, efeito `73`, duracao `4s`, aplicado ao alvo.

## Offsets principais de SkillData

- `Index`: `0`
- `MinLevel`: `4`
- `NameEnglish`: `20`, tamanho `64`
- `Name`: `84`, tamanho `64`
- `Classe`: `156`
- `MP`: `172`
- `Cooldown`: `184`
- `CooldownType`: `188`
- `TargetType`: `192`
- `Range`: `208`
- `DamageRange`: `212`
- `SuccessRate`: `216`
- `Damage`: `248`
- `Adicional`: `252`
- `Duration`: `292`
- `CastTime`: `320`
- `TargetAnimation`: `348`
- `Anim`: `356`
- `SelfAnimation`: usa o campo Delphi `Anim` no offset `356`; o offset `344` pertence ao bloco desconhecido anterior e nao deve ser usado como animacao propria.
- `Description`: `428`, tamanho `288`

## Limites desta etapa

Nao foram portados ainda:

- AoE;
- cast time real;
- passivas especiais/complexas;
- PvP;
- IA de mob usando skill;
- cooldown avancado por tipo/grupo;
- regras especiais por classe/skill da Delphi.
- AoE complexo;
- revisao manual completa das 7.283 skills em `SkillBehaviors.json`;
- remocao manual/cancelamento visual avancado de buff;
- todas as regras especiais de buff/debuff da Delphi.

## Relacao com Delphi

Na Delphi, `TPacketHandlers.UseSkill` consome MP, valida cooldown/ataque, faz broadcast do `0x320` e, quando `CastTime <= 0`, cria internamente um `TSendAtkPacket` (`0x302`) usando `SelfAnimation` e chama `AttackTarget` com `ByUseSkill = True`.

O C# segue esse desenho, mas no primeiro recorte limita o alvo a mob comum carregado no `WorldDataService.Mobs`.

Em 2026-07-05, a factory de `0x320` foi corrigida para copiar os bytes antes de devolver o `PacketStream` ao pool. Isso e importante para efeitos visuais de skill/buff, porque devolver o objeto antes de `GetBytes()` podia corromper/zerar o payload visual. O comando `.effect <SkillDataId>` tambem passou a enviar `0x320` visual para si/visiveis antes do `0x31F` e do `0x16F`, aproximando o fluxo de uma skill real aplicada no proprio personagem.

Em 2026-07-08, o `SkillService.UseSkill` passou a suportar resultado multialvo para PvE inspirado no Rafinha: `SkillBehaviorDefinition` ganhou `TargetMode`, `AreaCenter` e `MaxTargets`; skills com `SuccessRate = 1` e `Range > 0` sao inferidas como area; o servico consome MP/cooldown uma vez por cast, resolve mobs ativos dentro da area, aplica dano/buff por alvo e retorna listas de `CombatResults`/`AppliedBuffs`. O `SkillHandler` envia `0x102` e `0x16F` para todos os resultados afetados, preservando compatibilidade com `CombatResult`/`AppliedBuff` para o primeiro alvo.

## Passivas v1

`CharacterPassiveSkillEffectService` porta um primeiro subconjunto de `TPlayer.SearchSkillsPassive`, somente para efeitos diretos que ja existem no status atual. Exemplos implementados:

- `Index 9`: dano fisico e acerto;
- `Index 10`: HP maximo;
- `Index 23`, `47`, `81`: critico/dano fisico direto quando aplicavel;
- `Index 57`: acerto;
- `Index 82`: esquiva/parry;
- `Index 152`: velocidade.

Efeitos especiais sem infraestrutura atual continuam no-op documentado ate as mecanicas correspondentes existirem.

## Templaria, party e hooks de combate - 2026-07-14

- `TemplarSkillRuleService` centraliza regras por familia/Index mantendo o ID exato do cast como nivel (`ef 1281`, `1282`, etc.).
- Pesca `1025` e montaria `1041` sao rejeitadas antes de MP/cooldown com erro explicito; ficam fora do pacote atual.
- Core implementado: Defesa Concentrada `993`, Stigma `1009`, Proficiência com Escudo `1057`, Remediar `1073`, Nemesis `1089`, Incitar Multidao `1105`, Guardiao `1121`, Sangue Sagrado `1137`, Travar Alvo `1153`, Defesa Concentrada de cargas `1169`, Punicao `1185`, Revelacao `1201`, Uniao Divina `1217`, Protecao `1233`.
- Avancadas implementadas: Emissao Divina `1249` AoE 4m/silence, Escudo Refletor `1265`, El Tycia `1281`, El Aster `1297`, El Thymos `1313`, El Aegis `1329`, Atracao Divina `1345`.
- `CombatModifierService` aplica multiplicador racial contra Demon/Undead, reducoes, Protecao com cargas, reflexao sem recursao, life steal, splash basico do El Thymos e redirect da Uniao Divina.
- `PartyDamageService` gerencia link da Uniao Divina, redirect de 30% com cap acumulado 2680, bonus de resistencia e remocao de link invalido.
- `ControlEffectService` separa stun, silence e root. Silence bloqueia skills, nao ataque basico; root bloqueia movimento, nao ataque se ja estiver em alcance.
- `BuffLifecycleService` processa tick do El Aegis a cada 2s e limpa links invalidos de Uniao Divina.
