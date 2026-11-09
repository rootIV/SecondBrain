# Aika OG - Desenho Atributos e Combate 2026-10-19

Estado: pesquisa e desenho concluídos; implementação não iniciada. O operador pediu revisão antes de alterar cálculos e, depois, concluir sem perguntas e desligar o PC.

Relatório fonte: [COMBAT-ATTRIBUTES-2026-10-19.md](C:/Projetcts/aika-og/docs/design/COMBAT-ATTRIBUTES-2026-10-19.md). O repositório atual continua sendo a fonte da verdade.

## Achados duráveis

- `DamageCalculator.CalculateBaseDamage` reduz `floor(DEF/8)` do ataque, com mínimo 1. `MobAiService.AttackPlayer` soma aleatório 10..119 e +15 **depois** disso. Defesa suficiente para neutralizar o ataque ainda deixa dano normal 26..135, antes de buffs/proteções. É evidência de código, não uma captura do oficial.
- `CharacterStatusService.GetEquipmentDefense` soma templates das armaduras, sem ler refino. Não confundir efeitos de item/conjunto/título/buff com defesa adicional por refino.
- Resistência crítica é calculada, mas o sorteio de crítico do mob não a consulta. O multiplicador comum usa crítico ×2 e não consome `CriticalDamage`.
- Duplo/crítico compartilham um único sorteio com sobreposição `min(C,D)`; não pressupor que sejam chances independentes no original.
- CSV auxiliar tem 376 mobs com estatísticas de combate zeradas, mas runtime exige banco `mob_templates`. Valores ativos não foram consultados; não declarar que todo mob em execução usa ataque zero.
- Referências Rafinha/TheMu são relacionadas e têm customizações/defeitos. Seu DEF/8 é hipótese histórica, não comprovação da fórmula oficial. Não copiar seleção de defesa pela classe da vítima, metade de ataque ou frequência de 3 s sem validar.
- Blog 2013, AikaWiki e Simulator divergem. Calculadoras modernas incluem patamares e classes de versões posteriores ao cap1. Preservar a decisão anterior de restauração de atributos até nova aprovação.

## Próxima implementação proposta

Catálogo/medição → composição e mitigação PvE → tabelas reais de refino → atributos/arredondamento → sorteios e resistências → skills/DoT/PvP. Reutilizar serviços existentes, valores comuns para painel e combate, recálculo idempotente e inteiros largos nos intermediários. Nenhuma migração destrutiva ou engine genérica foi proposta.

## Limites e verificação

Fontes locais e web examinadas; JavaScript das calculadoras lido estaticamente e hashes registrados no relatório. Fandom bloqueado 402/403. Sem nova prova de assembly oficial, medição de gameplay ou alteração de fórmulas. Exemplos aritméticos conferidos. Shutdown normal será solicitado ao concluir, sem forçar fechamento de aplicativos; não afirmar que a máquina já desligou.

Relacionado: [[Aika OG - MOC]].
