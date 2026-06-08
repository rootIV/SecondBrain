# Docker

Relacionado: [[LotoJogo - MOC]], [[Backend]], [[Frontend]], [[Auth]].

## Compose de desenvolvimento

Arquivo:

```text
docker-compose.yml + .env
```

Servicos:

- `db`: MySQL 8.0.
- `db-slave`: MySQL 8.0 read-only para consultas do backend.
- `api-dev`: backend ASP.NET Core com `dotnet watch` em `http://localhost:5176`.
- `frontend-dev`: Vite em `http://localhost:5173`.

Uso local:

```bash
docker compose --env-file .env up -d --build
```

O `.env` local usa `COMPOSE_PROFILES=dev`, entao Caddy, API de producao e frontend de producao nao sobem no desenvolvimento.

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

## Compose profiles

- `COMPOSE_PROFILES=dev`: sobe `db`, `db-slave`, `api-dev` e `frontend-dev`.
- `COMPOSE_PROFILES=prod`: sobe `db`, `db-slave`, `api`, `frontend` e `caddy`.
- O `.env` da raiz do workspace e de desenvolvimento e nao deve ser usado no EC2.
- O `.env` de producao do EC2 precisa definir `COMPOSE_PROFILES=prod`.

## Compose de producao

Arquivo:

```text
docker-compose.yml
```

Decisoes atuais:

- Build da API usa `./lotojogo-back-end`.
- `lotojogo-back-end/Dockerfile` publica explicitamente `lotojogo-api.csproj`; nao deve publicar a solution dentro da imagem porque `lotojogo-api.sln` referencia `../lotojogo-tests`, que fica fora do build context.
- Build do frontend usa `./lotojogo-front-end`.
- MySQL de producao usa `db` como master e `db-slave` como replica read-only para consultas.
- Master `db` roda com `server-id=1`, binlog ROW, GTID e usuario de replicacao vindo de `MYSQL_REPLICATION_USER`, com default `lotojogo_replica`.
- Slave `db-slave` inicia com `server-id=2`, relay log e GTID. `read-only` e `super-read-only` sao ativados pelo init script depois de configurar a replicacao; nao devem ficar no command inicial porque bloqueiam o proprio entrypoint do MySQL.
- O init do slave espera conseguir autenticar no master com o usuario de replicacao antes de executar `CHANGE REPLICATION SOURCE TO`; isso evita race condition com o init do master.
- O healthcheck do slave valida `Replica_IO_Running: Yes` e `Replica_SQL_Running: Yes`; a API so sobe depois do slave saudavel.
- MySQL nao publica porta no host; apenas containers da rede Compose acessam `db:3306` e `db-slave:3306`.
- API nao publica porta no host; Nginx do frontend faz proxy para `api:8080`.
- Caddy publica `80` e `443`, emite/renova TLS automaticamente e faz proxy para `frontend:80`.
- Frontend Nginx nao publica porta no host em producao; fica acessivel apenas pela rede Compose via Caddy.
- Nginx proxy deve cobrir todos os prefixes de API usados pelo frontend, incluindo `/Generate` e o alias legado `/generate`; sem isso, `POST /generate` cai no fallback estatico e retorna `405 Not Allowed`.
- Nginx preserva `X-Forwarded-Proto` recebido de um proxy/TLS terminator externo; se nao houver header externo, usa o scheme local.
- Volume `mysql_data` persiste o master; volume `mysql_slave_data` persiste o slave.
- Volume `data_protection_keys` persiste chaves do ASP.NET Data Protection usadas por [[TokenProtectorService]] e cookies/tokens protegidos.
- Volumes `caddy_data` e `caddy_config` persistem certificados TLS e estado do Caddy.
- A API roda como usuario nao-root dentro da imagem final.
- O compose exige `.env` de producao com valores nao sensiveis e caminhos de secrets.
- Segredos de producao ficam em arquivos montados como Docker secrets: senhas MySQL, connection strings, JWT key, senha admin e Google Client Secret.

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

Depois de reconectar no SSH:

```bash
git clone <repo-url> lotojogo
cd lotojogo
cp .env.production.example .env
nano .env
mkdir -p secrets
docker compose --env-file .env config
docker compose --env-file .env up -d --build
docker compose ps
docker compose logs -f api
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

## Replicacao MySQL em dev

- `db` roda com `server-id=1`, binlog, GTID e cria o usuario `replica`.
- `db-slave` roda com `server-id=2`, relay log e GTID.
- `read-only` e `super-read-only` nao ficam no comando inicial do container porque isso bloqueia o entrypoint oficial de criar `MYSQL_DATABASE`.
- `db-slave` nao define `MYSQL_DATABASE`, `MYSQL_USER` ou `MYSQL_PASSWORD`; o schema `lotojogo` e o usuario `vitor` chegam pela replicacao do master.
- O script `docker/mysql/slave/init/01-start-replication.sh` configura `CHANGE REPLICATION SOURCE TO` apontando para `db` com `SOURCE_AUTO_POSITION=1`.
- A API escreve no master e usa `db-slave` para leituras read-only por `ReadOnlyConnection`.
- Para acessar o slave pelo MySQL Workbench no host, usar porta `3308`; dentro do compose a API continua usando `db-slave:3306`.

## Replicacao MySQL em producao

- `docker-compose.yml` tambem sobe `db` e `db-slave`.
- `ConnectionStrings__DefaultConnection` aponta para `db`; `ConnectionStrings__ReadOnlyConnection` aponta para `db-slave`.
- `db-slave` nao define `MYSQL_DATABASE`, `MYSQL_USER` ou `MYSQL_PASSWORD`; schema e usuario chegam pela replicacao do master.
- A senha de replicacao nao fica hardcoded; usar o Docker secret `mysql_replication_password` ou um gerenciador de segredos equivalente.
- `mysql_replication_password` deve ter no maximo 32 caracteres; `openssl rand -base64 32` gera cerca de 44 caracteres e nao serve para esse secret.
- Scripts em `docker/mysql/*/init` rodam somente em volumes novos. Em servidor existente, recriar volumes apenas depois de backup, ou aplicar manualmente os comandos equivalentes.
