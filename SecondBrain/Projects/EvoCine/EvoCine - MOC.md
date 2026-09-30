---
title: EvoCine - MOC
tags:
  - project
  - evocine
  - nextjs
  - dotnet
updated: 2026-08-26
---

# EvoCine - MOC

Landing de venda e download do aplicativo Android para celular, tablet e dispositivos Android compatíveis. O workspace fica em `C:\Users\root4\OneDrive\Documents\Projetcts\ec-stream-tv`.

## Contratos atuais

- Sem conta, login ou senha para o comprador.
- O produto é divulgado para celular e tablet Android, com TV Box e outros dispositivos Android tratados como compatíveis apenas quando instalam e executam apps Android como celular ou tablet.
- O PIX é criado pela API ASP.NET Core e confirmado por webhook do Mercado Pago.
- A geração de PIX tem rate limit por IP e bloqueio de nova cobrança recente para o mesmo e-mail/IP enquanto houver compra `CREATING` ou `PENDING`; a janela ativa padrão do checkout é 5 minutos, enquanto a expiração enviada ao Mercado Pago segue o mínimo aceito pelo provedor.
- O primeiro link fica disponível na página somente após `APPROVED`.
- A recuperação usa o e-mail da compra, sem código humano, e aceita no máximo uma emissão a cada 24 horas por hash de e-mail.
- O checkout solicita somente nome e e-mail, sem CPF. O e-mail normalizado é localizado por HMAC SHA-256 com o pepper da API e não é persistido em texto aberto.
- O envio de recuperação depende da configuração `RecoveryEmail__*` de um servidor SMTP.
- O comprador baixa sempre pela API; após pagamento aprovado, o checkout exibe o aplicativo padrão e o aplicativo alternativo. Quando configurado, as origens dos APKs podem ser Google Drive API via `Download__GoogleDriveFileId`, `Download__AlternativeGoogleDriveFileId` e `Download__GoogleDriveApiKey`, sem expor link do Drive no frontend.

## Implementação principal

- Frontend: `ec-stream-tv-front/src/app/page.tsx`, `src/components/site-header.tsx`, `src/components/product-showcase.tsx`, `src/components/device-scroll-story.tsx` e `src/components/checkout-panel.tsx`.
- A copy da landing prioriza linguagem direta para público leigo: compra única de 38 R$ por PIX, acesso vitalício, Android com ressalva para TV Box/outros dispositivos compatíveis, termos internos em `/termos` e CTAs de compra/saber mais.
- A home usa somente capturas locais convertidas para WebP: galeria em leque para as categorias do aplicativo e sequência progressiva de quatro telas controlada pelo scroll. Movimento reduzido troca a sequência por uma grade estática.
- O checkout mantém PIX e recuperação na mesma instância do cartão, em faces alternáveis, preservando o estado do pagamento e o contrato de recuperação por e-mail. Quando o provedor retorna `CANCELLED`, `REJECTED` ou `FAILED`, a tela esconde QR/copia-e-cola e libera a criação de outro PIX.
- A landing possui contexto de produto em `PRODUCT.md`, sistema visual em `DESIGN.md`, arquitetura em `docs/ARCHITECTURE.md` e gates em `docs/QUALITY-GATES.md`.
- O SonarQube deve ser executado por `scripts/Invoke-SonarQube.ps1` depois de configurar `SONAR_HOST_URL` e `SONAR_TOKEN`; o alvo API gera cobertura xUnit/Coverlet em OpenCover antes do `sonarscanner end`.
- O Compose local serve o frontend como imagem standalone de produção em `127.0.0.1:3001`; ele não reflete `npm run dev` automaticamente. Após mudanças de UI/API, executar `docker compose up -d --build evocine-api evocine-front` para evitar imagem antiga e healthcheck antigo nos logs.
- API: `ec-stream-tv-api/Program.cs`, `Startup/EvoCineStartup.cs`, `Endpoints/CheckoutEndpoints.cs`, `Services/DownloadProxyService.cs`, `Repositories/MySqlPurchaseRepository.cs` e `Services/RecoveryEmailSender.cs`.
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
