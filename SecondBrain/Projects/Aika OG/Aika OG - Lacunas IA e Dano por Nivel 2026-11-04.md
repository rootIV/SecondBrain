---
tags:
  - project/aika-og
  - combat
  - investigation
  - ai
updated: 2026-11-04
---

# Lacunas da IA e estudo de dano por nível

> Atualização posterior: [[Aika OG - Curva PvE Mana e Area 2026-11-04]] implementa curva4×, mana e área após autorização. Este estudo conserva os resultados anteriores à mudança.

[[Aika OG - MOC]], [[Aika OG - IA Combate e Niveis Referencias 2026-11-03]], [[Aika OG - Implementacao Lore Combate 2026-10-20]]. Relatório: `C:\Projetcts\aika-og\docs\analysis\COMBAT-AI-GAPS-LEVEL-SCALING-2026-11-04.md`. Evidências: `artifacts/mob-ai-combat-gap-study-20261104/`.

## Resultado

Estudo solicitado após o usuário notar mobs de nível muito superior causando pouco dano. Nenhuma regra/dado/serviço foi alterado. Catálogo capturado em transação somente leitura:376modelos/5.623spawns;255modelos ativos não-serviço com spawn,248com ataque positivo,43de nível70–150.26desses43têm PATK≤400/MATK≤600, candidatos a revisão de conteúdo por identidade.

Fixture explícita jogador50/4.000HP/DEF1.200, básico normal acertado sem buffs: Lilitu Nova100/ATK200 dá50; Guarda Ungor Mirza150/ATK300 dá150; Scher100/ATK3108 dá2.958. Com fator final4×:200/600/11.832. Um único multiplicador não substitui a correção da potência de cada modelo; não assumir que todo roxo deva dar hitkill.

## Lacunas confirmadas

- Mana: loaders SQL/CSV não inicializam MaxMana/CurrentMana de mobs; o default é0 e CanUseMobSkill exige custo.19slots de9modelos ativos exigem MP; fornecer somente mana em memória desbloqueou10slots de7modelos: Dmitri Haskil, Krauss Deslumbrado, Ladia Gras, Jark Djubled, Esther Simons, Feiticeiro Negro Steichen e Stanka. Testes de skills existentes montam mana manualmente; falta contrato de carga→spawn→cast.
- Dispatcher de mobs aceita Enemy/Single Attack/AttackDebuff/Debuff.31slots Area em20modelos ativos são recusados;25têm MP0, portanto só fornecer mana não resolve a área. Probe sintético confirma recusa de Enemy/Area e Self/Heal.
- Perfil de básico depende de slots e prefixos de nome. MATK maior sem skill/básico reconhecido ainda pode usar PATK, como Lilitu Nova. Validar papel por modelo, sem transformar toda diferença MATK>PATK em magia automaticamente.
- Movimento/separação não incluem navegação de terreno/LOS nesses métodos; leash é relativo à posição inicial do alvo, não cerca absoluta do spawn. Velocidades-base de patrulha10/80 deram o mesmo passo1,5. Cooldown básico global3s e rotação de cinco slots não substituem scripts/fases de boss. Cast autoritativo ainda tem telegraph sem produtor nativo comprovado.
- Controle mantém direção do nível da vítima já apontada em03/11; efeito sobre dano é separado. Ataque/defesa efetivos de mobs saturam em65.535. Mina Invisível4934 e Aron1373 exigem revisão semântica; não aplicar vantagem de nível cega a objetos/sentinelas.

## Curva proposta, ainda fora do runtime

PvE apenas: Δ=nívelAtacante−nívelAlvo; e=max(0,|Δ|−5); vantagem=min(limite,2^(e/10)); fator=vantagem no sentido superior e recíproco no inferior. Modelo conservador para calibrar:limite4; contraste agressivo:limite8. Para mob acima do jogador: +10→1,414× recebido/0,707× causado; +20→2,828×/0,354×; +30 ou mais no limite4→4×/0,25×. São parâmetros de estudo, não limiares de cores nem fórmula oficial.

Preferir calibrar inicialmente após mitigação com dados corrigidos, antes de proteções/transferência/reflexão; avaliar separadamente a alternativa antes de defesa, que atravessa absorção de forma muito mais forte. Exemplo ATK200/DEF6000/fator4:atual1, pós-defesa4, pré-defesa50. Não usar environmentMultiplier como se fosse idêntico a multiplicar o dano já arredondado no piso.

Antes de implementar, cobrir DoT, splash por alvo, canais adicionais e dreno percentual, preservando dano zero/proteções, sem multiplicar reflexão/transferência de novo. Cura/XP/PvP ficam fora da proposta. Alterar dano recebido e causado simultaneamente compõe a relação de dificuldade: teto4 resulta em16×; teto8 em64×. Corrigir atributos e habilidades ausentes antes de decidir a curva.

## Verificação e limites

227testes existentes aprovados,47avisos de build;545assertivas no probe da DLL atual;155casos de slots,765casos modelo/defesa,1.260cenários de curvas e1.524projeções sobre o catálogo. Metadados nativos de skills têm o mesmo hash do recurso SQL. `CatalogResources.DatabaseLoaded=false` no probe, sem sessão/conexão SQL no processo; entidades reconstruídas da captura, não carga completa do servidor.

No recorte de25arquivos, CombatMath/DamageCalculator/MobAiService permanecem com o hash do relatório anterior; MobPacketFactory/ControlEffectService/PeriodicBuffService mudaram e foram relidos. Commit e hashes em source-manifest.json. Não foram comprovados cores exatas, gameplay/TTK real, todos os bosses ou a causa de um encontro específico sem personagem/mob/dano completos. A curva permanece hipótese customizada a homologar.
