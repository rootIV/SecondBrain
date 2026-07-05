# Known Issues

## HTTPS em `www.lotojogo.com.br` - corrigido em 2026-06-24

- Sintoma: `https://www.lotojogo.com.br` falhava com `ERR_SSL_PROTOCOL_ERROR`, enquanto `https://lotojogo.com.br` respondia normalmente.
- Causa: o DNS `www` resolvia para o servidor correto, mas o `Caddyfile` declarava somente `{$SITE_DOMAIN}` e nao solicitava certificado para `www.{$SITE_DOMAIN}`.
- Correcao: adicionar um site block para `www.{$SITE_DOMAIN}` que emite TLS e redireciona permanentemente para `https://{$SITE_DOMAIN}{uri}`.
- Verificacao pendente de deploy: recriar o container Caddy no EC2, confirmar a emissao do certificado nos logs e testar redirect com preservacao de caminho/query.
- Relacionado: [[Docker]], [[Decision Log]].

## Graphify indisponivel no PATH do Codex - resolvido em 2026-06-24

- Causa: `graphify-out/graph.json` existia, mas o pacote `graphifyy` nao estava instalado no Python bundled usado pelo Codex.
- Correcao: `graphifyy` instalado em `C:\Users\Vitor\.cache\codex-runtimes\codex-primary-runtime\dependencies\python`; CLI validado com `graphify explain "Hero"`.
- Integracao: skill instalada em `C:\Users\Vitor\.codex\skills\graphify` e MCP configurado no `.codex/config.toml` do projeto.
- Observacao: novas sessoes do Codex devem ser abertas para carregar o MCP adicionado.
- Recorrencia em 2026-06-25: o runtime Python bundled ainda estava no PATH, mas `graphifyy` nao estava mais instalado e `graphify.exe`/`graphify-mcp.exe` nao existiam em `Scripts`.
- Correcao em 2026-06-25: reinstalado `graphifyy==0.8.49` no runtime bundled, validado `rtk proxy graphify explain "Hero" --graph .\graphify-out\graph.json`, confirmado `Get-Command graphify` apontando para `...\python\Scripts\graphify.exe` e sincronizadas as skills `graphify` em `C:\Users\Vitor\.codex`, `C:\Users\Vitor\.agents` e `C:\Users\Vitor\.claude`.
- Persistencia: o PATH de usuario ja contem `C:\Users\Vitor\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\Scripts`; se uma nova sessao falhar de novo, verificar primeiro se o pacote foi removido do runtime com `python.exe -m pip show graphifyy`.
- Relacionado: [[Agent Context Rules]], [[Decision Log]].

## SonarQube token sem permissao de criar projeto

Em 2026-06-07, o scan local chegou a gerar o relatorio e importar cobertura C#, mas falhou no upload com:

```text
You're not authorized to analyze this project or the project doesn't exist on SonarQube and you're not authorized to create it.
```

Causa: token sem permissao para criar/analisar o projeto, ou projeto ainda inexistente. Para a primeira analise local, usar token do `admin` ou criar `lotojogo-backend` e `lotojogo-frontend` manualmente no SonarQube.

## Replica MySQL em volumes existentes

- Caveat: scripts em `docker/mysql/master/init` e `docker/mysql/slave/init` rodam somente na inicializacao de volumes MySQL novos.
- Impacto: se `mysql_data_dev`, `mysql_data` ou `mysql_slave_data` ja existirem, o usuario de replicacao e a configuracao inicial de replicacao podem nao ser aplicados automaticamente.
- Mitigacao: recriar volumes somente depois de backup, ou aplicar manualmente os comandos equivalentes de criacao do usuario de replicacao e `CHANGE REPLICATION SOURCE TO`.
- Relacionado: [[Docker]], [[Backend]].

## Replica MySQL nao deve criar usuario local

- Caveat: se `db-slave` definir `MYSQL_USER`/`MYSQL_PASSWORD`, o entrypoint cria usuario localmente e a replicacao pode abortar quando o master replicar `CREATE USER`.
- Decisao: o slave deve receber schema e usuario pela replicacao do master.
- Mitigacao: recriar o volume do slave depois de remover as variaveis de usuario/schema do slave, ou ajustar manualmente em ambiente existente.

## Replica MySQL nao deve iniciar super-read-only

- Caveat: se `db-slave` iniciar com `--super-read-only=ON`, o entrypoint oficial do MySQL pode falhar durante os scripts de init com `ERROR 1290`.
- Decisao: `read-only` e `super-read-only` devem ser ativados pelo script `docker/mysql/slave/init/01-start-replication.sh` somente depois de executar `CHANGE REPLICATION SOURCE TO`.
- Mitigacao: remover flags read-only do command inicial e recriar o volume do slave quando a falha ja ocorreu em volume novo.

## Senha de replicacao MySQL tem limite de 32 caracteres

- Caveat: `CHANGE REPLICATION SOURCE TO ... SOURCE_PASSWORD` falha com `ERROR 3056` quando a senha do usuario de replicacao passa de 32 caracteres.
- Mitigacao: gerar `secrets/mysql_replication_password.txt` com `openssl rand -hex 16`, que produz 32 caracteres.
- Relacionado: [[Docker]].

## Scripts MySQL init sao sourced pelo entrypoint

- Caveat: scripts `.sh` em `/docker-entrypoint-initdb.d` sao executados com `source` pelo entrypoint oficial do MySQL. Usar `set -u` nesses scripts altera o shell pai e pode causar `MYSQL_ONETIME_PASSWORD: unbound variable`.
- Decisao: scripts de init devem usar `set -eo pipefail`, sem `-u`.
- Relacionado: [[Docker]].

