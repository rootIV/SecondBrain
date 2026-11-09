---
tags:
  - project/aika-og
  - combat
  - ai
updated: 2026-11-04
---

# Curva PvE, mana e área

Implementação autorizada pelo usuário após [[Aika OG - Lacunas IA e Dano por Nivel 2026-11-04]], com objetivo mob80 matar player40 facilmente conforme armadura/HP. [[Aika OG - MOC]], [[Aika OG - IA Combate e Niveis Referencias 2026-11-03]].

## Decisão e contrato

- Curva customizada PvE após defesa: banda±5, `min(4,2^((abs(delta)-5)/10))`, recíproca no sentido inferior. Teto atingido em25níveis. Mob1–150/player1–99; inválidos neutros. Zero preservado, piso1 positivo e saturação segura. Acerto/crítico/duplo, PvP, cura e XP sem curva.
- Básico/skills físicas/mágicas, procs planos, DoT com metadata e splash por receptor cobertos. Dreno8% preservado; reflexão/transferência derivadas sem segundo fator. SourceLevel255 em novo DoT de mob inválido preserva defesa sem entrar no fallback legado de0.
- Mana finita MP=HP inicial na carga SQL/CSV/debug/bootstrap, preservando MP explícito. Evidência nativa ServerSocket.pas1352–1353/1787. Sem regen nova, sem custo zerado; retorno/respawn mantêm recuperação existente.
- Área hostil despachada pelo centro/raio/limite do catálogo, dano/proteções por receptor e custo/cooldown únicos. Busca espacial inclui alcance+raio. Pacotes de dano existentes; nenhum telegraph inventado.

Fixture real: mob80/ATK1600 × player40, normal sem buffs/variação: DEF800/HP4000→6000dano/letal; DEF8000/HP6000→2400dano/sobrevive; DEF800/HP10000→6000dano/sobrevive. Sem morte forçada por nível/cor.

## Conteúdo e limites

Auditoria26IDs+nomenativos exatos:26HP iguais às fontes;25níveis atuais100–150 vs49–56 nas referências,15conflitos de ATK/DEF Ghoul/Lore. Nenhuma fonte sustenta inflar potência para100/150. Cadáver de Verme80 também é fraco nas referências. Não rebaixar níveis nem importar atributos automaticamente; variante alta é decisão de conteúdo. [[Knowledge Debt]] mantém revisão.

Suporte/self-heal, bosses, perfil por identidade, leash absoluto, velocidade/cadência, controle e cap65535 continuam pendentes. Existem assets NVI/HGT/ATT/AKM, porém sem contratos de navegação/LOS reconciliados. Telegraph de mob não comprovado. Área autoritativa exige homologação visual.

## Evidências

- [Implementação](C:/Projetcts/aika-og/docs/analysis/COMBAT-AI-IMPLEMENTATION-2026-11-04.md).
- [Reprodução e TRX](C:/Projetcts/aika-og/artifacts/mob-combat-implementation-20261104/README.md), `verification.json` com resultados finais/hashes.
- [Conteúdo](C:/Projetcts/aika-og/artifacts/mob-combat-implementation-20261104/content-audit.md).

280testes pertinentes aprovados/zero falhas/skips,52casos novos, na source final. Suíte ampla:1.951passaram/zero falhas/10skips opt-in,10min19s, sem hang, na build anterior à última correção de custo em área vazia (coberta pelo recorte final). Build/testes isolados, sem alteração do catálogo ativo/reinício. A suíte ampla usa bancos temporários `aika_catalog_tests_<UUID>` com dados sintéticos; coleta somente leitura confirmou376modelos/5.623spawns e dados comparados idênticos. Runner inicial interrompido após10min11s com1.774passados/10skips; único schema órfão próprio removido, dois anteriores preservados. Não confundir com homologação no jogo ou versão ativa.
