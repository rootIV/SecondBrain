# Decision Log

## 2026-06-05 - Config de estrategias com schema rigido

- Decisao: manter `StrategyConfig.Config` e configs de templates como `JsonElement`, mas validar por allowlist de propriedades e tipos antes de gerar ou persistir.
- Decisao: rejeitar strings em campos numericos, propriedades extras e `numbersList` com itens nao inteiros, em vez de tentar sanitizar e aceitar payload adulterado.
- Decisao: no frontend, substituir campos numericos dos cards da Home por `NumericTextInput` (`type="text"` + `inputMode="numeric"` + filtro de digitos) para permitir campo vazio durante edicao.
- Motivo: melhorar a usabilidade dos cards e impedir que payloads HTML/SQL-like fiquem salvos como JSON bruto ou sejam interpretados como valores padrao.
- Relacionado: [[Frontend]], [[Backend]], [[DTOs]], [[Tests]].

## 2026-05-27 - Graphify como primeira fonte de contexto tecnico

- Decisao: usar Graphify primeiro para orientacao tecnica, perguntas de arquitetura, analise de impacto e relacoes entre arquivos quando `graphify-out/graph.json` existir.
- Decisao: manter Obsidian como memoria duravel para decisoes, caveats e documentacao, mas nao como primeira fonte para redescobrir estrutura de codigo.
- Decisao: depois de mudancas relevantes em codigo ou documentacao, atualizar outputs Graphify com `graphify update . --force`; para mudancas arquiteturais, regenerar tambem `graphify export callflow-html`.
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
- O agente deve iniciar buscas e edicoes pelo subprojeto relevante: `lotojogo-front-end`, `lotojogo-back-end`, `lotojogo-tests` ou vault.
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
