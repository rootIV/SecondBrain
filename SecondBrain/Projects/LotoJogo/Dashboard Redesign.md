# Dashboard Redesign

Relacionado: [[LotoJogo - MOC]], [[Frontend]], [[Architecture]], [[Auth]], [[LotteryStrategies]], [[Decision Log]], [[Known Issues]].

## Direcao aprovada

O redesign do dashboard deve seguir a direcao **Tactical Intelligence Dark**, combinando:

- **A. Mais operacional e denso**: priorizar uso repetido, leitura rapida de estado, configuracao de estrategias e gerenciamento de lotes sem ocupar a primeira dobra com elementos editoriais.
- **C. Fluxo mais guiado**: deixar claro o percurso `categoria -> estrategias -> revisao -> lote -> historico`, sem transformar o dashboard em uma landing page.

Marca e logo entram como ancora global no `TopNav`, mas nao devem disputar espaco com o trabalho principal do usuario.

## Principios visuais

- Manter tema dark premium com glass morphism controlado, superficies translúcidas, grade sutil e linguagem de fintech/trading quantitativo.
- Usar a paleta tática como tokens globais:
  - `--color-bg-base: #0A0C10`
  - `--color-bg-surface: #111318`
  - `--color-bg-glass: rgba(255,255,255,0.04)`
  - `--color-accent-primary: #6C63FF`
  - `--color-accent-hot: #FF6B6B`
  - `--color-accent-cold: #4ECDC4`
  - `--color-accent-gold: #FFD166`
  - `--color-text-primary: #F0F2F5`
  - `--color-text-muted: #8892A4`
  - `--color-border: rgba(255,255,255,0.08)`
- Preservar compatibilidade com tema claro usando overrides em `[data-theme="light"]`.
- Evitar hero grande dentro da dashboard. A tela inicial autenticada deve ser a ferramenta, nao marketing.
- Usar tipografia por funcao: display para marca, UI para controles, monospace para dezenas, custo e indicadores.

## Arquitetura de layout alvo

```text
TopNav fixo
  esquerda: hamburger + CategoryDrawer
  centro: logo LotoJogo
  direita: usuario, avatar, preferencias e perfil

Dashboard operacional
  control center compacto
  selecao de dezenas
  painel de estrategias/revisao
  lote atual / carrossel de apostas
  gerenciamento e historico

Footer global compacto
  branding, navegacao, informacoes, aviso de jogo responsavel
```

Em desktop, o dashboard deve favorecer duas ou tres regioes escaneaveis. Em mobile/tablet, o fluxo deve empilhar na ordem operacional: perfil/status curto, estrategias/revisao, volante, lote atual e gerenciamento.

## Componentes planejados

### `TopNav`

Novo componente global em `src/components/layout/TopNav`.

- Deve substituir a dependencia visual da `LeftSideBar` fixa como ponto de orientacao.
- O hamburger abre `CategoryDrawer` com categorias vindas de `domain/lottery/categories.ts`.
- A categoria ativa recebe destaque com `accent-primary`.
- O centro exibe logo `LotoJogo`; clique deve navegar para a rota real do dashboard.
- A zona direita usa `useUser` para nome/email e oferece dropdown com perfil, alternar tema e sair.
- Em mobile, ocultar saudacao textual e manter hamburger, logo e avatar.

### `CategoryDrawer`

Novo componente em `src/components/layout/CategoryDrawer`.

- Lista categorias de loteria, nome, indicador ativo e badge de lotes ativos quando houver dado disponivel.
- O backdrop fecha no clique externo.
- O link "historico de sorteios" pode entrar como atalho futuro. Needs verification: rota de historico ainda nao foi confirmada.

### `ProfilePage`

Nova pagina em `src/pages/ProfilePage`.

- MVP visual pode consumir apenas `/Auth/me`.
- Dados pessoais, preferencias e seguranca devem ser seções separadas.
- Edição real de nome, foto, senha ou exclusao de conta depende de novos endpoints backend. Needs verification antes da implementacao completa.
- A rota desejada pode ser `/profile`; o roteamento atual ainda usa `/dashboardPage`, `/loginPage` e `/registerPage`.

### `MainCard`

Redesign incremental do card principal existente.

- Manter seleção de dezenas e regras atuais.
- Adicionar chips animados, contador animado e borda gradiente sutil.
- Categorias como tabs horizontais podem substituir gradualmente a `LeftSideBar` em telas largas, mas a fonte de dados continua `lotteryCategories`.
- Não mudar a regra de limite de dezenas ou o contrato de aposta manual.

### `StrategyCard`

O redesign deve aproveitar os minicards existentes em `components/ui/StrategyCards/miniCards`.

- Ícones por tipo de estratégia.
- Badge de custo estimado.
- Collapse/expand suave.
- Estado otimizado com selo dourado quando `/StrategyOptimizer/suggest` preencher campos.
- Drag-to-reorder é desejável, mas deve preservar `sort_order`/ordem local usada por templates e geração.

### `LoteShowcaseCard`

Manter o papel de Tactical Bet Card.

