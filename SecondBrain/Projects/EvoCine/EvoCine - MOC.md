---
title: EvoCine - MOC
tags:
  - project
  - evocine
  - nextjs
  - dotnet
updated: 2026-08-25
---

# EvoCine - MOC

Landing de venda e download do aplicativo Android para celular e tablet. O workspace fica em `C:\Users\root4\OneDrive\Documents\Projetcts\ec-stream-tv`.

## Contratos atuais

- Sem conta, login ou senha para o comprador.
- O produto é divulgado somente para celular e tablet Android; não há suporte anunciado para TV Box.
- O PIX é criado pela API ASP.NET Core e confirmado por webhook do Mercado Pago.
- A geração de PIX tem rate limit por IP e bloqueio de nova cobrança recente para o mesmo e-mail/IP enquanto houver compra `CREATING` ou `PENDING`.
- O primeiro link fica disponível na página somente após `APPROVED`.
- A recuperação usa o e-mail da compra, sem código humano, e aceita no máximo uma emissão a cada 24 horas por hash de e-mail.
- CPF e e-mail não são persistidos em texto aberto. O e-mail normalizado é localizado por HMAC SHA-256 com o pepper da API.
- O envio de recuperação depende da configuração `RecoveryEmail__*` de um servidor SMTP.

## Implementação principal

- Frontend: `ec-stream-tv-front/src/app/page.tsx`, `src/components/site-header.tsx`, `src/components/product-showcase.tsx`, `src/components/device-scroll-story.tsx` e `src/components/checkout-panel.tsx`.
- A copy da landing prioriza linguagem direta para público leigo: compra rápida por PIX, somente Android, sem TV Box, termos internos em `/termos` e CTAs de compra/saber mais.
- A home usa somente capturas locais convertidas para WebP: galeria em leque para as categorias do aplicativo e sequência progressiva de quatro telas controlada pelo scroll. Movimento reduzido troca a sequência por uma grade estática.
- O checkout mantém PIX e recuperação na mesma instância do cartão, em faces alternáveis, preservando o estado do pagamento e o contrato de recuperação por e-mail.
- A landing possui contexto de produto em `PRODUCT.md`, sistema visual em `DESIGN.md`, arquitetura em `docs/ARCHITECTURE.md` e gates em `docs/QUALITY-GATES.md`.
- O SonarQube deve ser executado por `scripts/Invoke-SonarQube.ps1` depois de configurar `SONAR_HOST_URL` e `SONAR_TOKEN`; sem token não há análise válida.
- O Compose local serve o frontend como imagem standalone de produção em `127.0.0.1:3001`; ele não reflete `npm run dev` automaticamente. Após mudanças de UI/API, executar `docker compose up -d --build evocine-api evocine-front` para evitar imagem antiga e healthcheck antigo nos logs.
- API: `ec-stream-tv-api/Program.cs`, `Repositories/MySqlPurchaseRepository.cs` e `Services/RecoveryEmailSender.cs`.
- Banco novo: `ec-stream-tv-api/database/schema.sql`.
- Banco existente: `ec-stream-tv-api/database/migrations/20260820_email_recovery.sql`.

> [!warning] Compras anteriores à migração
> O antigo hash de código não permite reconstruir o e-mail. Compras antigas ficam sem recuperação automática por e-mail e exigem tratamento operacional.

## Verificação mínima

```powershell
dotnet test .\ec-stream-tv-api\EvoCine.Api.Tests\EvoCine.Api.Tests.csproj
cd .\ec-stream-tv-front
npm.cmd run lint
npm.cmd test
npm.cmd run typecheck
npm.cmd run build
```

Relacionado: [[Decision Log]], [[Second Brain - MOC]] e [[Knowledge Operating Model]].
