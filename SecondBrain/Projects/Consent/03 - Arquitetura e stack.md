# Arquitetura e stack

## Direção geral

Seguir o padrão arquitetural já usado no projeto e documentado no repositório. O backend mantém fronteiras claras entre Controllers, Services, Repositories e Database. O frontend organiza a aplicação por app, páginas, módulos, componentes, hooks, serviços, tipos e estilos.

## Frontend

Stack:

- React
- TypeScript
- Vite
- React Router
- React Query
- Axios
- React Hook Form
- Zod
- SCSS
- lucide-react

Estrutura:

- `src/app`: providers e wiring da aplicação
- `src/pages`: telas de rota
- `src/modules`: módulos de negócio
- `src/components`: componentes compartilhados
- `src/hooks`: hooks compartilhados
- `src/services`: clientes HTTP tipados
- `src/types`: contratos TypeScript
- `src/utils`: utilitários
- `src/styles`: tokens e estilos globais

## Backend

Stack:

- .NET 8
- ASP.NET Core
- Entity Framework Core
- MySQL preparado
- EF Core InMemory para desenvolvimento e testes
- ASP.NET Identity
- JWT Bearer

Camadas:

- Controllers: expõem APIs versionadas e retornam DTOs.
- Services: concentram regras de negócio, validações, transições de status e eventos.
- Repositories: persistência, queries e comandos de banco.
- Data: DbContext e configuração EF.
- Entities: modelo persistido.
- DTOs: contratos públicos.

## Convenções de API

- Rotas públicas em `/api/v1`.
- DTOs obrigatórios.
- Entidades EF nunca devem sair diretamente pela API.
- Mutations auditáveis devem gerar evento.
- Soft delete deve esconder registros das leituras padrão.

## Graphify

O grafo local encontrou o núcleo atual em:

- `Agreement`
- `AgreementsService`
- `AgreementsController`
- `IAgreementsService`
- `AgreementRepository`
- `AuditableEntity`
- tipos frontend de `agreement.ts`
- `agreementsApi.ts`
- `useAgreements.ts`

Após mudanças estruturais, atualizar com:

```powershell
python -m graphify update . --force
```