- Swipe no carrossel e dots animados.
- IA Score deve continuar derivado de dados reais de `/BetInsights/analyze`, sem métricas simuladas.
- Hot/cold por dezena só deve ser mostrado como preciso quando o backend expuser frequencia individual por número.
- Copiar apostas para clipboard pode entrar como ação rápida, com toast.

### `DashboardTicker`

O ticker deve virar um Control Center mais compacto.

- Indicadores principais: missão, progresso, custo, status e analytics.
- Contadores podem animar, mas a informação deve continuar objetiva.
- Tooltips devem explicar dados estatísticos sem prometer resultado.

### `LoteListItem` e `BetRow`

- `LoteListItem`: compactar custo, status e ações, com reveal no hover.
- `BetRow`: manter expansão de `Analise`, melhorar badges sem aumentar demais a altura.
- A interação de selecionar aposta para o `MainCard` não deve ser quebrada.

### `Footer`

Novo footer global compacto.

- Links internos para dashboard, perfil e informações.
- Aviso de jogo responsável.
- Uma coluna em mobile.
- Não deve aparecer como bloco pesado dentro do fluxo principal da dashboard.

## Motion

- Adotar `framer-motion` depois de instalar a dependência.
- Entradas: `0.35s` a `0.4s`, `easeOut`, com stagger pequeno.
- Saídas: `0.2s`, `opacity: 0`, deslocamento curto.
- Usar `AnimatePresence` em drawer, dropdown, modais, page transitions e collapses.
- Usar animação com parcimônia em surfaces densas; o dashboard deve parecer responsivo, não teatral.

## Fases recomendadas

1. **Base global**: instalar `framer-motion`, ajustar tokens, criar `TopNav`, `CategoryDrawer`, rota `/profile` MVP e page transitions. Implementado em 2026-05-25 no frontend.
2. **Fluxo guiado**: reorganizar dashboard para explicitar categorias, estrategias, revisao e lote atual sem mudar lógica de geração.
3. **Cards operacionais**: refinar `MainCard`, `DashboardTicker`, `StrategyCard`, `LoteShowcaseCard`, `BetRow` e `LoteListItem`.
4. **Perfil e footer**: completar `ProfilePage` visual, footer global e rotas auxiliares.
5. **Backend de perfil**: se o produto exigir edição real, adicionar endpoints de atualização de perfil, senha/foto e exclusão de conta.

## Regras de implementacao

- Preservar `useDashboardState`, `useStrategyBuilder`, React Query hooks e services.
- Não simular analytics financeiros/estatísticos.
- Não trocar SCSS global por CSS modules nesta iniciativa.
- Não migrar lógica de geração para componentes visuais.
- Validar em 320px, 640px, 1024px e 1200px.
- Executar `npm run build` depois das mudanças frontend; `npm run lint` se o estado atual permitir.

## Caveats

- O dashboard atual está roteado como `/dashboardPage`; a spec fala em dashboard global, mas a URL final precisa ser decidida.
- `/Auth/me` existe; CRUD de perfil ainda não foi confirmado no backend.
- Frequência hot/cold por dezena depende de contrato backend futuro.

## Implementação 2026-08-12

- Dashboard aplicado diretamente em `/dashboard` e `/dashboardPage` como shell SaaS Ops/Tactical Intelligence, preservando `useDashboardState`, `useStrategyBuilder`, hooks React Query e contratos existentes.
- A dashboard foi travada em dark premium mesmo quando o tema global está light, para manter fidelidade ao mock aprovado.
- Mobile segue a ordem aprovada: status/perfil, inteligência/estratégias, volante, lote atual e gerenciamento.
- Footer global fica visivel no fim da dashboard operacional, alinhado ao shell SaaS Ops; a pagina desktop deve rolar para expor o rodape sem cortar o layout principal.
- Validação visual automatizada em preview local com API mockada nos breakpoints 320, 390, 640, 1024, 1440 e 3840 px confirmou `scrollWidth == clientWidth` e nenhum elemento com overflow horizontal.
- Verificações finais executadas no frontend: `npm run build`, `npm run lint`, `npm test -- MainCard BetRow LoteListItem useStrategyBuilder planQuotaSummary`, `git diff --check`.

## Ajuste operacional 2026-08-13

- `CategoryDrawer` e `LeftSideBar` foram removidos do frontend porque o novo shell usa `TopNav` e categorias dentro do `MainCard`.
- `DashboardSaasOpsPanel` passou a ser renderizado dentro do `MainCard`, logo abaixo do `dashboard-card__header`; a coluna direita fica dedicada ao `RightConfigSideBar`.
- O `MainCard` passou a abrir o volante manual apenas por CTA explicito `Adicionar aposta manual`; no estado inicial, `dashboard-card__selection-panel` e `dashboard-card__betting-shell` nao sao renderizados.
- No modo manual, o `dashboard-card__header` fica oculto e o `card-actions` mostra apenas `Selecionar categoria`, que retorna ao estado inicial sem alterar contratos de geracao, lote ou estrategia.
- A camada final SaaS Ops foi estendida para estados secundarios da dashboard: filtros/lista/detalhe de lote, importacao historica/admin, lixeira, confirmacoes, templates e combinacoes avancadas.
- A importacao historica de apostas do usuario fica em view dedicada dentro de `ManageTab`, aberta por CTA na lista de lotes e fechada por botao `X`; a aba `Configurar` fica bloqueada enquanto nao houver estrategia adicionada.
- Verificacoes executadas no frontend: `npm.cmd run build`, `npm.cmd run lint`, `npm.cmd test -- MainCard BetRow LoteListItem useStrategyBuilder planQuotaSummary`, `git diff --check`.

