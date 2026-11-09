# Aika OG - Balanceamento Classes e Progressao 2026-10-19

**Estado posterior20/10/2026:** [[Aika OG - Implementacao Lore Combate 2026-10-20]] substituiu a matemáticaV1 instalada por DEF/8, pools/coefs Lore e normalização conjunta de123mobs.49extras/cap11 preservados. O conteúdo abaixo descreve a etapaV1 anterior; não usar5925HP ou400ATK50 como orçamento atualmente instalado.

Estado atual: primeira V1 com49 extras/cap11 implementada e instalada com backup em19/10/2026.1.183 testes GameServer+119 Studio passaram, zero falhas,10 condicionais não executados em cada suíte. Smoke real de quatro portas/catálogos e encerramento por ENTER passou; serviços ficaram parados. Continuação de [[Aika OG - Desenho Atributos e Combate 2026-10-19]].

## Contrato posterior que substitui a proposta abaixo

- Primeira V1 com49 extras até50, cap de contribuição de refino+11; não usar os pools reduzidos v1.1. HP50 sem itens: guerreiro5925/templária6610/atirador4375/pistoleira4745/feiticeiro3785/clériga4670.
- Crescimento derivado preserva atributos persistidos, mana0 não enche ao recalcular, morto mantém HP/MP0. Defesa absorve DEF/8 e mitiga K/(K+DEF), K100+20L; variação±5% antes da defesa, sem25..134 pós-mitigação.
- Equipamento por1.270 IDs explícitos, família PvE/PvP por peça; natureza e refino nativo comprovados.56 instâncias auditadas sem refino acima11. Arquivo Data externo na raiz, não criar Data parcial nos binários.
-124 templates normais de mundo validados no banco real, ATK50=400/HP4000/DEF600; manifest transacional com antes/depois, backup/rollback recusando drift.376 templates totais, apenas13 totalmente zerados; não inferir o banco pelo CSV.
- Catálogo real preservado para guardas/bosses/eventos/DGs não identificadas. Não aplicar orçamento de dificuldade por suposição.
-25.924 verificações matemáticas no modelo V1+49. Feiticeiro de referência18,8s contra três mobs, abaixo da referência20s mas sem morte instantânea; calibração no jogo pendente. Coeficientes customizados, sem alegação de fidelidade comprovada ao oficial.
- Relatório executável e evidências: [COMBAT-V1-IMPLEMENTATION-2026-10-19.md](C:/Projetcts/aika-og/docs/operations/COMBAT-V1-IMPLEMENTATION-2026-10-19.md). O texto v1.1 abaixo fica somente como histórico.
- Backup: `artifacts/combat-implementation/backup-20261019-181850`, SQL completo+binários+manifest antes. SQL verificou5 colunas, extensão1,376 templates preservados;1.270 perfis reais carregados no smoke.113 testes focados de buff/SQL e55 de isolamento de quests passaram sem skips. `EditorQuests.json` do operador permanece intacto; fixtures não podem herdar seu modo de teste global.
- Motor PvP testado, mas handlers fechados até existir política explícita de zonas/alianças; não habilitar globalmente por nações diferentes. DR15s é transitório por entidade; fim do controle persiste. Classificação conhecida de dano atrasado inclui Mjolnir2977–2992 com evidência física explícita. Gameplay das seis classes e dificuldades de DG continuam pendentes.

Fonte: [BALANCED-COMBAT-2026-10-19.md](C:/Projetcts/aika-og/docs/design/BALANCED-COMBAT-2026-10-19.md). Modelo isolado: [verify_combat_balance_v1.py](C:/Projetcts/aika-og/docs/design/verify_combat_balance_v1.py).

## Decisões propostas

- Após correção do operador, crescimento automático de **um ponto por nível**, 2–50; **49 extras**, pesos próprios por classe. Soma dos atributos naturais93–99 no50 com as bases atuais, sem itens/GM. Distribuição determinística por acumuladores, sem perdas nem duplicação ao relogar/subir múltiplos níveis. Preservar base persistida e separar efetivos; não conceder também pontos manuais pelo mesmo crescimento. Substitui os196extras da v1.
- HP/MP e dano foram reduzidos junto com os pontos: guerreiro3.230HP, templária3.425HP sem itens; mob comum50ATK255/HP2800/DEF450. Preservar a hierarquia e as funções; não repor o excesso em efeitos/cura/dano fixo.
- Defesa customizada: absorção DEF/8 seguida de fator K/(K+DEF), K=100+20×nível do atacante. Toda variação normal passa pela defesa; não há adicional pós-mitigação. Piso 1 somente para impacto válido não bloqueado; zero/erro/bloqueio não são piso 1.
- PvE: raro > honra≈quest > superior > comum. PvP: honra > raro > quest > superior > comum, no mesmo nível/refino/classe. Bônus pertencem à contribuição de cada peça, sem converter um set misto inteiro. Metadados de combate não devem ser inferidos de raridade de drop/TypeItem.
- **Cap de refino +11**, por decisão do operador; curva proposta+0=1 até+11=1,42 apenas sobre ATK/DEF base do item. GameServer/Studio/importações devem rejeitar acima do limite sem cobrar recursos; auditar e migrar explicitamente legados, preservando backup. Substituição por tabela nativa exige evidência e mantém o cap; nunca somar duas curvas.
- Referência aproximada lembrada pelo operador: templária muito forte no cap50, melhor set/adicionais/Pran refinados, cerca12milHP e5–7milDEF. Adotar como meta de build máxima+11, não como HP base nem evidência de fórmula oficial. Orçamento ilustrativo do modelo chega11.880HP/6.199DEF, pendente de mapear efeitos compatíveis aos itens reais.
- Classes têm funções diferentes; templária protege/segura boss, guerreiro luta próximo/área, atirador pressiona alvo único à distância, pistoleira mobilidade/debuff/DoT, feiticeiro área/controle, clériga cura/limpeza/suporte.
- Perfis distintos de DG fácil/média/difícil. Boss médio revisado HP120k/DEF2200 recebe125 por golpe ATK650; tempo-alvo100–160s para PT com DPS efetivo750–1200. Solo é limitado por recursos/defesa/mecânicas, não por penalidade oculta de tamanho do grupo.

## Verificação e limites

25.932 verificações matemáticas passaram no script isolado, que não importa nem altera GameServer/banco. Exemplo DEF1100 no nível50: mob comum1–20 dá1. Três mobs comuns50 deixam tempo estimado22–101s, conforme classe, sem cura/esquiva/abates, cadência2s e hipótese5%crítico. São cenários do desenho, não gameplay observado. Grades de defesa foram ampliadas até7000; incluídas verificações de total natural abaixo100, HP base abaixo4mil, cap+11 e orçamento da build máxima.

Coeficientes são customizados, não prova das fórmulas oficiais. Ainda requer revisão do operador, mapeamento de IDs/efeitos reais, implantação em fatias e medição das rotações/recursos/CC nas seis classes. Não alterar alcance de aggro ou protocolos junto com a calibração. Ver [[Aika OG - MOC]].
