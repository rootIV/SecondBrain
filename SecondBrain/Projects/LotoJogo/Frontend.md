# Frontend

Relacionado: [[LotoJogo - MOC]], [[Architecture]], [[Auth]], [[Dashboard Redesign]], [[ApiService Frontend]], [[AuthService Frontend]], [[LoteService Frontend]], [[StrategyService Frontend]], [[LotteryStrategies]].

## Stack

- React 19
- TypeScript
- Vite
- React Router
- React Query
- SCSS
- Google OAuth component
- `createClientId()` centraliza IDs efemeros de UI e evita crash em browsers/contextos HTTP sem `crypto.randomUUID`.
- PWA via `site.webmanifest` para instalacao como app nativo com suporte a temas e ícones multi-resolucao.

## Estrutura atual

```text
src/
  components/
  contexts/
  domain/
  features/
  hooks/
  pages/
  routes/
  services/
  strategies/
  styles/
  types/
```

## Estado remoto

- `useUser`: query `["me"]` para `/Auth/me`.
- `useLotes`: query `["lotes"]`.
- `useLoteDetail`: query por lote.
- `useLoteMutations`: mutacoes de aposta/lote e invalidacao de queries.
- `useDashboardState`: orquestra selecao de categoria/dezenas, apostas manuais, lote exibido e selecao de aposta gerenciada.
- `useStrategyBuilder`: orquestra estrategias do `HomeTab`, templates locais, validacao e chamada a `generateBets`.
- `useSavedStrategies`: query de estrategias salvas em `/api/strategies`, opcionalmente filtrada por categoria.
- `useCreateSavedStrategy`, `useUpdateSavedStrategy`, `useDeleteSavedStrategy`: mutations para CRUD de estrategias salvas.

## HomeTab