## Versao clara 2026-08-13

- A dashboard passou a usar uma versao branca como visual padrao em `:root:not([data-theme="dark"])`, com tokens `--dashboard-*` claros para fundo, surfaces, bordas, texto, scrim e sombras.
- A direcao Tactical Intelligence Dark continua preservada em `:root[data-theme="dark"] .dashboard`, sem alterar contratos React, hooks, geracao, estrategia, lote ou importacao.
- A separacao visual no tema claro depende de borda sutil e `--dashboard-shadow`/`--dashboard-shadow-soft`; no tema dark esses tokens ficam `none`.
- Ajuste posterior no tema dark removeu vestigios do primario antigo rosa/roxo em inputs, botoes, `MainCard`, `LoteListItem`, filtros/lista/detalhe de lote, lixeira, seções de categoria/estrategia e importacoes, usando overrides finais escopados por `.dashboard` e tokens `--dashboard-*`.
 
## Ajuste visual 2026-08-13

- `dashboard-current-lote` saiu da composicao principal de `DashboardMain`, mas `LoteShowcaseCard` e os estilos `.dashboard-current-lote*` foram preservados para reaproveitamento futuro; o espaco restante fica com `dashboard-card dashboard-card--category-mode`.
- Nova limpeza de tema dark cobriu `quick-generation-review__header-actions`, `mini-card-input`, `strategy-section__bets`, `BetRow`, `dashboard-card__header` e `card-actions`, mantendo a paleta SaaS Ops por tokens sem mudar contratos de geracao/lote/estrategia.
- Ajuste posterior removeu fundo/rosa do bloco `dashboard-card__category-balloons`, deixou `strategy-creation-panel` neutro no estado base, corrigiu visibilidade do `strategy-defaults-trigger` via overflow/z-index e passou a preservar `drawDateTime` no draft para o control center renderizar proximo sorteio como `DD/MM/YY, HH:MM`.
- A paleta da dashboard deixou de usar roxo como acento principal: `--dashboard-primary` no dark passou para azul frio `#38bdf8` e os pontos visiveis com gradiente/borda rosa-roxo herdados do `MainCard`/`RightConfigSideBar` foram neutralizados por overrides finais escopados em `.dashboard`.
- O seletor de concurso da aba de estrategias usa formato unico `3762 - 14/08/26` tanto no item fechado quanto nas opcoes; nao deve haver overlay visual separado nem prefixo `Concurso` dentro do dropdown.
- `HomeTab` importa `ConfigTab` diretamente para a aba Configurar aparecer imediatamente; templates continuam carregando sob demanda quando configuracao/templates sao usados.

## Shell Linear-like 2026-08-27

- A dashboard autenticada passou a seguir uma direcao mais proxima de app operacional tipo Linear: rail esquerdo fixo, fila central de trabalho por grupos e painel direito contextual.
- `TopNav` e `Footer` nao fazem mais parte da experiencia autenticada da dashboard; a navegacao principal fica no rail e a tela deve parecer ferramenta de trabalho, nao pagina editorial.
- A superficie central prioriza `DashboardWorkQueue`, que transforma rascunhos manuais, status de estrategia, lote da sessao e historico real de lotes em linhas operacionais compactas.
- `RightConfigSideBar` continua sendo o painel funcional de geracao/configuracao/gerenciamento, preservando contratos existentes de `useDashboardState`, `useStrategyBuilder`, React Query e services.
- `DashboardSaasOpsPanel` saiu da composicao da landing autenticada da dashboard para reduzir cara de mockup/CRM generico; o `MainCard` permanece como ferramenta de volante e rascunho manual.
- O dark passa a ser seco e utilitario neste shell: menos brilho, menos glass, menos bordas chamativas, com roxo apenas como acento de selecao.
- Validacoes executadas no frontend: `npm.cmd test`, `npm.cmd run lint`, `npm.cmd run build` e Playwright em `1440x920` e `390x844` com API mockada. Resultado: sem overflow horizontal, sem `TopNav`, sem footer, sem loading preso e sem erros novos no console.

## Harmonizacao de superficies 2026-08-27

