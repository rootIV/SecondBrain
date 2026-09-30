---
title: Landing Page Redesign
date: 2026-08-01
tags:
  - lotojogo
  - frontend
  - design-system
status: implemented
---

# Landing Page Redesign

## Decisão

A landing pública do LotoJogo foi reconstruída como um fluxo vertical escuro, orientado a produto, com roxo LotoJogo como única cor de ação. A logo e o componente `BrandText` permanecem inalterados. O CTA primário é **Criar conta grátis** e sempre aponta para `/registerPage`.

O trabalho seguiu o fluxo `redesign` da skill Hallmark:

- gênero visual: atmospheric;
- macroestrutura: Workbench;
- navegação: N10, sticky e flutuante após rolagem;
- rodapé: Ft5, com mensagem de uso responsável;
- enriquecimento visual: mockup responsivo construído em React e CSS, sem imagens remotas.

## Arquitetura

Os componentes da landing ficam em `src/components/layout/home/landing`. Copy, modalidades, planos, FAQ, passos e recursos são centralizados em `landing.data.ts`. A composição principal fica em `LandingPageContent.tsx`, e os estilos isolados pelo escopo `.landing-page` ficam em `src/styles/components/layout/home/Landing.scss`.

O fluxo público preserva os anchors:

- `#home`
- `#features-section`
- `#how-it-works-section`
- `#pricing-section`
- `#faq-section`

`homePage.tsx` respeita o hash inicial e só força o topo quando a URL não contém anchor.

## Movimento e responsividade

`LandingMotion.tsx` e `landing.motion.ts` concentram as cenas de revelação e o parallax da landing. Não há listeners manuais contínuos de scroll: o parallax usa `useScroll` e `useTransform` do Framer Motion.

- Movimento espacial e parallax só são habilitados acima de 1024 px.
- As cenas de seção repetem quando saem e voltam ao viewport; mobile permanece estático.
- `prefers-reduced-motion` remove deslocamentos e mantém somente mudanças funcionais curtas.
- Hero, Como funciona e capítulos do produto usam `min-block-size` orientado ao viewport em desktop, sem altura fixa que corte conteúdo.
- A escala foi validada de 320 px a 3840 px; a largura de conteúdo é limitada para preservar leitura em telas 4K.

## Contrato de conteúdo

- Não prometer aumento de chances ou prêmio.
- Apresentar estratégia, organização, conferência e controle como os quatro pilares.
- Apresentar os nove recursos premium definidos pelo produto.
- Manter os planos Básico grátis, Pro por R$ 29/mês e Bolão por R$ 59/mês, com desconto anual de 20%.
- Não usar depoimentos placeholder; enquanto não houver relatos verificáveis, a landing deve preferir compromissos factuais de confiança e uso responsável.
- Remover métricas não verificadas, vídeo e formulário sem backend.

## Verificação

Comandos principais no frontend:

```powershell
npm.cmd test
npx.cmd eslint src/pages/homePage.tsx src/components/layout/home/landing --ext .ts,.tsx
npm.cmd run build
```

Validado no navegador em 320, 768, 1024 e 1440 px: ausência de overflow horizontal, menu mobile, anchors, passos interativos, alternância mensal/anual e hierarquia de headings.

> [!warning] Lint global
> `npm run lint` ainda falha por seis ocorrências preexistentes de `react-refresh/only-export-components` em `src/components/strategies/StrategyTemplatesView.tsx`. O escopo da landing passa no ESLint.

## Relações

- [[Frontend]]
- [[Dashboard Redesign]]
- [[Tests]]

## Follow-up visual de 2026-08-01

- O hero passou a animar no carregamento da landing, independente de entrada por scroll.
- O mockup React do hero foi substituído por uma arte local em `public/media/lotojogo-hero-parallax-v2.jpg`, derivada de PNG preservado em `public/media/lotojogo-hero-parallax-v2.png`.
- `ProductArtwork.tsx` e `productArtwork.data.ts` centralizam os assets demonstrativos usados no hero, em "Como funciona" e nos capítulos do produto.
- A composição desktop foi ampliada: conteúdo textual fica à esquerda e arte domina o lado direito, com parallax discreto acima de 1024 px.
- Mobile mantém fluxo estático, sem parallax, com regras específicas para 320 px e CTAs sem quebra de rótulo.

