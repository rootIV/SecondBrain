---
title: FRP Brasil - Investigacao externa 2026-10-09
updated: 2026-10-09
tags:
  - security
  - incident
  - frpbrasil
---

# FRP Brasil - Investigação externa 2026-10-09

Relacionados: [[Knowledge Operating Model]], [[Strix - Instalacao Windows e escopo de auditoria]] e [[Knowledge Debt]].

## Resumo e impacto

O usuário declarou ser proprietário de frpbrasil3.com.br e relatou troca indevida do provedor de pagamento e alteração de páginas. Data do incidente, destinatário e estado atual do checkout não fornecidos. Investigação externa sem contas/código/logs, em 09/10/2026 a partir de 12h30 America/Sao_Paulo.

## Verificação atual

- DataTables 1.10.21 servido com SHA-256 idêntico ao CDN oficial: `ffbce8dbb2e5fe154a842b04fb2f26d924b96e114f11016179308bf3b1eeba60`. Faixa afetada por CVE-2020-28458 e CVE-2021-23445; exploração no site não demonstrada.
- Bundle html2pdf contém DOMPurify 2.3.0 e jsPDF 2.3.1; módulos identificados no conteúdo. Avisos CVE-2024-45801 e CVE-2025-57810 aplicáveis por versão, uso explorável não demonstrado.
- PHP anuncia 8.2.33; existe atualização oficial de segurança 8.2.34. Verificar versão interna/backports.
- CSP é apenas `upgrade-insecure-requests`; não há proteção de scripts nem enquadramento nos headers das páginas examinadas.
- Cookie laravel_session: Secure, HttpOnly, SameSite=Lax. TLS 1.2/1.3 aceitos; 1.0/1.1 recusados no teste Python. A tentativa inicial Node com protocolos antigos foi inconclusiva localmente.
- HEAD de .env, Git HEAD e logs, inclusive variantes /public, retornou 403; sem prova de proteção de todos os métodos/nomes.
- JavaScript gsmtheme.js linhas 359–379 envia mudanças de 2FA/API por GET; execução no backend não testada.
- POST de login vazio com X-Requested-With processa validação sem token CSRF. POST com identidade sintética, origem externa e sem esse cabeçalho retorna 302. Não declarar CSRF explorável ou bypass de autenticação.

## Causa raiz e correção

Causa raiz não confirmada. Correlacionar auditoria administrativa, hospedagem/deploy, banco e provedor financeiro. Preservar evidências antes de restaurar; revogar sessões/acessos atingidos, conferir beneficiário e corrigir componentes. Nenhuma correção foi aplicada no site.

## Contrato reutilizável

Presença de CVE por versão não prova reachability, exploração ou causa do incidente. Rota inexistente e várias rotas privadas devolvem o mesmo 302; não tratar isso como descoberta ou autorização completa. Proteger logs e segredos; relatório sanitizado não substitui imagem forense.

## Entrega e pendências

Relatório e evidências em `C:\Users\root4\Documents\Codex\2026-10-09\files-pasted-by-the-user-hello\outputs`: frpbrasil3-auditoria-2026-10-09.md e frpbrasil3-evidencias-2026-10-09.json.

Sem contas, código e logs não foram verificados IDOR, regras financeiras, XSS/SQLi/RCE efetivos, MFA, persistência nem limpeza do servidor. Estado do pagamento e atribuição da invasão permanecem desconhecidos.