- `HomeTab` agora e majoritariamente UI e delega estado/regras para `useStrategyBuilder`.
- Criacao, clonagem e conversao de apostas manuais ficam em `features/strategies/strategyFactory.ts`.
- Persistencia local de templates fica em `features/strategies/strategyTemplates.ts`.
- Validacoes antes de `/generate` ficam em `features/strategies/strategyValidation.ts`.
- O mapeamento do `GenerateResponseDto` para `GeneratedBetGroup[]` fica em `features/dashboard/generatedBetGroups.ts`.
- O botão `load-strategy-button` abre um painel inline dentro de `strategies-scroll`.
- `SavedStrategiesPanel` lista, cria, edita, apaga e carrega estrategias salvas da categoria atual.
- Criar estrategia salva usa a configuracao atual de `StrategyInstance[]`.
- Editar config ainda usa JSON de `items` para preservar o contrato antes de uma UI estruturada por strategy.
- O fluxo local de templates tambem salva/restaura estrategias `manual` junto das estrategias configuradas.
- Em 2026-07-06, a criacao de estrategias da aba Home passou a usar `strategy-creation-panel` com IDs estaveis para `Categoria:`, `Algoritmo:` e defaults, evitando IDs React `_r_*` no DOM.
- Em 2026-07-06, `strategies-config-div` mostra a categoria atual no cabecalho e oferece busca com blur por estrategias e apostas manuais em rascunho agrupadas por categoria; abrir um item troca para a categoria correta e posiciona a paginacao.
- Em 2026-07-06, `strategy-pagination` permanece visivel sempre que existe ao menos uma pagina de estrategia/manual, inclusive exibindo `Estratégia 1 de 1` com setas desabilitadas quando ha pagina unica.
- Em 2026-07-08, a paginacao de estrategias passou para o header do painel, em formato compacto `n/total` ao lado da busca por categoria.
- Depois de uma geracao bem-sucedida, a aba Home limpa automaticamente as estrategias configuradas e apostas manuais usadas na geracao.
- A aba Home persiste rascunho local em `localStorage` para sobreviver a refresh acidental, incluindo estrategias configuradas, defaults, estrategia selecionada e apostas manuais por categoria.
- O rascunho local da Home e limpo/substituido quando o usuario limpa estrategias, aplica template ou conclui uma geracao com sucesso.
- A tela de templates da aba Home exibe criacao de template em bloco destacado e cada `strategy-template-card` resume as estrategias salvas em lista com tipo, dezenas, apostas e quantidade de numeros configurados quando aplicavel.
- O HomeTab valida configuracoes antes de chamar `generateBets`, bloqueando dezenas/apostas zeradas, somas impossiveis e combinacoes inconsistentes.
- O botao `Gerar apostas` abre `GenerationReviewPanel` dentro de `strategies-scroll`; a chamada real a `/Generate` acontece somente no botao `Confirmar`.
- Cada geracao bem-sucedida na aba Home incrementa um contador de rodadas geradas no texto da aba `Gerenciar`, exibido como `Gerenciar (n)`.
- Apos gerar apostas com sucesso, o HomeTab mostra um overlay com blur, icone de sucesso, mensagem de confirmacao e acao para abrir diretamente o lote gerado.
- Abrir o lote gerado pelo overlay ou clicar no mesmo lote na aba Gerenciar limpa o contador `Gerenciar (n)`.
- `GenerationReviewPanel` resume categoria, universo numerico, total previsto de apostas/dezenas, quantidade de estrategias, apostas manuais e uma lista por estrategia.
- `GenerationReviewPanel` calcula custo previsto por estrategia usando `domain/lottery/pricing.ts`; o custo total aparece no resumo.
- `GenerationReviewPanel` tambem mostra score medio de otimizacao no resumo da geracao.
- Para `+Milionaria`, o custo exibido considera 2 trevos porque o dashboard ainda nao modela selecao de trevos.
- Cada minicard de estrategia possui botao de foguete para chamar `/StrategyOptimizer/suggest`; a resposta preenche apenas campos especificos da estrategia, preservando quantidade de dezenas e apostas.
- Campos numericos dos cards da Home usam `NumericTextInput`: renderizam `type="text"`, teclado numerico, filtro de digitos no `onChange`, selecao ao focar e estado visual vazio durante edicao. O estado recebe `0` quando o campo fica vazio para manter a validacao existente bloqueando geracao invalida.
- Apos otimizar, o HomeTab exibe um painel inline com blur explicando em linguagem simples que a estrategia foi calibrada por historico, sem promessa de resultado.
- O painel `strategy-optimization-overlay__panel` alterna textos a cada otimizacao e lista detalhes relevantes como quantidade de sorteios analisados, faixa de soma, paridade e configuracao sugerida.
- O fluxo de atualizar template mostra comparativo inline entre resumo atual e resumo apos mudanca, com `x` para fechar, cancelar ou confirmar.
- A aba Gerenciar mostra chips de identificacao para combinacoes, incluindo Fibonacci, exclusao, sequencia maxima, primos, multiplos, final do numero e faixa.
- `strategies-scroll` usa `useScrollActivity` para exibir a barra de rolagem somente durante interacoes reais de rolagem (`wheel`, toque e teclas), evitando piscar scrollbar ao clicar em controles.
- Quando a aba Home nao possui estrategias nem apostas manuais, `HomeTab` exibe um estado vazio: "Lista de estratégias vazia. Adicione ou carregue estratégias."
- Em 2026-07-02, a lista normal de estrategias da aba Home passou a paginar uma estrategia por vez; apostas manuais usam uma pagina propria que mostra todas as manuais da categoria atual.
- Em 2026-07-02, `strategies-scroll__toolbar` saiu de dentro de `strategies-config-div` e fica como acao propria da aba Home, acima do frame de estrategias.
- Ao adicionar ou clonar estrategia na aba Home, a paginacao avanca diretamente para a pagina da estrategia criada.
- A paginacao da Home usa um controle compacto com seta esquerda, texto central da pagina atual e seta direita, em vez de dots numerados.
- `strategies-scroll` reserva padding interno para que o brilho de `strategy-card` nao seja cortado pelo container rolavel.
- `strategy-card` usa `overflow: visible` para preservar o glow externo, mantendo a camada de brilho interna limitada por `border-radius`.
- Em celulares ate 640px, a aba Home nao usa mais limite fixo de `76px` na area de estrategias; os minicards mantem altura natural e o documento principal assume a rolagem no layout responsivo.
- Ate 1024px, `right-config__content`/`home-tab` nao usam rolagem interna na Home; o conteudo expande em altura natural e a pagina principal assume a rolagem.
- `strategies-scroll` define seus filhos como `flex: 0 0 auto` para impedir que `StrategyBaseCard` e paineis inline encolham dentro do container rolavel no desktop.
- `strategy-card__cost-preview` fica alinhado no canto direito da linha de quantidade de apostas e usa largura compacta para caber em 320px.

