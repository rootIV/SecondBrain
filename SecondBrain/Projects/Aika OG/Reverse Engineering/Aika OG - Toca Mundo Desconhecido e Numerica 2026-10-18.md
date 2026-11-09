# Aika OG - Toca Mundo Desconhecido e Numerica 2026-10-18

Estado: ativado em18/out; renderização e diálogos no jogo pendentes do operador. Fonte atual: `C:/Projetcts/aika-og`.

## Atualização posterior: retirada da numérica

O operador solicitou remover a numérica por mau funcionamento. A imagem da recusa mostra o final do anúncio genérico “Verifique a senha numérica, desconecte o personagem e saia da guilda”. Consulta ao ADMIN confirmou guildIndex0, nenhum vínculo guild_storage_members, zero erros e nenhum hash: a recusa era PIN não cadastrado, não guilda. Não inferir guilda pelo texto dessa versão.

Verificação da retirada:1069 testesGS aprovados,10 condicionais ignorados,29 focados sem falha; três publicações conferidas. Ativado após encerramento real do GameServer59324 (primeira tentativa bloqueada corretamente). Backup SQL8973715bytes+3bins em artifacts/remove-numeric-20261018/backup-20261018-114426; nenhuma migração/reset. GameServer15640 iniciado com quatro listeners; hashes/activation.json/runtime-check.json conferidos, Studio fechado. ADMIN continua intacto sem guilda e sem hash. Gameplay visual pendente.

PIN/hash/cadastro/lock foram retirados do fluxo ativo e das dependências de schema. Campos antigos e tabela instalada preservados sem uso; não houve DROP/reset. Lobby901/336 bytes zera flags de numérica. Login F02 mantém conta/slot/reload/exclusividade, sem PIN. Exclusão3F33/24step7 usa confirmação nativa, retorna lista901;603/28 antigo não exclui. Resultado específico de guilda só para guildIndex/vínculo real. Exclusão lógica/gate/transação/ownership/online preservados. Novos testes cobrem contrato sem PIN, guilda real, rollback/concorrrência/inventário. Referência atual: `docs/operations/REMOVE-NUMERIC-2026-10-18.md`; logs/ativação em `artifacts/remove-numeric-20261018`. As seções abaixo são históricas da implementação retirada; Toca/quest84 continuam vigentes.

## Contratos confirmados

- Toca277 tem quatro diárias2575–2578 classificadas incorretamente pelo importador com Mark8. Override verificado Mark11 no catálogo e importador, sem inferir classificação global dos campos1244/1246. Trocas continuam read-only: consumo gold tipo15 não suportado.
- Quest84 Mundo Desconhecido nível1: Clair2112 → Catharina2113, Conversar1 → Clair2112; diálogos624/626/627,50XP/75gold. Override em VerifiedQuests, não habilitação genérica de Type19. Só abrir menu não progride; recompensa única e rollback SQL testados.
- Cliente SHA256e1104cbb8d313ec9b07e18c5529ac6865d1eda92e429355185617a4f805ff002 contém rotinas de numérica/exclusão. FUN005bd640:603/28B,açãoDWORD20=0 confirma/1 cancela; servidor invertia. FUN005bf790/850: F02/32B,slot12/request16/PIN20. NumRegister=byte97 da linha104. Login servidor ignorava numérica; referência Delphi também fazia Exit antes da validação.
- FUN005c0350: resultado0 abre PIN,1 código existente,3 mensagemPvP. FUN005ae9c0 trata984/flag16 na seleção7533: hipótese inicial de que seleção ignorava984 foi descartada. Nenhum patch do cliente ou exclusão real feito. REA estático não comprova execução visual.

## Implementação e verificação

Nova tabela character_numeric_credentials: PBKDF2-SHA256600000,salt16/hash32. Hash autoritativo; legacy correto migra+apaga texto na mesma transação, sem reset. ProbesNUL não contam como PIN0000 nem aumentam erros. Gate+FORUPDATE serializam cadastro/erros/exclusão, bloqueio em3erros. Request2 alteraçãoPIN permanece fora de escopo. Exclusão lógica preservada, conta/slot/guilda/online/intenção pendente verificados. Writer plaintext morto removido.

1092 testesGS passaram,10 condicionais ignorados,3Python passaram. SQL isolado cobre concorrência, rollback/retry/hashautoritativo e missão84. Backup8972549bytesSQL+3bins+Quest em `artifacts/quest-dialog-delete-20261018/backup-20261018-111929`; migração aditiva2execuções, hashes/API/startup conferidos. GameServer59680/Studio52248. TestMode continua false; apenas explicado como ligar pelo Studio, não alterado.

Docs: `docs/operations/RELEASE-QUESTS-NUMERIC-2026-10-18.md`, `docs/reverse-engineering/NUMERIC-DELETE-2026-10-18.md`; evidência sete rotinas `artifacts/quest-dialog-delete-20261017/deletion-native-selected.json`. Rollback para servidor antigo é inadequado após migrar hashes: antigo ignora hash e continha bypass. Preferir correção para frente.

Relacionados: [[Aika OG - Progressao Pran e Retornos 2026-10-17]], [[Aika OG - Missoes Mapa e Nivel 2026-10-17]], [[Aika OG - MOC]].