- `dashboardOperationalShell.scss` passou a ser a camada final importada por `dashboardPage.tsx` para governar `dashboard-main`, `right-config` e dependentes visuais conectados.
- A regra duravel e manter o shell autenticado sem glass/blur/sombra ornamental: `RightConfigSideBar`, `MainCard`, criacao/revisao de estrategias, gerenciar lotes, detalhe, linhas de aposta, lixeira, importacao historica e admin devem herdar surfaces neutras, bordas discretas e raio maximo de 8-10px.
- Selecoes ativas e CTAs primarios usam o acento roxo `#a582ff`; azul/ciano fica reservado a estados informativos ou legados que ainda nao foram revisitados.
- Tabs do painel direito ficam icon-only no visual, com `aria-label`/`title` preservando significado; isso evita texto truncado em largura estreita.
- Validacoes executadas no frontend: `npm.cmd test`, `npm.cmd run lint`, `npm.cmd run build` e Playwright em `1440x920` e `390x844` com API mockada. Resultado: sem overflow horizontal, sem `TopNav`, sem footer, sem loading preso, sem erros novos no console e sem blur computado em `right-config`/`dashboard-card`.

## Ajuste de continuidade visual 2026-08-27

- O shell Linear-like deve preencher o viewport inteiro em desktop: `.dashboard-layout` usa `100vh`, `dashboard-main-area` ocupa a linha restante abaixo do control center e `right-config-area`/`right-config` esticam ate o fundo.
- O rail esquerdo ganhou atalho direto para `/financeiro` logo abaixo de `Recarregar` e alternancia de tema entre usuario e `Sair`.
- A camada final tambem cobre os controles que ainda herdavam a pele antiga: `strategy-defaults-popover`, paginacao de estrategia, seletor de algoritmo, hover de `card-button__info`, acoes de lote, tabs do detalhe, grupos por dezenas, filtros do detalhe e botao de exclusao.
- Validacao visual via Chrome/CDP com API mockada em `1440x920` e `390x844`: sem tela de loading presa, sem overflow horizontal, sem erros de console, `Financeiro` e botao de tema visiveis, e no desktop `dashboard-main-area`, `right-config` e `right-config-area` fechando no bottom do viewport.

## Abas operacionais 2026-08-27

- `dashboard-content` foi removido do shell e do componente `DashboardMain`; o centro da dashboard fica dedicado a `DashboardWorkQueue` ate que o volante/manual seja reposicionado.
- `RightConfigSideBar` passou a ter header contextual por aba (`Gerar`, `Configurar`, `Gerenciar`, `Admin`, `Recarregar`) com descricao curta e metricas reais de modalidade, estrategias e lotes novos.
- A camada final de `dashboardOperationalShell.scss` governa tambem `config-tab`, `manage-tab`, `admin-tab`, headers internos, importacao admin e historico operacional para manter o padrao Linear-like escuro, denso e sem glass ornamental.
- Validacao visual via Chrome/CDP com role Admin mockada em `1440x920` e `390x844`: sem `.dashboard-content` no DOM, sem overflow horizontal, sem erros no console, e abas `Gerar`, `Gerenciar` e `Admin` renderizando com o novo header.

## Distill do painel direito 2026-08-27

- O header contextual extra do `RightConfigSideBar` foi revertido: a direcao correta nao e adicionar mais um bloco explicativo, e sim destilar as abas existentes para uma leitura operacional densa.
- `dashboard-content` continua removido; somente esse elemento estrutural removido deve permanecer fora do shell enquanto o volante/manual aguarda novo destino.
- A regra visual duravel para `right-config` e suas abas internas e estilo de gerenciador SaaS denso: superficies planas, divisorias de lista, controles compactos, raios pequenos, sem glass/blur/sombra ornamental e sem estados vazios com cara de card placeholder.
- A camada final deve cobrir `strategy-pagination.quick-generation-review__pagination` com largura estavel e botoes fixos, e manter `admin-tab__history` com altura propria/overflow visivel para nao ser cortado dentro da aba Admin.
- Validacao executada no frontend: `npm.cmd run lint`, `npm.cmd test`, `npm.cmd run build`, `git diff --check` e Chrome/CDP em `1440x920` e `390x844`. Resultado: sem loading, sem overflow horizontal, sem `.dashboard-content`, `right-config` ate o fundo, botao de tema e Financeiro visiveis, e `admin-tab__history` renderizando.

## Distill de acoes e lotes 2026-08-27

- A aba Admin deve ficar focada em administracao de sorteios; o bloco `Histórico operacional`/`ManageTab` foi removido dela para evitar duplicacao com a aba Gerenciar.
- `QuickGenerationReview` nao deve bloquear `Estratégias Salvas` por scope/concurso antigo. `Limpar Estratégias` fica disponivel quando houver rascunho no scope visivel, e tenta ativar esse scope antes da confirmacao para limpar o alvo correto.
- `strategy-pagination.quick-generation-review__pagination` deve ser uma linha compacta acima do CTA de configurar estrategias, nao um controle largo com cara de card.
- `contest-scope-filter__field` nao deve ter fundo proprio; apenas os selects internos carregam superficie de controle.
- `lote-list-item` segue o padrao de lista densa: sem card, sem gradiente, chips sem pill, acoes icon-only e custo alinhado a direita.
- Validacao executada no frontend: `npm.cmd run lint`, `npm.cmd test` com 237 testes, `npm.cmd run build`, `git diff --check` e Chrome/CDP em `1440x920`/`390x844`.

## Distill de review, configurar e gerenciar 2026-08-27