## Home pública

- A rota `/` monta seis capítulos: `Hero`, `HowItWorks`, `Features`, `Benefits`, `Pricing` e o fechamento com `CTA` + `Footer`.
- `HomeStory` organiza a Home em capítulos com scroll interno, navegação lateral e parallax seletivo; a estrutura foi separada em `HomeChapter`, `ChapterRail`, `useActiveHomeChapter` e tipos compartilhados.
- Cada capítulo declara `variant`, `motion` e `showCaption` explicitamente; não há mais decisão de parallax baseada em `className.includes`.
- Dados estáticos de `HowItWorks`, `Features`, `Benefits`, `Pricing` e `Footer` vivem em arquivos `data/*.data.ts`, deixando os componentes focados em renderização e interação.
- `Hero` usa `public/media/lotojogo-hero-dark.png` como fundo escuro com loop cinematográfico em CSS (`pan/zoom` e varredura de luz), preservando `prefers-reduced-motion`; `HowItWorks` usa capítulo escuro com marquee contínuo de modalidades.
- A seção `Pricing` usa palco e fundo escuros em vinho/plum, distintos do fundo roxo do capítulo de produto.
- `chapter-closing` reúne CTA e footer em uma pilha responsiva; o footer usa superfície translúcida escura e deve permanecer integralmente dentro dos limites do capítulo.
- IDs públicos das seções preservam links âncora do menu.
- `prefers-reduced-motion` reduz ou remove animações nos componentes que oferecem essa regra.

### Tipografia e encaixe da Home

