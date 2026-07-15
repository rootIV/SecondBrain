---
tags:
  - project/aika-og
  - references
  - graphify
  - skills
  - animations
updated: 2026-07-08
---

# Aika OG - Rafinha Server Skills e Animacoes

## Referencia Graphify

- Projeto Delphi: `C:\Users\Vitor\Documents\Projects\aika\Aika Rafinha Server`
- Grafo: `C:\Users\Vitor\Documents\Projects\aika\Aika Rafinha Server\graphify-out\graph.json`
- Relatorio: `C:\Users\Vitor\Documents\Projects\aika\Aika Rafinha Server\graphify-out\GRAPH_REPORT.md`
- Visualizacao: `C:\Users\Vitor\Documents\Projects\aika\Aika Rafinha Server\graphify-out\graph.html`
- Escopo: projeto inteiro, incluindo `Src`, `Bin`, `Arquivos antigos`, backups e artefatos suportados pelo Graphify.
- Limitacao do run: a extracao semantica de docs/imagens foi bloqueada por ausencia de `GEMINI_API_KEY`/`GOOGLE_API_KEY`; o grafo gerado e estrutural/AST para codigo. A deteccao encontrou `1163` arquivos de codigo, `297` docs e `422` imagens.
- Estatisticas do grafo estrutural: `31580` nos, `67826` arestas pos-build e `1790` comunidades.
- Aviso de saude do grafo: `5789` arestas com endpoint pendente, `28` self-loops e `14634` colapsos por pares de endpoints no grafo nao-direcionado. O grafo e util para orientacao, mas o codigo ativo em `Src` deve ser a fonte final antes de portar regras.

## Fontes Delphi usadas

- `C:\Users\Vitor\Documents\Projects\aika\Aika Rafinha Server\Src\PacketHandlers\PacketHandlers.pas`
- `C:\Users\Vitor\Documents\Projects\aika\Aika Rafinha Server\Src\Mob\BaseMob.pas`
- `C:\Users\Vitor\Documents\Projects\aika\Aika Rafinha Server\Src\Mob\BaseNpc.pas`
- `C:\Users\Vitor\Documents\Projects\aika\Aika Rafinha Server\Src\Mob\Player.pas`
- `C:\Users\Vitor\Documents\Projects\aika\Aika Rafinha Server\Src\Data\FilesData.pas`
- `C:\Users\Vitor\Documents\Projects\aika\Aika Rafinha Server\Src\Data\Packets.pas`
- `C:\Users\Vitor\Documents\Projects\aika\Aika Rafinha Server\Src\Functions\Load.pas`
- `C:\Users\Vitor\Documents\Projects\aika\Aika Rafinha Server\Src\Functions\SkillFunctions.pas`

## Hubs do Graphify

- `TPacketHandlers.UseSkill` e `TPacketHandlers.AttackTarget`: entrada de skill `0x320`, criacao interna de `0x302` para cast instantaneo e roteamento para dano/skill por tipo de alvo.
- `TBaseMob.HandleSkill`, `SendDamage`, `AreaSkill`, `AreaBuff`, `SelfBuffSkill`, `TargetBuffSkill` e `AttackParse`: nucleo de aplicacao de dano, buff/debuff e animacao no pacote `0x102`.
- `TBaseNpc` replica a mesma familia de funcoes para NPC/guardas, com logica equivalente a `BaseMob`.
- Funcoes por classe: `WarriorSkill`, `TemplarSkill`, `RiflemanSkill`, `DualGunnerSkill`, `MagicianSkill`, `ClericSkill` e variantes `*AreaSkill`.
- `TPlayer.SendAnimation`: pacote visual `0x31F` com `Anim` e `Loop`.

## Fluxo UseSkill

