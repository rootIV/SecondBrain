# Docker

Relacionado: [[LotoJogo - MOC]], [[Backend]], [[Frontend]], [[Auth]].

## Compose de desenvolvimento

Arquivo:

```text
docker-compose.dev.yml + .env.development.example
```

Servicos:

- `db`: MySQL 8.0.
- `db-slave`: MySQL 8.0 read-only para consultas do backend.
- `api-dev`: backend ASP.NET Core com `dotnet watch` em `http://localhost:5176`.
- `frontend-dev`: Vite em `http://localhost:5173`.

Uso local:

```bash
copy .env.development.example .env.development
docker compose -f docker-compose.dev.yml --env-file .env.development up -d --build
```

O compose de desenvolvimento e separado do compose de producao. Caddy, API de producao e frontend de producao nao sobem no desenvolvimento.

## Rede Docker/WSL no Windows

Em 2026-08-01, o ambiente Windows foi ajustado porque abrir o Docker Desktop podia conflitar com redes/drive de rede:

- `C:\Users\root4\.docker\daemon.json` fixa o `docker0` em `10.240.0.0/24` via `bip: 10.240.0.1/24`.
- O mesmo `daemon.json` define `default-address-pools` em `10.241.0.0/16` com redes `/24`; o compose `lotojogo_default` foi recriado em `10.241.0.0/24`.
- `C:\Users\root4\.wslconfig` define `networkingMode=mirrored`, `dnsTunneling=true`, `autoProxy=true` e `firewall=false`.
- Verificacao local: `wsl -d docker-desktop -- wslinfo --networking-mode` retornou `mirrored`; `docker network inspect bridge lotojogo_default` retornou `bridge 10.240.0.0/24` e `lotojogo_default 10.241.0.0/24`; portas `127.0.0.1:3306` e `127.0.0.1:5173` responderam.
- Atualizacao em 2026-08-08: o Hyper-V firewall do WSL mirrored ficou com inbound padrao `Block` e sem regras para `5173`/`5176`, fazendo containers saudaveis nao responderem via `localhost`. Como criar `New-NetFirewallHyperVRule` exigiu admin, o workaround local foi trocar `.wslconfig` para `firewall=false`, reiniciar Docker Desktop/WSL e subir `docker compose -f docker-compose.dev.yml --env-file .env.development up -d`.
- Atualizacao em 2026-08-08: `lotojogo-api-dev-1` podia sair com `MySqlConnector.MySqlException: Unable to connect to any of the specified MySQL hosts` apos restart do Docker/WSL. Causa: `Program.cs` usava `ServerVersion.AutoDetect(connectionString)`, que abre conexao durante a resolucao do DbContext, antes de qualquer retry; se o MySQL ainda estivesse aceitando conexoes parcialmente, a API encerrava. Fix: usar `MySqlServerVersion(new Version(8, 0, 0))`, `EnableRetryOnFailure` nos dois DbContexts e `restart: unless-stopped` para `api-dev`/`frontend-dev` no compose dev.

Caveat: se uma VPN/NAS/drive de rede tambem usar `10.240.0.0/16` ou `10.241.0.0/16`, trocar essas faixas por outro bloco livre e recriar as redes Docker.

## SonarQube local

Arquivo:

```text
docker-compose.sonar.yml
```

Compose project name: `lotojogo-sonar`.

Servicos:

- `sonarqube`: SonarQube Community Build atual em `http://localhost:9000`.
- `sonar-db`: PostgreSQL 16 dedicado ao SonarQube.

Uso local:

```powershell
.\scripts\sonar-up.ps1
```

O compose do SonarQube e separado do compose da aplicacao para manter analise de qualidade isolada de dev/prod. O servidor usa volumes Docker persistentes para banco, dados, extensoes e logs. Nao usar `docker compose -f docker-compose.sonar.yml down -v` se quiser preservar usuarios, tokens e historico.

Imagem: `sonarqube:community`. Nao usar `sonarqube:lts-community` para este fluxo local porque em 2026-06-07 ela subiu `9.9.8.100196`, que o painel marca como antiga. Como migrar diretamente de `9.9.8` para `26.6.0` falhou com exigencia de passar antes por `25.12`, o compose usa project name separado para criar volumes novos no fluxo local.

Fluxo de analise:

- Criar token em `My Account > Security` no SonarQube.
- Exportar `SONAR_TOKEN`.
- Rodar `.\scripts\sonar-scan.ps1`.

Ver tambem [[Tests]].

## API watch

