# Decision Log

## 2026-09-08 - Financeiro integrado ao dashboard central

- Decisao: `Financeiro` deixou de ser uma pagina independente e passou a ser uma aba interna do dashboard em `/dashboard?aba=financeiro`; a rota protegida `/financeiro` redireciona para esse endereco.
- Decisao: `DashboardPage` mantem uma unica `DashboardLinearRail` e um unico `DashboardControlCenter`; o workspace financeiro renderiza um centro proprio e um `right-config-area--financeiro` ao lado, enquanto as areas de apostas ficam montadas e ocultas com `hidden` para preservar rascunhos, selecao, configuracoes e menu anterior.
- Decisao: `useFinanceiro` recebe `enabled` e so consulta dados quando a aba financeira esta ativa; o periodo selecionado permanece no modulo carregado sob demanda enquanto o usuario alterna entre financeiro e apostas.
- Atualizacao: `FinanceiroShell`, `FinanceiroPage`, `financeiro-shell__aviso` e `DisclaimerCard` foram removidos da renderizacao; o preloading antigo de Financeiro agora aquece o dashboard e o chunk `FinanceiroDashboard`.
- Verificacao: frontend validado com testes de rotas/componentes, lint, build e Playwright em 320, 768, 1024 e 1440 px, incluindo `/financeiro`, clique pela rail, voltar/avancar, uma unica rail/control center, ausencia dos avisos removidos e ausencia de overflow horizontal.
- Relacionado: [[Frontend]], [[Dashboard Redesign]], [[Tests]].

## 2026-08-19 - Uma tela de carregamento no boot

- Decisao: o carregamento normal da SPA usa uma unica identidade visual baseada em `boot-loading`, tanto no `index.html` antes do JavaScript quanto no fallback React de `Suspense`/auth.
- Motivo: ao iniciar Docker/Vite e abrir o site, o usuario via duas telas sequenciais de carregamento: `boot-loading` do HTML e `AppLoadingFallback` com skeleton.
- Verificacao: `npm.cmd test -- src/App.routes.test.ts --run`, `npm.cmd run lint`, `npm.cmd run build` e `npm.cmd test -- --run` passaram no frontend.
- Relacionado: [[Frontend]], [[Dashboard Redesign]], [[Known Issues]].

## 2026-08-15 - Financeiro com primeira tela desacoplada

- Decisao: a rota `/financeiro` deve carregar `FinanceiroPage` diretamente, sem aguardar o chunk do dashboard gerador.
- Decisao: `useFinanceiro` passa a carregar primeiro o resumo base (`/Lotes`) e agenda/detalhes/insights financeiros em fase complementar agendada por `requestIdleCallback`.
- Motivo: a dashboard financeira estava lenta tanto por link direto quanto vindo do dashboard porque pagava o custo do chunk de jogos e bloqueava a primeira tela em dados secundários.
- Verificacao: `npm.cmd run lint`, `npm.cmd run build` e `npm.cmd test -- --run` passaram no frontend.
- Relacionado: [[Frontend]], [[Dashboard Redesign]], [[Known Issues]].

## 2026-08-14 - Hardening de auth, bots e segredos

- Decisao: usar Cloudflare Turnstile como protecao anti-bot para endpoints publicos de auth (`/Auth/login`, `/Auth/register`, `/Auth/google`), com token validado server-side pela API antes de processar credenciais ou codigo Google.
- Decisao: manter MySQL e nao migrar para Supabase; a alternativa a RLS e isolamento por API/repository com `UserId`, JWT em cookie HttpOnly, controllers autorizados, roles para admin, usuario DB read/write separado do read-only e nenhuma credencial DB no frontend.
- Decisao: `VITE_TURNSTILE_SITE_KEY` e publico e pode entrar no bundle; `Turnstile:SecretKey` fica apenas no backend, via Docker secret/arquivo em producao.
- Decisao: remover chaves de Data Protection e `.sonarqube` do indice Git do backend e ignorar `keys/`, `secrets/`, `.env.*`, credenciais e artefatos gerados. Historico antigo ainda exige purge coordenado e rotacao de credenciais fora do codigo.
- Atualizacao: cadastro passa a autenticar o usuario quando a conta e criada, evitando consumir dois tokens Turnstile em sequencia no fluxo register -> login.
- Atualizacao: resposta de importacao historica nao ecoa mais a linha bruta rejeitada; retorna linha e motivo, mas `Raw` sai nulo para reduzir reflexao/vazamento.
- Verificacao: `dotnet build lotojogo-api.sln`; `dotnet list lotojogo-api.csproj package --vulnerable --include-transitive`; `dotnet test lotojogo-api.Tests\lotojogo-api.Tests.csproj --no-build --filter "FullyQualifiedName~HistoricalBetImport"`; `npm.cmd audit --omit=dev`; `npm.cmd run lint`; `npm.cmd run build`.
- Caveat: purge de historico Git nao foi executado automaticamente porque reescreve commits e exige coordenacao de remote/force-push; o procedimento ficou documentado em `lotojogo-api/docs/security-hardening.md`.
- Relacionado: [[Auth]], [[Backend]], [[Frontend]], [[Docker]], [[Known Issues]].`r`n`r`n## 2026-08-08 - Auditoria e normalizacao de sorteios historicos

- Decisao: `LotteryGameCatalog` normaliza aliases legados do seed (`loto_mania`, `time_mania`, `dia_sorte`) para os nomes canonicos `lotomania`, `timemania` e `dia_de_sorte`.
- Decisao: `LotteryDrawSeedService` grava novos imports com `game_type` canonico e `LotteryDrawRepository` consulta aliases para preservar bancos que ja tenham linhas antigas com nomes legados.
- Decisao: admins podem chamar `GET /Admin/lottery-draws/coverage` para auditar cobertura por modalidade, incluindo maior concurso conhecido, concursos faltantes, ordens faltantes e amostras dos primeiros gaps.
- Decisao: `POST /Admin/lottery-draws/import-caixa` suporta todas as modalidades do `LotteryGameCatalog` via `OfficialCaixa:ContestUrlTemplate`, reutiliza `LotteryProviderJson.ParseContest` e limita cada request a 500 concursos.
- Atualizacao em 2026-08-08: admins tambem podem usar `POST /Admin/lottery-draws/import-text` para importar sorteios antigos por CSV/TSV/texto com cabecalho (`concurso`, `data`, `numeros`, opcionalmente `modalidade`, `drawOrder`, `trevos`, `columns`, `extras`). O parser valida tamanho total, tamanho de linha, quantidade de linhas, modalidade, data, concurso, universo numerico e extras antes de delegar a persistencia idempotente ao `LotteryDrawSeedService`.
- Decisao: o contrato textual foi documentado em `lotojogo-api/docs/lottery-draw-import.md`; isso vira fallback operacional quando a importacao oficial for bloqueada por `429/403`.
- Atualizacao em 2026-08-08: o frontend exibe um painel admin na aba Gerenciar para importar sorteios antigos por TXT/CSV, baixar modelo por modalidade e visualizar resumo de cobertura; o painel so renderiza quando `/Account/entitlement` retorna `role = Admin`.
- Atualizacao em 2026-08-08: a importacao textual de sorteios tambem faz upsert idempotente em `LotteryContests` como `Drawn`, permitindo que concursos antigos existam no dominio sem depender de importacao de apostas; para nao poluir o seletor de geracao, `GET /LotteryContests?category=...` filtra concursos historicos e retorna apenas `Scheduled` para categorias.
- Evidencia em 2026-08-08: seed local cobre sem lacunas `loto_facil`, `mega_sena`, `quina`, `lotomania`, `dupla_sena`, `dia_de_sorte` e `timemania`; o concurso 1623 da Timemania foi adicionado ao seed como `timemania` canonico.
- Caveat em 2026-08-08: `super_sete` ainda falta 1-879 e `mais_milionaria` ainda falta 1-375 no seed; a tentativa de preencher em massa pela API oficial da Caixa foi interrompida por `429` e `403` no edge Azion/ShieldSquare para o IP local. Usar download oficial de resultados quando acessivel, ou retomar importacao por intervalos depois do desbloqueio.
- Verificacao: `docker exec lotojogo-api-dev-1 dotnet test /app/lotojogo-api.Tests/lotojogo-api.Tests.csproj --verbosity minimal` passou com 382 testes; `dotnet build lotojogo-api\lotojogo-api.csproj --no-restore --verbosity minimal` passou no host.
- Relacionado: [[Backend]], [[LotteryDraws]], [[LotteryStrategies]], [[Tests]].

