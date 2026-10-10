---
title: Strix - Instalacao Windows e escopo de auditoria
updated: 2026-10-09
tags:
  - security
  - codex
  - tooling
---

# Strix - Instalação Windows e escopo de auditoria

Contexto: instalação solicitada pelo usuário para avaliar `frpbrasil3.com.br`. O usuário declarou ter sido contratado para os testes. Relacionado a [[Knowledge Operating Model]] e [[Maintenance Log]].

## Instalação verificada

- Strix 1.7.0 instalado em `C:\Users\root4\AppData\Local\Programs\Strix\strix.exe`, usando o ZIP oficial para Windows x86-64 e conferindo seu SHA-256 contra o digest da release GitHub.
- Diretório acrescentado ao PATH do usuário, preservando as entradas anteriores. Não modificar o `config.toml`, provedores, modelos ou autenticação do Codex para configurar o Strix.
- Docker Desktop com engine Linux ativo; sandbox `ghcr.io/usestrix/strix-sandbox:1.3.0`, aproximadamente 5,9 GB.
- Login ChatGPT feito pelo fluxo próprio `strix auth login chatgpt`. Nunca registrar tokens em notas, relatórios ou comandos compartilhados.

## Caveat do modelo

O exemplo documentado `chatgpt/gpt-5.4` foi recusado como indisponível na assinatura. A consulta à lista de modelos do serviço com a versão do cliente atual `0.162.0` confirmou `gpt-6.1-sol`; com `STRIX_LLM=chatgpt/gpt-6.1-sol`, a análise deep iniciou. Uma consulta com `client_version=0.116.0` devolveu apenas um modelo oculto: a versão do cliente afeta a descoberta, portanto uma lista antiga não prova ausência de modelos.

## Contrato de auditoria

Escopo restrito ao domínio exato, portas HTTP/HTTPS, sem terceiros, alterações de dados, pagamentos, criação de contas, mensagens de recuperação, brute force, DoS, persistência ou extração de dados pessoais. Limite solicitado ao agente: uma requisição por segundo e 250 requisições. Essa instrução não equivale a controle de egress ou rate limiting externo.

Resultados de headers, redirecionamentos e bibliotecas públicas são cobertura parcial. Sem contas de teste e código-fonte, não declarar verificados IDOR, segregação entre usuários, regras financeiras, hashing de senha ou todas as dependências. Ausência de HSTS/CSP/frame-ancestors é um gap de proteção, não evidência de comprometimento.

Fonte de instalação: [usestrix/strix v1.7.0](https://github.com/usestrix/strix/releases/tag/v1.7.0). Relatórios locais em `C:\Users\root4\Documents\Codex\2026-10-09\ins\outputs`. Esta nota confirma instalação e início da execução, sem antecipar o resultado final da análise.