- `api-dev` define o entrypoint da API como `dotnet watch --project /app/lotojogo-api.csproj run --no-launch-profile`.
- `Dockerfile.dev` tambem usa o mesmo comando como fallback da imagem.
- `lotojogo-api.sln` referencia a API e os testes, mas o compose da API monta seletivamente apenas os diretórios/arquivos da API em `/app`.
- `Dockerfile.dev` remove `lotojogo-api.sln` da imagem base para evitar que `dotnet watch` tente resolver `../lotojogo-tests` dentro do container.
- Testes xUnit podem ser rodados no host pela solution ou pelo projeto `[[Tests]]`.

## Variaveis relevantes

API:

- `ASPNETCORE_ENVIRONMENT=Development` no compose dev; `Production` no compose de deploy.
- `ASPNETCORE_URLS=http://+:5176` no compose dev; `http://+:8080` no compose de deploy.
- `ConnectionStrings__DefaultConnection=server=db;port=3306;database=lotojogo;...`
- `ConnectionStrings__ReadOnlyConnection=server=db-slave;port=3306;database=lotojogo;...`
- `AllowedOrigins__0=http://localhost:5173`
- `Jwt:Key` deve vir de Docker secret ou gerenciador externo.
- `Seed__AdminEmail` e `Seed__AdminPassword` sao obrigatorios em producao.
- `DataProtection__KeyPath=/var/lib/lotojogo/keys` em producao.
- `RateLimit__AuthPermitLimit` e `RateLimit__AuthWindowSeconds` ajustam o rate limit de login/register/refresh/Google.

Frontend:

- `VITE_API_BASE_URL=http://localhost:5176`
- Em producao, `VITE_API_BASE_URL` fica vazio para usar mesma origem via Nginx.
- `VITE_GOOGLE_CLIENT_ID` e publico, mas deve ser configurado por ambiente.

## Arquivos da raiz Docker

- `docker-compose.dev.yml`: MySQL master/slave, API com `dotnet watch` e Vite.
- `docker-compose.prod.yml`: MySQL master/slave, API publicada, frontend Nginx e Caddy em `80/443`.
- `.env.development.example`: variaveis nao sensiveis para desenvolvimento.
- `.env.production.example`: variaveis nao sensiveis para producao.
- `secrets/*.txt`: arquivos de segredo montados via Docker secrets; no repo local ficam vazios e devem ser preenchidos no EC2.
- `docker/caddy/Caddyfile`: TLS para `SITE_DOMAIN` e redirect permanente de `www.${SITE_DOMAIN}`.
- `docker/mysql/master/init/01-create-replication-user.sh`: cria usuario de replicacao no master.
- `docker/mysql/slave/init/01-start-replication.sh`: configura replica via GTID.

## Compose de producao

Arquivo:

```text
docker-compose.prod.yml
```

Decisoes atuais:

- Build da API usa `./lotojogo-api`.
- `lotojogo-api/Dockerfile` publica explicitamente `lotojogo-api.csproj`; nao deve publicar a solution dentro da imagem porque `lotojogo-api.sln` referencia `../lotojogo-tests`, que fica fora do build context.
- Build do frontend usa `./lotojogo`.
- MySQL de producao usa `db` como master e `db-slave` como replica read-only para consultas.
- Master `db` roda com `server-id=1`, binlog ROW, GTID e usuario de replicacao vindo de `MYSQL_REPLICATION_USER`, com default `lotojogo_replica`.
- Slave `db-slave` inicia com `server-id=2`, relay log e GTID. `read-only` e `super-read-only` sao ativados pelo init script depois de configurar a replicacao; nao devem ficar no command inicial porque bloqueiam o proprio entrypoint do MySQL.
- O init do slave espera conseguir autenticar no master com o usuario de replicacao antes de executar `CHANGE REPLICATION SOURCE TO`; isso evita race condition com o init do master.
- O healthcheck do slave valida `Replica_IO_Running: Yes` e `Replica_SQL_Running: Yes`; a API so sobe depois do slave saudavel.
- MySQL nao publica porta no host; apenas containers da rede Compose acessam `db:3306` e `db-slave:3306`.
- API nao publica porta no host; Nginx do frontend faz proxy para `api:8080`.
- Caddy publica `80` e `443`, emite/renova TLS automaticamente e faz proxy para `frontend:80`.
- Caddy emite TLS para o dominio canonico definido em `SITE_DOMAIN` e para `www.${SITE_DOMAIN}`.
- Requisicoes para `www.${SITE_DOMAIN}` recebem redirect permanente para `https://${SITE_DOMAIN}{uri}`, preservando caminho e query string.
- Frontend Nginx nao publica porta no host em producao; fica acessivel apenas pela rede Compose via Caddy.
- Nginx proxy deve cobrir todos os prefixes de API usados pelo frontend, incluindo `/Generate` e o alias legado `/generate`; sem isso, `POST /generate` cai no fallback estatico e retorna `405 Not Allowed`.
- Nginx preserva `X-Forwarded-Proto` recebido de um proxy/TLS terminator externo; se nao houver header externo, usa o scheme local.
- Volume `mysql_data` persiste o master; volume `mysql_slave_data` persiste o slave.
- Volume `data_protection_keys` persiste chaves do ASP.NET Data Protection usadas por [[TokenProtectorService]] e cookies/tokens protegidos.
- Volumes `caddy_data` e `caddy_config` persistem certificados TLS e estado do Caddy.
- A API roda como usuario nao-root dentro da imagem final.
- O compose exige `.env` de producao com valores nao sensiveis e caminhos de secrets.
- Segredos de producao ficam em arquivos montados como Docker secrets: senhas MySQL, connection strings, JWT key, senha admin e Google Client Secret.
- O compose de producao usa `ConnectionStrings__DefaultConnection_FILE`, `ConnectionStrings__ReadOnlyConnection_FILE`, `Jwt__Key_FILE`, `Seed__AdminPassword_FILE` e `Google__ClientSecret_FILE`, que sao lidos por `FileBackedSecretConfiguration`.

