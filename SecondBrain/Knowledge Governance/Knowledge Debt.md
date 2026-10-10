---
tags:
  - second-brain
  - debt
  - knowledge-quality
updated: 2026-08-26
---

# Knowledge Debt

## LotoJogo: asserções antigas na fila operacional — 2026-10-09

- A suíte completa do frontend apresenta duas falhas em `DashboardWorkQueue.test.tsx`: espera “Estratégias configuradas” e “Pronto para gerar”, enquanto `DashboardWorkQueue.model.ts` usa “Configuradas” e “Pronta”. Ambos os arquivos estavam sem alterações nesta tarefa de combinações.
- Pendência: alinhar as asserções ao contrato atual de texto da fila; não mudar o produto para atender expectativas antigas. Lint, build, testes focados de combinações e os 491 testes do backend passaram.
- A divergência de caminhos OneDrive/vault já registrada abaixo permanece: o vault acessível e utilizado foi `C:\Projetcts\SecondBrain\SecondBrain`.

## Aika OG: referências de caminhos e tamanhos antigos — 2026-10-09

- O MOC e notas herdadas apontam para `C:\Users\Vitor\Documents\Projects\aika_og`; o workspace desta verificação é `C:\Projetcts\aika-og`.
- O Knowledge Operating Model ainda cita a raiz OneDrive, enquanto as instruções atuais do usuário apontam para `C:\Projetcts\SecondBrain`, com conteúdo em `SecondBrain/`. Não houve migração ou reorganização nesta tarefa.
- `T_SkillData` Delphi tem 716 bytes; o cliente OG observado usa slots de 720. A divergência está documentada em [[Aika OG - MasterEditor File Crypto]], sem alteração da referência antiga.
- Pendência técnica: estabelecer o significado dos quatro bytes finais de ItemList/SkillData e validar arquivos editados numa sessão do cliente. O editor preserva esses bytes.

## 2026-10-05 — metadados de records na importacao historica

- Ao corrigir o registro de quota, a busca identificou DataAnnotations com `property:` nos construtores primarios de `HistoricalBetImportRequest` e `HistoricalBetInputDto` em `lotojogo-api/Models/HistoricalBetDtos.cs`. O MVC exige atributos nos parametros de records; ha risco do mesmo erro de validacao na importacao historica. Esses DTOs tambem podem ser validados diretamente por DataAnnotations, portanto revisar os consumidores e adicionar cobertura MVC antes de alterar. Fora do escopo da correcao de estrategias/combinacoes.

## 2026-09-22 — avisos e agendamentos antigos de concursos

- LotoJogo: o aviso genérico de validação do filtro usa qualquer concurso stale da categoria, não somente o selecionado. Pode persistir por causa de registros antigos. A abrangência foi preservada ao corrigir cache, abertura de estratégias e startup da API.
- No runtime local, o control center ainda mostrou alguns concursos antigos como abertos apesar de existirem resultados posteriores. A lista de seleção aplicava a política de encerramento corretamente. Revisar reconciliação de concursos antigos e a escolha do próximo concurso no control center em trabalho próprio; não limpar dados históricos sem conferir referências de lotes/rascunhos.
- Caminhos OneDrive em regras antigas do projeto/vault divergem do MOC atualizado: checkout e vault atuais usados e verificados em `C:\Projetcts\Lotojogo` e `C:\Projetcts\SecondBrain`.

Registro de lacunas, duplicacoes e inconsistencias da base de conhecimento.

## Aberto

### Oferta comercial de planos do LotoJogo

- Detectado em 2026-09-18 durante [[Checkout Mercado Pago]]. A landing anuncia Plus e beneficios ilimitados que nao correspondem aos planos/quotas da API.
- O checkout foi limitado aos contratos implementados: Pro e Bolao, um mes por pagamento, renovacao manual. Reconciliar landing e politicas de quota antes da ativacao comercial.

### Nomes duplicados `Architecture`

- Detectado em 2026-07-25 pelo health check do vault.
- Impacto: wikilinks para `[[Architecture]]` podem ficar ambiguos no Obsidian.
- Arquivos:
  - `SecondBrain/Projects/LotoJogo/Architecture.md`
  - `SecondBrain/Projects/MotionInBet/Architecture.md`
- Mitigacao pendente: desambiguar nomes ou links quando houver contexto suficiente para decidir o padrao por projeto.

### Nome duplicado `Decision Log`

- Detectado em 2026-08-26 pelo health check do vault.
- Impacto: wikilinks para `[[Decision Log]]` podem ficar ambiguos no Obsidian.
- Arquivos:
  - `SecondBrain/Projects/EvoCine/Decision Log.md`
  - `SecondBrain/Projects/LotoJogo/Decision Log.md`
- Mitigacao pendente: preferir links qualificados por projeto ou renomear notas apos verificar impacto no vault.

### Referencias ausentes no workspace Obsidian

- Detectado em 2026-08-26 pelo health check do vault.
- Impacto: `.obsidian/workspace.json` referencia artefatos que nao existem mais, o que mantem o health check em falha.
- Referencias:
  - `Untitled.canvas`
  - `Untitled.base`
- Mitigacao pendente: limpar o workspace ativo do Obsidian ou recriar artefatos apenas se eles ainda forem relevantes.

## Resolvido

### Referencias antigas no workspace Obsidian

- Resolvido em 2026-06-05.
- Justificativa: referencias a `DesignSkills`/`design-skills` foram removidas de `.obsidian/workspace.json` apos verificar que os diretorios nao existem no vault atual.

### Vault raiz vs subpasta `SecondBrain`