## 2026-08-08 - Importacao historica de apostas e quotas por plano

- Decisao: apostas antigas importadas/manualizadas reutilizam `Lotes`, `LoteStrategies` e `Bets`; cada aposta importada entra como estrategia `manual` bloqueada (`is_locked`) para evitar regeneracao/edicao acidental do registro historico.
- Decisao: `POST /Lotes/historical/import` aceita linhas estruturadas, TXT simples, CSV semicolon padronizado com `numeros;valor;premio;titulo` ou `bets[]` estruturado; o frontend le `.txt/.csv`, oferece modelos CSV/XLSX baixaveis, parseia XLSX no navegador com limites de tamanho/linhas/celulas e permite cadastrar uma aposta antiga manual por campos, sem upload binario para o servidor nesta fatia.
- Atualizacao em 2026-08-09: o modelo CSV/XLSX de apostas antigas inclui `concurso` e `data`; o backend tambem aceita esses metadados por linha em arquivo delimitado ou `bets[]` estruturado, desde que a importacao represente um unico concurso/data por lote.
- Atualizacao em 2026-08-09: o frontend aceita importacao TXT/CSV/XLSX sem preencher `Concurso`/`Data` na tela quando o arquivo ja contem cabecalho de metadados ou a planilha estruturada ja gerou `bets[]` com `contestNumber`/`drawDate`; entrada manual continua exigindo metadados na tela.
- Decisao: `Bets` passou a ter `stake_amount` e `prize_amount` opcionais; lotes retornam `totalPrize` e `netResult`, usando `stake_amount` real quando presente e a tabela atual apenas como fallback para apostas geradas.
- Decisao: quotas por plano ficam centralizadas em `PlanQuotaPolicy` e aparecem em `/Account/entitlement`: Basic importa ate 20 apostas por lote, Pro ate 200 e Bolao ate 1000.
- Caveat: premios reais por faixa/rateio historico ainda nao sao calculados automaticamente porque `LotteryDraws` guarda dezenas/metadados, mas nao rateios/premiacoes da Caixa; `prize_amount` pode ser informado na importacao estruturada e a UI TXT inicial cobre modalidades numericas convencionais.
- Verificacao: `rtk dotnet test lotojogo-api.Tests\lotojogo-api.Tests.csproj --verbosity minimal`; `rtk npm test`; `rtk npm run lint`; `rtk npm run build`; `dotnet test lotojogo-api/lotojogo-api.Tests/lotojogo-api.Tests.csproj --verbosity minimal`; `npm.cmd test`; `npm.cmd run lint`; `npm.cmd run build`.
- Relacionado: [[Backend]], [[Frontend]], [[LotteryDraws]], [[LotteryStrategies]], [[Tests]].

## 2026-08-08 - Estrategias derivadas das apostas antigas do usuario

- Decisao: `GET /Lotes/historical/strategy-insights` calcula estatisticas apenas de apostas historicas: concursos `Drawn`, apostas bloqueadas/importadas ou apostas com custo/premio real, ignorando jogos futuros `Scheduled`.
- Decisao: o contrato retorna frequencia das dezenas mais/menos usadas, estrategias mais/menos usadas, totais financeiros e sugestoes ja no formato `StrategyConfig` (`fixed_number`, `exclude_number`, `odd_even`, `high_low`, `sum`).
- Decisao: `PlanQuotaPolicy` tambem limita quantidade de sugestoes por plano: Basic 3, Pro 8, Bolao 12. Basic recebe somente sugestoes sem `requiresPaidPlan`.
- Decisao: o frontend mostra as sugestoes na aba Gerenciar junto da importacao, permite copiar a config JSON e permite aplicar a sugestao diretamente na aba `Configurar`.
- Decisao: a aplicacao direta usa `features/strategies/historicalStrategySuggestions.ts` para converter a sugestao em `StrategyInstance`, clonando config e marcando `optimization.source = "user-historical-bets"`.
- Decisao: sugestoes com `requiresPaidPlan` ficam bloqueadas para uso direto na UI quando o plano nao permite, mas continuam visiveis/copiaveis.
- Atualizacao em 2026-08-08: o mesmo endpoint tambem le `LotteryDraws` da modalidade e retorna `drawCount`, `mostDrawnNumbers` e `leastDrawnNumbers`; quando o plano permite frequencia, adiciona sugestoes `most_frequent` e `less_frequent` baseadas nos sorteios importados. Sugestoes `draw-*` aplicadas pelo frontend recebem `optimization.source = "lottery-draws"`.
- Atualizacao em 2026-08-08: a UI da aba Gerenciar passou a exibir rankings separados de "mais/menos usados" nas apostas antigas e "mais/menos sorteadas" nos sorteios importados; sugestoes premium agora usam `quotas.frequencyStrategiesEnabled` em vez de bloquear todo `requiresPaidPlan` indiscriminadamente.
- Atualizacao em 2026-08-08: plano Bolao recebe pacote avancado de sugestoes historicas com `prime_count`, `multiple_count`, `ending_digit`, `range_count`, `f1f2f3` e uma sugestao `sum` com `combinations` (`prime_count`, `range_count`, `max_sequence`); cada sugestao e verificada contra `StrategyRequestValidator` e `StrategyCapacityCalculator` para evitar filtros impossiveis.
- Atualizacao em 2026-08-08: o projeto de testes backend desabilita paralelizacao de xUnit porque `StrategyOptimizerService` usa cache historico estatico invalidado por imports/syncs, evitando falso negativo entre testes concorrentes.
- Verificacao: `rtk dotnet test lotojogo-api.Tests\lotojogo-api.Tests.csproj --verbosity minimal`; `rtk npm test`; `rtk npm run lint`; `rtk npm run build`; `npm.cmd test`; `npm.cmd run lint`; `npm.cmd run build`; `docker exec lotojogo-api-dev-1 dotnet test /app/lotojogo-api.Tests/lotojogo-api.Tests.csproj --verbosity minimal`; `npm.cmd test`; `npm.cmd run lint`; `npm.cmd run build`.
- Relacionado: [[Backend]], [[Frontend]], [[LotteryStrategies]], [[Tests]].

## 2026-08-08 - Disponibilidade de concurso para geracao

- Decisao: concurso disponivel para gerar apostas exige `Status == Scheduled`, sem conflito de verificacao e antes do fechamento de apostas calculado em `America/Sao_Paulo`.
- Decisao: o cutoff padrao e domingo 10h e demais dias 20h, derivado do cronograma CAIXA de sorteio domingo 11h ou demais 21h menos 1 hora; overrides por modalidade/data ficam em `LotteryContestAvailability`.
- Decisao: snapshots externos com `NextDrawDate` anterior ao dia atual no Brasil sao rejeitados pelo validator para forcar fallback quando a API oficial estiver atrasada.
- Decisao: DTOs de concursos expoem `isAvailable`, `unavailableReason`, `drawDateTime` e `salesCloseAt`; frontend deve desabilitar concursos vencidos/apurados e bloquear geracao localmente antes de chamar `/Generate`.
- Motivo: impedir que concursos como Lotofacil 3756 continuem selecionaveis quando a CAIXA ainda retorna um proximo concurso ja vencido.
- Verificacao: `rtk dotnet test lotojogo-api.Tests\lotojogo-api.Tests.csproj`; `rtk npm test`; `rtk npm run lint`; `rtk npm run build`.
- Relacionado: [[Backend]], [[Frontend]], [[LotteryDraws]], [[Tests]].

## 2026-08-02 - Concursos cache-first no backend

