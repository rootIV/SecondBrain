---
tags:
  - project/aika-og
  - references
  - combat
  - investigation
updated: 2026-11-03
---

# Aika OG - IA Combate e Niveis Referencias 2026-11-03

## Resultado confirmado

Nova referência cadastrada: `D:\aika\AIKA Source`, Delphi, DPR com 49 unidades explícitas presentes e 58 arquivos PAS em Src. Comparada com Lore, Rafinha, TheMu, AikaEmu e a source atual `C:\Projetcts\aika-og`. Não houve mudança de gameplay, banco, protocolo, cliente ou serviços instalados.

- `CombatMath.Mitigate/Penetration/RollDamageType` atuais mantêm parâmetros de nível sem usá-los na aritmética. A remoção do fator antigo é intencional, testada em `LoreCombatMathTests.DefenseUsesLoreAbsorptionWithoutTheFormerLevelFactor`.
- Atributos finais fixos: 17 pares de nível e 408 cenários nas funções reais não mudaram o dano nos sentidos jogador→mob, jogador→jogador e mob→jogador. PvP usa fator global 0,75; miss/proteções podem produzir zero e armadura suficiente produz piso 1 em impacto válido.
- Progressão e equipamento mudam o resultado indiretamente: amostra de guerreiro comum sem refino, nível 10→30 = 53 de dano, 30→10 = 110; 30→50 = 57, 50→30 = 205. São catálogos locais e uma amostra explícita, não o snapshot MySQL ou calibração de gameplay.
- Controle é uma exceção importante: `ControlEffectService.CanApplyControl` depende do nível da vítima. Resistência fixa 100 dá 58,33%/68,75%/75% nos níveis 10/30/50. A direção merece revisão de intenção; não foi alterada. XP usa diferença de nível separadamente.

## Nova referência e caveats

- `GetDamage`: DEF/10 e aleatório 1..54 após defesa/piso; `AttackParse` soma o termo da skill após defesa; `SendDamage` acrescenta outro aleatório +13. A fórmula atual usa DEF/8, termo da skill antes da defesa e não possui esse aleatório genérico após absorção.
- O fator 0,25 em `SendDamage` novo é condicionado a PONTO_CEGO + skill 95 do alvo, não é fator global PvP ou penalidade de nível.
- O crítico novo pode atingir 100% na etapa com rating positivo e resistência zero; curvas não devem ser portadas automaticamente. Rafinha/TheMu reutilizam o sorteio; Lore tem outras descontinuidades.
- `GetCurrentScore` novo consulta StatusPoint por atributos excedentes à base e acrescenta parcelas por nível de ataque/defesa/acerto/esquiva/dano crítico. `D:\aika\Data\StatusPoint.bin` tem 200.100 bytes compatíveis com o layout 2001×25×int32, sem comprovação de carga no EXE instalado.
- IA atual já possui ameaça/decay, formação, retorno andando, rotação/cast/mana/cooldown de skills. Delphi possui regras úteis de conteúdo, guardas e instâncias, mas resets imediatos e patrulha por eixos não são substitutos automáticos melhores.
- Nenhuma chamada de `SendMobDamage` foi localizada nas unidades explícitas dos quatro DPRs. O fluxo confirmado é AttackTarget→BaseMob.SendDamage→GetDamage→AttackParse. A rotina legada GetMobDamage não representa esse fluxo.
- Guardas NPCs e DG/Pheltas têm caminhos próprios; não converter atores NPCs ou tomar Customs como implementação completa de guerra/combate.
- AikaEmu: handlers de skills enviam efeitos/cast; engine autoritativa equivalente de dano/aggro/perseguição não localizada no projeto e Shared examinados. Não inventar fórmula para completar a comparação.

## Evidências e validação

- [Relatório com funções/linhas e classificação C/I/N](C:/Projetcts/aika-og/docs/analysis/COMBAT-AI-REFERENCE-COMPARISON-2026-11-03.md).
- [Manifesto](C:/Projetcts/aika-og/artifacts/combat-ai-reference-comparison-20261103/source-manifest.json): 968 entradas SHA-256, 116 âncoras de rotinas e 81 comparações textuais nos artefatos associados. Similaridade não comprova equivalência nem referência independente.
- [Reprodução](C:/Projetcts/aika-og/artifacts/combat-ai-reference-comparison-20261103/README.md): 189 testes existentes passaram; 841 asserts no probe C# e 844 checks/816 linhas nas traduções escalares Delphi.
- Nenhum servidor de referência foi executado. Cliente identificado por hash, sem atribuir fórmula oficial ao renderizador. O probe atual usa funções reais e arquivos locais com DatabaseLoaded=false; gameplay, carga, todos os bosses, cerco e fórmulas oficiais continuam pendentes.

## Relações

- [[Aika OG - Referencias Externas AikaEmu e Delphi]]
- [[Aika OG - Comparacao Combate IA Referencias 2026-10-19]]
- [[Aika OG - Lore Community Combate Atributos 2026-10-19]]
- [[Aika OG - Implementacao Lore Combate 2026-10-20]]
- [[Aika OG - Studio Perfis de Spawn e Customs Ghoul 2026-11-02]]
- [[Aika OG - MOC]]
