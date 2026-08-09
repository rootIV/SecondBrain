---
tags:
  - second-brain
  - debt
  - knowledge-quality
updated: 2026-07-25
---

# Knowledge Debt

Registro de lacunas, duplicacoes e inconsistencias da base de conhecimento.

## Aberto

### Nomes duplicados `Architecture`

- Detectado em 2026-07-25 pelo health check do vault.
- Impacto: wikilinks para `[[Architecture]]` podem ficar ambiguos no Obsidian.
- Arquivos:
  - `SecondBrain/Projects/LotoJogo/Architecture.md`
  - `SecondBrain/Projects/MotionInBet/Architecture.md`
- Mitigacao pendente: desambiguar nomes ou links quando houver contexto suficiente para decidir o padrao por projeto.

## Resolvido

### Referencias antigas no workspace Obsidian

- Resolvido em 2026-06-05.
- Justificativa: referencias a `DesignSkills`/`design-skills` foram removidas de `.obsidian/workspace.json` apos verificar que os diretorios nao existem no vault atual.

### Vault raiz vs subpasta `SecondBrain`

- Resolvido operacionalmente em 2026-06-05.
- Justificativa: [[Knowledge Decisions]] definiu a raiz `C:\Users\root4\OneDrive\Documents\Projetcts\SecondBrain` como vault operacional e `SecondBrain/` como namespace principal de conteudo, sem migracao fisica neste momento.

### Arquivos com extensao dupla `.md.md`

- Resolvido em 2026-06-05.
- Justificativa: `AGENTS.md.md` e quatro notas em `Skills` foram renomeados para `.md`; referencias diretas nos workspaces Obsidian foram atualizadas.

### Consent/Handshake sem MOC nomeado padrao

- Resolvido em 2026-06-05.
- Justificativa: criado [[Consent - MOC]] e conectado ao `README.md`, mantendo compatibilidade com a entrada antiga.

### Wikilinks orfaos de modalidades de loteria

- Resolvido em 2026-06-05.
- Justificativa: criadas notas curtas para [[Quina]], [[Timemania]], [[Time Mania]], [[Lotomania]], [[Mega-Sena]], [[Dia de Sorte]] e [[Dupla Sena]].

### Notas vazias de skills

- Resolvido em 2026-06-05.
- Justificativa: as notas vazias foram preenchidas como indices praticos para reduzir orfaos sem substituir as skills reais instaladas.
