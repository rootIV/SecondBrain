---
tags:
  - second-brain
  - maintenance
  - log
updated: 2026-08-10
---

# Maintenance Log

## 2026-08-10 - Pesquisa de oportunidade para negocio digital autonomo

### Problema

Era necessario escolher uma oportunidade comercial real antes de implementar produto, evitando assumir uma ideia por preferencia tecnica.

### Solucao aplicada

- Pesquisadas oportunidades digitais para uma operacao solo com baixo custo e alta automacao.
- Comparadas sete oportunidades em matriz ponderada com prioridade para primeira venda, aquisicao, automacao, recorrencia e potencial de R$ 3.000/mes.
- Registrada em [[Knowledge Decisions]] a escolha do **CobraFlux** como hipotese inicial: micro-SaaS de cobranca recorrente Pix + regua de lembretes para pequenos negocios com mensalidades.

### Resultado esperado

A proxima etapa deve validar a hipotese comercial com entrevistas, landing page e pre-venda antes de escrever codigo.

## 2026-08-10 - MVP local CobraFlux

### Solucao aplicada

- Implementado MVP local em `C:\Users\root4\Documents\Codex\2026-08-10\files-mentioned-by-the-user-miss\work\cobraflux-mvp`.
- Backend ASP.NET Core com dominio de clientes, cobrancas, regua de lembretes, auth local, persistencia JSON, dashboard e gateway mock.
- Frontend React/TypeScript/Vite com landing, cadastro/login, importacao de clientes, geracao de cobrancas, painel, funil e checkout mock.
- Criados docs de arquitetura, pagamentos, seguranca, plano de marketing de 30 dias, README, `.env.example` e CI.

### Verificacao

- `dotnet test CobraFlux.slnx`: 6 testes passaram.
- `npm.cmd test`: 1 teste passou.
- `npm.cmd run build`: build passou.
- `npm.cmd audit --audit-level=moderate`: 0 vulnerabilidades.
- Fluxo HTTP validado: cadastro, criacao de cliente, geracao de cobranca, marcacao de pagamento e dashboard.

### Caveat

Pagamento real, WhatsApp oficial e deploy de producao dependem de credenciais externas; o MVP usa `MockPaymentGateway` e persistencia JSON para validacao local.

## 2026-06-05 - Leitura inicial e camada de governanca

### Problema

O Second Brain ja continha boas notas por projeto, mas nao possuia um ponto de entrada operacional unico nem um modelo explicito para manutencao continua.

### Hipotese

Criar uma camada pequena de governanca reduz ambiguidade para futuras interacoes sem exigir reorganizacao destrutiva imediata.

### Solucao aplicada

- Criado [[Second Brain - MOC]] como entrada principal do vault.
- Criado [[Knowledge Operating Model]] para fluxo por interacao, fontes de verdade e politica de reorganizacao.
- Criado [[Knowledge Debt]] para registrar lacunas antes de mover ou excluir arquivos.
- Criados templates de decisao, aprendizado e incidente.
- Preenchidas notas vazias de skills com indices praticos.
- Criado [[Consent - MOC]] e conectado ao README do projeto Consent.
- Atualizado `AGENTS.md` com o ponto de entrada do vault e regras basicas para Consent/Handshake.
- Criadas notas minimas para modalidades de loteria referenciadas por wikilinks orfaos.
- Renomeados arquivos com extensao dupla `.md.md` para `.md`, atualizando referencias de workspace relacionadas.
- Criado [[Continuous Improvement]] como area dedicada para erros recorrentes, correcoes recorrentes, gargalos, debitos, decisoes revertidas e boas praticas descobertas.
- Criado [[Knowledge Decisions]] para decisoes transversais de governanca do vault.
- Definida a raiz operacional do vault como `C:\Users\root4\OneDrive\Documents\Projetcts\SecondBrain`, mantendo `SecondBrain/` como namespace principal de conteudo.
- Removidas referencias obsoletas a `DesignSkills`/`design-skills` do workspace raiz apos confirmar que os diretorios nao existem.
- Criado [[Health Check]] e `Tools/Test-SecondBrainHealth.ps1` para automatizar verificacoes basicas do vault.
- Renomeada a nota generica `Skills/Docker.md` para [[Docker Skill]] para evitar ambiguidade com a nota de projeto [[Docker]].

### Resultado esperado

Futuras mudancas passam a ter local padrao para registrar decisoes, aprendizados, incidentes, caveats e debitos de conhecimento.

### Licoes aprendidas

- `LotoJogo` possui a documentacao mais madura e deve servir como referencia de estrutura para outros projetos.
- `Aika OG` exige mais cuidado com contratos binarios do que com refatoracao estetica.
- `Consent/Handshake` ainda esta mais orientado a produto/MVP e precisa evoluir para docs por servico conforme o codigo estabilizar.

### Melhorias futuras

- Planejar uma migracao fisica somente se houver valor claro em eliminar o namespace `SecondBrain/`.
- Criar uma verificacao automatizada simples para detectar notas vazias, wikilinks quebrados e arquivos recentes inexistentes.

## 2026-07-25 - Configuracao global do Codex

### Problema

O Codex ainda dependia de contexto por tarefa para lembrar o uso do Second Brain, Graphify, RTK e selecao correta de skills.

### Solucao aplicada

- Atualizado `C:\Users\root4\.codex\AGENTS.md` para carregar `C:\Users\root4\.codex\RTK.md`.
- Adicionado include global para `C:\Users\root4\OneDrive\Documents\Projetcts\SecondBrain\AGENTS.md`.
- Registradas preferencias permanentes para pt-BR, estilo pragmatico, uso do Second Brain, consulta a Graphify quando houver `graphify-out`, uso de RTK e selecao proporcional de skills.
- Confirmado que `C:\Users\root4\.codex\config.toml` ja mantem `personality = "pragmatic"`.

### Verificacao

- Caminhos globais do RTK, Second Brain, MOC principal e Knowledge Operating Model existem.
- `Tools\Test-SecondBrainHealth.ps1` passou com `Passed = True`.
- O health check apontou apenas duplicidade de notas `Architecture`, registrada em [[Knowledge Debt]].

## 2026-07-25 - Instalacao operacional do Graphify

### Problema

O Codex estava configurado para consultar Graphify quando houvesse grafo, mas o CLI `graphify` ainda nao estava instalado nem resolvendo no PATH.

### Solucao aplicada

- Confirmado que o Python passou a responder via python-manager: `Python 3.14.6`.
- Instalado `uv 0.11.32` via WinGet.
- Instalado Graphify pelo pacote oficial `graphifyy==0.9.26`, que fornece os comandos `graphify` e `graphify-mcp`.
- Registrada a skill Graphify para Codex em `C:\Users\root4\.codex\skills\graphify\SKILL.md`.
- Criados shims em `C:\Users\root4\.codex\bin` para `graphify`, `graphify-mcp` e `uv`, mantendo as ferramentas resolviveis no mesmo PATH operacional do RTK.
- Atualizado `C:\Users\root4\.codex\AGENTS.md` para definir o uso conjunto correto: Graphify para perguntas de grafo/arquitetura e RTK para busca, git, testes, builds e leituras auxiliares.

### Verificacao

- `graphify --version` retornou `graphify 0.9.26`.
- `uv --version` retornou `uv 0.11.32`.
- `rtk --version` retornou `rtk 0.43.0`.
- `graphify god-nodes --top 3` funcionou contra o grafo existente do LotoJogo.
- `rtk rg --files .` funcionou no mesmo projeto.
- `multi_agent = true` ja estava ativo em `C:\Users\root4\.codex\config.toml`.
