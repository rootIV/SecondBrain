---
tags:
  - project/aika-og
  - game-server
  - skills
updated: 2026-07-04
---

# Aika OG - SkillService

## Escopo implementado

Sistema inicial de skills no `GameServer`: skills iniciais do personagem, uso PvE instantaneo contra mobs, janela de skills via NPC e aprendizado/elevacao simples.

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
  - para `CastTime <= 0`, executa dano reaproveitando `CombatService` e pacote `0x102`.

## Dialogo NPC e aprendizado

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
- Ao aprender, atualiza `SkillSlots`, gasta `SkillPoint`/gold, persiste `skills`/`itembars` e envia `0x106`, `0x107`, HP/MP, status, atributos e level/EXP.

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
- `SelfAnimation`: `344`
- `TargetAnimation`: `348`
- `Anim`: `356`
- `Description`: `428`, tamanho `288`

## Limites desta etapa

Nao foram portados ainda:

- AoE;
- buffs/debuffs;
- cura;
- cast time real;
- passivas;
- PvP;
- IA de mob usando skill;
- cooldown avancado por tipo/grupo;
- regras especiais por classe/skill da Delphi.

## Relacao com Delphi

Na Delphi, `TPacketHandlers.UseSkill` consome MP, valida cooldown/ataque, faz broadcast do `0x320` e, quando `CastTime <= 0`, cria internamente um `TSendAtkPacket` (`0x302`) usando `SelfAnimation` e chama `AttackTarget` com `ByUseSkill = True`.

O C# segue esse desenho, mas no primeiro recorte limita o alvo a mob comum carregado no `WorldDataService.Mobs`.
