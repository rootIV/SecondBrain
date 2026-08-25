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