## Deploy EC2

Pre-requisitos:

- Dominio apontando para o IP publico do EC2 para deploy seguro com HTTPS.
- Security Group liberando apenas `22`, `80` e `443`; nao abrir `3306` publicamente.
- Arquivo `.env` criado no servidor a partir de `.env.production.example`, sem commitar.

Fluxo recomendado:

```bash
sudo apt update
sudo apt install -y docker.io docker-compose-plugin git
sudo usermod -aG docker ubuntu
```

Depois de reconectar no SSH e apontar o DNS para o EC2 novo:

```bash
git clone <repo-url> lotojogo
cd lotojogo
cp .env.production.example .env.production
nano .env.production
mkdir -p secrets
```

Para gerar segredos no servidor:

```bash
openssl rand -hex 16      # 32 caracteres; usar para senhas MySQL, incluindo replicacao
openssl rand -base64 64   # usar para JWT_KEY
```

Arquivos de secrets esperados pelo `.env.production.example`:

```text
secrets/mysql_password.txt
secrets/mysql_root_password.txt
secrets/mysql_replication_password.txt
secrets/default_connection.txt
secrets/readonly_connection.txt
secrets/jwt_key.txt
secrets/admin_password.txt
secrets/google_client_secret.txt
```

`default_connection.txt` deve apontar para `db`; `readonly_connection.txt` deve apontar para `db-slave`. Ambos devem usar a senha de `secrets/mysql_password.txt`.

`mysql_replication_password.txt` deve ter no maximo 32 caracteres por limite do MySQL em `CHANGE REPLICATION SOURCE TO`. Usar `openssl rand -hex 16` evita caracteres problemáticos e gera exatamente 32 caracteres.

Subir producao:

```bash
docker compose -f docker-compose.prod.yml --env-file .env.production config
docker compose -f docker-compose.prod.yml --env-file .env.production up -d --build
docker compose -f docker-compose.prod.yml --env-file .env.production ps
docker compose -f docker-compose.prod.yml --env-file .env.production logs -f caddy api
```

Atualizar depois de novas modificacoes Docker:

```bash
git pull
docker compose -f docker-compose.prod.yml --env-file .env.production up -d --build --force-recreate
```

Verificacao local em 2026-07-16:

- `docker compose -f docker-compose.dev.yml --env-file .env.development.example config` passou.
- `docker compose -f docker-compose.prod.yml --env-file .env.production.example config` passou.
- Builds Docker nao foram executados porque o Docker daemon/Desktop nao estava ativo no Windows (`failed to connect to the docker API at npipe:////./pipe/dockerDesktopLinuxEngine`).

DNS Hostinger observado em 2026-07-16:

- Registro `A @` estava apontando para `18.231.198.237`, IP do EC2 antigo.
- Novo EC2 observado: `18.228.48.86`.
- Preferencia operacional: associar um Elastic IP ao EC2 novo e apontar `A @` para esse Elastic IP; se nao usar Elastic IP, apontar `A @` para `18.228.48.86`.
- `CNAME www -> lotojogo.com.br` pode permanecer.

## Auth e Docker

Como cookies sao usados no auth, CORS e `credentials: include` precisam continuar alinhados:

