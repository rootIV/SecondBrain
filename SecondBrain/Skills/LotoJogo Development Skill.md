---
tags:
  - skill
  - project/lotojogo
updated: 2026-07-16
---

# LotoJogo Development Skill

Relacionado: [[LotoJogo - MOC]], [[Backend]], [[Frontend]], [[DTOs]], [[Repositories]], [[LotteryStrategies]], [[Auth]], [[Docker]], [[Tests]]

Skill local de projeto documentada em:

`C:\Users\root4\OneDrive\Documents\Projetcts\SecondBrain\SecondBrain\Skills\LotoJogo Development Skill.md`

Skills Codex instaladas para apoiar este projeto:

- `csharp-developer`, `dotnet-core-expert`
- `react-expert`, `typescript-pro`
- `code-reviewer`, `debugging-wizard`, `test-master`
- `obsidian-markdown`, `obsidian-bases`, `json-canvas`, `obsidian-cli`, `defuddle`
- `impeccable`

## Quando usar

Use esta skill ao trabalhar no repositorio `C:\Users\root4\OneDrive\Documents\Projetcts\Lotojogo`, especialmente em:

- frontend React, TypeScript e SCSS em `lotojogo`;
- backend .NET 8, EF Core, MySQL e Docker em `lotojogo-api`;
- fluxos de autenticacao JWT/cookie;
- geracao de lotes e apostas;
- estrategias de loteria;
- DTOs, contratos de API, repositories, services e testes;
- atualizacao das notas do projeto em `[[LotoJogo - MOC]]`.

## Regras lembradas pela skill

- Tratar `AGENTS.md` e as notas do Obsidian como baseline do projeto.
- Consultar `[[LotoJogo - MOC]]` e `[[Agent Context Rules]]` antes de exploracao ampla.
- Manter controllers finos e colocar orquestracao de negocio em services.
- Preferir guard clauses para reduzir aninhamento e deixar pre-condicoes explicitas.
- Usar repository pattern: contratos em `Application/Interfaces` e EF implementations em `Infrastructure/Repositories`.
- Usar DTOs em boundaries de API. Nao retornar entities EF diretamente dos controllers.
- Preservar auth por cookie/JWT, incluindo leitura de `access_token`, refresh em `/Auth/refresh` e rate limiting dos endpoints de auth.
- Preferir `TimeProvider` em services no lugar de `DateTime.UtcNow`.
- Manter compatibilidade de strategies entre backend e frontend: `type`, `config`, `poolSize` e `bets`.
- Guardar configs de strategies e dezenas como JSON no banco quando fizer sentido, expondo DTOs parseados para a API.
- Atualizar generator, pool-size, tipos frontend, registry, contratos e testes juntos quando uma strategy mudar.
- Evitar inline styles no frontend; seguir os SCSS existentes em `src/styles`.
- Usar React Query hooks e services em `src/services` para estado remoto e chamadas HTTP.
- Atualizar `[[Decision Log]]` e `[[Known Issues]]` quando houver decisao tecnica, caveat, teste falhando ou mismatch.

## Comandos de verificacao

Backend build:

```powershell
cd C:\Users\root4\OneDrive\Documents\Projetcts\Lotojogo\lotojogo-api
dotnet build lotojogo-api.sln
```

Backend tests:

```powershell
cd C:\Users\root4\OneDrive\Documents\Projetcts\Lotojogo\lotojogo-api
dotnet test
```

Observacao: no estado atual, nao foi encontrado projeto de testes backend versionado em `lotojogo-api`; `dotnet test` pode nao executar testes ate que um projeto de testes seja criado ou reativado.

Frontend build:

```powershell
cd C:\Users\root4\OneDrive\Documents\Projetcts\Lotojogo\lotojogo
npm run build
```

Frontend lint:

```powershell
cd C:\Users\root4\OneDrive\Documents\Projetcts\Lotojogo\lotojogo
npm run lint
```

## Caveats atuais

- O projeto pode nao ter um repositorio Git no root atual. Verificar antes de depender de comandos Git.
- A raiz `C:\Users\root4\OneDrive\Documents\Projetcts\Lotojogo` e workspace coordenador; `lotojogo` e `lotojogo-api` sao repositorios Git separados.
- `npm run lint` pode falhar por issues existentes no frontend, incluindo `any`, variaveis nao usadas, Fast Refresh context exports e uma expressao nao usada.
- Testes backend podem expor mismatch de contrato em `poolSize` para `exclude_number`. Confirmar se `poolSize` significa quantidade de dezenas disponiveis ou combinacoes possiveis.
- O frontend usa SCSS global, apesar de notas antigas mencionarem SCSS modules.
