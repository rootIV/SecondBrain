---
title: Strategy Optimization Entitlements
tags:
  - lotojogo
  - backend
  - strategies
  - auth
updated: 2026-08-08
---

# Strategy Optimization Entitlements

Relacionado: [[LotteryStrategies]], [[LotteryDraws]], [[GenerateService]], [[LoteService]], [[DTOs]], [[Tests]].

## Decisão de plano no servidor

- `UserPlan` é `Basic`, `Pro` ou `Bolao`; `UserRole` é `User` ou `Admin`.
- O JWT carrega plano e role, mas a decisão sensível recarrega o usuário persistido. O cliente não informa o plano na sugestão ou geração.
- `GET /Account/entitlement` informa a interface. `PUT /Admin/users/{id}/plan` e `POST /Admin/lottery-draws/import-caixa` exigem `Admin`.
- Básico recebe sugestões `random`; Pro e Bolão recebem `historical`, calculadas sobre todos os concursos importados. A interface comunica o modo, sem prometer previsão ou prêmio.
- `most_frequent` e `less_frequent` são negadas no backend para Basic, inclusive em `/Generate` e regeneração. Para Pro/Bolão, o ranking é resolvido do histórico no serviço, não aceito como autoridade do cliente.

## Geração e capacidade

- Uma solicitação é pré-validada e persiste todas as apostas únicas ou falha antes de criar o lote; não há resposta parcial.
- `poolSize` significa combinações possíveis, inclusive estruturas especiais.
- A geração usa orçamento cooperativo de três segundos. Espaços que não possam ser verificados dentro do orçamento retornam limite operacional explícito, não uma combinação inválida.
- Aposta manual precisa ter a cardinalidade declarada e os dados da modalidade; não é permitido usar uma lista curta para contornar a validação.

## Modalidades especiais

- Super Sete usa sete colunas de dígitos `0..9`. As APIs preservam `numbers` por compatibilidade e acrescentam `columns`; cada coluna tem 1–3 dígitos, com a distribuição permitida pelo total de 7–21.
- +Milionária preserva `numbers` de 1–50 e acrescenta exatamente dois `trevos` distintos de 1–6. A capacidade considera os 15 pares de trevos.
- Leitura de lotes legados cujo `NumbersJson` é somente um array continua suportada.

## Histórico CAIXA

- O seed versionado contém amostras oficiais e o importador administrativo busca intervalos explicitamente solicitados; a aplicação não acessa a rede no startup.
- As URLs são configuráveis com `OfficialCaixa:SuperSeteContestUrlTemplate` e `OfficialCaixa:MaisMilionariaContestUrlTemplate`, usando `{contest}`. O importador é idempotente por `game_type + contest_number + draw_order` e invalida o cache histórico após inserir dados.
- No Super Sete, `columns` é normalizado para códigos posicionais de coluna+dígito antes de produzir ranking histórico.

## Verificação

- Suite local backend: `dotnet test lotojogo-api.Tests/lotojogo-api.Tests.csproj --no-restore`.
- Frontend: `npm.cmd run build`.
- A matriz e a categoria `Stress` devem cobrir modalidades, quantidades, planos, capacidade e formatos especiais antes de integrar mudanças estruturais.

## Capacidade exata de estratégias

- `StrategyCapacityCalculator` é a fonte única para capacidade de estratégias e filtros combinados. A geração usa esse cálculo antes de criar apostas; `LoteService` usa o mesmo resultado ao montar DTOs.
- `StrategyDto.poolSize` continua existindo como inteiro legado e saturado em `int.MaxValue`. O contrato confiável para UI e clientes novos é `poolSizeExact` (`string` exata), `poolSizeLabel` (formatada para leitura) e `poolSizeIsCapped`.
- Filtros combinados devem ser contados de forma determinística para 0, 1, 2, 3 ou mais combinações, sem retornar `int.MaxValue` como capacidade desconhecida.
- +Milionária multiplica a capacidade das dezenas pelos 15 pares de trevos. Super Sete conta colunas válidas e aplica filtros sobre códigos posicionais coluna+dígito.
- Verificação de 2026-08-08: backend `dotnet test lotojogo-api.Tests\lotojogo-api.Tests.csproj --no-restore --verbosity minimal` passou com 347 testes; frontend `npm.cmd run build` e `npm.cmd run lint` passaram.