- A tipografia aprovada usa Satoshi nos titulos principais do Hero, Inter no `hero__subtitle`, Syne nos titulos de `hero__metrics`, no titulo principal de HowItWorks, no marquee de modalidades e nos titulos das etapas; Inter permanece em controles/labels e no `hero__stats-strip`.
- O `hero__stats-strip` usa tamanhos fixos por faixa responsiva e `white-space: nowrap` no desktop para evitar que os indicadores quebrem ou sejam cortados ao lado de `hero__metrics`.
- Em Mobile S ate Mobile L, os separadores de `hero__stats-item` sao linhas horizontais roxas de largura integral no topo de todos os itens, incluindo o primeiro.
- Em Mobile S ate Mobile L, `hero__stats-strip` centraliza os indicadores e fecha o conjunto com uma linha roxa abaixo do ultimo item.
- Em tablet, `hero__stats-strip` mantem linhas verticais somente entre os itens. No layout compacto entre 1024px e 1180px, os indicadores ficam centralizados nos dois eixos e o conjunto recebe linhas horizontais superior e inferior; desktops maiores com pouca altura continuam sem essas adicoes.
- Entre 320px e 480px, o titulo principal usa quebra balanceada e margem de seguranca na direita para evitar clipping.
- O Hero oferece o CTA secundario `Saiba mais`, com link direto para `#how-it-works-section`, preservando `Criar estrategia gratis` como acao principal.
- A comunicacao principal da Home usa a promessa `Gere jogos inteligentes em segundos` seguida de `Aposte com mais criterio, menos improviso`, com subheadline orientada a filtros, historico e controle.
- Os CTAs `Criar estrategia gratis` e `Saiba mais` permanecem lado a lado em todas as faixas; ate 480px usam duas colunas iguais e, a partir de 1024px, o CTA principal deixa de impor largura minima de 360px.
- Os CTAs do Hero usam acabamento glass em formato pill; o CTA principal recebe gradiente magenta/roxo e o secundario fica translucido para manter hierarquia visual sem alterar rotas ou comportamento.
- O `hero__stats-strip` não usa container/glass próprio; o roxo deve aparecer somente como separador entre conteúdos. Em desktop grande, incluindo 1920x917 até 4K, os textos ficam centralizados em colunas responsivas.
- O `hero__metrics` usa acabamento editorial discreto com superfície escura translúcida, borda leve e sem neon/glow forte.
- O login desktop do Hero reutiliza `useAuth`: mostra `Entrar` para visitantes e `Dashboard` apontando para `/dashboard` quando o usuário já está autenticado.
- O CTA de HowItWorks usa o mesmo vocabulário visual magenta/roxo do CTA principal do Hero, mantendo o comportamento de cadastro.
- O Hero exibe a microcopy `Comece sem cartao. Configure seus criterios em menos de 1 minuto.` e recorta 4px do topo da midia para esconder artefatos do primeiro quadro do video.
- HowItWorks usa o titulo `Da ideia ao jogo pronto em 3 passos.` e apresenta o fluxo `Escolha a modalidade -> Defina seus criterios -> Gere combinacoes`, com CTA para montar a primeira estrategia.
- Os depoimentos da Home sao ordenados como Carla, Felipe e Marcos e enfatizam criterios salvos, comparacao de padroes e organizacao de boloes.
- Nos capitulos `chapter-proof`, `chapter-pricing` e `chapter-closing`, Syne e usada nos titulos principais e nomes de planos; Inter e usada em textos corridos, avaliacoes, autores, labels, precos, controles, formulario e footer. A aspas decorativa de `chapter-proof` permanece serifada.
- No titulo do HowItWorks, o destaque atual e `3 passos.` em italico, preservando a quebra semantica do titulo.
- O layout desktop do HowItWorks compacta titulo, cards e CTA dentro de `100svh` para impedir que o botao seja cortado pelo `overflow: hidden` do capitulo.
- Entre 320px e 375px, o HowItWorks reduz titulo, margens e padding dos cards de etapas sem remover os blocos semanticos do titulo.
- Entre 1024px e 1180px, `chapter-proof` reserva um corredor de 96px a direita para impedir sobreposicao dos reviews com `chapter-nav`.
- Os headers de `chapter-pricing` e o CTA de `chapter-closing` usam wrappers com largura limitada e clamps dedicados para evitar clipping entre Mobile S e tablet.
- Em desktops largos com pouca altura util (`min-width: 1600px` e `max-height: 980px`), `pricing-stage` usa uma variante compacta para evitar ocupar visualmente todo o height do capítulo em telas como 1920x917.

## ManageTab

- `BetRow` exibe uma mini secao de metadados logo abaixo do titulo da aposta: quantidade de dezenas, data, hora, soma e status.
- `BetRow` tambem exibe paridade, identificacoes no hover dos metadados e insights historicos em um bloco compacto colapsado chamado `Analise`.
- Cada `strategy-section` do `LoteDetail` inicia em modo compacto, com toggle por seta para expandir/compactar.
- O estado expandido/compacto e salvo em `localStorage` por `loteId:strategyId`.
- No modo compacto, `BetRow` nao renderiza `bet-row__meta`, `bet-row__insights`, regenerar ou excluir; tambem nao dispara a query de insights.
- Os insights de aposta usam `/BetInsights/analyze` para mostrar frequencia media das dezenas no historico, comparacao com o ultimo sorteio e selo `Combinacao vencedora` quando a combinacao ja cobriu um sorteio anterior.
- A data/hora da aposta e formatada em `America/Sao_Paulo`; timestamps sem timezone vindos do backend sao tratados como UTC antes da conversao.
- Clicar em qualquer area da aposta, incluindo `bet-row__meta`, seleciona a aposta para o `MainCard`; apenas os botoes de acao bloqueiam a propagacao do clique.
- Os containers rolaveis da lista de lotes e do detalhe do lote tambem usam `useScrollActivity` para mostrar scrollbar apenas durante rolagem real.
- `lote-list-item__cost` exibe o custo total do lote em layout compacto, calculado a partir das apostas e precos reais por categoria/quantidade de dezenas.
- Em 2026-07-08, a aba Gerenciar passou a exportar CSV de apostas ativas pelo header da lista, por lote individual e pelo detalhe do lote, usando geracao de arquivo no frontend sem novo endpoint backend.
- Em telas ate 1200px, `ManageTab`, lista de lotes, detalhe do lote e lixeira removem alturas fixas internas e deixam o documento principal rolar. Isso evita que `LoteDetail`, apostas e acoes da lixeira fiquem cortados no layout mobile/tablet.
- Em 320px, `strategy-section__bets` e `BetRow` reduzem padding, gaps, botoes e chips numericos para evitar overflow horizontal e impedir que a aba Gerenciar force os demais elementos a crescerem.

