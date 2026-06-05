# Docker Skill

Relacionado: [[Second Brain - MOC]], [[Knowledge Operating Model]], [[Docker]].

## Uso neste Second Brain

Docker aparece principalmente como infraestrutura local e deploy dos projetos .NET/React/MySQL.

## Regras praticas

- Nao commitar segredos em `.env`, compose ou appsettings.
- Usar Docker secrets ou gerenciador externo para senhas, JWT keys e client secrets.
- Separar compose de desenvolvimento e producao por profiles ou arquivos claros.
- Em producao, publicar somente portas necessarias e manter banco fora da exposicao publica.
- Persistir volumes de banco e chaves de Data Protection quando cookies/tokens protegidos dependem delas.

## Aplicacao por projeto

- LotoJogo: ver [[Docker]], [[Auth]], [[Known Issues]].
- Consent: ver [[03 - Arquitetura e stack]] e [[05 - Segurança e privacidade]].

## Checklist rapido

- `docker compose config` antes de subir ambiente.
- Healthchecks para servicos criticos.
- HTTPS real quando cookies `Secure` forem obrigatorios.
- Rotacao de credenciais quando segredo tiver sido exposto localmente ou em commit.