1. `TPacketHandlers.UseSkill` interpreta `TSendSkillUse` (`0x320`), valida itens, MP, cooldown e condicoes de ataque.
2. O pacote `0x320` recebido e reenviado para jogadores visiveis via `Player.Base.SendToVisible`.
3. Para `CastTime <= 0`, a Delphi monta um `TSendAtkPacket` (`0x302`) interno:
   - `Header.Code = $302`
   - `Index = Packet.Index`
   - `Anim = DataSkill^.SelfAnimation`
   - `Skill = Packet.Skill`
   - `MyPos = Player.Base.PlayerCharacter.LastPos`
   - `TargetPos` resolvido por tipo de alvo.
4. O buffer `0x302` chama `AttackTarget(Player, ..., ByUseSkill=True, Tipo)`.
5. `AttackTarget` separa ataque basico, skill de area (`SuccessRate = 1` e `Range > 0`) e skill direcionada. Direcionadas chamam `Player.Base.HandleSkill`; dano basico chama `SendDamage`.
6. `HandleSkill` escolhe entre dano single target, `TargetBuffSkill`, `SelfBuffSkill`, `AreaBuff` e `AreaSkill`.
7. `SendDamage`, `HandleSkill` e `AreaSkill` geram `TRecvDamagePacket` (`0x102`), colocando a animacao do caster em `Animation` e a animacao do alvo em `MobAnimation`.

## Pacotes e campos de animacao

| Opcode | Struct Delphi | Papel | Campos relevantes |
| --- | --- | --- | --- |
| `0x320` | `TSendSkillUse` | Entrada/broadcast visual de uso da skill | `Skill: DWORD`, `Index: DWORD`, `Pos: TPosition` |
| `0x302` | `TSendAtkPacket` | Ataque/skill interno para resolver dano instantaneo | `Index`, `Anim`, `Skill`, `MyPos`, `TargetPos` |
| `0x102` | `TRecvDamagePacket` | Dano/efeito enviado aos visiveis | `SkillID`, `AttackerID`, `Animation`, `TargetID`, `DNType`, `MobAnimation`, `DANO`, `MobCurrHP`, `DeathPos` |
| `0x16F` | `TUpdateBuffPacket` | Add/update de buff individual | `Buff`, `EndTime`, `Unk` |
| `0x31F` | `TSendAnimationPacket` | Animacao direta do personagem | `Anim`, `Loop` |

## SkillData e animacoes

- `TLoad.InitSkillData` le `GetCurrentDir + '\Data\SkillData.bin'` como `File of TSkillData` e popula o global `SkillData`.
- `T_SkillData` em `FilesData.pas` contem `SelfAnimation`, `TargetAnimation` e `Anim` nesta ordem perto do fim do record Delphi:
  - `SelfAnimation: DWORD`
  - `TargetAnimation: DWORD`
  - `Anim: DWORD`
- No Rafinha ativo:
  - `UseSkill` usa `DataSkill^.SelfAnimation` em `Packet2.Anim` no `0x302`.
  - `SendDamage`, `HandleSkill` e `AreaSkill` usam o parametro `Anim` em `Packet.Animation`.
  - `SendDamage`, `HandleSkill` e `AreaSkill` usam `DataSkill^.TargetAnimation` em `Packet.MobAnimation`.
  - Alguns fluxos especiais ainda usam `SkillData[Skill].Anim`, por exemplo splash/passivas/skills de mob/NPC.
- Divergencia importante para o Aika OG: a nota atual `Aika OG - SkillService.md` registra que o parser C# le `SelfAnimation` do offset `356`, usando efetivamente o campo Delphi `Anim`, e `TargetAnimation` do offset `348`. Antes de portar regras do Rafinha, validar byte a byte o layout real do `SkillData.bin` usado pelo Aika OG para nao trocar `SelfAnimation`/`Anim`.

## Regras por classe