- backend permite credenciais em `AllowFrontEnd`;
- frontend usa `credentials: include` em [[ApiService Frontend]].
- em producao, cookies `Secure` exigem HTTPS no navegador; usar apenas `http://IP` permite smoke de pagina publica, mas nao e deploy de auth seguro.

## Checklist de producao segura

Configuracao esperada:

```env
COMPOSE_PROFILES=prod
SITE_DOMAIN=seudominio.com
TLS_EMAIL=admin@seudominio.com
FRONTEND_URL=https://seudominio.com
AUTH_RATE_LIMIT_PERMIT=5
AUTH_RATE_LIMIT_WINDOW_SECONDS=60
```

Antes de considerar o deploy pronto para usuarios reais:

- Configurar dominio e TLS; `FRONTEND_URL` deve usar `https://`.
- Garantir que `SITE_DOMAIN` aponte para o mesmo dominio de `FRONTEND_URL`.
- Se TLS terminar fora do container, o proxy externo precisa enviar `X-Forwarded-Proto: https`.
- Usar cookies `Secure` e `SameSite=Strict`; auth por `http://IP` nao e suportado em producao.
- Manter `AUTH_RATE_LIMIT_PERMIT` e `GENERATE_RATE_LIMIT_PERMIT` em valores conservadores.
- Rotacionar `JWT_KEY`, senhas MySQL, senha admin e Google Client Secret que tenham sido usados durante MVP/testes.
- Manter segredos sensiveis em Docker secrets ou migrar para AWS Secrets Manager, AWS SSM Parameter Store ou outro gerenciador equivalente. O `.env` deve guardar apenas caminhos/valores nao sensiveis e nunca ser versionado.
- Confirmar que Security Group nao expoe `3306` e que SSH fica restrito ao IP do operador.
- Recriar containers com `docker compose up -d --build --force-recreate` apos mudar as variaveis.
- Depois de alterar o `Caddyfile`, recriar ao menos o servico com `docker compose -f docker-compose.prod.yml --env-file .env.production up -d --force-recreate caddy` e verificar `docker compose -f docker-compose.prod.yml --env-file .env.production logs --since 10m caddy`.
- Validar que `https://www.${SITE_DOMAIN}/login?next=%2Fdashboard` negocia TLS e redireciona para `https://${SITE_DOMAIN}/login?next=%2Fdashboard`.

## Replicacao MySQL em dev

- `db` roda com `server-id=1`, binlog, GTID e cria o usuario `replica`.
- `db-slave` roda com `server-id=2`, relay log e GTID.
- `read-only` e `super-read-only` nao ficam no comando inicial do container porque isso bloqueia o entrypoint oficial de criar `MYSQL_DATABASE`.
- `db-slave` nao define `MYSQL_DATABASE`, `MYSQL_USER` ou `MYSQL_PASSWORD`; o schema `lotojogo` e o usuario `vitor` chegam pela replicacao do master.
- O script `docker/mysql/slave/init/01-start-replication.sh` configura `CHANGE REPLICATION SOURCE TO` apontando para `db` com `SOURCE_AUTO_POSITION=1`.
- A API escreve no master e usa `db-slave` para leituras read-only por `ReadOnlyConnection`.
- Para acessar o slave pelo MySQL Workbench no host, usar porta `3308`; dentro do compose a API continua usando `db-slave:3306`.
- A API deve configurar EF com `MySqlServerVersion(new Version(8, 0, 0))` em vez de `ServerVersion.AutoDetect(connectionString)` no startup; `AutoDetect` abre conexao durante a montagem do service provider e pode derrubar `lotojogo-api-dev-1` se o MySQL ainda estiver aceitando conexoes de forma instavel.

## Replicacao MySQL em producao

- `docker-compose.prod.yml` tambem sobe `db` e `db-slave`.
- `ConnectionStrings__DefaultConnection` aponta para `db`; `ConnectionStrings__ReadOnlyConnection` aponta para `db-slave`.
- `db-slave` nao define `MYSQL_DATABASE`, `MYSQL_USER` ou `MYSQL_PASSWORD`; schema e usuario chegam pela replicacao do master.
- A senha de replicacao nao fica hardcoded; usar o Docker secret `mysql_replication_password` ou um gerenciador de segredos equivalente.
- `mysql_replication_password` deve ter no maximo 32 caracteres; `openssl rand -base64 32` gera cerca de 44 caracteres e nao serve para esse secret.
- Scripts em `docker/mysql/*/init` rodam somente em volumes novos. Em servidor existente, recriar volumes apenas depois de backup, ou aplicar manualmente os comandos equivalentes.
