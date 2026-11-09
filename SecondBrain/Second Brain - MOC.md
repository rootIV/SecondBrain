---
tags:
  - second-brain
  - moc
  - knowledge-management
updated: 2026-11-02
---

# Second Brain - MOC

Mapa operacional do vault. Este arquivo e o ponto de entrada para agentes e manutencao continua da base de conhecimento.

## Projetos

- [[LotoJogo - MOC]]: loterias, geracao de apostas, dashboard React, backend .NET, MySQL, Docker e Graphify.
- [[Aika OG - MOC]]: servidor Aika, protocolo binario, GameServer, TokenServer, services e reverse engineering responsavel.
- [[Consent - MOC]]: produto de confianca digital para acordos mutuos, consentimento dinamico e Safety Mode.
- [[MotionInBet - MOC]]: API .NET, bot Windows Forms/Selenium, website React e fluxo de assinaturas via Pix/Mercado Pago.
- [[EvoCine - MOC]]: landing Next.js, checkout PIX, entrega protegida do APK e recuperação por e-mail.
- [[A90 Performance - MOC]]: diagnóstico ADB somente-leitura, baseline de desempenho e investigação Android 14 reversível.

## Carreira

- [[Job Search - TI]]: busca ativa de vagas em TI, candidaturas, curriculos por vaga e bloqueios operacionais.

## Ambiente Codex

- [[Preferencias de Engenharia e Reverse Engineering]]: avaliar referencias pelo merito tecnico, melhorar implementacoes com justificativa e salvar nomes de funcoes/labels durante analises no Ghidra/x64dbg.
- [[Codex Pet Nexo]]: instalacao, contrato v2, animacoes validadas e limite da integracao com consumo dinamico.

## Governanca

- [[Knowledge Operating Model]]
- [[Knowledge Decisions]]
- [[Maintenance Log]]
- [[Knowledge Debt]]
- [[Continuous Improvement]]
- [[Health Check]]
- [[Decision Record Template]]
- [[Learning Record Template]]
- [[Incident Record Template]]

## Regras de manutencao

- Tratar o repositorio e o vault como um sistema de conhecimento vivo.
- Registrar decisoes duraveis no contexto mais especifico possivel e, quando forem transversais, tambem em [[Maintenance Log]].
- Registrar lacunas, inconsistencias e duplicacoes em [[Knowledge Debt]] antes de fazer reorganizacoes destrutivas.
- Preferir MOCs por projeto para descoberta rapida e notas menores por servico, decisao ou dominio.
- Preservar rastreabilidade entre decisao, implementacao, teste e caveat conhecido.

## Fontes oficiais

- Vault: `C:\Users\root4\OneDrive\Documents\Projetcts\SecondBrain`
- Conteudo principal do vault: `C:\Users\root4\OneDrive\Documents\Projetcts\SecondBrain\SecondBrain`
- Projetos:
  - `C:\Users\root4\OneDrive\Documents\Projetcts\Lotojogo`
  - `C:\Users\Vitor\Documents\Projects\aika_og`
  - `C:\Users\Vitor\Documents\Projects\consent`
  - `C:\Users\Vitor\Documents\Projects\motioninbet`

## Observacoes estruturais

- `LotoJogo` e `Consent` possuem `graphify-out/`; usar Graphify como orientacao tecnica inicial quando houver grafo disponivel.
- `Aika OG` contem contratos binarios sensiveis. Mudancas em `EncDec`, keys, opcodes ou layout de pacote exigem validacao explicita com cliente real.
- O vault possui notas antigas ou vazias em `Skills`; elas devem funcionar como indices de conhecimento, nao como substitutas das skills reais instaladas em `.codex`.
- Para LotoJogo neste ambiente, o Codex deve iniciar por [[LotoJogo - MOC]] e [[Agent Context Rules]], usar `rtk`/Graphify para reduzir saida e aplicar a curadoria de skills registrada em [[LotoJogo Development Skill]].
