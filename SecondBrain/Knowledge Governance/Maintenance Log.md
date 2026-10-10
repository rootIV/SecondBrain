---
tags:
  - second-brain
  - maintenance
  - log
updated: 2026-08-26
---

# Maintenance Log

## 2026-10-03 - MCPs 21st e shadcn

- Registrados globalmente em `C:\Users\root4\.codex\config.toml`: `21st`, HTTP em `https://21st.dev/api/mcp`, autenticado pelo OAuth detectado pelo Codex; `shadcn`, stdio via `npx -y shadcn@latest mcp`.
- O repositorio `21st-dev/magic-mcp` informa que Magic foi substituido pelo 21st; foi usada a conexao HTTP atual. OAuth concluiu com sucesso, sem salvar chave em texto no config ou neste vault.
- Backup anterior: `C:\Users\root4\.codex\config.toml.before-ui-mcp-20261003-181039.bak`. Comparacao TOML confirmou igualdade de todas as configuracoes anteriores apos excluir somente os dois novos servidores; provider, modelos e integracoes preservados.
- Verificacao real via `codex app-server`/`mcpServerStatus/list`: 21st com 34 ferramentas e shadcn com 7. O shadcn tambem respondeu a `initialize`, `tools/list` e `get_project_registries`; CLI 4.21.1.
- Reiniciar Codex para carregar o novo catalogo nesta sessao. MCP shadcn nao implica migrar a aplicacao para Tailwind nem instalar componentes no projeto; [[Dashboard Redesign]] manteve React, SCSS e Framer Motion existentes.
- Fontes: [21st/Magic](https://github.com/21st-dev/magic-mcp), [shadcn MCP](https://ui.shadcn.com/docs/mcp), [Codex MCP](https://learn.chatgpt.com/docs/extend/mcp?surface=cli).

## 2026-08-26 - Manutencao de skills e configuracao Codex

### Problema

O ambiente Codex acumulou skills de engenharia, RTK, frontend, Obsidian e projeto sem uma verificacao recente de compatibilidade de manifesto, cobertura por stack e roteamento global.

### Solucao aplicada

- Inventariadas skills em `C:\Users\root4\.codex\skills` e projetos em `C:\Users\root4\OneDrive\Documents\Projetcts`.
- Confirmada stack recorrente: React/TypeScript/Next/Vite, ASP.NET Core/.NET 8-10, Docker, MySQL, Obsidian/Second Brain, Graphify e RTK.
- Instaladas skills curadas oficiais `aspnet-core`, `security-best-practices` e `security-threat-model`.
- Corrigidos manifestos inválidos em skills locais movendo metadados fora do schema (`triggers`, `effort`, `tags`, `version`) para `metadata` e adicionando `name` onde faltava.
- Atualizado `C:\Users\root4\.codex\AGENTS.md` com roteamento por stack para ASP.NET Core, React/TypeScript, segurança e Obsidian.
- Atualizado `C:\Users\root4\.codex\config.toml` com `project_doc_fallback_filenames = ["CLAUDE.md", ".cursorrules"]`.
- Instalado `PyYAML` no Python local para permitir rodar o validador oficial `quick_validate.py`.

### Verificacao

- `py ...\quick_validate.py` passou para todas as skills pessoais em `C:\Users\root4\.codex\skills`.
- `py -c "import tomllib ..."` confirmou que `C:\Users\root4\.codex\config.toml` continua com TOML valido.
- Consulta oficial OpenAI confirmou o uso complementar de `AGENTS.md`, memorias, skills e MCP, e o modelo de progressive disclosure das skills.

### Decisao

Nenhuma skill valida foi removida neste ciclo. As duplicidades aparentes foram preservadas porque representam escopos diferentes: processo geral, stack especifica ou workflows RTK.

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

## 2026-09-05 - Backup limpo Codex/Windows e novo caminho de projetos

### Problema

Projetos e Second Brain foram movidos para `C:\Projetcts`, mas a configuracao global do Codex ainda apontava para o caminho antigo no OneDrive.

### Solucao aplicada

- Atualizado `C:\Users\root4\.codex\AGENTS.md` para carregar `C:\Projetcts\SecondBrain\AGENTS.md`.
- Adicionadas entradas confiaveis em `C:\Users\root4\.codex\config.toml` para `C:\Projetcts` e projetos principais.
- Criado backup sanitizado em `outputs\codex-windows-clean-install-backup-2026-09-05-212807.zip`, com configs, skills, binarios auxiliares, inventarios e copia Markdown do Second Brain.
- Excluidos `auth.json`, secrets, sessoes, logs, bancos SQLite, caches e plugin cache.

### Verificacao

- `config.toml.current` e `config.portable.toml` do backup parseiam com `tomllib`.
- `backup-manifest.json`, `file-manifest.sha256.json` e `.skill-lock.json` parseiam como JSON.
- Varredura do ZIP nao encontrou `auth.json`, SQLite, sessoes, caches ou secrets.

## 2026-09-22 - Serena sem janelas automaticas

### Problema

Serena abria varias janelas/abas ao iniciar como MCP no Codex.

### Solucao aplicada

- Alterado `C:\Users\root4\.serena\serena_config.yml`: `web_dashboard_open_on_launch: false`.
- Mantido `gui_log_window: false` e `web_dashboard: true`, deixando o dashboard disponivel sem abrir automaticamente.
- Atualizado `C:\Users\root4\.codex\config.toml` para iniciar Serena com `--open-web-dashboard=false` e `--enable-gui-log-window=false`.
- Encerradas instancias antigas do Serena que ainda rodavam com os argumentos anteriores.

### Verificacao

- `serena_config.yml` parseou corretamente.
- `config.toml` parseou corretamente.
- `codex mcp get serena` mostrou os novos argumentos.
- Nao havia mais processos Serena antigos apos a limpeza.

## 2026-09-22 - Backup Codex/Windows regenerado apos ajuste do Serena

### Solucao aplicada

- Atualizado o gerador de backup para incluir as flags do Serena no `config.portable.toml`.
- Regenerado backup limpo do Codex/Windows com a configuracao que impede janelas automaticas do Serena.

### Verificacao

- Backup validado com parse de TOML e JSON.
- Varredura do ZIP nao encontrou `auth.json`, SQLite, sessoes, caches ou secrets.

## 2026-09-28 - Upgrade das animacoes do Codex Pet Nexo

### Solucao aplicada

- Criada [[Codex Pet Nexo]] como referencia operacional do pet customizado.
- Regeneradas e instaladas as linhas `idle`, `waving`, `waiting` e `running` com identidade preservada.
- Mantidas as demais animacoes e as 16 direcoes de olhar do atlas v2.
- Registrado que o formato do pet nao suporta uma barra dinamica de consumo; o valor de 5 horas deve vir de Settings/Usage ou do usage dashboard do Codex.

### Verificacao

- Todas as linhas passaram na extracao e inspecao sem erros ou avisos.
- O atlas instalado passou em `validate_atlas.py --require-v2` com `ok: true`, dimensoes `1536 x 2288`, RGBA e zero residuos RGB em pixels transparentes.

## 2026-09-28 - Nexo Darkstorm

### Solucao aplicada

- Transformado o atlas v2 instalado do Nexo para um visual mais masculino e sombrio, com paleta azul-preta, contorno mais pesado, marca eletrica no peito e raios ciano/violeta anexados ao corpo.
- Preservadas a grade `8 x 11`, as celulas `192 x 208`, a ordem das animacoes e as 16 direcoes de olhar.
- Atualizada a descricao do pet em `C:\Users\root4\.codex\pets\nexo\pet.json`.

### Verificacao

- PNG intermediario e WebP final passaram em `validate_atlas.py --require-v2`.
- O atlas instalado em `C:\Users\root4\.codex\pets\nexo\spritesheet.webp` passou com `ok: true`, dimensoes `1536 x 2288`, RGBA, zero residuos RGB em pixels transparentes, sem erros ou avisos.

## 2026-09-30 - Plugins Ponytail e Agent Skills no Codex

### Decisao

- Ponytail compensa como plugin nativo do Codex para reforcar solucoes minimalistas sem remover verificacao, seguranca ou acessibilidade.
- Agent Skills tambem foi instalado como plugin nativo para integracao oficial, embora o conteudo principal das 25 skills ja existisse em `C:\Users\root4\.codex\skills`.
- O backup limpo continua excluindo `auth.json`, secrets, sessoes, logs, SQLite, caches e `plugins/cache`; a restauracao deve reinstalar plugins a partir dos marketplaces GitHub.

### Solucao aplicada

- Registrado marketplace `DietrichGebert/ponytail` e instalado `ponytail@ponytail` versao `4.10.0`.
- Registrado marketplace `addyosmani/agent-skills` e instalado `agent-skills@agent-skills` versao `0.6.11`.
- Gerado backup limpo em `C:\Users\root4\Documents\Codex\2026-09-30\co\outputs\codex-windows-clean-install-backup-2026-09-30-172435.rar`.

### Verificacao

- `codex plugin list` mostrou `ponytail@ponytail` e `agent-skills@agent-skills` como `installed, enabled`.
- `config.toml.current`, inventario de plugins e `RESTORE.md` do backup registram os dois plugins e comandos de reinstalacao.
- Varredura do RAR nao encontrou `auth.json`, SQLite, sessoes, caches, plugin cache ou secrets.

## 2026-10-09 - Instalação do Strix para auditoria autorizada

- Instalado Strix 1.7.0 para Windows com SHA-256 conferido; preservadas as configurações do Codex e as entradas anteriores do PATH.
- Autenticação própria com ChatGPT concluída. O exemplo `gpt-5.4` da documentação foi rejeitado; modelo `gpt-6.1-sol` confirmado pelo serviço e análise deep iniciada.
- Registrados contrato de escopo e limitações em [[Strix - Instalacao Windows e escopo de auditoria]]. O início não representa uma auditoria concluída.
