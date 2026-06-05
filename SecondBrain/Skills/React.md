# React

Relacionado: [[Second Brain - MOC]], [[Frontend]], [[Dashboard Redesign]].

## Uso neste Second Brain

React e a base dos frontends atuais, especialmente LotoJogo e Consent.

## Regras praticas

- Manter estado remoto em React Query quando a fonte for API.
- Manter chamadas HTTP em `services` tipados.
- Separar hooks consumidores de contextos quando isso preservar Fast Refresh.
- Extrair regras puras para `features` ou `domain`, evitando componentes com logica excessiva.
- Evitar inline styles; seguir o padrao de estilos existente do projeto.
- Usar componentes pequenos e orientados a fluxo real do usuario.

## Aplicacao por projeto

- LotoJogo: ver [[Frontend]], [[ApiService Frontend]], [[StrategyService Frontend]], [[LoteService Frontend]].
- Consent: ver [[03 - Arquitetura e stack]].

## Caveat

O LotoJogo usa SCSS global apesar de notas antigas mencionarem SCSS modules. Seguir o padrao atual ate haver uma decisao explicita de migracao.
