---
tags:
  - evocine
  - api
  - security
updated: 2026-08-25
---

# EvoCine - Decision Log

## Anti-slop visual, React Doctor e gates SonarQube

- Data: 2026-08-25
- Decisão: instalar/atualizar Impeccable, remover slop de copy da landing e documentar o produto/design em `PRODUCT.md` e `DESIGN.md`.
- Copy: trocar promessas amplas como "acesso vitalício", "liberação imediata", "stream barato" e claim de exclusividade por linguagem concreta: Android, PIX, confirmação Mercado Pago, download temporário e recuperação por e-mail.
- SEO: reduzir keyword stuffing em `seoKeywords`, preservando termos comerciais principais sem repetir dezenas de variações artificiais.
- UI: no mobile/tablet, `DeviceScrollStory` deixa de usar o story sticky alto e passa a exibir grade estática de capturas para evitar área vazia longa abaixo da dobra.
- Qualidade: adicionar `README.md`, `docs/ARCHITECTURE.md`, `docs/QUALITY-GATES.md` e `scripts/Invoke-SonarQube.ps1`. SonarQube ficou configurável, mas não executado porque faltavam `SONAR_HOST_URL` e `SONAR_TOKEN`.
- Verificação: React Doctor 100/100, Impeccable detect `[]`, ESLint, Vitest, TypeScript, build Next, testes .NET, npm audit e NuGet vulnerable aprovados localmente.

## Hardening anti-flood do checkout PIX

- Data: 2026-08-25
- Decisão: aplicar defesa em camadas na API C#: Kestrel sem header `Server`, corpo máximo de 16 KB, timeouts curtos, JSON obrigatório em `checkout/pix` e `recovery`, rejeição de alvo HTTP com controle/traversal, cabeçalhos de segurança, rate limit por IP com fila zero por endpoint e allowlist opcional de IP/CIDR para webhook.
- Anti-flood PIX: antes de criar cobrança no Mercado Pago, a API adquire um lock consultivo no MySQL por chave HMAC de e-mail/IP, verifica se já há compra `CREATING` ou `PENDING` recente e só então insere; se já existir pendência, responde `429` com `Retry-After` e preserva a cobrança existente até a janela configurada por `Security__ActivePixHoldMinutes`.
- Sanitização: e-mail e CPF são normalizados por helpers dedicados, rejeitando CRLF, caracteres de controle, formatos com script/SQL-like e CPF com caracteres fora de dígitos, ponto, hífen e espaço; tokens de download aceitam somente base64url no tamanho esperado.
- Caveat: o rate limit da aplicação mitiga flood, scanners e abuso comum observado por Burp, mas não substitui WAF/CDN/firewall/Security Group contra DDoS volumétrico. `Security__TrustForwardedHeaders=true` só é seguro se a API estiver exposta apenas atrás de proxy confiável.
- Verificação: `dotnet test .\ec-stream-tv-api\EvoCine.Api.Tests\EvoCine.Api.Tests.csproj` aprovou 44 testes após cobrir validadores, allowlist IP/CIDR e guarda de requisição.

## Home com galeria local, narrativa por scroll e recuperação no cartão

- Data: 2026-08-21
- Hero: usar “IPTV como tem que ser”, comunicar SD, HD, HD+ e 4K e reduzir somente a altura desktop para manter a faixa completa de confiança na primeira dobra de 1440×900.
- Ativos: os 16 screenshots locais foram convertidos para WebP e são servidos por `next/image`; a demonstração de jogos e conteúdo ao vivo permanece estática, sem integração de agenda ou transmissão.
- Galeria: a seção “Veja antes de comprar” usa GSAP em um leque circular com 7, 5 ou 3 cartões conforme a largura, operável por botões, teclado e gesto horizontal.
- Scroll: “Do bolso para a tela do tablet” mantém um painel fixo durante quatro etapas com posições próprias; `prefers-reduced-motion` apresenta as quatro telas em grade estática.
- Checkout: PIX e recuperação são faces do mesmo cartão. A troca preserva os dados e o estado do PIX, transfere o foco e remove a face oculta da navegação e da árvore acessível; a API e o limite de uma recuperação a cada 24 horas não mudaram.
- Verificação: 7 testes Vitest, ESLint, TypeScript, build de produção e inspeção em navegador real de 320 a 1440 px concluídos sem erros de console ou overflow horizontal.

