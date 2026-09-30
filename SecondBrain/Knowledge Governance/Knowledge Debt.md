---
tags:
  - second-brain
  - debt
  - knowledge-quality
updated: 2026-08-26
---

# Knowledge Debt

## 2026-09-22 — avisos e agendamentos antigos de concursos

- LotoJogo: o aviso genérico de validação do filtro usa qualquer concurso stale da categoria, não somente o selecionado. Pode persistir por causa de registros antigos. A abrangência foi preservada ao corrigir cache, abertura de estratégias e startup da API.
- No runtime local, o control center ainda mostrou alguns concursos antigos como abertos apesar de existirem resultados posteriores. A lista de seleção aplicava a política de encerramento corretamente. Revisar reconciliação de concursos antigos e a escolha do próximo concurso no control center em trabalho próprio; não limpar dados históricos sem conferir referências de lotes/rascunhos.
- Caminhos OneDrive em regras antigas do projeto/vault divergem do MOC atualizado: checkout e vault atuais usados e verificados em `C:\Projetcts\Lotojogo` e `C:\Projetcts\SecondBrain`.

Registro de lacunas, duplicacoes e inconsistencias da base de conhecimento.

## Aberto

### Oferta comercial de planos do LotoJogo

- Detectado em 2026-09-18 durante [[Checkout Mercado Pago]]. A landing anuncia Plus e beneficios ilimitados que nao correspondem aos planos/quotas da API.
- O checkout foi limitado aos contratos implementados: Pro e Bolao, um mes por pagamento, renovacao manual. Reconciliar landing e politicas de quota antes da ativacao comercial.

### Nomes duplicados `Architecture`

- Detectado em 2026-07-25 pelo health check do vault.
- Impacto: wikilinks para `[[Architecture]]` podem ficar ambiguos no Obsidian.
- Arquivos:
  - `SecondBrain/Projects/LotoJogo/Architecture.md`
  - `SecondBrain/Projects/MotionInBet/Architecture.md`
- Mitigacao pendente: desambiguar nomes ou links quando houver contexto suficiente para decidir o padrao por projeto.

### Nome duplicado `Decision Log`

- Detectado em 2026-08-26 pelo health check do vault.
- Impacto: wikilinks para `[[Decision Log]]` podem ficar ambiguos no Obsidian.
- Arquivos:
  - `SecondBrain/Projects/EvoCine/Decision Log.md`
  - `SecondBrain/Projects/LotoJogo/Decision Log.md`
- Mitigacao pendente: preferir links qualificados por projeto ou renomear notas apos verificar impacto no vault.

### Referencias ausentes no workspace Obsidian

- Detectado em 2026-08-26 pelo health check do vault.
- Impacto: `.obsidian/workspace.json` referencia artefatos que nao existem mais, o que mantem o health check em falha.
- Referencias:
  - `Untitled.canvas`
  - `Untitled.base`
- Mitigacao pendente: limpar o workspace ativo do Obsidian ou recriar artefatos apenas se eles ainda forem relevantes.

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
