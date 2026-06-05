# Agent Context Rules

Relacionado: [[LotoJogo - MOC]], [[Architecture]], [[Frontend]], [[Backend]], [[Tests]], [[Known Issues]].

## Objetivo

Reduzir consumo de contexto e risco de edicoes fora de escopo. O agente deve buscar, ler e editar somente as pastas relevantes para a tarefa atual.

## Regra base

- O vault Obsidian correto do projeto e `C:\Users\Vitor\Documents\SecondBrain\SecondBrain\Projects\LotoJogo`.
- Atualizar notas do projeto somente nesse caminho.
- Quando `graphify-out/graph.json` existir, usar Graphify como primeira fonte de orientacao tecnica sobre codigo, arquitetura, impacto e relacoes entre arquivos.
- Usar comandos escopados do Graphify antes de varrer arquivos: `graphify query`, `graphify explain` e `graphify path`.
- No PowerShell, definir `$env:PYTHONIOENCODING='utf-8'` antes de consultas Graphify para evitar erro de Unicode.
- Usar Obsidian como memoria duravel de decisoes, caveats e documentacao, nao como primeira fonte para redescobrir estrutura de codigo.
- Comecar pelo menor escopo possivel.
- Expandir o escopo somente quando uma referencia concreta exigir.
- Nao varrer a pasta pai inteira sem motivo tecnico.
- Nao ler `node_modules`, `dist`, `bin`, `obj`, `.git`, arquivos gerados ou migrations antigas, salvo quando a tarefa pedir explicitamente.
- Nao atualizar o vault Obsidian sem pedido explicito do usuario.
- Quando uma alteracao de codigo ou documentacao mudar contexto relevante, atualizar os outputs Graphify com `graphify update . --force`; para mudancas arquiteturais, regenerar tambem `graphify export callflow-html`.

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
   - `graphify query "<pergunta>" --graph .\graphify-out\graph.json --budget 1200`
   - `graphify explain "<servico ou componente>" --graph .\graphify-out\graph.json`
   - `graphify path "<origem>" "<destino>" --graph .\graphify-out\graph.json`
3. Rodar `rg --files` apenas no subprojeto relevante quando a consulta apontar arquivos especificos ou o grafo estiver insuficiente.
4. Ler primeiro os arquivos de entrada provaveis da feature.
5. Editar somente arquivos diretamente relacionados.
6. Validar com o menor comando suficiente:
   - frontend: `npm run build` e `npm run lint`;
   - backend: `dotnet build lotojogo-api.sln`;
   - testes backend: `dotnet test lotojogo-tests\lotojogo-tests.csproj`.
7. Atualizar Graphify quando a mudanca afetar o mapa futuro do projeto.
8. Atualizar Obsidian somente se o usuario pedir ou se a mudanca criar decisao/caveat/documentacao duravel.

## Exemplos

- Ajuste visual em `GeneratedBetsCard`: pesquisar em `lotojogo-front-end/src/components`, `src/styles` e, se houver preco/categoria, `src/domain`.
- Novo endpoint estatistico: pesquisar em `lotojogo-back-end/Controllers`, `Services`, `Models`, `Application/Interfaces` e `Infrastructure/Repositories`.
- Alteracao em comportamento de lote na aba Gerenciar: pesquisar em frontend `Manage` e backend `LoteService` apenas se houver chamada API ou contrato envolvido.
