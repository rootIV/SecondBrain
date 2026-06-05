# Prompt completo do MVP

Você é um agente de desenvolvimento sênior trabalhando no projeto Handshake, em `C:\Users\Vitor\Documents\Projects\consent`.

## Objetivo

Construir o MVP funcional da plataforma Handshake, uma aplicação dashboard-first de confiança digital para criação, revisão, confirmação e acompanhamento de acordos mútuos estruturados.

O produto não deve ser tratado como sistema jurídico, cartorial ou ferramenta de blindagem legal. O foco é transparência, segurança interpessoal, comunicação, consentimento dinâmico e alinhamento de expectativas.

## Contexto obrigatório

- Use o repositório existente como fonte principal.
- Antes de decisões arquiteturais, consulte docs locais e Graphify.
- Respeite `AGENTS.md`.
- Não commitar `graphify-out`.
- O vault informado pode estar vazio; se houver notas disponíveis, leia antes de mudar direção de produto.
- O MVP deve seguir a arquitetura já documentada em `docs/architecture.md`, `docs/data-model.md`, `docs/api-conventions.md` e `docs/privacy-security.md`.

## Stack

Frontend:

- React
- TypeScript
- Vite
- React Router
- React Query
- Axios
- React Hook Form
- Zod
- SCSS com tokens
- lucide-react
- Zustand ou Context API somente se necessário

Backend:

- .NET 8
- ASP.NET Core
- Entity Framework Core
- MySQL preparado, InMemory aceitável em desenvolvimento
- ASP.NET Identity
- JWT
- Refresh token via cookie HttpOnly, Secure e SameSite
- Controllers -> Services -> Repositories -> Database
- Controllers finos, regras em Services, persistência em Repositories
- DTOs obrigatórios em todos os contratos públicos

## Produto MVP

Construir a primeira versão utilizável, sem landing page. A tela inicial autenticada deve ser um dashboard operacional com:

- acordos recentes
- ações rápidas para criar acordo
- templates
- status de segurança
- atividade recente
- estados de loading, vazio, erro, sucesso, confirmação e revisão

## Conceito central

Tudo gira em torno de Agreements. Um Agreement representa uma fotografia temporal do entendimento entre participantes. Ele não é permanente: qualquer participante pode retirar consentimento, discordar ou negociar termos.

## Escopo funcional

1. Autenticação
   - registro
   - login
   - emissão de JWT
   - refresh token preparado em cookie seguro
   - usuário autenticado no frontend
   - proteção básica de rotas

2. Agreements
   - criar acordo
   - listar acordos
   - visualizar detalhes
   - editar enquanto rascunho ou pendente
   - soft delete
   - restaurar
   - exclusão permanente lógica e auditável
   - eventos de auditoria para ações relevantes
   - status: Draft, PendingReview, Active, Changed, Withdrawn, Expired e Deleted

3. Tipos de acordo
   - Encontro
   - Compra e Venda
   - Prestação de Serviço
   - Empréstimo
   - Outro

Cada tipo deve usar schema próprio no frontend e payload estável no backend, mas persistir no modelo central de Agreement, Terms, Participants, Attachments e Events.

4. Wizard de criação
   - escolher tipo
   - preencher termos
   - adicionar participante por username ou link temporário simulado
   - revisar resumo
   - confirmar criação
   - exibir resultado persistido

5. Decisão de participante
   - Concordo
   - Discordo
   - Negociar
   - Retirar consentimento

A mudança deve atualizar status do acordo e gerar evento.

6. Safety Mode MVP
   - ativar/desativar modo segurança em um acordo
   - contato de confiança simples
   - timer/check-in manual
   - evento SOS simulado
   - timeline de eventos de segurança

Não implementar rastreamento real de localização nesta fase; preparar DTOs e entidades para evolução.

7. Templates
   - salvar configuração de acordo como template
   - listar templates
   - reutilizar template para iniciar novo acordo
   - excluir template

8. Histórico e auditoria
   - toda ação relevante deve gerar AgreementEvent ou SafetyEvent
   - histórico deve aparecer nos detalhes do acordo
   - soft delete deve ocultar de listagens padrão
   - auditoria não deve expor dados desnecessários

## Privacidade e segurança

- coleta mínima de dados
- não criar rankings, reputação íntima, score moral ou contagem pública de parceiros
- sanitizar entradas
- validar DTOs
- configurar CORS, rate limiting e security headers
- preparar arquitetura para LGPD, expiração, exclusão definitiva e futura criptografia

## Design

- Visual de fintech/social app premium/SaaS moderno
- Dashboard-first
- Sem landing page como primeira experiência
- SCSS com tokens para colors, spacing, typography, radius, elevation e transitions
- Dark mode preparado
- Usar ícones lucide em botões
- Interface densa, clara e responsiva
- Não usar cards dentro de cards
- Garantir estados loading, empty, error, success, confirmação e revisão

## Critérios técnicos

- Manter estrutura frontend: `src/app`, `src/pages`, `src/modules`, `src/components`, `src/hooks`, `src/services`, `src/types`, `src/utils`, `src/styles`.
- Manter estrutura backend: `Controllers`, `Services`, `Repositories`, `Data`, `Entities`, `DTOs`.
- Não retornar entidades EF diretamente.
- Usar migrations quando MySQL for introduzido.
- Manter testes relevantes.

## Testes mínimos

Backend:

- autenticação
- criação de acordo
- transições de status
- decisão de participante
- soft delete/restauração
- safety events
- templates

Frontend:

- renderização do dashboard
- wizard de criação
- validação de formulários
- hooks de agreements
- estados vazios, erro e loading

## Entregáveis

- MVP executável localmente
- frontend integrado ao backend
- documentação atualizada em `docs/`
- changelog atualizado
- comandos de verificação rodados:
  - `cmd /c dotnet test .\consent-back-end\consent-back-end.sln`
  - `npm run lint`
  - `npm test`
  - `npm run build`

## Antes de finalizar

- rodar verificação
- atualizar Graphify após mudanças estruturais com `python -m graphify update . --force` se disponível
- reportar exatamente o que foi implementado, o que ficou preparado para futuro e qualquer limitação conhecida