- `TBaseMob` e `TBaseNpc` possuem funcoes single target por classe: `WarriorSkill`, `TemplarSkill`, `RiflemanSkill`, `DualGunnerSkill`, `MagicianSkill`, `ClericSkill`.
- As variantes AoE seguem o mesmo padrao: `WarriorAreaSkill`, `TemplarAreaSkill`, `RiflemanAreaSkill`, `DualGunnerAreaSkill`, `MagicianAreaSkill`, `ClericAreaSkill`.
- `HandleSkill` usa `TargetSkill` para dano single target e depois aplica `AttackParse`; se `Add_Buff` ficar verdadeiro e a skill nao for resistida, chama `TargetBuffSkill`.
- `AreaSkill` itera alvos visiveis/dungeon, aplica a funcao AoE da classe por `DataSkill^.Classe`, chama `AttackParse` e depois `TargetBuffSkill` quando aplicavel.
- `AttackParse` centraliza modificadores de dano, critico/double, splash, efeitos de reliquia, debuff adicional e alteracoes especiais por skill.

## Comparacao com Aika OG atual

- O Aika OG ja tem `SkillService.UseSkill`, `SkillBehaviorCatalogService`, `SkillBehaviors.json`, `0x320`, `0x31F`, `0x102` e `0x16F`.
- Limites ja registrados em `Aika OG - SkillService.md`: AoE, cast time real, passivas complexas, PvP, IA de mob usando skill, cooldown avancado por tipo/grupo, regras especiais por classe/skill e revisao completa das skills.
- O fluxo C# atual e compativel em alto nivel com a Delphi, mas ainda esta mais restrito: foco em PvE contra mob comum, inferencia/catalogo de comportamento e execucao instantanea temporaria para cast.
- O Rafinha traz a matriz detalhada que falta: funcoes especiais por classe, variantes AoE, bifurcacao alvo/self/buff/debuff e animacao por pacote.

## Backlog priorizado para portar

1. Validar definitivamente offsets de `SkillData.bin` no Aika OG: `SelfAnimation`, `TargetAnimation` e `Anim`, comparando parser C# com o record Delphi do Rafinha e com exemplos visuais no cliente.
2. Alinhar o pipeline visual de skill: `0x320` broadcast, `0x302`/equivalente interno para cast instantaneo, `0x31F` quando aplicavel e `0x102` com `Animation`/`MobAnimation`.
3. Portar a decisao de roteamento de `HandleSkill`: dano single target, self buff, target buff, area buff e area damage.
4. Portar `AttackParse` em fases: dano base + skill damage, critico/double, splash, debuffs adicionais e modificadores de reliquia/status.
5. Portar funcoes single target por classe para o catalogo (`WarriorSkill`, `TemplarSkill`, `RiflemanSkill`, `DualGunnerSkill`, `MagicianSkill`, `ClericSkill`).
6. Portar AoE depois do single target, usando `WorldEntitySpatialIndex.GetNearbyMobs`/equivalente e respeitando `Range`, `MaxTargets`, party e dungeon.
7. Portar `SelfBuffSkill` e `TargetBuffSkill` por blocos de skill index, evitando regras genericas quando a Delphi tem caso especial.
8. Portar skill de mob/NPC separadamente, reaproveitando `BaseNpc`/`BaseMob` apenas como referencia, porque o Aika OG ainda nao tem IA de mob usando skill completa.
9. Revisar `SkillBehaviors.json` por lotes de classe, marcando `reviewed=true` apenas quando a regra foi validada contra Rafinha.
10. Depois das regras PvE, abrir frente separada para PvP, cooldown por grupo/tipo e cast time real.

## Consultas Graphify executadas

- `graphify query "UseSkill skill animation SelfAnimation TargetAnimation packet 0x320 0x31F damage buff" --budget 3000`
- `graphify query "HandleSkill AreaSkill SelfBuffSkill TargetBuffSkill class skill behavior animation" --budget 3000`
- `graphify query "SkillData fields SelfAnimation TargetAnimation Anim packet layouts" --budget 2500`

Resultado pratico: devido ao escopo completo, o Graphify encontra muitos backups antes de `Src`; por isso, o levantamento final acima foi confirmado por leitura direta dos arquivos ativos em `Src`.
