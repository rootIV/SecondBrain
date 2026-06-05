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
