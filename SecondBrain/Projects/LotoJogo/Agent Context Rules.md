# Agent Context Rules

Relacionado: [[LotoJogo - MOC]], [[Architecture]], [[Frontend]], [[Backend]], [[Tests]], [[Known Issues]].

## Objetivo

Reduzir consumo de contexto e risco de edicoes fora de escopo. O agente deve buscar, ler e editar somente as pastas relevantes para a tarefa atual.

## Regra base

- O vault Obsidian correto do projeto e `C:\Users\Vitor\Documents\SecondBrain\SecondBrain\Projects\LotoJogo`.
- Atualizar notas do projeto somente nesse caminho.
- Prefixar comandos suportados com `rtk` para reduzir saida e consumo de contexto.
- Usar comando nativo somente quando o RTK nao oferecer equivalente, quando a saida bruta exata for necessaria ou quando o wrapper falhar.
- Usar `rtk proxy <comando>` para comandos sem filtro que ainda devem ser rastreados.
- Quando `graphify-out/graph.json` existir, usar Graphify como primeira fonte de orientacao tecnica sobre codigo, arquitetura, impacto e relacoes entre arquivos.
- Usar comandos escopados do Graphify antes de varrer arquivos: `rtk proxy graphify query`, `rtk proxy graphify explain` e `rtk proxy graphify path`.
- No PowerShell, definir `$env:PYTHONIOENCODING='utf-8'` antes de consultas Graphify para evitar erro de Unicode.
- O Graphify usa o Python bundled do Codex em `C:\Users\Vitor\.cache\codex-runtimes\codex-primary-runtime\dependencies\python`.
- Diagnostico rapido: `Get-Command graphify`, `graphify explain "Hero" --graph .\graphify-out\graph.json` e `python.exe -c "import graphify"` usando o caminho bundled acima.
- Se o CLI Graphify nao estiver disponivel, consultar diretamente `graphify-out/graph.json` com o runtime Node.js ou Python disponivel antes de fazer buscas amplas.
- Em toda tarefa, consultar as notas Obsidian relevantes antes de exploracao ampla para recuperar decisoes, caveats e conhecimento geral duravel.
- Usar Graphify como mapa de relacoes do codigo e Obsidian como memoria duravel; atualizar Obsidian somente quando houver conhecimento duravel novo ou alterado.
- Quando codigo atual, Graphify e Obsidian divergirem, validar pelo codigo/runtime atual e corrigir a memoria desatualizada relevante.
- Comecar pelo menor escopo possivel.
- Expandir o escopo somente quando uma referencia concreta exigir.
- Nao varrer a pasta pai inteira sem motivo tecnico.
- Nao ler `node_modules`, `dist`, `bin`, `obj`, `.git`, arquivos gerados ou migrations antigas, salvo quando a tarefa pedir explicitamente.
- Nao atualizar o vault Obsidian para ajustes efemeros que nao alterem conhecimento duravel.
- Quando uma alteracao de codigo mudar contexto relevante, atualizar o grafo com `graphify update . --force`; alteracoes semanticas em documentos ou imagens exigem um backend LLM configurado. Para mudancas arquiteturais, regenerar tambem os exports relevantes.

## Escopos por tipo de tarefa

### Frontend

Use `lotojogo-front-end` quando a tarefa envolver UI, hooks, React Query, estilos, rotas, tipos TypeScript ou services frontend.

Priorizar:

- `src/components`
- `src/hooks`
- `src/services`
- `src/types`
- `src/domain`
- `src/features`
- `src/strategies`
- `src/styles`

Evitar no primeiro passe:

- `dist`
- `node_modules`
- arquivos de build/cache

### Backend

Use `lotojogo-back-end` quando a tarefa envolver API, DTOs C#, services, controllers, repositories, EF Core, migrations atuais ou seed.

Priorizar:

- `Controllers`
- `Services`
- `Models`
- `Application/Interfaces`
- `Infrastructure/Repositories`
- `Data/AppDbContext.cs`
- `Data/Seed` quando houver estatisticas ou sorteios historicos

Evitar no primeiro passe:

- `bin`
- `obj`
- migrations antigas, exceto quando a tarefa envolver schema/EF

### Testes

Use `lotojogo-tests` quando a tarefa envolver regressao backend, validacao de services ou contratos de geracao.

Comando principal:

```powershell
dotnet test lotojogo-tests\lotojogo-tests.csproj
```

### Docker e infra local

Use a pasta pai `lotojogo` somente para:

- `docker-compose.yml`
- `docker-compose.dev.yml`
- documentacao raiz
- coordenar frontend/backend/testes

Nao assumir que a pasta pai e o repositorio Git principal.

## Git

- `lotojogo-front-end` possui `.git`.
- `lotojogo-back-end` possui `.git`.
- Rodar `git status`, `git diff`, commits e branches dentro do subprojeto correto.
- A pasta pai serve como workspace de coordenacao, nao como repositorio unico.

## Procedimento recomendado

1. Identificar se a tarefa e frontend, backend, testes, docs ou infra.
2. Consultar Graphify quando houver grafo disponivel:
   - `rtk proxy graphify query "<pergunta>" --graph .\graphify-out\graph.json --budget 1200`
   - `rtk proxy graphify explain "<servico ou componente>" --graph .\graphify-out\graph.json`
   - `rtk proxy graphify path "<origem>" "<destino>" --graph .\graphify-out\graph.json`
3. Rodar `rtk find`, `rtk grep` ou `rg --files` apenas no subprojeto relevante quando a consulta apontar arquivos especificos ou o grafo estiver insuficiente.
4. Ler primeiro os arquivos de entrada provaveis da feature.
5. Editar somente arquivos diretamente relacionados.
6. Validar com o menor comando suficiente:
   - frontend: `rtk npm run build` e `rtk npm run lint`;
   - backend: `rtk dotnet build lotojogo-api.sln`;
   - testes backend: `rtk dotnet test lotojogo-tests\lotojogo-tests.csproj`.
7. Atualizar Graphify quando a mudanca afetar o mapa futuro do projeto.
8. Atualizar Obsidian somente se o usuario pedir ou se a mudanca criar decisao/caveat/documentacao duravel.

## Exemplos

- Ajuste visual em `GeneratedBetsCard`: pesquisar em `lotojogo-front-end/src/components`, `src/styles` e, se houver preco/categoria, `src/domain`.
- Novo endpoint estatistico: pesquisar em `lotojogo-back-end/Controllers`, `Services`, `Models`, `Application/Interfaces` e `Infrastructure/Repositories`.
- Alteracao em comportamento de lote na aba Gerenciar: pesquisar em frontend `Manage` e backend `LoteService` apenas se houver chamada API ou contrato envolvido.
