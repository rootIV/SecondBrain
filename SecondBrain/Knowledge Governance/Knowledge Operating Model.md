---
tags:
  - second-brain
  - governance
  - operating-model
updated: 2026-06-05
---

# Knowledge Operating Model

## Objetivo

Manter o Second Brain como memoria persistente de arquitetura, produto, qualidade, seguranca, infraestrutura e aprendizados dos projetos.

## Fontes de verdade

- Codigo e testes sao fonte de verdade para comportamento implementado.
- Docs do repositorio sao fonte de verdade para contratos locais do projeto.
- Obsidian e fonte de memoria duravel para decisoes, caveats, padroes e historico.
- Graphify e fonte primaria de orientacao tecnica quando `graphify-out/graph.json` existir.

## Raiz operacional do vault

- A raiz operacional atual e `C:\Users\Vitor\Documents\SecondBrain`.
- O conteudo principal fica no namespace `SecondBrain/` dentro da raiz.
- A configuracao `.obsidian` da raiz deve ser tratada como configuracao ativa enquanto seus paths apontarem para `SecondBrain/...`.
- A subpasta `SecondBrain/.obsidian` e configuracao secundaria/herdada; nao deve orientar reorganizacoes sem verificacao manual.

## Fluxo por interacao

1. Identificar o projeto e o contexto mais especifico.
2. Ler o MOC do projeto antes de varrer arquivos amplamente.
3. Consultar Graphify quando disponivel e relevante.
4. Fazer a menor mudanca coerente com o objetivo.
5. Verificar com comandos proporcionais ao risco.
6. Atualizar notas quando houver decisao, caveat, contrato, padrao ou aprendizado duravel.
7. Registrar inconsistencias em [[Knowledge Debt]] quando nao forem resolvidas no mesmo ciclo.

## Health check

Rodar [[Health Check]] apos mudancas estruturais no vault:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Tools\Test-SecondBrainHealth.ps1
```

## Onde registrar

- Decisao de projeto: `Projects/<Projeto>/Decision Log.md` quando existir.
- Problema conhecido: `Projects/<Projeto>/Known Issues.md` quando existir.
- Padrao tecnico especifico: nota do servico, componente, camada ou dominio afetado.
- Aprendizado transversal: [[Maintenance Log]] ou nota propria em `Knowledge Governance`.
- Debito da base de conhecimento: [[Knowledge Debt]].

## Politica de reorganizacao

- Evitar mover ou renomear arquivos antes de verificar links e impacto em Obsidian.
- Consolidar duplicacoes somente quando houver destino claro e justificativa tecnica.
- Dividir documentos grandes quando eles misturarem decisoes, implementacao, backlog e caveats sem fronteira clara.
- Manter arquivos pequenos e linkados por MOCs.

## Padroes de qualidade

- Toda nota deve ter titulo claro, contexto, links relacionados e data `updated` quando fizer sentido.
- Toda decisao deve registrar motivo, alternativas descartadas, tradeoffs e impacto.
- Todo caveat deve registrar impacto e mitigacao.
- Toda mudanca de arquitetura deve conectar decisao, implementacao e verificacao.

## Regras de seguranca

- Nao versionar segredos, tokens, keys privadas, senhas ou arquivos `.env` sensiveis.
- Registrar exposicoes de segredo como incidentes ou known issues ate a rotacao ser verificada.
- Preferir Least Privilege, Secure by Design e Defense in Depth nas recomendacoes.