- A limpeza de estrategias do review rapido deve limpar o scope visivel via `clearStrategiesForScope(scopeKey, categoryName)`, incluindo manual bets e erros desse scope; isso evita prender o usuario em estrategias antigas de concurso anterior.
- A confirmacao de limpeza usa dialog compacto dentro do fluxo do painel direito e deve permanecer funcional: abrir ao clicar `Limpar Estratégias`, limpar ao confirmar e fechar sem deixar drafts no localStorage.
- A aba `Configurar` nao exibe mais categoria nem concurso no header; esse escopo fica concentrado na aba `Gerar`, enquanto `Configurar` prioriza busca, paginacao e cards de estrategias.
- `strategy-card`, `strategy-draft-search`, `lote-list__header`, `lote-list-item` e `category-section__dozen-groups` seguem o padrao de lista operacional densa: divisorias, botoes icon-only, campos compactos, sem gradiente, glass ou card ornamental.
- `strategy-pagination.quick-generation-review__pagination` segue o modelo pagina-anterior/paginas/proxima em uma linha de 38px acima do CTA de configurar estrategias, com pagina ativa em roxo e overflow horizontal zero.
- Validacao executada no frontend: `npm.cmd run lint`, `npm.cmd test` com 237 testes, `npm.cmd run build`, `git diff --check` e Chrome/CDP em `1440x920`/`390x844`. Resultado: cards presentes antes da limpeza, categoria/concurso removidos da aba Configurar, limpeza persistida com `afterClearCount = 0`, paginação com altura estavel, sem overflow horizontal e console sem erros.

## Ajuste final do painel Gerar 2026-08-28

- O CTA `Configurar Estratégias` da aba Gerar deve ficar colado ao fundo do painel direito em desktop; a paginação do review rapido fica imediatamente acima dele, aparece somente quando ha mais de uma pagina e nao possui borda/barra superior.
- `quick-generation-review__category`, `right-config__tabs`, `add-strategy-button`, `generate-button`, `strategy-templates-view` e `generation-success-overlay` foram neutralizados para seguir o visual Linear-like: superficies planas, bordas discretas, sem sublinhado ornamental, sem gradiente e sem glass.
- `DashboardWorkQueue` agora recebe `draftScopeSummaries` e lista uma linha em `Prontos para gerar` por categoria com estrategia configurada; quando as estrategias validam sem erro, o status mostrado e `Pronto para gerar` em verde, mantendo a linha como item operacional denso.
- Lotes com `date === localDateKey` permanecem no grupo `Gerados` ate virar o proximo dia; lotes anteriores entram em `Histórico`. Lotes com sinais operacionais (`trashedCount`, premios, perdas, aguardando ou melhor acerto) aparecem como `Modificado`.
- Validacao executada no frontend: `npm.cmd run lint`, `npm.cmd test` com 239 testes, `npm.cmd run build`, `git diff --check` e Chrome/CDP em `1440x920`/`390x844`. Resultado: overview com 3 categorias sem paginação, paginação de detalhe com 38px sem borda superior, CTA no fundo em desktop, templates neutros, limpeza persistida e sem overflow horizontal.

## Separacao de colunas da fila 2026-08-28

- `DashboardWorkQueue` deve separar `apostas` e `valor` em campos proprios para linhas de `Gerados` e `Histórico`; nao usar `·`, barra ou outro separador textual para simular coluna.
- A separacao visual da fila usa espaco entre grupos e colunas, nao barras adicionais. `dashboard-work-queue__groups` pode ter `gap`, enquanto as linhas mantem densidade operacional.
- Headers/campos do painel direito que pareciam cards antigos nao devem ter borda inferior ornamental: `strategy-creation-panel__topline`, `strategy-creation-panel__scope`, `strategy-creation-panel__field--algorithm`, `strategy-card__header` e `lote-list__header`.
- Validacao executada no frontend: `npm.cmd run lint`, `npm.cmd test` com 239 testes, `npm.cmd run build`, `git diff --check` e Chrome/CDP em `1440x920`/`390x844` sem overflow horizontal.

## Regua de colunas da fila 2026-08-28

- `DashboardWorkQueue` usa uma linha `dashboard-work-queue__column-header` por grupo preenchido para explicitar categorias de leitura sem barras: Categoria, Status/Lote, Estrategias/apostas ou Apostas/Valor, Estado e Concurso.
- As linhas `dashboard-work-row`, incluindo `dashboard-work-row--info`, compartilham a mesma variavel CSS `--dashboard-work-row-columns` do header; o botao de acao tem largura reservada por `--dashboard-work-action-width`, evitando sobra vazia ou colisao com o status.
- Em desktop com painel direito aberto, a regua foi validada com 3 linhas prontas por categoria em 1440x920: cada linha central mediu 796px, conteudo 696px, acao 78px, gap 12px e sem overflow horizontal.
- Ajuste posterior separou `Estrategias` e `Apostas` em colunas proprias tambem para `Prontos para gerar`; linhas prontas nao devem renderizar celula de `Valor` vazia. `Valor` e `Concurso` ficam alinhados a esquerda sob seus headers para manter a leitura de tabela compacta.

## Ajuste de gerados e review rapido 2026-08-28