## Healthcheck local e imagens Docker stale

- Data: 2026-08-22
- Incidente: o terminal continuava mostrando `GET /api/v1/checkout/status?orderId=00000000-0000-0000-0000-000000000001` com `404`, e o site local em Docker mostrava visual antigo enquanto `npm run dev` mostrava a versão nova.
- Causa: os containers Docker estavam reiniciados, mas as imagens `ec-stream-tv-evocine-api` e `ec-stream-tv-evocine-front` haviam sido construídas antes das mudanças. O Docker local usa build standalone de produção sem volume de código, exposto em `127.0.0.1:3001`; `npm run dev` usa servidor Next dev em outra porta e HMR.
- Decisão: trocar o healthcheck da API para `/health/ready`, que executa uma consulta simples no MySQL, e filtrar logs verbosos de hosting/routing/result em `appsettings.json`. Para alinhar Docker local ao código atual, rebuildar com `docker compose up -d --build evocine-api evocine-front`.
- Verificação: após rebuild, `http://127.0.0.1:3001` contém `IPTV como tem que ser` e não contém o hero antigo; logs recentes da API não mostram mais o healthcheck fake de checkout.

## API de checkout em ASP.NET Core

- Data: 2026-08-19
- Decisão: criar `ec-stream-tv-api` em ASP.NET Core/.NET 10, usando MySQL e Dapper, enquanto o frontend Next continua operando durante a migração.
- Contrato: `POST /api/v1/checkout/pix`, status, recuperação, download temporário e webhook Mercado Pago; o frontend foi migrado para `NEXT_PUBLIC_API_URL` e as rotas antigas do Next agora retornam `410 Gone` sem integrar MySQL ou Mercado Pago.
- Privacidade: CPF e e-mail são usados somente para criar a cobrança no Mercado Pago e não entram na tabela `purchases`. Códigos e tokens persistem apenas como HMAC SHA-256 com pepper.
- Segurança: o webhook valida `x-signature` com HMAC e consulta o pagamento no provedor antes de atualizar o banco. O APK continua externo e deve ser distribuído somente por uma origem privada configurada.
- Verificação: `dotnet build`, `dotnet test`, `npm.cmd run lint` e `npm.cmd run build` devem ser executados após a configuração de dependências.

## Containerização para Render

- Data: 2026-08-20
- Decisão: a API possui Dockerfile multi-stage .NET 10, usa `PORT`/`0.0.0.0` e expõe `/health`; `render.yaml` cria um Web Service público a partir do Dockerfile.
- Motivo: o Mercado Pago precisa chamar o webhook pela internet e o Render encaminha tráfego HTTPS por proxy para a porta interna do serviço.
- Caveat: Render oferece Postgres, mas a API atual usa MySQL; utilizar Postgres exigiria uma migração de banco e repositório, fora deste deploy.
- Verificação: compilação e testes .NET aprovados; build da imagem local pendente enquanto Docker Desktop estiver desligado.

## Seed de administrador por ambiente

- Data: 2026-08-20
- Decisão: criar `admin_users` no schema e executar um seed opt-in por `AdminSeed__Enabled`, `AdminSeed__Email` e `AdminSeed__Password`.
- Segurança: não existe senha padrão no repositório; a senha é persistida somente como PBKDF2-SHA512 com salt aleatório e 600.000 iterações. O seed é idempotente e não sobrescreve uma senha existente.
- Operação: habilitar somente no primeiro deploy, confirmar o registro e voltar `AdminSeed__Enabled` para `false`. O seed não cria autenticação, sessão ou rota administrativa pública.

## Landing page cinematográfica orientada ao PIX

