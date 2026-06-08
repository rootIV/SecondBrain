---
tags:
  - motioninbet
  - moc
  - project
updated: 2026-06-05
---

# MotionInBet - MOC

Mapa do projeto MotionInBet / Beetomation.

## Codigo

- Workspace: `C:\Users\Vitor\Documents\Projects\motioninbet`
- API: `motioninbet-api` (.NET 8, EF Core, MySQL, JWT, Mercado Pago, email)
- Bot desktop: `motioninbet-bot` (.NET 8 Windows Forms, Selenium, ChromeDriver)
- Website: `motioninbet-website` (React 19, TypeScript, Vite, SCSS)

## Notas principais

- [[Architecture]]
- [[Security Review - 2026-06-05]]
- [[Graphify]]
- [[Roadmap]]

## Estado atual

- Graphify foi instalado no workspace em `AGENTS.md` e `.codex/hooks.json`.
- Grafo atual: `graphify-out/graph.json`, `graphify-out/graph.html`, `graphify-out/GRAPH_REPORT.md`.
- Build da API passou em 2026-06-05 com alerta NU1902 em `MailKit 4.13.0`.
- Build do bot passou em 2026-06-05 com dois warnings menores.
- Build do website passou em 2026-06-05, mas o lint falha com 7 erros.
- `npm audit` apontou 10 vulnerabilidades: 4 moderadas e 6 altas.

## Proxima prioridade

1. Rotacionar segredos versionados e mover configuracao sensivel para variaveis de ambiente.
2. Corrigir bypass de login no bot e inconsistencias de token.
3. Remover ruido do grafo excluindo `bin/`, `obj/`, `dist/` e `node_modules/` do processo de conhecimento.
4. Corrigir lint e vulnerabilidades do website.