Verificação executada no follow-up:

```powershell
npm.cmd test
npx.cmd eslint src\components\layout\home\landing --ext .ts,.tsx
npm.cmd run build
npm.cmd run lint
```

`npm run lint` global continua falhando fora da landing em `StrategyTemplatesView.tsx` e na cópia em `.worktrees`, por `react-refresh/only-export-components`.

## Follow-up de carregamento e largura de 2026-08-26

- A rota pública `/` não deve passar pelo fallback visual de rotas lazy: `homePage.tsx` fica importado de forma síncrona em `App.tsx`.
- O boot loader pré-React em `index.html` é injetado somente quando `window.location.pathname !== "/"`.
- O loader `.boot-loading` deve ocupar exatamente o viewport, com `body` sem margem e `box-sizing: border-box`.
- A landing mantém `landing-nav`, `landing-final-cta` e `landing-footer` em largura total; o conteúdo interno continua alinhado pelo `landing-shell`.

Verificação executada:

```powershell
npm.cmd test
npm.cmd run lint
npm.cmd run build
```

Playwright com Chrome local validou desktop 1920x920 e mobile 390x844: `/` sem `.boot-loading`; `/dashboard` pré-app com loader em `left=0`, `top=0`, largura e altura iguais ao viewport; nav e footer com bounding box igual à largura do viewport.

## Follow-up anti-slop de 2026-08-27

- A landing pública não usa boot loader estático em `index.html`; `#root` inicia vazio e a home permanece importada de forma síncrona em `App.tsx`.
- Os rótulos repetidos `landing-eyebrow`, a seção de depoimentos demonstrativos e marcadores numéricos decorativos foram removidos da narrativa principal.
- `TrustAndFaq.tsx` substitui prova social placeholder por compromissos factuais: sem promessa de prêmio, orçamento visível e conferência rastreável.
- `LandingReveal` não usa mais `opacity: 0` como estado inicial; conteúdo de anchors e seções já nasce visível e o movimento apenas assenta posição.
- Mobile 390x844 foi validado sem `.boot-loading`, sem resíduos de `landing-eyebrow`/testimonials, sem overflow em benefícios/FAQ e com hero/FAQ legíveis.

Verificação executada:

```powershell
npm.cmd test
npm.cmd run lint
npm.cmd run build
```

## Follow-up anti-slop visual de 2026-08-27

- A landing removeu o `ProductMockup` React e seus testes porque o componente era um mockup demonstrativo sem uso real na composição atual.
- O hero mantém apenas uma arte local principal (`lotojogo-hero-parallax-v2.jpg`), sem calculadora duplicada, parallax ou asset `imgupscaler` na landing.
- O ticker animado de modalidades foi substituído por uma faixa estática com as nove modalidades.
- `PremiumFeatures` deixou de usar ícones repetidos; a seção premium agora é uma lista editorial de capacidade e descrição.
- O exemplo de bolão deixou de usar avatares/nomes fictícios e passou a ser uma tabela compacta de cotas, participação e status.
- `LandingMotion` mantém apenas reveal visível por padrão; não há mais `data-landing-motion="parallax"` na landing.

Verificação executada:

```powershell
npm.cmd test
npm.cmd run lint
npm.cmd run build
```

Playwright validou desktop 1440x920 e mobile 390x844: sem `.boot-loading`, sem `.landing-eyebrow`, sem ticker/mockup/parallax, sem ícones premium repetidos, com uma única imagem no hero carregada e largura do documento igual ao viewport. O único aviso de console observado continua sendo `VITE_GOOGLE_CLIENT_ID is not configured`.

## Follow-up hero grid 3D de 2026-08-27

- `HeroSection.tsx` passou a renderizar uma cena decorativa própria em HTML/CSS, sem imagem de dashboard: malha 3D em perspectiva, quadrados numéricos glassmorphism e placeholder inferior `DASHBOARD PLACEHOLDER`.
- A cena usa `perspective: 1800px`, `transform-style: preserve-3d`, animações em `transform`, `opacity`, `filter` e `box-shadow`, e elementos decorativos com `pointer-events: none`.
- A lógica do hero gera números no mount, escolhe poucos quadrados em intervalos aleatórios para pulso ou curto-circuito, cria faíscas transitórias e limpa timers/event listeners no unmount.
- `prefers-reduced-motion` reduz o loop para pulsos mais espaçados e remove faíscas via CSS.
- Mobile reduz a quantidade de quadrados renderizados, mantém CTA e texto legíveis e deixa o placeholder parcialmente visível no rodapé do hero.

