---
title: Aika OG - Imagens de Mapas 2026-10-11
tags:
  - project/aika-og
  - reverse-engineering
updated: 2026-10-11
---

# Aika OG - Imagens de Mapas 2026-10-11

Relacionado: [[Aika OG - MOC]], [[Aika OG - Cliente OG 2026-10-09]],
[[Aika OG - WorldDataService]], [[Aika OG - MobService]].

Fonte local verificada: `D:\aika\Aika OG`. No workspace
`C:\Projetcts\aika-og`, `tools/extract_map_images.py` reutiliza o decoder JIT
existente e exporta `artifacts/maps/`: 43 mapas regionais e três mapas gerais
em PNG. Os 16 mapas do seletor solicitado estão presentes; Floresta Zeelant
corresponde à textura `UI/map59.jit`. A montagem está em
`preview-requested-maps.jpg`, e nomes/dimensões/hashes/retângulos crus em
`manifest.json`. Contrato e tabela completa: `docs/reverse-engineering/MAP-IMAGES.md`.

`UI/Map.bin` tem 80 retângulos de quatro int32 no início e 80 nomes de 28 bytes
Windows-1252 no offset 1280. A associação posição + 1 → `MapNN.jit` foi
corroborada visualmente; o lookup nativo ainda não foi rastreado.

> [!warning] Limite para editor de hordas
> Índices dessas texturas não são IDs confirmados do mapa dos mobs. Retângulos
> são candidatos a limites do mundo; calibrar escala, orientação e margens no
> cliente antes de converter clique em spawn. Texturas têm textos e áreas
> pretas e não fornecem colisão, altura ou navegabilidade. Um MySQL não vazio
> tem precedência sobre os CSVs, portanto editar Data pode não mudar o mundo ativo.

Verificação: 46 PNGs reabertos com igualdade dos pixels, 47 hashes de origem
preservados e inspeção visual dos 16 mapas pedidos. Sem alteração de cliente,
catálogo ou spawns; editor e calibração no jogo não implementados nesta etapa.