## Dashboard principal

- `DashboardPage` agora compoe `LeftSideBar`, `DashboardMain` e `RightConfigSideBar`, consumindo `useDashboardState`.
- O planejamento aprovado em [[Dashboard Redesign]] direciona o proximo redesign para **Tactical Intelligence Dark** com enfase em dashboard operacional denso e fluxo guiado por etapas (`categoria -> estrategias -> revisao -> lote -> historico`).
- O redesign planejado introduz `TopNav`, `CategoryDrawer`, `ProfilePage`, page transitions e footer global, mas deve preservar hooks/services existentes e a logica de geracao/gerenciamento.
- Em 2026-05-25, a fase base do [[Dashboard Redesign]] instalou `framer-motion`, adicionou `TopNav`, `CategoryDrawer`, `Footer`, `ProfilePage`, transicoes de rota e aliases `/dashboard`, `/login`, `/register` e `/profile`, mantendo compatibilidade com `/dashboardPage`, `/loginPage` e `/registerPage`.
- O `TopNav` substitui a `LeftSideBar` no fluxo principal da dashboard e usa `useAuthActions`; a selecao de categoria fica no `MainCard`.
- O `TopNav` foi ajustado para o padrao visual mini-navbar: pill flutuante centralizada, logo abstrato de quatro pontos, links com hover vertical, botoes compactos e formato que muda de `rounded-full` para card arredondado quando menus/dropdowns estao abertos.
- Em 2026-06-25, o `TopNav` da dashboard passou a seguir o menu transparente da Home: ocupa 100% da viewport, mostra apenas `PERFIL`, `CATEGORIA`, `TERMOS` e `SAIR`, e no mobile abre um painel transparente com altura de viewport.
- Em 2026-06-25, o shell desktop da dashboard passou a alinhar `TopNav`, `dashboard-layout` e `app-footer` pelo mesmo gutter a partir de 1201px; `CategoryDrawer` removeu blur/backdrop-filter e usa animacao curta baseada em transform/opacity para evitar reflexo e custo alto em celulares.
- Em 2026-07-02, a selecao de categoria saiu do `TopNav`; o canto direito foi reduzido para um pill com avatar por iniciais que alterna tema via `useTheme` e botao `Sair` que chama logout.
- Em 2026-07-02, o `TopNav` passou a mostrar saudacao local (`Bom Dia`, `Boa Tarde` ou `Boa Noite`), nome do usuario, separador vertical e `Sair`; o avatar por iniciais continua alternando tema.
- Em 2026-07-03, o `TopNav` ganhou uma engrenagem apos a saudacao; o tooltip abre por clique, fecha por Escape/clique externo e oferece as acoes reais `Tema` e `Perfil`.
- A dashboard nao renderiza mais `RightProfileStatusBar`/`right-profile-area`; a `right-config-area` ocupa a altura lateral disponivel ao lado do painel principal.
- `DashboardMain` nao renderiza mais `dashboard-header__brand` nem `dashboard-flow`; o `dashboard-ticker` assume o topo do painel principal.
- O footer global foi adaptado para uma estrutura tipo 21st.dev: marca/logo, botoes sociais circulares, links principais, links legais e copyright/aviso de jogo responsavel.
- As categorias de loteria ficam em `domain/lottery/categories.ts`.
- Os precos de apostas ficam em `domain/lottery/pricing.ts`.
- A regra de merge/substituicao do `GeneratedBetsCard` fica fora da pagina em `features/dashboard/generatedBetGroups.ts`.
- O `MainCard` usa `dashboard-card__selection-panel` dentro de `card-button`, mantendo selecao de dezenas e aposta manual juntos no rodape do card.
- O `MainCard` exibe todas as categorias de loteria em baloes ao lado direito do titulo dentro de `dashboard-card__header`; clicar em uma categoria muda a categoria ativa e atualiza titulo/limites do card.
- O `MainCard` rotula os campos tracejados com `Categorias:`, `Selecione:` e `Adicione manualmente:`.
- O `MainCard` exibe a selecao atual e apostas manuais ja adicionadas em chips numericos dentro de `card-button__manual-bets`.
- O input `Adicione manualmente:` aceita dezenas separadas por virgula para preencher a selecao atual; duplicados e limites exibem aviso pequeno sem salvar aposta automaticamente.
- Em 2026-07-02, o input `Adicione manualmente:` passou a manter o texto editavel enquanto sincroniza a linha `Atual` em tempo real; apagar um numero do texto ou usar o `x` do chip remove somente o numero do rascunho atual, sem alterar apostas manuais ja adicionadas.
- Em 2026-07-02, `Super Sete` ganhou layout visual proprio no `MainCard`: 7 colunas com digitos `0` a `9`, usando codificacao interna por coluna para permitir repetir digitos em colunas diferentes sem alterar contratos do backend.
- Em 2026-07-08, `card-button__manual-bets` do `MainCard` passou a exibir uma aposta manual por vez, com navegacao, busca local, edicao inline e exclusao sem alterar o contrato de geracao.
- Em 2026-07-09, apostas manuais passaram a usar `ManualBetDraft = { title, numbers }` no frontend, com leitura retrocompativel dos rascunhos antigos salvos como `number[]` em `localStorage`.
- Em 2026-07-09, `MainCard` passou a exibir o titulo da aposta manual no cabecalho do carrossel, permitir editar titulo e numeros juntos, e separar o modo de rascunho de nova aposta da visualizacao de apostas ja adicionadas.
- Em 2026-07-09, os exports de `LoteList`, item individual e `LoteDetail` passaram a abrir uma tela contextual de exportacao com escopo visivel e acoes `Exportar PDF`, `Exportar CSV` e `Exportar CSV e PDF`.
- Em 2026-07-09, o frontend adicionou geracao de PDF por `Blob` sem dependencia externa, reaproveitando os dados do CSV e incluindo titulo da aposta quando existir.
- Em 2026-07-09, `dashboard-card__selection-panel` voltou a ficar logo abaixo de `dashboard-card__header`; `card-actions` ficou dedicado apenas a exibicao/edicao da aposta manual.
- Em 2026-07-09, `right-config__tabs` passou a nomear a aba inicial como `Gerar`, adicionou a aba `Configurar` com icone de sliders e trocou `Gerenciar` para icone de ferramenta.
- Em 2026-07-09, a aba `Gerar` passou a manter `strategy-creation-panel` e `strategies-scroll__toolbar` no topo, seguidos do `quick-generation-review`; cada linha do review abre a estrategia correspondente em `Configurar`. A aba `Configurar` mantem a toolbar no topo e o conteudo no `strategies-scroll`, com a acao `Gerar Apostas`.
- Em 2026-07-03, a visualizacao do `Super Sete` passou a renderizar 7 colunas reais (`dashboard-card__super-sete-board`) com label `Col. 1` a `Col. 7`, em vez de depender de `grid-auto-flow`; os breakpoints compactam gaps, labels e celulas mantendo as 7 colunas de mobile S ate 4K.
- Em 2026-07-03, o tabuleiro do `Super Sete` passou a limitar largura e altura das celulas por viewport para impedir que as 7 colunas gerem quadrados gigantes em 1920x917, laptop L e 4K; a compactacao geral de dezenas fica restrita de tablet ate laptop para preservar a Lotomania em 4K.
- Em 2026-07-03, a correcao do `Super Sete` removeu os overrides antigos com `grid-auto-flow`/linhas `1fr` que reapareciam em tablet, laptop L, 1920x917 e 4K; o JSX agora usa `dashboard-card__super-sete-board` com colunas independentes e celulas de altura fixa compacta.
- Em 2026-07-03, Mobile S ate Mobile L do `Super Sete` voltou aos tamanhos anteriores: 26px ate 520px e 24px ate 340px, mantendo a compactacao nova apenas de tablet para cima.
- Em 2026-07-02, `strategy-pagination` saiu de dentro de `strategies-scroll` e passou a ficar preso ao rodape do painel de estrategias, permanecendo visivel enquanto a estrategia rola.
- Em 2026-07-02, o rodape de `card-actions` passou a manter `card-button__header` e `card-button__manual-bets` na area esquerda, com `dashboard-card__selection-panel` no canto superior direito e `card-button__manual-actions` abaixo.
- Em 2026-07-03, `card-button__manual-actions` passou a pertencer visualmente ao `dashboard-card__selection-panel`; de tablet ate 4K, `card-button__manual-bets` estica para alinhar seu fundo ao fundo dos botoes, e em mobile S ate mobile L a ordem visual fica cabecalho manual, apostas manuais, aviso e painel de quantidade.
- Em 2026-07-02, Quina e Timemania usam classe visual `dashboard-card--wide-number-grid` para compactar grades de 80 numeros somente em desktop/laptop de pouca altura.
- Para Lotomania, o `MainCard` ativa modo denso quando `maxNumbers >= 100`, reduzindo celulas/gaps para exibir 100 numeros sem rolagem interna em layouts desktop.
- Em 2026-07-02, a compactacao forte da Lotomania foi limitada aos breakpoints de pouca altura, mantendo quadrados em tamanho normal em telas 4K.
- `dashboard-card__lote-slot` nao e mais renderizado no dashboard; o `LoteShowcaseCard` permanece preservado para reutilizacao futura.
- O titulo `dashboard-card__header h2` usa efeito de metal liquido em CSS: movimento lento continuo no gradiente do texto e reflexo forte raro em ciclo longo.
- O `dashboard-card__header` usa a mesma geometria entre tema claro e escuro; a troca de tema altera somente paleta, fundo, borda, sombra e mascara de cor do titulo.
- No tema claro, o `dashboard-card__header` segue a paleta roxa/rosa da dashboard e evita degradê branco no texto para manter legibilidade.
- O contador `dashboard-card__counter` e `card-button` ficam ancorados no rodape do `dashboard-card`, enquanto a grade de dezenas ocupa a area flexivel central.
- O dropdown `dashboard-card__dozen-select` fica dentro de `card-button`, mantendo o controle de quantidade perto da acao de aposta manual.
- `card-actions` posiciona a acao de aposta manual no lado direito, sem borda superior; `Limpar` usa icone de lixeira e `Adicionar` usa icone de correto.
- Em telas estreitas, o bloco de selecao empilha abaixo do titulo para evitar quebra visual.
- `DashboardPage` rastreia o `loteId` exibido no `GeneratedBetsCard`.
- Ao clicar em apostas diferentes do mesmo lote na aba [[Frontend|Gerenciar]], somente o `MainCard` muda a selecao; o `GeneratedBetsCard` nao recebe novos grupos.
- Se o lote atual estiver aberto no `GeneratedBetsCard` e uma nova geracao criar apostas para o mesmo lote, os grupos recem-gerados sao mesclados ao card exibido.
- Ao regenerar uma aposta na aba [[Frontend|Gerenciar]], `DashboardPage` recebe o `BetDto` atualizado e troca somente a combinacao correspondente no `GeneratedBetsCard`, usando `betIds` para localizar o item.
- `GeneratedBetsCard` usa `memo` para evitar renderizacao quando as props continuam iguais.
- `GeneratedBetsCard` foi simplificado para um carrossel visual focado somente nos numeros da combinacao, preservando o `generated-bets-card__stage`, animacao e arraste lateral.
- A dashboard usa visual inspirado em plataforma de investimento/crypto: fundo com grade sutil, cards glass, superficies translúcidas, ticker de indicadores e `strategy-card` com acabamento de vidro.
- O `dashboard-ticker` agora funciona como Control Center: mostra missao atual, progresso da selecao, custo, complexidade operacional, status e analytics historico da selecao manual completa via `/BetInsights/analyze`.
- O `LoteShowcaseCard` foi redesenhado como Tactical Bet Card e consulta `/BetInsights/analyze` somente para o slide ativo do carrossel, evitando disparar uma query por aposta gerada.
- O IA Score do `LoteShowcaseCard` e derivado de dados reais retornados pelo insight ativo, combinando frequencia media, recorrencia, sobreposicao com ultimo sorteio e bonus para combinacao vencedora ja observada.
- No tema claro, o `IA Score` do `LoteShowcaseCard` usa rotulo com contraste dedicado para evitar texto apagado sobre superficies translúcidas.
- Os chips numericos do `LoteShowcaseCard` diferenciam par/impar, faixa alta/baixa e sobreposicao com o ultimo sorteio; hot/cold por dezena ainda depende de o backend expor frequencia por numero.
- `lote-showcase-card__context` mostra texto abreviado ate 425px (`Fx`, `Med`, `Fort`) e texto completo acima disso (`Faixa`, `Media`, `Fortes`), sempre centralizado nos chips.
- Em telas ate 1200px, a ordem responsiva e `RightProfileStatusBar`, `RightConfigSideBar`, `DashboardMain` e `GeneratedBetsCard`; isso cobre as faixas de 1026px e 1102px que antes ainda recebiam layout desktop e podiam cortar cards.
- O `GeneratedBetsCard` fica fora do `DashboardMain` no fluxo mobile/tablet para preservar a ordem visual esperada depois do painel principal.
- O botao `category-menu__close` da [[Frontend|LeftSideBar]] usa centralizacao via pseudo-elemento para corrigir o alinhamento visual do `x`.