- Data: 2026-08-19
- Decisão: adotar no frontend Next uma identidade de streaming noturno, com preto quente, laranja neon e damasco, dirigida a usuários de TV Box, celular e tablet.
- Estrutura: hero com promessa direta, Feature Stack com capturas reais do produto, seção de dispositivos, jornada de compra em três passos, checkout PIX, prova de segurança e FAQ.
- Conversão: `Gerar PIX` permanece como ação principal; navegação flutuante e barra de compra contextual repetem o CTA sem alterar o contrato existente do checkout.
- Performance: as cinco capturas originais, com cerca de 23,4 MB em PNG, foram convertidas para WebP e passaram a somar cerca de 0,79 MB, servidas pelo componente `Image` do Next.
- Acessibilidade e responsividade: hierarquia semântica, foco visível, suporte a movimento reduzido e ausência de overflow horizontal foram verificadas em larguras de 320, 375, 414, 768, 1280 e 1440 px.
- Verificação: `npm run lint`, `npm run build` e inspeção em navegador real concluíram sem erros; nenhum pagamento real foi submetido durante a validação.

## Endurecimento da confirmação Mercado Pago

- Data: 2026-08-20
- Decisão: manter a integração direta com a API HTTPS oficial do Mercado Pago na API C#; não há MCP oficial do Mercado Pago instalado ou necessário no runtime do projeto.
- Contrato do webhook: ler o identificador pelo parâmetro oficial `data.id`, validar `x-signature`/`x-request-id` e consultar `GET /v1/payments/{id}` antes de alterar a compra.
- Liberação: um status `approved` só libera o pedido quando `external_reference`, `transaction_amount` e `currency_id` correspondem ao pedido, ao preço configurado e a `BRL`.
- Idempotência: usar o UUID do pedido como `X-Idempotency-Key`, mantendo a mesma chave em uma repetição da criação daquele pagamento.
- Ordem de estados: uma compra já `APPROVED` não pode ser rebaixada por uma notificação tardia ou repetida.
- Verificação local: Access Token respondeu `200` em consulta autenticada; MySQL Docker ficou saudável em `127.0.0.1:13307`, schema presente, API/checkout retornou `404` para pedido inexistente, webhook sem assinatura retornou `401` e CORS local retornou `204`.
- Caveat: não foi criado PIX real porque domínio público, segredo de webhook e origem do APK permanecem sem configuração; concluir primeiro em sandbox e só então trocar para produção.

## SDK oficial do Mercado Pago

- Data: 2026-08-20
- Referência: o Graphify de `motioninbet-api` localizou `mercadopago-sdk` 2.10.0, `PixController.CreatePix` e o contrato funcional de `POST /v1/payments`; a versão antiga ainda fazia a chamada por HTTP direto.
- Decisão: instalar `mercadopago-sdk` 3.4.0 no EvoCine e usar `PaymentClient` com `DefaultHttpClient` injetado e `RequestOptions.AccessToken` por chamada, sem credencial global estática.
- Contrato preservado: PIX, `transaction_amount`, e-mail/CPF do pagador, `external_reference`, URL HTTPS opcional de notificação e `X-Idempotency-Key` estável por pedido.
- Verificação: testes do adapter SDK validam criação, autenticação Bearer, idempotência, consulta e mapeamento de QR Code; 19 testes e build Release aprovados.
- Bloqueio de sandbox: a credencial local atual é produtiva; o Mercado Pago respondeu `Unauthorized use of live credentials` ao receber comprador sintético. Substituir somente no Secret Manager local pelo Access Token da aba Teste antes de repetir o PIX de sandbox.

## Docker secrets por aplicação