Relacionado: [[LotoJogo - MOC]], [[Tests]], [[Frontend]], [[LotteryStrategies]], [[Docker]].

## Backend

- O test project pode emitir warning de conflito de versao em `Microsoft.EntityFrameworkCore.Relational`.
- A migration `AddUserEmailSecurityConstraints` cria indice unico em `Users.email`; se ja existirem e-mails duplicados em uma base real, a migration exigira limpeza previa desses registros. Needs verification em producao/dev compartilhado antes de aplicar.
- Saved Strategies ainda persistem `generation_mode = combined`, mas a UI de Saved Strategies nao usa esse modo. A geracao combinada atual usa `config.combinations` no fluxo de gerar apostas.

## Frontend

- A fase base do [[Dashboard Redesign]] adicionou aliases limpos `/dashboard`, `/login`, `/register` e `/profile`, mas as rotas antigas `/dashboardPage`, `/loginPage` e `/registerPage` ainda existem para compatibilidade. Needs verification: decidir quando remover ou redirecionar definitivamente as rotas antigas.
- `ProfilePage` completa depende de endpoints backend ainda nao confirmados para atualizar nome/foto/preferencias, alterar senha e excluir conta. Hoje o contrato confirmado no frontend e backend e `/Auth/me`. Needs verification antes de prometer CRUD de perfil.
- Em 2026-05-13, `npm run lint` passou apos a refatoracao do frontend; se voltar a falhar, revalidar antes de considerar problema conhecido.
- Existem inline styles em componentes da landing.
- O projeto usa SCSS global, embora notas antigas pedissem SCSS modules.
- A UI de Saved Strategies existe no `HomeTab`, mas o editor de config ainda e JSON bruto em vez de minicards estruturados.
- A validacao visual completa do dashboard exige login no app local.
- Smoke em `http://127.0.0.1:5173` mostrou CORS ao chamar `/Auth/me` em `http://localhost:5176`. Needs verification: alinhar `VITE_API_BASE_URL`, origem permitida no backend e porta real da API local.
- A verificacao visual do layout responsivo em 2026-05-15 usou mock local de `/Auth/me` no navegador porque a rota da dashboard e protegida. Needs verification com backend real autenticado para cobrir dados reais de Gerenciar/Lixeira.
- O redesign premium do `LoteShowcaseCard` nao consegue marcar hot/cold historico por dezena com precisao individual, porque `/BetInsights/analyze` retorna `strongNumbersCount` agregado e nao a lista/frequencia de cada numero. Needs verification se o contrato deve expor frequencias por dezena.

## Produto/Contrato

- `poolSize` tem significado ambiguo entre "disponiveis" e "combinacoes".
- Em 2026-05-11, `dotnet test lotojogo-api.sln` passou no workspace atual. A divergencia conceitual de `poolSize` segue pendente ate decidir se o campo representa "disponiveis" ou "combinacoes".
- `most_frequent` e `less_frequent` existem no frontend, mas nao tem algoritmo especifico no backend.
- `+Milionaria` ainda nao modela selecao de trevos no dashboard; custo atual do resumo assume 2 trevos. Needs verification quando trevos forem implementados.
- `Super Sete` tem regra oficial por colunas, mas o gerador atual ainda trata o universo como numeros sequenciais. Needs verification antes de considerar a modalidade fiel ao volante oficial.
- As planilhas de [[Time Mania]] ate concurso 2360 nao contem o concurso 1623; o seed importado tem 2359 registros para `time_mania`. Needs verification contra outra fonte antes de preencher manualmente.

## Infra

- Docker hot reload em Windows foi anotado como instavel em notas antigas; revalidar antes de tratar como bug atual.
- O vault ativo do LotoJogo e `C:\Users\Vitor\Documents\SecondBrain\SecondBrain\Projects\LotoJogo`; o duplicado antigo em `C:\Users\Vitor\Documents\SecondBrain\Projects\LotoJogo` foi removido em 2026-05-16.
- A pasta pai `C:\Users\Vitor\Documents\Projects\lotojogo` nao e o repositorio Git principal; os repositorios Git encontrados ficam em `lotojogo-front-end` e `lotojogo-back-end`. Rodar comandos Git a partir do subprojeto correto.
- Em 2026-05-20, foram encontrados segredos reais em arquivos locais antes da limpeza: senha MySQL, JWT key e Google OAuth Client Secret. Mitigacao: rotacionar credenciais no MySQL/ambiente de producao e recriar o Google Client Secret no Google Cloud Console. Needs verification depois da rotacao.
- O deploy seguro no EC2 precisa de dominio e TLS. Com `ASPNETCORE_ENVIRONMENT=Production`, cookies `Secure` exigem HTTPS; `http://IP` nao deve ser usado para fluxo autenticado. Needs verification apos configurar HTTPS.
- Segredos em `.env` nao devem ser usados em producao. O compose de producao usa Docker secrets por arquivo; antes de producao real, avaliar migracao para AWS Secrets Manager, SSM Parameter Store ou mecanismo equivalente. Needs verification.
- O frontend mantem fallback em `createClientId` para compatibilidade de navegadores em IDs efemeros de UI; nao usar esse helper para identificadores de seguranca ou persistencia sensivel.
- `POST /generate` em build antigo do frontend retornava `405 Not Allowed` no Nginx porque apenas `/Generate` era proxyado. Mitigacao: frontend usa `/Generate` e Nginx mantem alias `/generate`.