- Decisao: `GET /LotteryContests` e a UI autenticada devem tratar o banco como fonte principal para concursos, retornando cache salvo sempre que existir e usando APIs externas apenas via refresh server-side.
- Decisao: o parametro opcional `forceRefresh=true` apenas solicita refresh no servidor; o frontend nao deve fazer rotacao ou fallback direto entre APIs de loteria.
- Decisao: concursos retornam `isStale` para a UI diferenciar cache vencido de erro fatal; erro bloqueante so deve ocorrer quando nao houver nenhum dado utilizavel no banco.
- Atualizacao em 2026-08-02: `GET /LotteryContests` nao aguarda provider externo; ele dispara refresh server-side em background e retorna apenas o cache do banco, ou `503` rapido se ainda nao houver cache.
- Atualizacao em 2026-08-02: datas de providers da Caixa em `dd/MM/yyyy` devem ser parseadas antes da cultura invariavel para evitar salvar `01/08/2026` como janeiro; proximo concurso com data passada pode ser salvo como `Stale`.
- Motivo: reduzir dependencia de terceiros no carregamento da dashboard e evitar que falhas temporarias de provider bloqueiem concursos ja salvos.
- Verificacao: `rtk dotnet test lotojogo-api.sln`, `rtk npm run lint`, `rtk npm run test`, `rtk npm run build`.
- Relacionado: [[Backend]], [[Frontend]], [[LotteryDraws]].

## 2026-07-16 - Codex, SecondBrain e skills curadas

- Decisao: tratar `C:\Projetcts\SecondBrain` como memoria operacional do Codex para LotoJogo.
- Decisao: instalar um perfil curado de skills em `C:\Users\root4\.codex\skills`: Obsidian, C#/.NET, React/TypeScript, qualidade e `impeccable`.
- Decisao: nao duplicar Superpowers como skill local porque ja esta disponivel via plugin instalado.
- Decisao: usar `rtk` e Graphify antes de leituras amplas; LLMLingua fica como ferramenta experimental de compressao, nao como fluxo padrao.
- Motivo: reduzir consumo de token, evitar skills concorrentes e aumentar precisao na escolha de ferramenta por tipo de tarefa.
- Consequencia: novas tarefas devem iniciar por [[LotoJogo - MOC]] e [[Agent Context Rules]], depois expandir para codigo somente no subrepo relevante.
## 2026-06-24 - Dominio canonico sem www

- Decisao: manter `SITE_DOMAIN` e `FRONTEND_URL` apontando para `lotojogo.com.br` como origem canonica.
- Decisao: configurar o Caddy para emitir TLS tambem para `www.lotojogo.com.br` e redirecionar permanentemente esse hostname para a origem canonica, preservando caminho e query string.
- Motivo: o CNAME `www` ja apontava corretamente para `lotojogo.com.br`, mas o Caddy conhecia apenas o hostname sem `www`; por isso o handshake TLS de `https://www.lotojogo.com.br` falhava antes de qualquer redirect HTTP.
- Tradeoff: `www` permanece apenas como alias de entrada; cookies, OAuth e URLs da aplicacao continuam concentrados na origem sem `www`.
- Relacionado: [[Docker]], [[Known Issues]].

## 2026-06-24 - Graphify integrado ao runtime do Codex

- Decisao: instalar `graphifyy` no Python bundled do Codex e instalar a skill oficial em `C:\Users\root4\.codex\skills\graphify`.
- Decisao: configurar o MCP Graphify no `.codex/config.toml` do LotoJogo, apontando para `graphify-out/graph.json`.
- Decisao: manter `multi_agent = true` e `PYTHONIOENCODING=utf-8` na configuracao global do Codex.
- Decisao: usar `graphify update . --force` para atualizacao incremental somente de codigo, sem depender de uma chave LLM.
- Atualizacao em 2026-06-25: reinstalar `graphifyy==0.8.49` quando o runtime bundled perder o pacote e manter `...\python\Scripts` no PATH de usuario para que novas sessoes resolvam `graphify` sem ajuste manual.
- Atualizacao em 2026-06-25: manter as skills `graphify` de `C:\Users\root4\.codex`, `C:\Users\root4\.agents` e `C:\Users\root4\.claude` sincronizadas com a versao instalada para evitar avisos de incompatibilidade.
- Motivo: o grafo existia, mas o pacote Python/CLI nao estava instalado no runtime que o Codex usa, deixando `graphify` indisponivel no PATH.
- Relacionado: [[Agent Context Rules]], [[Known Issues]], [[Architecture]].

## 2026-06-24 - Tipografia da Home publica

- Decisao: usar Satoshi nos titulos do Hero e HowItWorks.
- Decisao: manter `segundos` e `metodo` em italico no titulo do HowItWorks.
- Decisao: usar Clash Display no `hero__stats-strip`; textos corridos continuam em Satoshi e controles/labels em Inter.
- Motivo: preservar a direcao visual aprovada pelo usuario e manter uma hierarquia tipografica consistente.
- Relacionado: [[Frontend]].

## 2026-06-07 - SonarQube local gratuito

Decisao: usar SonarQube Community Build local via `docker-compose.sonar.yml`, separado do compose da aplicacao, com PostgreSQL dedicado e volumes persistentes.

Racional: o pedido foi por SonarCloud/SonarQube local gratuito. SonarCloud depende de conta externa e token de organizacao; SonarQube Community Build atende o uso local sem custo. A analise fica dividida em dois projetos: `lotojogo-backend` pelo SonarScanner for .NET e `lotojogo-frontend` pelo SonarScanner CLI, evitando uma configuracao de monorepo fragil para C# e TypeScript. Em 2026-06-07, `sonarqube:lts-community` subiu `9.9.8.100196` e foi marcado como antigo; o compose passou a usar `sonarqube:community` para acompanhar o Community Build atual. Como o upgrade direto do banco `9.9.8` para `26.6.0` exige passar antes por `25.12`, o compose ganhou `name: lotojogo-sonar` para criar volumes novos e evitar migração acidental nesse uso local.

Links: [[Docker]], [[Tests]], [[Backend]], [[Frontend]].

## 2026-06-05 - Config de estrategias com schema rigido

- Decisao: manter `StrategyConfig.Config` e configs de templates como `JsonElement`, mas validar por allowlist de propriedades e tipos antes de gerar ou persistir.
- Decisao: rejeitar strings em campos numericos, propriedades extras e `numbersList` com itens nao inteiros, em vez de tentar sanitizar e aceitar payload adulterado.
- Decisao: no frontend, substituir campos numericos dos cards da Home por `NumericTextInput` (`type="text"` + `inputMode="numeric"` + filtro de digitos) para permitir campo vazio durante edicao.
- Motivo: melhorar a usabilidade dos cards e impedir que payloads HTML/SQL-like fiquem salvos como JSON bruto ou sejam interpretados como valores padrao.
- Relacionado: [[Frontend]], [[Backend]], [[DTOs]], [[Tests]].

## 2026-05-27 - Graphify como primeira fonte de contexto tecnico

- Decisao: usar Graphify primeiro para orientacao tecnica, perguntas de arquitetura, analise de impacto e relacoes entre arquivos quando `graphify-out/graph.json` existir.
- Decisao: manter Obsidian como memoria duravel para decisoes, caveats e documentacao, mas nao como primeira fonte para redescobrir estrutura de codigo.
- Decisao: depois de mudancas relevantes em codigo, atualizar outputs Graphify com `graphify update . --force`; alteracoes semanticas em documentos ou imagens exigem um backend LLM configurado. Para mudancas arquiteturais, regenerar tambem os exports relevantes.
- Motivo: reduzir consumo de tokens e evitar releitura ampla de notas/arquivos quando o grafo pode responder por subgrafos menores.
- Relacionado: [[Agent Context Rules]], [[Architecture]], [[Known Issues]].

## 2026-05-25 - Direcao visual do redesign do dashboard

- Decisao: documentar o redesign do dashboard como [[Dashboard Redesign]], seguindo a direcao **Tactical Intelligence Dark**.
- Decisao: combinar os eixos **A. Mais operacional e denso** e **C. Fluxo mais guiado**.
- Decisao: a marca deve aparecer no `TopNav`, mas a dashboard autenticada continua sendo uma ferramenta de trabalho, nao uma landing page.
- Decisao: o fluxo visual alvo deve explicitar `categoria -> estrategias -> revisao -> lote -> historico`, preservando `useDashboardState`, `useStrategyBuilder`, hooks React Query e services atuais.
- Motivo: o documento inicial misturava visao, exemplos de codigo e tarefas; a spec separa direcao visual, componentes planejados, fases e caveats.
- Relacionado: [[Frontend]], [[Dashboard Redesign]], [[Known Issues]].