Verificação executada:

```powershell
npx.cmd eslint src\components\layout\home\landing\HeroSection.tsx --ext .ts,.tsx
npm.cmd test
npm.cmd run lint
npm.cmd run build
```

Playwright capturou desktop 1440x920, mobile 390x844 e mobile 320x844 em `output/playwright`, confirmando hero escuro, texto legível, grid à direita e placeholder inferior parcialmente visível.

Follow-up visual do mesmo dia: a escala do H1 foi reduzida, a malha foi reposicionada para ocupar melhor o centro-direita como na referência, o placeholder inferior ganhou mais presença e `landing-nav`/`landing-footer` passaram a usar conteúdo full-width em vez de limite centralizado.

## Follow-up price section shadcn de 2026-08-27

- A landing passou a usar `src/components/ui/pricing-section.tsx` com `PricingCard` e `PricingTab`, adaptando os planos oficiais de `landing.data.ts`.
- A oferta preserva o contrato atual: Básico grátis, Pro R$29/mes, Bolão R$59/mes, desconto anual de 20% e CTA para `/registerPage`, sem promessa de resultado.
- Atualizacao em 2026-09-05: Tailwind v4 foi removido do frontend. A landing permanece baseada no SCSS global centralizado e nao deve depender de utilities Tailwind, `@tailwindcss/vite`, `tailwind-merge`, `class-variance-authority` ou `clsx`.
- `.landing-page` define tokens CSS proprios (`--color-background`, `--color-card`, `--color-primary`, etc.) para a secao herdar a identidade visual da landing.

Verificacao executada:

```powershell
npm.cmd run lint
npm.cmd test
npm.cmd run build
```

Playwright validou desktop e mobile 390x844 em `http://127.0.0.1:5173/#pricing-section`; o toggle anual renderizou R$23,20 e R$47,20, com console sem erros.

## Follow-up hero/pricing/FAQ de 2026-08-27

- O hero recuperou a copy anterior: "Gere jogos inteligentes em segundos", "Aposte com mais critério, menos improviso", CTA "Criar estratégia grátis" e link "Saiba mais".
- O fundo do hero foi refinado para uma malha escura em perspectiva com pontos luminosos amarelos e uma moldura de produto na base, inspirada na referência anexada.
- A price section agora tem quatro planos de landing: Free, Pro, Plus e Bolão. Plus fica como plano individual destacado em R$39/mes; Pro permanece R$29/mes e Bolão R$59/mes, todos com desconto anual de 20%.
- O primeiro item da FAQ nao abre mais por padrão; todos os itens iniciam fechados.

Verificacao executada:

```powershell
npm.cmd run lint
npm.cmd test
npm.cmd run build
```

Playwright capturou hero desktop/mobile e full-page mobile com pricing/FAQ em `lotojogo/output/playwright`.

## Follow-up hero/pricing anti-slop de 2026-08-28

- O hero deixou de usar copy generica de velocidade/inteligencia e voltou para uma promessa factual: metodo, controle, custo e conferencia.
- A malha do hero voltou para quadrados numericos azuis com glassmorphism, profundidade variada e brilho contido; o amarelo dominante dos pontos foi removido para alinhar com o restante da landing.
- A price section deixou de usar o componente promocional `src/components/ui/pricing-section.tsx` na landing. A nova secao renderiza uma comparacao local, sem halo, badge "Mais escolhido", icones de check, NumberFlow ou CTA repetido por card.
- A nomenclatura do plano gratuito passou de `Free` para `Gratis` no conteudo publico, mantendo os quatro planos: Gratis, Pro, Plus e Bolao.
- O desconto anual de 20% e os precos atuais foram preservados; a copy reforca que planos pagos ampliam organizacao e controle, sem prometer resultado.

Verificacao executada:

```powershell
npm.cmd test
npm.cmd run lint
npm.cmd run build
```

Playwright capturou `landing-hero-anti-slop-1440-v4.png`, `landing-pricing-anti-slop-1440-v2.png`, `landing-hero-anti-slop-390.png` e `landing-pricing-anti-slop-390.png` em `lotojogo/output/playwright`.