## Auth no frontend

Ver [[Auth]].

## Contexts e hooks

- Providers continuam em `src/contexts`.
- Contextos puros ficam em arquivos `*ContextCore.ts`.
- Hooks de consumo ficam em `src/hooks`: `useAuth`, `useTheme` e `useToast`.
- Essa separacao evita misturar export de componente e hook no mesmo arquivo, mantendo compatibilidade com Fast Refresh.

## Estilos

O codigo atual usa SCSS global com imports por componente/pagina. Isso diverge da regra antiga "Use SCSS modules".

Padrao atual observado:

- classes BEM-like (`lote-detail__body`, `strategy-section__header`);
- tokens SCSS em `src/styles/tokens`;
- imports diretos de `.scss`.

## Favicon e PWA

- **favicon.ico**: Multi-resolucao (16, 32, 48, 64, 128, 256px) no `public/`.
- **apple-touch-icon.png**: 180x180 para iOS ao adicionar app a home screen.
- **site.webmanifest**: Configuracao PWA com metadados, ícones e tema (`#1a1a2e`).
  - `display: "standalone"` → app aparece sem barra do navegador.
  - `theme_color` → cor da barra superior em Android.
  - Permite instalacao em Android/iOS via "Adicionar a home screen".

## Pontos de atencao

- Alguns componentes de landing ainda usam inline styles.
- Se a regra desejada continuar sendo SCSS modules, migrar por feature aos poucos.
- PWA suporta instalacao offline-ready; testar com DevTools Lighthouse para medir compliance.
# Frontend
