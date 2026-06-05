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
- A `strategy-select-div` da aba Home possui acao de limpar todas as estrategias e apostas manuais da categoria atual, com painel de confirmacao antes de remover.
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
- `strategies-scroll` reserva padding interno para que o brilho de `strategy-card` nao seja cortado pelo container rolavel.
- `strategy-card` usa `overflow: visible` para preservar o glow externo, mantendo a camada de brilho interna limitada por `border-radius`.
- Em celulares ate 640px, a aba Home nao usa mais limite fixo de `76px` na area de estrategias; os minicards mantem altura natural e o documento principal assume a rolagem no layout responsivo.
- `strategies-scroll` define seus filhos como `flex: 0 0 auto` para impedir que `StrategyBaseCard` e paineis inline encolham dentro do container rolavel no desktop.
- `strategy-card__cost-preview` fica alinhado no canto direito da linha de quantidade de apostas e usa largura compacta para caber em 320px.

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
- Em telas ate 1200px, `ManageTab`, lista de lotes, detalhe do lote e lixeira removem alturas fixas internas e deixam o documento principal rolar. Isso evita que `LoteDetail`, apostas e acoes da lixeira fiquem cortados no layout mobile/tablet.
- Em 320px, `strategy-section__bets` e `BetRow` reduzem padding, gaps, botoes e chips numericos para evitar overflow horizontal e impedir que a aba Gerenciar force os demais elementos a crescerem.

## Dashboard principal

- `DashboardPage` agora compoe `LeftSideBar`, `DashboardMain` e `RightConfigSideBar`, consumindo `useDashboardState`.
- O planejamento aprovado em [[Dashboard Redesign]] direciona o proximo redesign para **Tactical Intelligence Dark** com enfase em dashboard operacional denso e fluxo guiado por etapas (`categoria -> estrategias -> revisao -> lote -> historico`).
- O redesign planejado introduz `TopNav`, `CategoryDrawer`, `ProfilePage`, page transitions e footer global, mas deve preservar hooks/services existentes e a logica de geracao/gerenciamento.
- Em 2026-05-25, a fase base do [[Dashboard Redesign]] instalou `framer-motion`, adicionou `TopNav`, `CategoryDrawer`, `Footer`, `ProfilePage`, transicoes de rota e aliases `/dashboard`, `/login`, `/register` e `/profile`, mantendo compatibilidade com `/dashboardPage`, `/loginPage` e `/registerPage`.
- O `TopNav` substitui a `LeftSideBar` no fluxo principal da dashboard e usa `lotteryCategories`, `useLotes`, `useAuthActions`, `useTheme` e `useAuth` para categorias, badges, logout, tema e usuario.
- O `TopNav` foi ajustado para o padrao visual mini-navbar: pill flutuante centralizada, logo abstrato de quatro pontos, links com hover vertical, botoes compactos e formato que muda de `rounded-full` para card arredondado quando menus/dropdowns estao abertos.
- A dashboard nao renderiza mais `RightProfileStatusBar`/`right-profile-area`; a `right-config-area` ocupa a altura lateral disponivel ao lado do painel principal.
- `DashboardMain` nao renderiza mais `dashboard-header__brand` nem `dashboard-flow`; o `dashboard-ticker` assume o topo do painel principal.
- O footer global foi adaptado para uma estrutura tipo 21st.dev: marca/logo, botoes sociais circulares, links principais, links legais e copyright/aviso de jogo responsavel.
- As categorias de loteria ficam em `domain/lottery/categories.ts`.
- Os precos de apostas ficam em `domain/lottery/pricing.ts`.
- A regra de merge/substituicao do `GeneratedBetsCard` fica fora da pagina em `features/dashboard/generatedBetGroups.ts`.
- O `MainCard` usa `dashboard-card__selection-panel` no cabecalho do card.
- O titulo `dashboard-card__header h2` usa efeito de metal liquido em CSS: movimento lento continuo no gradiente do texto e reflexo forte raro em ciclo longo.
- O `dashboard-card__header` usa a mesma geometria entre tema claro e escuro; a troca de tema altera somente paleta, fundo, borda, sombra e mascara de cor do titulo.
- No tema claro, o `dashboard-card__header` segue a paleta roxa/rosa da dashboard e evita degradê branco no texto para manter legibilidade.
- O contador `dashboard-card__counter` fica acima do dropdown dentro de `dashboard-card__selection-panel`, com o rotulo `Marcar:` alinhado a esquerda.
- O dropdown `dashboard-card__dozen-select` fica abaixo do contador, mantendo o controle de quantidade perto do estado "selecionados / limite".
- `card-actions` posiciona a acao de aposta manual no lado direito; `Limpar` usa icone de lixeira e `Adicionar` usa icone de correto.
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