- Data: 2026-08-20
- Decisão: separar `secrets/api/*.txt` de `secrets/front/*.txt`; o Compose concede cada arquivo somente ao serviço necessário e não mantém senha, token ou pepper em `environment`.
- API: o ASP.NET Core usa `AddKeyPerFile("/run/secrets")`, com `__` como delimitador hierárquico; MySQL recebe senhas por `_FILE` e a API injeta a senha no connection string em memória.
- Frontend: somente `NEXT_PUBLIC_SITE_URL` e `NEXT_PUBLIC_API_URL` entram como build secrets. Esses valores não são confidenciais e ficam incorporados ao bundle; `no_cache: true` evita reutilizar bundle criado com URL antiga.
- Operação local: `Initialize-DockerSecrets.ps1` gera senhas MySQL e pepper, cria placeholders para credenciais externas e mantém os `.txt` reais ignorados pelo Git e pelo contexto Docker.
- Compatibilidade: o inicializador usa APIs disponíveis no Windows PowerShell 5.1 e grava UTF-8 sem BOM para evitar senhas diferentes entre MySQL `_FILE` e o provedor .NET.
- Volume existente: arquivos `_FILE` não rotacionam usuários já persistidos; alterar a senha exige atualizar o MySQL antes de reiniciar os serviços. O health check da API consulta o banco para não mascarar credenciais divergentes.
- Webhook: enquanto a integração usar `PaymentClient`/Payments v1, configurar a rota pública completa `/api/v1/webhooks/mercado-pago` e o evento `Pagamentos (legacy)`, mantendo teste e produção separados.
- Verificação: 20 testes .NET, lint/build Next, Compose válido, três containers ativos, API e frontend respondendo `200`, CORS `204`, 12 mounts em `/run/secrets` e nenhuma chave sensível em variáveis de ambiente.

## Recuperação por e-mail e posicionamento mobile

- Data: 2026-08-20
- Substitui: o código humano de recuperação, a comunicação de TV Box e a navegação flutuante descritos nas decisões anteriores da landing.
- Produto: o EvoCine é divulgado somente para celular e tablet Android. O cabeçalho passa a ser uma barra padrão de largura total e usa no site a marca ampliada do favicon.
- Checkout: a API não cria nem retorna `RecoveryCode`. O primeiro token fica associado à compra e só ganha validade de 15 minutos quando o webhook confirma `APPROVED`.
- Recuperação: `POST /api/v1/recovery` recebe o e-mail, responde de forma neutra e envia o novo link por SMTP. A emissão é serializada no MySQL e limitada a uma vez por hash de e-mail a cada 24 horas.
- Privacidade: o banco mantém somente HMAC SHA-256 do e-mail normalizado; CPF e endereço de e-mail não são persistidos em texto aberto.
- Migração: compras antigas não possuem hash de e-mail recuperável. Executar `database/migrations/20260820_email_recovery.sql` em bancos existentes e tratar clientes legados operacionalmente.
- Configuração: cadastrar `RecoveryEmail__Host`, porta, usuário, senha, remetente, nome e SSL no cofre de segredos.
- Verificação: 23 testes .NET, lint/build Next, auditorias npm/NuGet sem vulnerabilidades conhecidas, Compose válido e inspeção real em 320, 375 e 1440 px sem erro de console.

## Links

## Correção da materialização de compras no Dapper

- Data: 2026-08-20
- Incidente: `GET /api/v1/checkout/status` retornava `503` repetidamente após a criação correta do PIX.
- Causa: o MySQL retornava `status` como `string` e `download_count` como `byte`, tipos incompatíveis com o construtor posicional de `Purchase`, que espera `PurchaseStatus` e `int`.
- Decisão: materializar a consulta em `PurchaseRow`, alinhado aos tipos do provedor, e converter explicitamente para o modelo de domínio antes de retornar do repositório.
- Verificação: teste de regressão com `DataTableReader` e deserializador real do Dapper, suíte com 25 testes aprovada e build Release sem avisos.

- Projeto: `C:\Users\root4\OneDrive\Documents\Projetcts\ec-stream-tv\ec-stream-tv-api`
- Schema: `database/schema.sql`
- [[Knowledge Operating Model]]

## SEO técnico e Google no frontend

