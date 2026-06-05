---
tags:
  - second-brain
  - governance
  - quality
  - automation
updated: 2026-06-05
---

# Health Check

Verificacao automatizada basica do vault.

## Script

Arquivo:

```text
Tools/Test-SecondBrainHealth.ps1
```

Comando recomendado a partir da raiz do vault:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Tools\Test-SecondBrainHealth.ps1
```

Saida JSON opcional:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Tools\Test-SecondBrainHealth.ps1 -Json
```

## O que valida

- Quantidade de arquivos Markdown.
- Notas Markdown vazias.
- Arquivos com extensao dupla `.md.md`.
- Wikilinks sem nota alvo.
- JSON invalido em workspaces Obsidian conhecidos.
- Referencias em `lastOpenFiles` apontando para arquivos inexistentes.

## Politica

- Erros objetivos fazem o script retornar exit code `1`.
- Nomes de notas duplicados sao reportados como aviso, nao como falha, porque Obsidian permite duplicidade, embora isso possa tornar wikilinks ambiguos.
- Rodar este health check apos renomear, mover, criar ou excluir notas.