- O grupo `Gerados` deve preencher colunas reais: `Apostas` recebe apenas a quantidade de apostas e `Valor` recebe o custo formatado. O lote gerado na sessao calcula o valor a partir de `loteBetGroups` e `getLotteryBetPrice`.
- Regeneracao de aposta dentro de um lote gerado na sessao marca o lote como `Editado` na fila central. Marcacao/bloqueio continuam atualizando o lote, mas a fila reserva `Editado` para regeneracao explicita.
- `Limpar Estrategias` no review rapido e uma acao global: limpa estrategias, selecoes de estrategia, defaults, erros e apostas manuais de todos os scopes/categorias, nao apenas o scope aberto.
- O perfil visual final remove `quick-generation-review__metrics`, elimina borda do icone de `generation-success-overlay`, neutraliza `strategy-defaults-popover` e `strategy-optimization-overlay`, e restaura labels visiveis para Importar/Exportar no `lote-list`.
- Validacao executada no frontend: `npm.cmd test -- DashboardWorkQueue`, `npm.cmd test -- QuickGenerationReview`, `npm.cmd run lint` e `npm.cmd run build`. QA visual autenticado via Playwright nao fechou porque a API local `https://127.0.0.1:7178/Auth/me` estava recusando conexao e a rota redirecionou para `/login`.

## Entrada por categorias na aba Gerar 2026-09-05

- `dashboard-manual-workspace` e o `DashboardMain` foram retirados da composicao atual da dashboard; o centro permanece dedicado a `DashboardWorkQueue` enquanto o fluxo manual aguarda o novo destino.
- A secao antes rotulada `Review rapido` passa a se chamar `Configurar` e sempre abre pela lista das categorias que possuem rascunhos reais, inclusive quando existe apenas uma categoria. As rows de estrategias so aparecem depois que o usuario escolhe o mini card da categoria.
- O CTA `Configurar Estrategias` foi removido do rodape da aba Gerar. A navegacao para Configurar continua pelas abas, rail e rows de estrategia.
- `quick-generation-review__category` e uma excecao intencional ao perfil totalmente plano: usa glass cinza muito discreto, borda neutra, blur curto e sem gradientes ou brilho ornamental.
- A composicao do mini card de categoria usa duas faixas compactas: identidade com icone, nome e origem mais contador de apostas no topo; estrategias e concursos no rodape. Nao usar neon, glow externo ou ilustracao decorativa de fundo.
- `dashboard-main-area` usa scrollbar fina nas cores neutras do shell e oculta os botoes de seta nativos no Chromium/WebKit.
- Validacao: lint e build passaram; teste dirigido do `QuickGenerationReview` passou com 2 casos; QA Playwright passou em 36 screenshots, temas claro/escuro e larguras de 320 a 1440px, sem overflow ou erros de console. A suite Vitest completa teve 244/245 testes verdes e manteve uma falha preexistente em `App.routes.test.ts`, cujo texto esperado nao acompanha a formatacao multiline atual de `FinanceiroPage` em `App.tsx`.

## Limites e atalhos do painel Gerar 2026-09-07

- O quarto indicador do `DashboardControlCenter` agora e `Limites`, calculado no escopo ativo por `maxStrategiesPerGeneration - strategyCount` e `maxBetsPerStrategy - maxConfiguredBetsPerStrategy`, ambos limitados a zero. O contrato atual nao fornece uma cota temporal/global de geracoes; o texto comunica o saldo do escopo.
- O trigger de padroes da estrategia mostra o icone de engrenagem seguido da label `Configurar`, preservando o nome acessivel `Configurar padrões da estratégia`.
- Os atalhos `Aposta manual` e `Calendário` pertencem a `strategy-creation-panel__scope`, logo abaixo do proximo sorteio do `ContestScopeFilter`.
- Verificacao: teste dirigido de `DashboardControlCenter`, `npm.cmd run lint`, `npm.cmd run build`, `git diff --check` e QA visual autenticado em `http://localhost:5173/dashboard`.

## Refinamento do popover de padroes 2026-09-07

- `Limites` deve renderizar duas linhas puras: estrategias restantes na primeira e geracoes restantes na segunda, sem subtitulo auxiliar.
- Ao abrir `strategy-defaults-trigger`, `strategy-creation-panel__scope` troca o filtro/atalhos pelo `strategy-defaults-popover` inline; o popover deixa de funcionar como overlay absoluto e o cabecalho fica sem fundo proprio.
- O atalho do review rapido para templates passa a usar a copy `Carregar/Salvar Estratégias`.
- Verificacao: testes dirigidos de `DashboardControlCenter` e `QuickGenerationReview`, `npm.cmd run lint`, `git diff --check` e QA visual em `http://localhost:5173/dashboard`. `npm.cmd run build` ficou bloqueado por alteracao preexistente em `ManualBetEditor.test.tsx` (`onSelectedLimitChange` fora do contrato atual de props).

## Dashboard mobile por tarefas — 2026-09-18