## 2026-05-25 - Fase base do Dashboard Redesign

- Decisao: implementar primeiro a base global do redesign, sem alterar a logica de geracao ou gerenciamento de lotes.
- Decisao: adicionar aliases limpos `/dashboard`, `/login`, `/register` e `/profile`, preservando as rotas antigas para compatibilidade.
- Decisao: trocar a entrada principal de categorias da dashboard para `TopNav` + `CategoryDrawer`, deixando a `LeftSideBar` fora do fluxo principal.
- Decisao: `ProfilePage` e MVP visual baseado em `/Auth/me`; edicao real de perfil continua bloqueada por contrato backend futuro.
- Motivo: entregar uma camada navegacional consistente e o fluxo guiado A+C sem misturar com redesign fino de cards e sem inventar endpoints.
- Relacionado: [[Frontend]], [[Dashboard Redesign]], [[Auth]].

## 2026-05-25 - Compactacao da dashboard apos TopNav

- Decisao: remover `RightProfileStatusBar`/`right-profile-area` do layout principal da dashboard.
- Decisao: remover `dashboard-header__brand` e `dashboard-flow`, deixando o `dashboard-ticker` ocupar o topo do painel principal.
- Decisao: expandir `right-config` para ocupar a altura lateral disponivel.
- Decisao: adaptar o footer global para o padrao de footer com marca, links sociais, links principais, links legais e copyright.
- Motivo: reduzir redundancia visual depois da introducao do `TopNav` e liberar espaco operacional para configuracao e volante.
- Relacionado: [[Frontend]], [[Dashboard Redesign]].

## 2026-05-18 - UX vazia e motion premium do dashboard

- Decisao: quando a aba Home nao tiver estrategias nem apostas manuais, exibir um estado vazio explicito em vez de renderizar cards vazios.
- Decisao: manter o efeito de `dashboard-card__header h2` em CSS, com movimento lento continuo no metal liquido e brilho forte raro em ciclo de 15 minutos.
- Decisao: corrigir o corte do glow dos `strategy-card` reservando padding no `strategies-scroll` e deixando o card com `overflow: visible`.
- Motivo: reduzir ambiguidade da aba Home vazia, manter a sensacao premium sem animacao agressiva e preservar o acabamento visual dos cards dentro do container rolavel.
- Relacionado: [[Frontend]], [[Tests]].

## 2026-05-18 - Persistencia local de UI do dashboard

- Decisao: salvar expansao/compactacao de `strategy-section` em `localStorage`, por `loteId:strategyId`.
- Decisao: salvar rascunho da aba Home em `localStorage`, por categoria, cobrindo estrategias configuradas, defaults, estrategia selecionada e apostas manuais.
- Motivo: esses estados sao preferencia/rascunho de UI, nao dados de dominio; persistir no backend criaria tabelas e endpoints sem necessidade.
- Relacionado: [[Frontend]], [[Tests]].

## 2026-05-18 - Cache read-only e replica MySQL

- Decisao: separar `AppDbContext` para master/escrita e `ReadOnlyAppDbContext` para slave/leitura.
- Decisao: aplicar cache em memoria apenas em consultas explicitamente read-only, com TTL de 30 segundos.
- Decisao: invalidar o cache de repositorios por token em qualquer `SaveChangesAsync`, sem limpar caches nao relacionados da aplicacao.
- Motivo: evitar leituras repetidas em telas e analises sem quebrar tracking do EF Core em fluxos que carregam entidades para mutacao.
- Relacionado: [[Backend]], [[Repositories]], [[Docker]].

Relacionado: [[LotoJogo - MOC]], [[Architecture]], [[LotteryStrategies]], [[Known Issues]].

## 2026-05-15

### Compactacao responsiva de Home e Gerenciar

Decisao atual no codigo:

- `strategies-scroll` nao limita mais a Home a uma altura fixa pequena em telas ate 640px.
- Filhos de `strategies-scroll` usam `flex: 0 0 auto` para impedir encolhimento visual de minicards.
- `strategy-card__cost-preview` foi mantido na linha de quantidade de apostas, alinhado a direita e com largura compacta.
- `BetRow` usa bloco `Analise` colapsado para insights historicos, reduzindo altura das apostas na aba Gerenciar.
- `strategy-section__bets`, `BetRow` e `CategorySection` tem breakpoints compactos ate 420px para caber em 320px sem overflow horizontal.
- `LoteListItem` usa grid compacto para data, categorias, custo e exclusao.
- `GeneratedBetsCard` foi reduzido ao carrossel visual de numeros, removendo resumo e metadados visuais redundantes.

Motivo:

- Evitar cards cortados/encolhidos na Home e impedir que a aba Gerenciar force largura/escala maior em 320x830.
- Priorizar leitura dos numeros e acoes principais em telas pequenas.

Tradeoff:

- Em telas muito estreitas, parte dos metadados fica mais compacta e a analise historica exige um clique para expandir.

### Dashboard responsiva com painel de estrategias antes do volante

Decisao atual no codigo:

- Em telas ate 1200px, a dashboard empilha `RightProfileStatusBar`, `RightConfigSideBar`, `DashboardMain` e `GeneratedBetsCard`.
- O breakpoint foi ampliado para cobrir larguras como 1026px e 1102px, que antes ainda entravam no layout desktop de duas colunas e podiam cortar cards.
- No mobile ate 640px, a aba Home deixa os minicards manterem altura natural e o documento principal assume a rolagem.
- Nas abas Gerenciar e Lixeira, alturas fixas internas foram removidas no layout ate 1200px para que o documento principal role e os elementos internos nao fiquem escondidos.
- `strategy-card` e `lote-detail` seguem a linguagem glass/fintech do dashboard, mantendo a ideia visual da [[Frontend|LeftSideBar]].

Motivo:

- Priorizar configuracao antes do volante em celular/tablet e evitar que paineis densos de estrategia, lote e lixeira fiquem presos em containers com altura insuficiente.
- Corrigir o comportamento de transicao entre tablet e desktop sem depender exatamente do corte em 1024px.

Tradeoff:

- A dashboard passa a usar layout empilhado por mais tempo, ate 1200px, favorecendo legibilidade em notebooks estreitos em vez de manter duas colunas.
- A aba Home no celular privilegia rolagem do documento principal; minicards mantem altura natural em vez de ficarem presos em uma area interna pequena.

## 2026-05-14

### Regras de contexto para agentes

Decisao atual no vault:

- Foi criada a nota [[Agent Context Rules]].
- O agente deve iniciar buscas e edicoes pelo subprojeto relevante: `lotojogo`, `lotojogo-api`, `lotojogo-tests` ou vault.
- A pasta pai `lotojogo` deve ser usada apenas para coordenacao, Docker e arquivos raiz.
- Obsidian so deve ser atualizado quando o usuario pedir explicitamente.

Motivo:

- Reduzir consumo de contexto, evitar leitura de arquivos gerados e diminuir risco de edicoes fora de escopo.

Tradeoff:

- Algumas tarefas cross-stack podem exigir expandir o escopo manualmente depois da primeira leitura.

### Otimizacao e insights estatisticos

Decisao atual no codigo:

- `StrategyOptimizerController` expoe `/StrategyOptimizer/suggest` para calibrar campos especificos de uma estrategia usando [[LotteryDraws]].
- O otimizador usa faixas/percentis e frequencias historicas, evitando tratar um unico valor como "bala de prata".
- `BetInsightsController` expoe `/BetInsights/analyze` para analisar uma aposta individual contra o historico.
- `BetRow` mostra frequencia media das dezenas, comparacao com o ultimo sorteio e selo dourado quando a combinacao ja cobriu um sorteio anterior.
- `GeneratedBetsCard` foi compactado e agora mostra custo total das apostas do lote atual usando `domain/lottery/pricing.ts`.

Motivo:

- Tornar a experiencia mais informativa sem transformar estatistica historica em promessa de ganho.
- Concentrar calculos historicos no backend, mantendo o frontend responsavel por apresentacao e interacao.

Tradeoff:

- Os endpoints estatisticos analisam uma janela limitada de sorteios recentes para manter resposta rapida.
- `Super Sete` e `+Milionaria` ainda possuem caveats de modelagem ja anotados em [[Known Issues]].

