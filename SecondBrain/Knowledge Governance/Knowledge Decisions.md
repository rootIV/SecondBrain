---
tags:
  - second-brain
  - decision-log
  - governance
updated: 2026-08-10
---

# Knowledge Decisions

## 2026-08-10 - Selecionar CobraFlux como hipotese inicial de negocio digital autonomo

- Decisao: tratar o micro-SaaS **CobraFlux** como hipotese comercial inicial para validacao: cobranca recorrente com Pix, boleto/cartao via gateway, regua automatica de lembretes e recuperacao de inadimplencia para pequenos negocios que cobram mensalidades.
- Motivo: pesquisa de oportunidade indicou melhor combinacao entre dor financeira urgente, publico identificavel, recorrencia, baixo custo operacional, automacao alta e caminho plausivel para R$ 3.000/mes com cerca de 21 clientes no plano Pro de R$ 149/mes.
- Alternativas descartadas:
  - Agenda anti-no-show: descartada como primeira aposta por concorrencia muito alta, suporte operacional maior e diferenciacao mais dificil.
  - Kit LGPD/cookies: descartado como primeira aposta por risco juridico, necessidade de autoridade externa e disposicao a pagar menos clara em PMEs.
  - Assistente fiscal MEI/e-commerce: descartado como primeira aposta por complexidade regulatoria/fiscal, maior risco de suporte e concorrentes ERP fortes.
  - Propostas/contratos + checkout: mantido como alternativa adjacente, mas descartado como foco inicial por recorrencia mais fraca.
- Tradeoffs: a oportunidade vencedora tem concorrentes fortes como Asaas, Efi, Iugu, Mercado Pago e Cobre Facil; a diferenciacao deve ser uma camada operacional simples e nichada, nao um novo gateway de pagamento.
- Impacto: antes de codigo, validar com entrevistas, landing page e pre-venda; MVP deve focar em transformar lista de clientes recorrentes em cobrancas acompanhadas automaticamente ate o pagamento.
- Artefato: `C:\Users\root4\Documents\Codex\2026-08-10\files-mentioned-by-the-user-miss\outputs\relatorio-oportunidade-negocio-digital-autonomo.md`.

## 2026-06-05 - Camada de governanca antes de reorganizacao destrutiva

- Decisao: criar um MOC principal e notas de governanca antes de mover ou excluir estruturas maiores do vault.
- Motivo: o vault ja possuia links e workspaces ativos; reorganizar primeiro aumentaria risco de quebrar descoberta.
- Alternativas descartadas:
  - Reorganizar diretorios imediatamente: descartado por risco de perda de contexto e links quebrados.
  - Manter apenas notas por projeto: descartado porque nao cobre aprendizado transversal, debt e operacao continua.
- Consequencia: o sistema agora tem ponto de entrada e processo, mas ainda preserva a estrutura de pastas existente ate uma decisao posterior.
- Verificacao: wikilinks verificados com zero links possivelmente quebrados apos o passe.

## 2026-06-05 - Normalizar extensao dupla sem alterar conteudo semantico

- Decisao: renomear `AGENTS.md.md` e notas de `Skills/*.md.md` para `.md`, mantendo o conteudo e atualizando workspaces Obsidian.
- Motivo: extensao dupla prejudica clareza e interoperabilidade com ferramentas.
- Alternativas descartadas:
  - Deixar como estava: descartado porque a anomalia ja havia sido registrada como divida.
  - Recriar arquivos manualmente: descartado porque mover preserva melhor o conteudo existente.
- Consequencia: paths ficam mais previsiveis; referencias historicas permanecem apenas no registro de decisao/debito.
- Verificacao: busca por arquivos `*.md.md` retornou vazia apos a mudanca.

## 2026-06-05 - Resolver wikilinks orfaos com notas minimas

- Decisao: criar notas curtas para modalidades de loteria ja referenciadas em vez de remover links.
- Motivo: as modalidades sao conceitos reais do dominio LotoJogo e aparecem em multiplos documentos.
- Alternativas descartadas:
  - Remover wikilinks: descartado porque reduziria o valor do grafo.
  - Criar uma unica nota generica: descartado porque cada modalidade possui caveats especificos.
- Consequencia: o grafo Obsidian passa a ter alvos resolvidos e pontos de expansao por modalidade.
- Verificacao: busca de wikilinks possivelmente quebrados retornou zero.

## 2026-06-05 - Definir raiz operacional sem mover conteudo

- Decisao: tratar `C:\Users\root4\OneDrive\Documents\Projetcts\SecondBrain` como raiz operacional do vault e `SecondBrain/` como namespace principal de conteudo.
- Motivo: o workspace ativo da raiz referencia arquivos em `SecondBrain/...`, e mover conteudo agora criaria risco desnecessario.
- Alternativas descartadas:
  - Mover todo conteudo da subpasta para a raiz: descartado por risco alto de quebrar links e workspace.
  - Tratar apenas `SecondBrain/SecondBrain` como vault: descartado porque a configuracao ativa e o arquivo `AGENTS.md` estao na raiz.
- Consequencia: futuras operacoes devem usar a raiz como workspace Obsidian e manter conteudo principal sob `SecondBrain/` ate uma migracao planejada.
- Verificacao: paths do workspace raiz continuam apontando para `SecondBrain/...`.

## 2026-06-05 - Limpar referencias de workspace para arquivos inexistentes

- Decisao: remover do `lastOpenFiles` do workspace raiz referencias a `DesignSkills`/`design-skills` porque os diretorios nao existem no vault atual.
- Motivo: referencias obsoletas criam ruido operacional e confundem descoberta de contexto.
- Alternativas descartadas:
  - Criar placeholders para `DesignSkills`: descartado porque nao ha fonte atual para reconstruir esse conteudo.
  - Manter referencias antigas: descartado porque elas nao apontam para arquivos reais.
- Consequencia: a lista de arquivos recentes do workspace passa a refletir melhor conteudo existente.
- Verificacao: busca por `DesignSkills|design-skills` fica restrita aos registros historicos de manutencao/debito.

## 2026-06-05 - Automatizar health check do vault

- Decisao: criar `Tools/Test-SecondBrainHealth.ps1` e documentar o uso em [[Health Check]].
- Motivo: verificacoes manuais repetidas sao propensas a esquecimento; o vault precisa de um gate simples para notas vazias, links quebrados e workspace inconsistente.
- Alternativas descartadas:
  - Manter verificacoes ad hoc no terminal: descartado porque nao cria capacidade duravel.
  - Adicionar dependencia externa: descartado porque um script PowerShell cobre a necessidade atual sem custo operacional.
- Consequencia: futuras reorganizacoes podem rodar uma verificacao objetiva e reproduzivel.
- Verificacao: o script deve retornar exit code `0` quando nao houver problemas objetivos.

## 2026-06-05 - Desambiguar nota generica de Docker

- Decisao: renomear `Skills/Docker.md` para [[Docker Skill]], preservando [[Docker]] para a nota de projeto LotoJogo.
- Motivo: notas com mesmo basename tornam wikilinks ambigüos em Obsidian e reduzem descoberta rapida.
- Alternativas descartadas:
  - Manter duplicidade como aviso: descartado porque a correcao e simples e melhora a clareza.
  - Renomear a nota de projeto: descartado porque [[Docker]] e o nome natural da documentacao operacional do LotoJogo.
- Consequencia: `[[Docker]]` aponta de forma mais clara para a nota do projeto; a skill generica fica nomeada explicitamente.
- Verificacao: health check nao deve reportar nomes duplicados para Docker.