- Abaixo de 901 px, a direção é menor densidade e uma função principal por tela. A direção operacional densa permanece no desktop. Destinos inferiores: Início, Jogos, Financeiro e Conta; tarefas em `?tela=...`, com `?aba=financeiro` compatível.
- `DashboardPage` mantém o estado compartilhado; `HomeTab`, editor manual e `ManageTab` permanecem montados quando ocultos. O detalhe/importação conserva sua árvore ao alternar destinos. Portais e bloqueio visual de overlays dependem do painel ativo.
- Navegação retoma a última tela por destino, preserva rolagem e foca o título. Voltar usa histórico interno ou pai no acesso direto. Rascunhos ainda não confirmados não ganham persistência após reload: a garantia nova cobre navegação na sessão.
- Financeiro mantém uma instância do hook, período selecionado, orçamento/análises expansíveis e agenda/lançamentos em tela separada; erro inicial oferece retry. Estilos mobile mapeiam os tokens financeiros ao shell neutro para evitar contraste inadequado.
- Verificação: lint, 273 testes em 57 arquivos, build e diff check; Chromium com API simulada em 77 combinações de telas/larguras de 320 a 1440 px, além de paisagem 844 px. Fluxos manual e geração, histórico, continuidade de seleções/grupos, tema, erro/retry e vazio. Teclado validado por redução da viewport; falta validação física Android/iOS.
- Detalhes e evidências reproduzíveis no repositório atual `C:\Projetcts\Lotojogo\lotojogo`: `docs/dashboard-mobile.md` e `output/playwright/`. Sem dependências novas nem migração nativa. Alterações da tarefa simultânea de assinatura preservadas.

## Calendário histórico para apostas manuais — 2026-09-28

- O seletor de concursos da geração lista datas em ordem decrescente, mas `getNextAvailableContest` continua escolhendo cronologicamente o próximo concurso; ordem visual e seleção automática são contratos distintos.
- Um clique em um dia do calendário consulta `GET /LotteryContests?category=...&date=YYYY-MM-DD`. Quando existe concurso compatível, o fluxo abre diretamente o editor manual e mostra a data à esquerda da configuração de dezenas.
- Concursos antigos aceitam somente apostas manuais. O vínculo usa `onAssignManualDraftToContest`, preserva estratégias fora do concurso apurado e grava a aposta em `Categoria::numero-do-concurso`.
- Em telas a partir de 1920 px, `strategy-creation-panel__field--algorithm` fica limitado a 360 px. O estado vazio de `quick-generation-review` não usa borda inferior.
- Verificação: 281 testes de frontend, lint, build, 434 testes de backend e Playwright em 2560x1440. O fluxo simulado salvou a aposta histórica em `Lotofácil::2997`, sem overflow horizontal.

## Consolidação do centro de controle — 2026-09-28

- O `DashboardControlCenter` consolida o número do próximo concurso no rótulo `Próximo Sorteio: Concurso N`, sem status `Concurso aberto`; a data e hora permanecem como valor sem negrito.
- A combinação anterior usa o rótulo `Combinação Concurso N - DD/MM/AA` e mantém somente a grade de dezenas centralizada no conteúdo. Os indicadores financeiros usam `Maior Prêmio:` e `Prêmio Total Acumulado:` e não exibem subtítulos auxiliares.
- O seletor `strategy-algorithm-select` e o botão `Adicionar` compartilham a mesma linha, com o botão imediatamente à direita. Em telas a partir de 1920 px, a linha inteira fica limitada a 472 px e o select a aproximadamente 350 px; a seta usa cinza neutro também no foco.
- Verificação: 281 testes, lint, build, `git diff --check` e QA visual autenticado em 1440 px e 2560x1440. Em 2560 px, não houve overflow horizontal e a seta calculada ficou em `rgb(136, 146, 164)`.

## Dimensionamento responsivo do controle e da criação — 2026-09-28

- O `DashboardControlCenter` usa Flexbox com bases por conteúdo: categoria cresce com o nome, próximo sorteio e valores financeiros podem encolher com elipse em uma linha, e a combinação recebe uma base calculada pela quantidade de colunas de dezenas.
- Entre 901 e 1180 px, os cinco indicadores ocupam duas faixas dentro dos mesmos 88 px: categoria/próximo sorteio na primeira e combinação/prêmios na segunda. Nenhum indicador é ocultado e não há overflow horizontal.
- Nome da categoria e grade de dezenas ficam alinhados à esquerda no mesmo eixo dos demais valores. A grade mantém largura explícita calculada pelas colunas para impedir o colapso dos números durante o flex-shrink.
- `contest-scope-filter` e `generation-mode-actions` compartilham duas colunas iguais a partir de 521 px. A linha Algoritmo/Adicionar usa proporção `1fr / 0.5fr`, ocupa toda a largura disponível e mantém select e botão com 36 px de altura.
- `Configurar` pertence ao cabeçalho de Algoritmo. `Gerar Apostas` também aparece no modo Gerar, ancorado ao fundo do painel com divisor superior, e abre a revisão na aba Configurar. O estado `strategy-templates-view__empty` usa `--dashboard-muted`, sem o mauve do token de superfície.
- O limite anterior de 472 px para a linha de algoritmo em 4K foi removido; a divisão proporcional impede que o select domine o painel e entrega o espaço restante ao botão `Adicionar`.
- A grade de dezenas usa chave composta por número e posição para permanecer estável mesmo diante de dados externos repetidos; o console autenticado ficou sem erros após recarregar.
- Verificação: lint, 281 testes, build e QA autenticado em 1024x900, 1440x900 e 2560x1440. Categoria/Concurso e Aposta manual/Calendário mediram larguras idênticas; input e Adicionar mediram 36 px de altura; CTA ficou no rodapé com borda superior de 1 px.