## 2026-05-13

### Revisao antes de gerar apostas

Decisao atual no codigo:

- O primeiro clique em `Gerar apostas` na Home valida as estrategias e abre `GenerationReviewPanel` dentro de `strategies-scroll`.
- A chamada a `/Generate` foi movida para o botao `Confirmar` da tela de revisao.
- A revisao usa visual inspirado no `benefits-split__visual`, adaptado para a sidebar e para muitas estrategias/apostas.
- O painel resume categoria, universo, total previsto, estrategias, apostas manuais e linhas por estrategia.
- O painel tambem exibe custo por estrategia e custo total, a partir de `domain/lottery/pricing.ts`.
- `Super Sete` passou a usar universo 70 no frontend, alinhado ao volante oficial de 7 colunas com 10 algarismos.

Motivo:

- Dar uma etapa clara de conferencia antes de criar o lote, principalmente quando houver varias estrategias, apostas manuais e categorias diferentes sendo alternadas no dashboard.
- Mostrar impacto financeiro antes de persistir um lote.

Tradeoff:

- A geracao passa a ter um clique extra quando a configuracao esta valida.
- `+Milionaria` usa custo assumindo 2 trevos enquanto o dashboard nao modela trevos.

### Refatoracao de responsabilidades do frontend

Decisao atual no codigo:

- `DashboardPage` ficou como componente de composicao e passou a consumir `useDashboardState`.
- `HomeTab` ficou como UI do painel de estrategias e passou a consumir `useStrategyBuilder`.
- Dados estaveis de loteria foram movidos para `domain/lottery/categories.ts`.
- Regras sem UI foram movidas para `features/dashboard` e `features/strategies`.
- Context providers foram separados dos hooks consumidores (`useAuth`, `useTheme`, `useToast`) para preservar Fast Refresh.
- `api.service.ts` usa `unknown` como generico padrao, exigindo tipagem explicita nos consumidores que sabem o contrato.

Motivo:

- Reduzir arquivos grandes com UI, estado remoto, persistencia local e validacao misturados.
- Tornar regras de estrategia, templates e merge de apostas mais testaveis e reutilizaveis.
- Limpar problemas de lint que escondiam acoplamentos reais.

Tradeoff:

