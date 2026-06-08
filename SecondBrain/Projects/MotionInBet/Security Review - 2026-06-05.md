---
tags:
  - motioninbet
  - review
  - security
  - risk
updated: 2026-06-05
---

# Security Review - 2026-06-05

Review completo feito em 2026-06-05 com apoio de Graphify e verificacoes locais.

## Contexto do owner

Em 2026-06-05, o owner confirmou que os seguintes pontos sao atalhos conscientes para ganhar agilidade em testes e serao corrigidos futuramente:

- token vazio / abertura rapida do bot;
- uso de `_userLoginPreset` no fluxo atual;
- `ValidateAudience = false`;
- logs de token/payload;
- preco de teste;
- webhook sem validacao completa.

Esses itens devem ser tratados como debito tecnico aceito para ambiente de teste, nao como comportamento desconhecido. Ainda precisam de guardrail para nao chegar a producao sem revisao: idealmente uma flag de ambiente, checklist de release ou bloqueio de deploy.

## Achados criticos

### Segredos reais versionados

Arquivos:

- `motioninbet-api/appsettings.json`
- `motioninbet-bot/config.json`

Problemas:

- Connection string MySQL com usuario e senha.
- Senha de email.
- Access token Mercado Pago.
- Chave JWT estatica.

Impacto:

- Qualquer pessoa com acesso ao repo pode acessar banco, email e gateway de pagamento.
- Mesmo que os arquivos sejam removidos depois, os segredos devem ser considerados comprometidos se ja foram commitados.

Acao recomendada:

- Rotacionar todos os segredos imediatamente.
- Remover segredos do historico se o repo for compartilhado.
- Usar variaveis de ambiente, user-secrets local e provedor de secrets em deploy.

### Bot ignora login ao carregar

Arquivo:

- `motioninbet-bot/FormLogin.cs`

Status:

- Atalho temporario aceito para teste.

Problema:

- No `FormLogin_Load`, o bot cria `FormMain` com token vazio, chama `Show()` e esconde o login antes de validar usuario/senha.

Impacto:

- A aplicacao pode abrir o fluxo principal sem autenticacao efetiva.
- Qualquer controle de plano baseado apenas em UI fica contornavel.

Acao recomendada:

- Remover abertura automatica de `FormMain` no load.
- Validar token antes de abrir o fluxo principal.
- Tratar token ausente como estado nao autenticado.

### Token inconsistente no bot

Arquivo:

- `motioninbet-bot/FormLogin.cs`

Problema:

- Apos login, o codigo salva `_userLoginPreset.Token = result.Token` somente se `StayLogged` estiver marcado.
- Em seguida usa `_userLoginPreset.Token` para `serialkey/status`, mesmo quando `StayLogged` nao esta marcado.

Impacto:

- Login valido pode falhar na verificacao de plano.
- Token antigo pode ser reutilizado por engano.

Acao recomendada:

- Usar `result.Token` diretamente na sessao atual.
- Persistir token apenas quando necessario e com protecao adequada.
- Antes de producao, remover dependencia do preset para autorizacao da sessao corrente.

### Webhook de pagamento sem validacao de origem

Arquivo:

- `motioninbet-api/Controllers/PixController.cs`

Problema:

- O webhook aceita qualquer POST publico.
- A protecao depende de consultar o pagamento no Mercado Pago, mas nao ha validacao de assinatura/origem do webhook nem idempotencia robusta por `paymentId`.

Impacto:

- Endpoint pode ser abusado para causar chamadas externas, logs e carga no servidor.
- Ha risco operacional se a regra de idempotencia for quebrada.

Acao recomendada:

- Validar assinatura/cabecalhos do Mercado Pago.
- Persistir `paymentId` processado em campo proprio.
- Usar transacao de banco ao criar/renovar serial key.
- Manter como pendencia obrigatoria antes de producao.

## Achados altos

### Precos divergentes entre API e website

Arquivos:

- `motioninbet-api/Controllers/PixController.cs`
- `motioninbet-website/src/pages/price.tsx`
- `motioninbet-website/src/pages/status.tsx`

Problema:

- API usa `1dia => 0.01`.
- Website exibe `1 Dia` como `R$50,00`.
- O owner confirmou que o valor atual e intencional para acelerar testes.

Impacto:

- Usuario ve um valor e paga outro.
- Pode haver compra indevida de plano por valor de teste em producao.

Acao recomendada:

- Centralizar catalogo de planos no backend.
- Website deve buscar planos da API, nao duplicar valores.
- Remover valores de teste de producao.

### JWT com validacao de audiencia desativada

Arquivo:

- `motioninbet-api/Program.cs`

Problema:

- `ValidateAudience = false`.
- Comentario indica estado temporario de teste.
- O owner confirmou que a desativacao e intencional para teste.

Impacto:

- Tokens emitidos para outro publico podem ser aceitos.

Acao recomendada:

- Reativar `ValidateAudience = true`.
- Definir `ValidAudience`.
- Falhar startup se configuracao JWT estiver ausente.
- Reativar antes de expor ambiente de producao.

### Logs expoem tokens e payloads sensiveis

Arquivos:

- `motioninbet-api/Program.cs`
- `motioninbet-website/src/pages/login.tsx`
- `motioninbet-website/src/pages/status.tsx`
- `motioninbet-api/Controllers/PixController.cs`

Problema:

- API loga header Authorization.
- Frontend loga token recebido.
- Status loga token enviado.
- Webhook loga payload/resposta completa do Mercado Pago.
- O owner confirmou que os logs sao intencionais para depuracao agora.

Impacto:

- Tokens e dados financeiros podem vazar em logs de producao, browser ou monitoramento.

Acao recomendada:

- Remover logs de token/payload sensivel.
- Usar logs estruturados com mascaramento.
- Condicionar logs sensiveis a ambiente local e nunca habilitar em producao.

### Credenciais locais usam AES com chave e IV fixos

Arquivo:

- `motioninbet-bot/Helpers/FileHelper.cs`

Problema:

- Chave e IV estaticos hardcoded.
- IV fixo elimina seguranca semantica.

Impacto:

- Qualquer pessoa com binario/codigo consegue descriptografar presets.

Acao recomendada:

- Usar DPAPI/ProtectedData no Windows para usuario/machine local.
- Evitar persistir senha bruta.

## Qualidade e manutencao

- API compila, mas `MailKit 4.13.0` possui vulnerabilidade moderada reportada por NuGet.
- Bot compila com warnings em `AccountCreateService.cs` e `FormMain.cs`.
- Website compila, mas `npm run lint` falha com 7 erros.
- `npm audit` reportou 10 vulnerabilidades: `ajv`, `brace-expansion`, `flatted`, `immutable`, `js-yaml`, `minimatch`, `picomatch`, `postcss`, `rollup`, `vite`.
- Sass emite muitos avisos de depreciacao por `@import` e funcoes globais.

## Verificacoes executadas

- `graphify update .`
- `graphify codex install`
- `dotnet build motioninbet-api\beetomation-api.sln`
- `dotnet build motioninbet-bot\beetomation-form.sln`
- `npm install`
- `npm run build`
- `npm run lint`
- `npm audit --audit-level=moderate`
