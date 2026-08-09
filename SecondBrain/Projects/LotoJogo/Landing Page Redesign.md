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
- Identificar depoimentos como conteúdo demonstrativo até existirem relatos verificáveis.
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