- A validacao client-side continua duplicando parte da regra do backend para feedback imediato.
- `strategyValidation.ts` usa casts por tipo porque `StrategyInstance` ainda nao discrimina `config` automaticamente no `switch`.
- Nota historica: nesta etapa o fluxo de templates ainda estava em `localStorage`; depois foi migrado para `/StrategyTemplates`. Ver decisao [[Decision Log#Strategy Templates como presets persistidos]].

### Endurecimento de input e geracao

Decisao atual no codigo:

- `SecurityLimits` concentra limites de body HTTP, config JSON, profundidade JSON, quantidade de estrategias, apostas por estrategia e universo numerico.
- `StrategyRequestValidator` valida requests de `/Generate` e `/StrategyTemplates`.
- Tipos de estrategia desconhecidos agora sao rejeitados em vez de cair para `random`.
- Rate limiting de `auth` e `generate` foi particionado por usuario/IP.
- Cookies de auth sao `Secure` fora de Development, e `Program.cs` usa forwarded headers.
- `Users.email` ganhou tamanho maximo e indice unico.
- `LoteService.ComputePoolSize` corta enumeracao combinatoria enorme retornando `int.MaxValue`.

Motivo:

- Reduzir risco de downtime por JSON grande/profundo, geracao combinatoria abusiva, templates malformados e consumo global de rate limit.

Tradeoff:

- O backend agora rejeita estrategias que o frontend ainda modela sem algoritmo backend, como `most_frequent` e `less_frequent`, ate elas serem implementadas.
- `poolSize = int.MaxValue` passa a significar "espaco combinatorio grande demais para contar com seguranca".

### Sorteios historicos em tabela unica

Decisao atual no codigo:

- Sorteios historicos ficam em [[LotteryDraws]].
- As dezenas sao armazenadas como JSON em `numbers_json` e tambem em `numbers_sorted_json`.
- Metadados variaveis ficam em `LotteryDrawExtras`.
- `dupla_sena` usa `draw_order` para guardar primeiro e segundo sorteio do mesmo concurso.
- O seed gerado das planilhas fica em `Data/Seed/lottery-draws.seed.json` e e importado de forma idempotente no startup.

Motivo:

- Manter uma base unica e simples para estatisticas futuras, sem criar uma tabela por modalidade.
- Preservar a ordem original do sorteio e tambem facilitar consultas por combinacoes ordenadas.

Tradeoff:

- Consultas estatisticas sobre dezenas podem exigir funcoes JSON do MySQL ou materializacoes futuras se performance virar gargalo.

## 2026-05-11

### Scrollbar transitoria e metadados de apostas

Decisao atual no codigo:

- Home e Gerenciar usam `useScrollActivity` para mostrar scrollbar apenas em rolagem real por wheel, toque ou teclas.
- Cliques simples nao ativam a scrollbar, para evitar flicker e para preservar a selecao de apostas em `BetRow`.
- `BetRow` mostra resumo visual da aposta com dezenas, data, hora, soma e status.
- Horarios de apostas sao exibidos em `America/Sao_Paulo`, tratando timestamps sem timezone como UTC.

Motivo:

- Remover o espaco permanente da scrollbar e manter os cards ocupando a largura disponivel, sem que cliques em controles ou metadados causem a barra a aparecer rapidamente.

Tradeoff:

- A scrollbar aparece somente durante interacao de rolagem detectavel; mudancas programaticas de scroll nao exibem a barra por si so.

### Layout do seletor de dezenas no MainCard

Decisao atual no codigo:

- O seletor `dashboard-card__dozen-select` foi movido para o cabecalho do card principal, no canto superior direito.
- O contador `dashboard-card__counter` fica imediatamente abaixo do seletor dentro de `dashboard-card__selection-panel`.
- O conjunto usa visual compacto com borda, fundo sutil e fallback responsivo para empilhar em telas estreitas.

Motivo:

- Aproximar o indicador de progresso do controle que altera o limite de dezenas e liberar a linha abaixo do titulo para a grade principal.

Tradeoff:

- O cabecalho do card passa a carregar mais informacao; por isso o layout responsivo empilha o bloco em larguras menores.

### Sincronizacao do GeneratedBetsCard com lote atual

Decisao atual no codigo:

- `DashboardPage` mantem o `loteId` associado ao conteudo exibido em `GeneratedBetsCard`.
- Selecionar outra aposta do mesmo lote em [[Frontend|Gerenciar]] atualiza apenas `MainCard` e `activeManagedBet`, sem substituir os grupos do `GeneratedBetsCard`.
- Quando uma nova geracao retorna o mesmo `loteId` que esta aberto como "Lote atual", os grupos recem-gerados sao mesclados aos grupos ja exibidos.
- Regenerar uma aposta na aba [[Frontend|Gerenciar]] propaga o `BetDto` atualizado para `DashboardPage` e substitui somente a combinacao correspondente no `GeneratedBetsCard`, localizada por `betIds`.
- `GeneratedBetsCard` foi memoizado para evitar renderizacoes quando grupos, titulo e callbacks permanecem iguais.

Motivo:

- Manter o card de apostas geradas como visualizacao do lote aberto, sem recarregar a lista inteira a cada clique em aposta, mas refletindo novas combinacoes geradas para o mesmo lote.

Tradeoff:

- A mesclagem usa os grupos retornados por `/generate`, que hoje representam apenas as estrategias recem-criadas, e nao o detalhe completo do lote.
- `GeneratedBetsCard` agora depende de `betIds` para troca granular; grupos sem ids continuam exibindo apostas, mas nao conseguem receber substituicao pontual por aposta regenerada.

### Regeneracao de apostas de soma

Decisao atual no codigo:

- `GenerateService.GenerateOne` para estrategia `sum` randomiza a ordem de busca antes de montar a combinacao.
- A aposta regenerada continua respeitando soma, quantidade de dezenas e filtros combinados.
- Foi adicionada regressao em `GenerateServiceTests` para garantir que varias chamadas possam retornar combinacoes validas diferentes.

Motivo:

- A busca recursiva deterministica encontrava sempre a primeira solucao valida, entao o botao regenerar na aba [[Frontend|Gerenciar]] parecia nao fazer nada para apostas de soma.

Tradeoff:

- Ainda nao ha garantia de combinacao inedita em todas as chamadas; ha garantia de que a busca nao fica presa sempre na primeira solucao.

### Expansao de estrategias e validacao defensiva

Decisao atual no codigo:

- Foram adicionadas estrategias `prime_count`, `multiple_count`, `ending_digit` e `range_count`.
- As mesmas regras podem ser usadas como combinacoes, quando fazem sentido, exceto com tipo igual ao da estrategia principal.
- `range_count` gera por grupos com uma incidencia viavel dentro do minimo/maximo, reduzindo dependencia de tentativas aleatorias.
- Frontend e backend validam configuracoes impossiveis antes/de durante a geracao.

Motivo:

- Dar mais opcoes combinaveis sem permitir apostas inconsistentes como soma impossivel, quantidade de dezenas zerada ou contagens maiores que o universo disponivel.

Tradeoff:

- A validacao no frontend duplica parte da regra do backend para melhorar feedback imediato; o backend continua sendo a fonte de verdade para consistencia.

## 2026-05-10

### Combined strategies como filtros E

Decisao atual no codigo:

- Estrategias principais podem receber `config.combinations`.
- O MVP suporta combinar com `fibonacci`, `exclude_number` e `max_sequence`.
- `fibonacci` e sempre incidencia exata.
- A UI usa subcards compactos dentro do minicard da estrategia principal.
- `manual` nao pode ser filtro combinado, mas pode ser salva/restaurada em templates.

Motivo:

- Representar casos como "Soma 200 com exatamente 3 numeros Fibonacci" como uma unica regra composta da mesma aposta, em vez de gerar grupos separados.

Tradeoff:

- Nota historica: o MVP cobria poucas combinacoes e ainda nao conectava o painel local do `load-strategy-button` ao CRUD backend `/StrategyTemplates`; essa conexao foi concluida depois. Ver [[Decision Log#Strategy Templates como presets persistidos]].

### Strategy Templates backend

Decisao atual no codigo:

- Templates de estrategia foram implementados como recurso separado em `GET/POST/PUT/DELETE /StrategyTemplates`.
- A persistencia usa `StrategyTemplate` e `StrategyTemplateStrategy`, vinculadas por `user_id`.
- Cada estrategia do template salva `type`, `config_json` e `sort_order`.
- O CRUD e autenticado por JWT/cookie e filtra sempre pelo usuario atual.

Motivo:

- Substituir a persistencia local do `load-strategy-button` por um contrato backend simples, alinhado ao formato `StrategyInstance[]` usado pela UI.

Tradeoff:

- Historicamente, templates persistiam configuracoes sem validar semanticamente cada `config` contra um schema especifico; em 2026-06-05, `StrategyRequestValidator` passou a validar allowlist de propriedades/tipos por estrategia e combinacao antes de persistir.

### Saved Strategies frontend

Decisao atual no codigo:

- O frontend espelha o contrato backend em `src/types/SavedStrategy.ts`.
- As chamadas CRUD de Saved Strategies ficaram em `strategy.service.ts`, junto do `generateBets`.
- Os hooks React Query ficaram em `useSavedStrategies.ts`.
- O `load-strategy-button` do `HomeTab` abre `SavedStrategiesPanel` inline dentro de `strategies-scroll`.
- Criar/editar config usa JSON de `items` no MVP.

Motivo:

- Entregar a integracao com `/api/strategies` sem criar modal global e sem duplicar UI de cada minicard nesta etapa.

Tradeoff:

- O editor JSON e menos amigavel, mas preserva o contrato e reduz risco ate Combined Strategies ser aprovado.

### Saved Strategies backend

Decisao atual no codigo:

- Estrategias salvas foram implementadas como recurso backend em `GET/POST/PUT/DELETE /api/strategies`.
- A persistencia usa `SavedStrategy` e `SavedStrategyItem`, vinculadas por `user_id` ao usuario autenticado.
- Cada item salva `type`, `config_json`, `sort_order` e `is_enabled`.
- O contrato aceita `generation_mode` como `independent` ou `combined`, mas a geracao combinada ainda nao foi implementada.

Motivo:

- Estabilizar o contrato backend antes da UI do painel de estrategias salvas no `HomeTab`.

Tradeoff:

- O backend ja persiste e valida estrategias salvas, mas o frontend ainda nao carrega/cria/edita pelo novo endpoint.
- `manual`, `most_frequent` e `less_frequent` sao bloqueadas em `combined` no MVP.

### PoolSize como combinacoes

Decisao atual no codigo:

- `LoteService.ComputePoolSize` calcula quantidade de combinacoes possiveis para varias estrategias.

Motivo provavel:

- Mostrar capacidade combinatoria das estrategias, nao apenas quantidade bruta de numeros disponiveis.

Tradeoff:

- UI ainda chama o valor de "disponiveis".
- Teste backend foi alinhado para esperar `15504` em `exclude_number` com 5 excluidos em 25 dezenas.

Proxima decisao:

- Renomear UI/DTO para explicitar combinacoes, ou reverter o calculo para disponibilidade simples.

### Strategy Templates como presets persistidos

Decisao atual no codigo:

- Manter `StrategyTemplates` e `StrategyTemplateStrategies` como persistencia efetiva dos templates/presets do `HomeTab`.
- O frontend usa `/StrategyTemplates` para listar, criar, atualizar, renomear e apagar templates.
- A quantidade de dezenas e de apostas permanece dentro do `config` de cada estrategia, incluindo estrategias `manual`.
- O fluxo de atualizar template mostra um comparativo inline antes de confirmar a gravacao.

Motivo:

- As tabelas ja modelam corretamente template por usuario, categoria e lista ordenada de estrategias.
- Remover essas tabelas perderia o caminho de persistencia backend aprovado para presets.

Tradeoff:

- Templates continuam flexiveis via JSON; a validacao semantica profunda de cada `config` ainda depende dos validadores/geradores existentes.

### DataAnnotations em request records

Decisao atual no codigo:

- Em records MVC com construtor primario, atributos de validacao devem usar alvo `[param: ...]`.
- `CreateStrategyTemplateRequest`, `UpdateStrategyTemplateRequest` e `StrategyTemplateStrategyRequest` seguem esse padrao.

Motivo:

- O ASP.NET Core ignora metadata de validacao definida na propriedade gerada de um record quando o valor vem do construtor primario, gerando `InvalidOperationException`.

Tradeoff:

- A anotacao fica mais explicita e menos parecida com DTOs de classe comum, mas evita falha runtime ao criar templates.

### Analytics reais no redesign premium do dashboard

Decisao atual no codigo:

- O `dashboard-ticker` foi redesenhado como Control Center e usa `/BetInsights/analyze` apenas quando a selecao manual esta completa.
- O `LoteShowcaseCard` foi redesenhado como Tactical Bet Card e usa `/BetInsights/analyze` somente para o slide ativo do carrossel.
- O IA Score visual e derivado dos campos reais de insight: frequencia media, recorrencia, sobreposicao com ultimo sorteio e sinal de combinacao vencedora ja observada.

Motivo:

- Evitar metricas simuladas em uma interface que comunica analise estatistica avancada.
- Controlar performance e trafego de rede evitando consulta historica para todas as apostas geradas ao mesmo tempo.

Tradeoff:

- A interface exibe hot/cold por dezena apenas parcialmente, porque o contrato atual do insight retorna contagens agregadas e numeros sobrepostos ao ultimo sorteio, nao frequencia individual por dezena.
- Se o produto exigir heatmap historico real por numero, o backend precisa expor frequencias por dezena no contrato de insights.

### Deploy Docker sem segredos versionados

Decisao atual no codigo:

- `docker-compose.yml` e `appsettings.json` nao carregam mais senhas, JWT key ou Google Client Secret hardcoded.
- O compose de producao usa Docker secrets por arquivo para senhas MySQL, connection strings, JWT key, senha admin e Google Client Secret.
- O `.env` de producao guarda caminhos de secrets e valores nao sensiveis, como `FRONTEND_URL` e usuario MySQL.
- `appsettings.Development.json` usa placeholders de desenvolvimento, nao credenciais reais.
- A API em producao persiste chaves de Data Protection em volume Docker dedicado.
- Frontend de producao usa `VITE_API_BASE_URL` vazio e Nginx faz proxy para os controllers do backend na mesma origem.

Motivo:

- Reduzir risco de vazamento por commit, build context Docker ou copia do projeto para EC2.
- Manter cookies HttpOnly/Secure e CORS alinhados com deploy atras de proxy reverso.

Tradeoff:

- O servidor precisa de `.env` local com caminhos e arquivos de secrets antes de `docker compose up`.
- Login em producao exige HTTPS; `http://IP` so serve para smoke limitado de pagina publica.

### Replica MySQL tambem em producao

Decisao atual no codigo:

- `docker-compose.yml` sobe `db` como master e `db-slave` como replica read-only.
- `ConnectionStrings__DefaultConnection` aponta para `db`; `ConnectionStrings__ReadOnlyConnection` aponta para `db-slave`.
- O usuario de replicacao vem de `MYSQL_REPLICATION_USER`, com default `lotojogo_replica`; a senha vem do Docker secret `mysql_replication_password`, sem senha hardcoded no script.
- Nenhuma porta MySQL e publicada no host em producao.
- O healthcheck do slave exige os threads `Replica_IO_Running` e `Replica_SQL_Running` antes da API subir.

Motivo:

- Alinhar o deploy de producao com a arquitetura de leitura read-only ja usada pelo backend.
- Evitar que consultas read-only concorram diretamente com escritas no master.

Tradeoff:

- Em volumes existentes, os scripts de init nao rodam novamente; a migracao para replica precisa de backup e procedimento manual ou recriacao controlada dos volumes.
- Segredos de replicacao ficam em Docker secrets; producao real ainda pode migrar para AWS Secrets Manager, SSM Parameter Store ou mecanismo equivalente.

### Remocao do modo HTTP no deploy

Decisao atual no codigo:

- Remover `Deployment:RequireHttps` e `Auth:AllowInsecureCookies`.
- Remover injecao de `Deployment__RequireHttps` e `Auth__AllowInsecureCookies` do compose.
- Remover diagnostico `X-Auth-Cookie-Mode`.
- Em `Production`, a API aplica redirect HTTPS e cookies `Secure`/`SameSite=Strict`.
- `.env.production.example` volta a exigir `FRONTEND_URL=https://...`.
- O Nginx interno preserva `X-Forwarded-Proto` recebido do terminador TLS externo para a API reconhecer HTTPS atras de proxy.
- Caddy foi adicionado como proxy publico em `80/443`, com TLS automatico, deixando o frontend Nginx acessivel apenas dentro da rede Compose.

Motivo:

- Evitar que o projeto mantenha um caminho de deploy publico com cookies de auth trafegando por HTTP.

Tradeoff:

- O MVP autenticado passa a exigir dominio/TLS; `http://IP` pode servir apenas para smoke de paginas publicas.
- Segredos sensiveis devem migrar para AWS Secrets Manager, SSM Parameter Store, Docker secrets ou mecanismo equivalente antes de producao real.

### Fallback de ID no frontend

Decisao atual no codigo:

- Substituir usos diretos de `crypto.randomUUID()` por `createClientId()`.
- `createClientId()` usa `crypto.randomUUID()` quando disponivel, `crypto.getRandomValues()` como fallback e `Math.random()` apenas como ultimo recurso para IDs locais de UI.

Motivo:

- Evitar tela preta em navegadores que nao exponham `crypto.randomUUID`, mantendo os IDs como identificadores efemeros de UI.

Tradeoff:

- O fallback e adequado para IDs efemeros do frontend, nao para identificadores de seguranca ou persistencia sensivel.
- Em producao HTTPS, o caminho preferencial continua sendo `crypto.randomUUID()`.

### Rate limit configuravel por ambiente

Decisao atual no codigo:

- Adicionar `RateLimitSettings` com limites configuraveis para politicas `auth` e `generate`.
- `docker-compose.yml` injeta `RateLimit__AuthPermitLimit`, `RateLimit__AuthWindowSeconds`, `RateLimit__GeneratePermitLimit` e `RateLimit__GenerateWindowSeconds`.
- Os limites podem variar por ambiente, mas a configuracao de producao deve manter valores conservadores.

Motivo:

- O limite fixo de 5 requisicoes/minuto era adequado como protecao inicial, mas agressivo demais para demonstracao por IP publico com tentativas repetidas.

Tradeoff:

- Limites maiores reduzem atrito em testes, mas tambem reduzem protecao contra abuso; em producao real manter valores conservadores.

### Universo numerico maximo alinhado ao frontend

Decisao atual no codigo:

- `SecurityLimits.MaxNumbersUniverse` passou de 60 para 100.
- A validacao de `GenerateRequest.MaxNumbers` e `StrategyOptimizationRequest.MaxNumbers` usa esse teto global.
- O frontend ja modela modalidades com universo acima de 60, incluindo [[Quina]] e [[Timemania]] com 80 e [[Lotomania]] com 100.

Motivo:

- Evitar que `/StrategyOptimizer/suggest` e `/Generate` rejeitem modalidades validas por usarem o limite de [[Mega-Sena]] como limite global.

Tradeoff:

- O teto continua global e defensivo, nao uma validacao especifica por categoria. Needs verification se o backend passar a exigir `maxNumbers` exatamente igual a modalidade selecionada.

# 2026-08-09

## Precos historicos configuraveis para apostas importadas

Decisao atual no codigo:

- A importacao historica de apostas preserva `valor` por linha e `DefaultStakeAmount` como fontes primarias de gasto real.
- Quando a aposta importada nao traz valor, o backend tenta preencher `StakeAmount` usando `HistoricalLotteryPrices:Entries`, com `Category`, `EffectiveFrom` e tabela `Prices` por quantidade de dezenas.
- A entrada mais recente com `EffectiveFrom <= data do sorteio` vence.
- A tabela de precos historicos fica vazia por padrao; precos reais devem ser adicionados por configuracao de ambiente quando confirmados.
- Para aposta historica importada sem valor e sem preco configurado, o custo permanece desconhecido em vez de cair no preco atual da modalidade.
- A resposta de importacao expõe `estimatedStakeCount` e `missingStakeCount` para a UI informar custo estimado ou ainda desconhecido.

Motivo:

- Evitar que gasto antigo seja mascarado com preco de aposta atual.
- Permitir gestao financeira por epoca sem hardcodar fatos historicos nao verificados no codigo.

Tradeoff:

- Sem tabela historica configurada, alguns gastos importados podem ficar zerados/desconhecidos no resumo ate o usuario informar `valor` ou o ambiente configurar a vigencia correta.
- A acuracia historica passa a depender da qualidade da fonte usada para preencher `HistoricalLotteryPrices`.

## Quotas historicas visiveis na UI

Decisao atual no codigo:

- O contrato `EntitlementResponse` ja expõe `PlanQuotaDto` com limites separados por plano.
- O painel de importacao historica resume o plano ativo com limite de apostas por importacao, numero de sugestoes e disponibilidade de estrategias de frequencia.
- O helper frontend `planQuotaSummary` centraliza essa frase para evitar textos divergentes entre componentes.
- Os limites de geracao tambem sao comerciais por plano e ficam dentro do teto tecnico global: Basic gera ate 2 estrategias e 10 apostas por estrategia; Pro ate 4 estrategias e 50 apostas por estrategia; Bolao ate 6 estrategias e 100 apostas por estrategia.
- `GenerateController` valida esses limites apos carregar o usuario e antes de chamar `LoteService.GenerateAsync`; `SecurityLimits` continua como limite defensivo global.
- `useStrategyBuilder` replica a mesma validacao de quota antes de abrir review/gerar para dar feedback local e evitar chamada desnecessaria ao backend.
- A mesma validacao local tambem roda ao adicionar estrategia, aplicar sugestao historica, clonar estrategia e aplicar template, considerando apostas manuais como estrategias `manual` de uma aposta cada.
- Edicoes em estrategias existentes tambem passam pela quota local; por exemplo, aumentar `bets` acima do limite do plano e recusado antes de alterar o rascunho.

Motivo:

- Tornar Free/Pro/Bolao mais compreensiveis no fluxo em que o limite afeta o usuario, em vez de aparecer apenas como erro de backend.

Tradeoff:

- Ainda nao ha tela comercial completa de comparacao de planos; o painel historico mostra apenas os limites diretamente relevantes para importacao e sugestoes.

## Importacao historica para modalidades especiais

Decisao atual no codigo:

- O importador historico aceita `trevos` para +Milionaria em TXT/CSV/XLSX e aposta manual.
- O importador historico aceita `colunas`/`columns` para Super Sete no formato de sete grupos separados por `|`, por exemplo `0|1|2|3|4|5|6`.
- Para Super Sete, o payload persiste `columns` para avaliacao de premio; a lista `numbers` serve como contagem/compatibilidade e pode conter digitos repetidos em colunas diferentes.
- O painel de importacao historica nao filtra mais +Milionaria e Super Sete.

Motivo:

- Aproximar a gestao historica de "todos os jogos", cobrindo modalidades que exigem metadados alem de dezenas numericas simples.

Tradeoff:

- O formato de Super Sete e especifico do app e precisa ser documentado para evitar confusao com dezenas tradicionais; por isso `colunas` e separado de `numeros`.

## Performance e uso de estrategias historicas

Decisao atual no codigo:

- `GET /Lotes/historical/strategy-insights` retorna `bestPerformingStrategies` e `worstPerformingStrategies`, agrupadas por `StrategyType`, com contagem, gasto, premio, resultado liquido e multiplicador de retorno.
- Quando uma estrategia geravel tem retorno historico positivo, o endpoint pode sugerir `user-best-performing-strategy`, convertendo o perfil historico para uma config valida de geracao.
- O mesmo endpoint tambem transforma a estrategia mais usada e a menos usada pelo usuario em sugestoes geraveis `user-most-used-strategy` e `user-least-used-strategy`, ignorando `manual` e `random` como tipos diretos.
- As configs geradas para esses perfis reutilizam as regras de `odd_even`, `high_low`, `fixed_number` ou `sum` conforme o tipo historico, e sao cobertas por `StrategyRequestValidator`/`StrategyCapacityCalculator` nos testes.
- O frontend exibe um resumo compacto de melhor retorno e maior prejuizo no painel de importacao historica quando esses dados existem.
- A listagem detalhada de apostas historicas exibe, quando a aposta esta expandida, acertos calculados contra o sorteio importado, ordem do sorteio, valor apostado, premio informado e liquido por aposta.
- `LoteSummaryDto` tambem expoe resumo de resultado por lote (`winningBets`, `lostBets`, `awaitingBets`, `bestHitCount`); a lista de lotes usa esses campos para mostrar apostas premiadas e melhor acerto sem abrir o lote.
- A exportacao de lotes em CSV/PDF inclui dados historicos por aposta: status de resultado, acertos, sorteio, concurso, valor apostado, premio e liquido; o PDF tambem mostra totais de gasto/premio/liquido por lote quando disponiveis.
- O projeto de testes backend referencia explicitamente `Microsoft.EntityFrameworkCore.Relational` 9.0.10 para alinhar a versao com a API e remover o warning de conflito EF durante `dotnet test`.

Motivo:

- Atender o requisito de gerar novas estrategias a partir de desempenho financeiro e de estrategias mais/menos usadas, sem deixar que jogos futuros ou estrategias manuais poluam o perfil.

Tradeoff:

- O ranking financeiro depende de `stake_amount` e `prize_amount`; historicos sem esses valores ainda entram nas frequencias e uso de estrategias, mas nao provam retorno financeiro.
# 2026-06-11

## Home pública cinematográfica por capítulos

Decisão atual no código:

- A Home pública `/` foi consolidada em seis capítulos com `HomeStory`.
- Desktop usa scroll snap obrigatório e parallax por capítulo com Framer Motion.
- Mobile usa rolagem natural com capítulos de altura mínima de viewport, evitando cortes em conteúdo longo.
- O trilho lateral mostra o capítulo ativo e permite navegação direta.
- Os componentes comerciais existentes continuam responsáveis pelo conteúdo e preservam seus IDs públicos.
- `prefers-reduced-motion` desativa movimento intenso e snap.
- Em 2026-06-19, a estrutura interna foi refatorada para separar `HomeChapter`, `ChapterRail`, `useActiveHomeChapter` e `HomeStory.types`; capítulos agora declaram `variant`, `motion` e `showCaption` explicitamente.
- Conteúdos estáticos de seções comerciais foram movidos para `data/*.data.ts`, reduzindo acoplamento entre copy, renderização e comportamento.

Motivo:

- Criar uma experiência de marca única e moderna sem duplicar conteúdo nem comprometer acessibilidade e responsividade.

Tradeoff:

- Alguns capítulos compostos ocultam cards secundários no desktop para caber na viewport; todo o conteúdo continua disponível no mobile.

## 2026-08-14 - Dashboard rapido com dados essenciais primeiro

Decisao atual no codigo:

- A primeira tela do dashboard autenticado deve depender apenas de `/Auth/me`, `/Account/entitlement`, concursos da modalidade ativa e estado local de rascunho.
- Requests normais do dashboard nao devem chamar providers externos nem agendar refresh por cache vazio/stale; eles retornam o que existe no banco/cache imediatamente.
- O refresh externo de concursos fica em thread de background (`LotterySyncHostedService`/`LotteryRefreshScheduler`) e em acao manual `forceRefresh=true`, fora do caminho critico do F5.
- `LotteryContestRepository` usa `IMemoryCache` para leituras de concursos e invalida pelo `RepositoryCache` em `SaveChangesAsync`.
- Quando existe ultimo concurso conhecido mas nao existe proximo concurso salvo, `LotterySyncService.EnsureScheduledPlaceholdersAsync` cria um proximo concurso `Provisional` com `Source = estimated:scheduler`; a API esconde datas desse placeholder ate haver dado verificado.
- DTOs de concursos aceitam `scheduledDrawDate`, `drawDateTime` e `salesCloseAt` nulos para representar "data a confirmar".
- O frontend persiste em `localStorage` o ultimo `/Auth/me`, entitlement e concursos por categoria para renderizar imediatamente apos F5 e revalidar em background.
- No seletor de concurso da criacao/configuracao de estrategias, todos os estados do dropdown usam formato unico `xxxx - DD/MM/YY`; o prefixo `Concurso` fica fora do option para evitar duplicacao visual.
- `RightConfigSideBar` deve disponibilizar Gerenciar e Admin imediatamente; a lentidao do primeiro load nao deve ser mitigada ocultando esses dados do usuario.
- `HomeTab` importa `ConfigTab` diretamente para a aba Configurar carregar imediatamente; templates de estrategia continuam sob demanda.
- Templates de estrategia nao sao buscados no mount de `useStrategyBuilder`; `useStrategyTemplates` usa React Query e só habilita ao abrir configuracao/templates ou pelo prefetch em idle.
- A lista global de concursos e a primeira pagina de lotes entram em prefetch pós-primeira tela via `requestIdleCallback` com fallback de timeout.
- `LotterySyncHostedService` respeita `LotterySync:InitialDelaySeconds` para evitar que chamadas externas de sincronizacao concorram com o primeiro dashboard após start local.

Verificacao:

- `npm.cmd run build`: `dashboardPage` final em 36,00 kB gzip e CSS inicial em 28,13 kB gzip.
- `npm.cmd run lint`: passou.
- `npm.cmd test -- --run`: 49 arquivos, 231 testes na revisao de cache-first.
- `dotnet test .\lotojogo-api.Tests\lotojogo-api.Tests.csproj`: 402 testes na revisao de cache-first.
- Docker dev recriado com `docker compose --env-file .env.development -f docker-compose.dev.yml up -d --build --force-recreate`, sem apagar volumes.

Motivo:

- Remover requests e chunks nao essenciais do carregamento inicial, especialmente Gerenciar/Lotes, Admin, templates e sync externo da Caixa, sem perder dados essenciais para gerar apostas.

Tradeoff:

- Abertura inicial de Gerenciar/Admin/Configurar pode carregar um chunk adicional na primeira visita da aba, mas a primeira tela do dashboard fica muito menor e com menos concorrencia de rede.

