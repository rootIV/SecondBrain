---
tags:
  - second-brain
  - continuous-improvement
  - learning
updated: 2026-06-05
---

# Continuous Improvement

Area dedicada ao aprendizado do proprio sistema de conhecimento e dos processos de desenvolvimento.

## Erros recorrentes

### Nomes e paths inconsistentes

- Sinal observado: arquivos com extensao dupla `.md.md` e referencias antigas em workspace Obsidian.
- Impacto: aumenta friccao de descoberta e pode confundir agentes, Obsidian e ferramentas externas.
- Padrao futuro: antes de criar notas novas, usar nomes simples, sem extensao duplicada, e validar links apos renomeacoes.

### Wikilinks sem nota alvo

- Sinal observado: modalidades de loteria eram referenciadas em varios documentos sem notas proprias.
- Impacto: grafo local cria nos orfaos e reduz descoberta rapida.
- Padrao futuro: quando um conceito aparecer em varios documentos, criar nota curta ou consolidar em um glossario.

## Correcoes recorrentes

- Criar ou atualizar MOC quando um contexto ganha massa critica.
- Registrar caveat em [[Knowledge Debt]] antes de fazer reorganizacao destrutiva.
- Atualizar `Maintenance Log` quando a estrutura do vault muda.
- Rodar verificacao de wikilinks depois de renomear, mover ou criar notas.
- Rodar [[Health Check]] apos mudancas estruturais no vault.

## Gargalos de desenvolvimento

- Ausencia de Git no vault `C:\Users\Vitor\Documents\SecondBrain` limita rastreabilidade por diff/commit.
- Duplicidade de configuracao `.obsidian` entre raiz e subpasta exige cuidado; a raiz foi definida como operacional, mas a configuracao secundaria ainda existe.
- Workspaces Obsidian podem carregar referencias antigas que nao representam mais conteudo atual; isso deve entrar em verificacao periodica.

## Debitos tecnicos de conhecimento

- Ver [[Knowledge Debt]].

## Boas praticas descobertas

- Usar `LotoJogo` como referencia de estrutura documental: MOC, Decision Log, Known Issues, notas por servico e regras de contexto.
- Manter `Aika OG` com notas orientadas a contratos sensiveis de protocolo, evitando refatoracao sem validacao binaria.
- Evoluir `Consent` de documentacao de produto para documentacao operacional por servico conforme o MVP estabilizar.

## Decisoes revertidas

- Nenhuma registrada ainda.
