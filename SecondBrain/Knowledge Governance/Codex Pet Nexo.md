---
title: Codex Pet Nexo
tags:
  - codex
  - pet
  - ambiente
updated: 2026-09-28
---

# Codex Pet Nexo

Nexo e o pet customizado ativo do Codex neste ambiente.

## Instalacao

- Manifesto: `C:\Users\root4\.codex\pets\nexo\pet.json`
- Atlas ativo: `C:\Users\root4\.codex\pets\nexo\spritesheet.webp`
- Contrato: `spriteVersionNumber: 2`, grade `8 x 11`, celulas `192 x 208`, atlas `1536 x 2288`.

## Upgrade de animacoes de 2026-09-28

- Regeneradas as linhas `idle`, `waving`, `waiting` e `running` com identidade visual preservada.
- `idle` ganhou respiracao, blink, leve movimento de antenas e cabeca sem perder o reduced-motion frame.
- `waving` passou a ter gesto de pata claramente legivel.
- `waiting` passou a comunicar pedido de input/confirmacao em vez de parecer apenas idle.
- `running` continua significando processamento ativo, sem locomocao literal.
- Corrida direcional, salto, falha, review e 16 direcoes de olhar foram preservados.

## Versao Darkstorm de 2026-09-28

- O atlas instalado foi transformado para uma identidade mais sombria: paleta azul-preta, contorno mais pesado, marca eletrica no peito e raios ciano/violeta anexados ao corpo.
- A transformacao foi aplicada no atlas v2 inteiro para manter consistencia entre linhas padrao e 16 direcoes de olhar.
- O efeito de raio deve permanecer conectado a silhueta do pet; evitar efeitos soltos, brilho difuso ou particulas separadas porque isso fragiliza a transparencia e a validacao do atlas.

## Verificacao

- Extracao e inspecao de todas as linhas: sem erros ou avisos.
- Atlas instalado validado com `validate_atlas.py --require-v2`: `ok: true`, RGBA, residuos RGB transparentes `0`.
- Backup anterior preservado no workspace da tarefa de 2026-09-28 antes da substituicao.
- Versao Darkstorm instalada validada com `validate_atlas.py --require-v2`: `ok: true`, `1536 x 2288`, RGBA, residuos RGB transparentes `0`, sem erros ou avisos.

## Consumo de 5 horas

O formato do pet aceita apenas manifesto e spritesheet; ele nao recebe dados dinamicos de uso. A documentacao oficial do Codex orienta consultar Settings/Usage ou o usage dashboard. Nao embutir percentuais no atlas, porque ficariam estaticos e incorretos.

## Relacionados

- [[Second Brain - MOC]]
- [[Knowledge Operating Model]]
- [[Maintenance Log]]
