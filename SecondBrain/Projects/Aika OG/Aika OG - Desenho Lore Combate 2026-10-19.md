# Aika OG - Desenho Lore Combate 2026-10-19

**Atualização20/10:** operador autorizou implementar; núcleo e catálogo comum foram instalados. Estado, verificações e lacunas remanescentes em [[Aika OG - Implementacao Lore Combate 2026-10-20]]. A descrição de proposta abaixo registra o desenho original, não o estado operacional atual.

**Proposta para revisão, não implementada nem ativada.** Operador considera Lore Community a referência mais próxima do original e pediu desenho que resolva suas lacunas. Não interpretar isso como prova de todas as fórmulas nem autorização para migrar. Relacionados: [[Aika OG - MOC]], [[Aika OG - Lore Community Combate Atributos 2026-10-19]], [[Aika OG - Balanceamento Classes e Progressao 2026-10-19]].

Artefato: [LORE-COMBAT-REDESIGN-2026-10-19.md](C:/Projetcts/aika-og/docs/design/LORE-COMBAT-REDESIGN-2026-10-19.md). Modelo: `docs/design/verify_lore_combat_design.py`; resultados: `artifacts/lore-combat-design/model-results.json` no mesmo projeto.

## Contrato proposto

- Lore como base de conteúdo, coeficientes eHP/MP; preservar49extras derivados até50/cap11 do operador. Usar DEF/8 da Lore, retirando K/(K+DEF) atual nesta proposta. **Não ativar somente a troca de fórmula sem recalibrar catálogo/skills.** Runtime atual continua V1.
- HP Lore por nível com incrementos fixos45/42/34/36/33/39 e27CON; MP33/39/44/45/99/40 e27SOR. Pools naturais50 W3195/Tp2991/Att2294/Dual2529/Fc2136/Cler2598HP. Valores são do modelo com bases/49extras declarados. Feiticeiro5490MP é resultado preservado da Lore; avaliar custos de skills junto.
- Todo dano plano de skill/HabAtk/variação passa pela defesa. Retirar adicional genérico pós-defesa, multiplicadores finais por classe sem evidência e dano de fallback. Normalização DNfis/2 é específica do catálogo mob Lore, aplicada uma vez; não reduzir jogadores nem dividir score já normalizado.
- Crit/duplo/acerto com curvas novas explícitas e monotônicas, sorteios independentes, RNG sem Randomize por golpe. Penetração eCDR viram ratings com curvas separadas, limites25%/30%; coeficientes são propostas customizadas, não oficiais recuperados.
- Score único para painel/combate, buffs por tempo absoluto/monotônico, expirando sem outro cast; cura produzida separada da recebida; natureza por skill/perfil; custos e dano exatamente uma vez; preservar zeroHP/MP do morto.
- IA por entidade500ms, ataque comum3s Lore; preservar detecção6/assistência5/melee2 atuais, com histerese2,5. Ameaça por personagem, retarget/retorno caminhando e cura na chegada, patrulha com tolerância, rotação Skill01..05 por elegibilidade, aproximação melee estável. Navegação depende de geometria ainda não comprovada.
- Itens/refino por dados nativos eIDs, sem dupla curva/refino nem bônus global por raridade. PvE raro>honra≈quest>superior>comum; PvP honra>raro>quest>superior>comum são critérios a conferir nos itens reais. Sem abertura automática do PvP.

## Verificação e pendências

30.180 checks isolados passaram: pontos/pools/curvas/saturação/defesa e perfis sintéticos. Mob comum50 proposto180ATK normalizado/3s; raro+0 ilustrativo comDEF800–1200 absorve mobs1–20 a1. Contra3comuns50, média sem cura/abates/esquiva:26–97,3s conforme classe; três críticos sincronizados com variação máxima abaixo20%HP. Não é gameplay nem captura oficial. Modelo não testa pacotes, IA real, rotação completa ou hierarquia dos itens nativos.

Cinco hashes-chave atuais reconferidos sem alteração. Sem build/deploy/migração/execução do servidor. A futura implementação exige revisão do desenho e conversões de catálogo, mapping de efeitos/skills/refino, testes .NET e medição no jogo. Pontos pendentes em [[Knowledge Debt]].
