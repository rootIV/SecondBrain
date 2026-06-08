---
tags:
  - motioninbet
  - graphify
  - knowledge-graph
updated: 2026-06-06
---

# Graphify

Graphify foi implementado no workspace MotionInBet em 2026-06-05.

## Artefatos

- `C:\Users\Vitor\Documents\Projects\motioninbet\AGENTS.md`
- `C:\Users\Vitor\Documents\Projects\motioninbet\.codex\hooks.json`
- `C:\Users\Vitor\Documents\Projects\motioninbet\graphify-out\graph.json`
- `C:\Users\Vitor\Documents\Projects\motioninbet\graphify-out\graph.html`
- `C:\Users\Vitor\Documents\Projects\motioninbet\graphify-out\GRAPH_REPORT.md`

## Resultado inicial

- 105 arquivos processados.
- 1813 nos.
- 1986 arestas.
- 183 comunidades.
- Extracao 100% deterministica por AST/config, sem custo de tokens.

## Limitacao encontrada

O primeiro grafo incluiu artefatos gerados:

- `motioninbet-api/bin`
- `motioninbet-api/obj`
- `motioninbet-website/dist`

Isso gerou comunidades dominadas por dependencias, assets de build, `.NETCoreApp`, `net8.0`, `compilerOptions` e pacotes, reduzindo a utilidade arquitetural do grafo.

## Como usar

Para perguntas de arquitetura ou relacionamento entre arquivos:

```powershell
graphify query "auth payment serial key user registration API bot website"
```

Para atualizar depois de mudancas de codigo:

```powershell
graphify update .
```

## Proxima melhoria

Criar estrategia de exclusao para arquivos gerados antes de reconstruir o grafo limpo. Se o CLI nao suportar ignore dedicado, rodar Graphify por subprojeto em copias limpas sem `bin/`, `obj/`, `dist/` e `node_modules/`.

## Observacao operacional

O workspace raiz nao e um repositorio Git, mas os subprojetos sao repos separados. O hook do Graphify foi instalado no workspace raiz via `.codex/hooks.json`; ele serve para orientar o Codex, nao substitui hooks Git por subrepo.

## Phase 1 Graph Hygiene

Graphify remains installed at the workspace root. The current graph includes generated artifacts and should not be treated as the final architectural map. Phase 1 records this limitation; later phases should rebuild a cleaner graph after generated artifacts are removed from the analysis corpus.

Graphify has been refreshed several times during Phase 1, but generated artifact noise remains present in the current graph.