- Resolvido operacionalmente em 2026-06-05.
- Justificativa: [[Knowledge Decisions]] definiu a raiz `C:\Users\root4\OneDrive\Documents\Projetcts\SecondBrain` como vault operacional e `SecondBrain/` como namespace principal de conteudo, sem migracao fisica neste momento.

### Arquivos com extensao dupla `.md.md`

- Resolvido em 2026-06-05.
- Justificativa: `AGENTS.md.md` e quatro notas em `Skills` foram renomeados para `.md`; referencias diretas nos workspaces Obsidian foram atualizadas.

### Consent/Handshake sem MOC nomeado padrao

- Resolvido em 2026-06-05.
- Justificativa: criado [[Consent - MOC]] e conectado ao `README.md`, mantendo compatibilidade com a entrada antiga.

### Wikilinks orfaos de modalidades de loteria

- Resolvido em 2026-06-05.
- Justificativa: criadas notas curtas para [[Quina]], [[Timemania]], [[Time Mania]], [[Lotomania]], [[Mega-Sena]], [[Dia de Sorte]] e [[Dupla Sena]].

### Notas vazias de skills

- Resolvido em 2026-06-05.
- Justificativa: as notas vazias foram preenchidas como indices praticos para reduzir orfaos sem substituir as skills reais instaladas.

## FRP Brasil — incidente de pagamento e páginas, 2026-10-09

- Referência: [[FRP Brasil - Investigacao externa 2026-10-09]]. Revisão pública concluída; causa raiz, data da invasão, beneficiário e estado atual do pagamento ainda não confirmados.
- Aberto: coletar e correlacionar auditoria administrativa, logs de hospedagem/deploy, histórico do banco e auditoria do provedor financeiro; verificar persistência e limpeza.
- Aberto: confirmar no backend operações de 2FA/API por GET e os controles CSRF/autorização. Bibliotecas em versões afetadas foram identificadas, sem demonstração de exploração no site.

## Pesquisa Aika OG — 2026-10-09

- Referência: [[Aika OG - Cliente OG 2026-10-09]]. Cliente com hash `7eca8e1e6573dc439cc803ef6cafe91aaca53e6c60d4b3bfd82ab267a7ad81aa`.
- Aberto: MakeItems tem 26.000 slots de 52 bytes; loader espera 31.000. Não preencher a cauda com receitas supostas.
- Aberto: hosts locais de SL coexistem com IPv4s antigos no campo 32; uso efetivo desse campo depende do consumidor/caminho ativo.
- Aberto: origem das diferenças entre footer e checksum nativo; comparações não condicionam rejeição nesta versão, sem evidência sobre outros checks/builds.
- Aberto: aceitação em sessão, campos de quests/crafting restantes, flags/eixos/escala dos mapas, AKM/meshes/animações completos e três JIT excepcionais.
- Resolvido nesta pesquisa: função do footer Item/Skill/PI comprovada por rotinas x86 escalar/SIMD; editor recalcula Item/Skill após edição. A pendência anterior de fórmula do footer não deve ser repetida como desconhecida.
- Resolvido no upgrade BinEditor: checksum SetItem comprovado escalar/SIMD/reference (64–215); editor recalcula também PI e SetItem. Ver [[Aika OG - BinEditor Sessoes e Seguranca]].
- Aberto no upgrade: associação automática de ID de ícone com atlas/célula, especialmente skill offset 0, ainda inferida. Pixels JIT estão verificados; não extrapolar isso para semântica de ícones. Referências cruzadas completas de quests/crafting/skills/NPCs ainda não estabelecidas.

## AikaMasterTool GM — 2026-10-09

- Referência: [[Aika OG - AikaMasterTool Central e GM]]. Manutenção é confirmada pelo operador, sem prova de ausência de sessões remotas. Uma administração em tempo real exige um contrato autenticado com o GameServer e aplicação via serviços de domínio.
- Aberto: separar relógio de expiração de banimento de tokenCreationTime antes de implementar banimento temporário. Interface atual oferece somente banimento permanente/suspensão.

## Auditoria servidor/client Aika OG — 2026-10-09

- Resolvido: [[Aika OG - Auditoria Servidor Client 2026-10-09]]. ExpList e SetItem corrigidos com 8 regressões. Catálogo MySQL ativo comparado e sincronizado após autorização expressa: zero diferenças entre client/Data/banco para itens e skills, EXP101 e conjuntos/comportamentos alinhados. Backup SQL/Data e verificação preservados; bootstrap confirmou database.
- Resolvido: 83 vínculos de conjuntos e 17 drops sem referência válida removidos de Data/banco; 352 testes aprovados na solution, 1 ignorado, runner legado exit0. Execuções finais usam banco temporário isolado.
- Aberto: 159 lojas observadas vazias, sem StoreData externo. Preencher exige fonte válida. Semântica do DWORD/bloco secundário de EXP, limite de nível e associação completa de conjuntos novos ainda não comprovadas; não extrapolar paridade das tabelas para essas regras.
- Aberto: confirmar comportamento em gameplay com logs/captura. Não há evidência de sessão completa nesta auditoria. Setup x32dbg/x64dbg + Automate/MCP posteriormente instalado e testado com processos do Windows; attach ao Aika e compatibilidade de gameplay permanecem pendentes. Ver [[Aika OG - Depuracao Realtime x64dbg]].
- Resolvido: [[Aika OG - WorldDataService]] atualizada para o bootstrap que prioriza MySQL. Aberto: MOC principal e Knowledge Operating Model ainda declaram raízes legadas do vault; a raiz usada e verificada neste trabalho é `C:\Projetcts\SecondBrain`, com conteúdo em `SecondBrain/`. Não houve reorganização de notas.