## Transição acessível e alinhamento da categoria — 2026-09-28

- `prefers-reduced-motion` não deve eliminar por completo a troca visual do ticker: nesse modo, a transição usa somente opacidade por 160 ms; o modo normal preserva o deslocamento vertical por 340 ms.
- O nome da categoria precisa neutralizar a altura herdada com `height: auto` e usar `align-self: center`; caso contrário, o texto ocupa toda a altura do conteúdo e fica visualmente preso ao topo enquanto o ícone permanece centralizado.
- Verificação: teste de contrato dirigido e navegador autenticado com redução de movimento ativa. A rotação mudou de `Super Sete` para `Timemania`, apresentou opacidade intermediária sem transformação e o centro vertical entre nome e ícone teve diferença de 0 px.

## Régua segmentada e largura por conteúdo — 2026-09-29

- Os quatro campos simples participam igualmente da distribuição horizontal (`flex-grow: 1`), com bases próximas por conteúdo: Categoria 160 px, Próximo Sorteio 168 px, Maior Prêmio 144 px e Acumulado 168 px. `Combinação` usa `flex-grow: 1.25`, base mínima calculada entre 200 e 276 px conforme as colunas e é o campo que mais cresce em telas largas.
- A combinação sorteada usa uma régua única com segmentos de 20 × 18 px, fonte tabular de 10 px, divisores de 1 px, padding simétrico, borda externa única e raio de 6 px. Até 10 dezenas ficam em uma linha; de 11 a 20 usam duas linhas balanceadas e preservam a ordem original.
- O cálculo reserva 58 px além da régua para ícone, gap, padding e divisor do indicador. Esse valor evita que a grade de 10 colunas perca 1 px no shell final: a régua mede 213 px e mantém inset de 2 px em ambas as extremidades.
- Entre 901 e 1180 px, o centro continua em duas faixas e usa 136 px de altura. Categoria/Próximo Sorteio dividem a primeira faixa igualmente; na segunda, Combinação preserva sua largura calculada e os dois campos financeiros usam base zero para compartilhar todo o espaço restante sem criar uma terceira linha.
- O estado vazio, `role="list"`/`role="listitem"`, `aria-label` e as transições normal/reduzida permanecem preservados.
- Verificação: 16 testes dirigidos passaram; lint, build, `git diff --check` e detector de layout do Impeccable passaram. O componente React real foi medido em 1024, 1440, 1920 e 2560 px nos temas claro/escuro, com 15 e 20 dezenas, sem overflow. Em 2560 px, os campos simples ficaram entre aproximadamente 278 e 310 px e Combinação entre 407 e 439 px; em 1024 px, Categoria e Próximo Sorteio ficaram iguais e os três indicadores da segunda faixa permaneceram na mesma linha. A suíte completa ficou em 285/287 por duas expectativas preexistentes e isoladamente reproduzíveis de `DashboardWorkQueue.test.tsx` (`Estratégias configuradas` e duas linhas `Pronto para gerar`).

## Sidebar operacional com busca e conta — 2026-09-29

- A sidebar desktop usa três grupos funcionais: `Visão geral` (`Gerar`, `Financeiro`), `Jogos e conta` (`Bolão`, `Assinatura`) e `Suporte` (`Ajuda`, além de `Admin` quando autorizado). As ações continuam passando pelos callbacks e rotas já existentes; nenhuma rota ou API pública nova foi criada.
- A busca rápida ignora acentos, mostra apenas destinos disponíveis para o usuário e abre o primeiro resultado com Enter. O botão de nova aposta permanece destacado e abre o fluxo manual atual.
- A sidebar pode ser recolhida para 72 px. O estado é controlado por `DashboardPage`, que ajusta a coluna do shell; no modo recolhido permanecem ícones com nomes acessíveis e a busca expande a rail antes de receber foco.
- O cartão de plano consome o `Entitlement` real e direciona ao checkout existente. O rodapé exibe identidade e plano; o popover da conta oferece somente ações reais: perfil, troca de tema e saída.
- A sidebar existe somente a partir de 901 px. Em 900 px ou menos, `DashboardMobile` continua sendo a navegação exclusiva, preservando o fluxo mobile por tarefas.
- Verificação: 12 testes dirigidos passaram; lint, build e `git diff --check` passaram. O componente real foi validado em 901, 1024, 1440, 1920 e 2560 px, nos temas claro e escuro, sem overflow; busca, recolhimento, popover e troca de tema foram exercitados, e uma sessão limpa do navegador ficou sem erros ou avisos. A suíte completa ficou em 287/289 pelas mesmas duas expectativas preexistentes de `DashboardWorkQueue.test.tsx`.