- Data: 2026-08-24
- Decisão: concentrar SEO técnico no frontend Next.js usando Metadata API, `robots.ts`, `sitemap.ts`, JSON-LD, `/ads.txt`, páginas públicas de termos/privacidade e scripts condicionais para Google Analytics e AdSense.
- Configuração: Search Console, GA4 e AdSense usam somente `NEXT_PUBLIC_*` de build do frontend em `secrets/front/*.txt`. Esses valores são públicos, mas ficam no mesmo fluxo de Docker secrets para evitar hardcode e permitir rebuild controlado no EC2.
- Crawlers: permitir rastreamento das páginas públicas, bloquear rotas privadas como `/api/` e `/download/`, e declarar bloqueio de crawlers comuns de scraping/IA. `robots.txt` não é mecanismo de segurança; rotas sensíveis continuam dependendo do backend e de tokens.
- Caveat: SEO técnico e structured data não garantem ranking ou aprovação do AdSense. Search Console, sitemap, GA4 Realtime e AdSense precisam de ativação e validação manual nos painéis do Google.
- Verificação: testes Vitest, ESLint, TypeScript, `docker compose config --quiet`, build Next de produção e curls locais para `/robots.txt`, `/sitemap.xml`, `/ads.txt`, home e `/privacidade`.

## Termos completos e navegação legal

- Data: 2026-08-25
- Decisão: ampliar `/termos` e `/privacidade` para documentar que o EvoCine intermedeia comercialmente a venda/liberação de acesso e não desenvolve, mantém, opera tecnicamente ou controla o aplicativo, catálogo, canais, transmissões ou conteúdos de terceiros.
- UI: centralizar os três itens da faixa de confiança com `.trust-strip__title`, mover `Termos` para o menu principal da home, deixar o rodapé da home sem link legal visível e usar linhas de rodapé full-width. As páginas legais usam `LegalNavigation` full-width com `Termos` e `Privacidade` e `LegalFooter` full-width com ambos os links.
- Verificação: testes de navegação legal e menu principal, suíte Vitest, ESLint, TypeScript, build Next e screenshots Playwright locais da home e da página de termos.

## Hero em slides e redução de JS/imagens

- Data: 2026-08-25
- Decisão: substituir o hero estático por slides WebP otimizados derivados de `Downloads/sitepics`, mantendo somente a primeira imagem como recurso de alta prioridade e montando as demais somente após o carregamento inicial para evitar downloads simultâneos no LCP. Screenshots `showcase` e `device-progress` permanecem em WebP, recomprimidos para uso como miniaturas.
- Performance: remover GSAP de `ProductShowcase` e `DeviceScrollStory`, usando transform/opacity nativos com CSS transitions para reduzir JavaScript inicial e parse de chunks apontado pelo trace/Lighthouse.
- Agentic browsing: atualizar `llms.txt` com H1 e links públicos para home, termos, privacidade, sitemap e robots.
- Verificação: análise do trace local anexado, testes Vitest, ESLint, TypeScript, build Next e screenshots Playwright locais confirmando hero carregado e primeira imagem da seção de dispositivos renderizada.

## Proxy HTTPS Caddy no EC2

- Data: 2026-08-25
- Decisão: manter `docker-compose.yml` como base local/produção interna e adicionar `docker-compose.ec2.yml` para o EC2, com serviço `caddy` usando a imagem oficial `caddy:2-alpine`.
- Roteamento: `evocine.tech` faz proxy para `evocine-front:3000`, `api.evocine.tech` faz proxy para `evocine-api:10000` e `www.evocine.tech` redireciona permanentemente para o domínio raiz.
- Persistência: certificados e estado do Caddy ficam em volumes nomeados `caddy-data` e `caddy-config`; esses volumes não devem ser removidos como cache.
- Operação: no EC2, usar `docker compose -f docker-compose.yml -f docker-compose.ec2.yml ...`; o comando com apenas `docker-compose.yml` não contém serviço `caddy`.
- Requisitos externos: Security Group precisa liberar TCP 80/443 e o DNS de `evocine.tech`, `www.evocine.tech` e `api.evocine.tech` deve apontar para o Elastic IP.
