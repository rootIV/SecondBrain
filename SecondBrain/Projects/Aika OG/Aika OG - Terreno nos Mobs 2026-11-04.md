---
tags:
  - project/aika-og
  - ai
  - terrain
updated: 2026-11-04
---

# Terreno nos movimentos dos mobs

Integração autorizada pelo usuário após [[Aika OG - Colisao e Movimento Client 2026-11-04]]. [[Aika OG - MOC]].

`MobTerrainService` captura assets ATT/HGT locais de AIKAOG_CLIENT/Env no startup, antes da IA. Catálogos editáveis continuam no banco; sem importação/gravação SQL nova. Validação em todoMoveToward(patrulha/perseguição/retorno/medo) e seleção de posição de combate. Snapshot imutável/Volatile, sem disco por tick.

Contrato reconciliado: z01XXYY semflip;local=(Y%256)*256+X%256;HGTsignedraw.005A9D65liga75BFEC→32448F0.11funções/8.935instruções conferidas com bytes194F…;não reutilizar só pelo endereço. Bloqueia flags241 e saltos de altura≥13/descidas≥39. Supercover conservador evita corte de cantos; saída da própria célula bloqueada preservada. Com dados carregados, domínio regular1≤coord<4096; origem sem chunk dentro do domínio preserva legado, mas saída de chunk conhecido para ausente é recusada. Sem assets preserva legado finito e registra cobertura zero.

139testes finais passaram/zero falhas/skips,28casos novos de terreno;174pares reais/22.620checks. SELECTreadOnly de5.623spawns:5.616origens cobertas,8com flags bloqueantes,7fora do domínio (4inativos−1/−1 e3customativos9999/9999).896retas recusadas,553ativas:550cruzam restrições cobertas e3partem de coords inválidas. Sem reescrever rotas/IDs/spawns.

Risco: sem pathfinding, rotas podem parar na barreira; não foi demonstrada impossibilidade de desvio. LOS de ataque/colisão3D/NVI/voadores/zonas sem dados continuam fora do contrato. Nova build requer startup normal para carregar dados; não houve restart/implantação nem gameplay visual.

[Relatório](C:/Projetcts/aika-og/docs/analysis/MOB-TERRAIN-INTEGRATION-2026-11-04.md), [artefatos e lista de rotas](C:/Projetcts/aika-og/artifacts/mob-terrain-integration-20261104/README.md), [[Knowledge Debt]].
