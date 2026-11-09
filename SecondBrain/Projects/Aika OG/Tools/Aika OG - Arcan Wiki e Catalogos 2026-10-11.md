---
title: Aika OG - Arcan Wiki e Catalogos 2026-10-11
updated: 2026-10-12
tags:
  - aika-og
  - studio
  - catalogos
---

# Aika Arcan e catálogos do Studio

Relacionadas: [[Aika OG - MOC]], [[Aika OG - Aika Studio Web]], [[Aika OG - Studio NPCs e Mobs 2026-10-11]], [[Aika OG - CharacterService]], [[Aika OG - MobService]].

## Contrato vigente em 12/10/2026

- Usuário pediu restaurar todos os atributos/fórmulas antigos de jogadores e usar os drops da wiki com fator 25%. A escolha intermediária de taxas exatas foi substituída explicitamente pelo fator 0,25.
- `mob_drop_profiles` em `localhost:3307 / aikaria` é a única fonte ativa de drops para servidor e Studio. Removido `Data/ArcanMonsters.json` e seu carregamento de mundo. Extração JSON é arquivo de referência para importação, nunca overlay do runtime. Tabelas legadas de drops são histórico; mobs sem perfil ficam sem loot, sem fallback genérico.
- Importação realizada com GameServer parado: 466 perfis armazenados e 363 templates atualizados em HP/EXP/nível/ataques/defesas. Associação `NameValue=intname`. Modelos, geometria, IA, velocidade e respawn preservados. Spawns leem os atributos dos templates SQL, sem reaplicar dados de arquivo.
- Backup: `C:/Projetcts/aika-og/artifacts/studio/drops/20261012-034216-739-arcan-import.json`. Guarda templates/tabelas/perfis anteriores, fator e hash da fonte. Importador: `AikaStudio --import-arcan-wiki <monsters.json>`, com validação, backup, InnoDB e transação.
- Fator aplicado uma única vez na importação: raro 0,1234% vira 0,03085% por abate. Runtime e editor usam taxa efetiva, inclusive decimais. Normais são categóricos e usam soma dos itens como chance geral para preservar marginais exatas: Max Domesticado 12,083225%, devido ao arredondamento da taxa publicada 48,33%. Específicos são independentes; eventos têm rolagem adicional e também recebem fator 0,25.
- Wiki não fornece dependência conjunta dos específicos nem calendário dos eventos; 337 perfis normais são marcados como estimados. Não alegar taxas oficiais OG comprovadas.
- 103 perfis sem modelos locais correspondentes e itens 5595/8739/15300/20635 ausentes continuam pendentes. Não criar/remapear entidades só com MN/MobPos ou CSV incompatível. Item ausente não tem chance redistribuída e não cancela outros vencedores válidos. Inventário usa lote atômico e preserva quantidade integral.
- Bootstrap do catálogo SQL falha em erro de banco, sem substituição silenciosa por arquivos. Importação inicial de arquivos só persiste no SQL antes do carregamento quando habilitada para banco vazio. Textos de diálogos do client mantêm seu fluxo específico anterior.

## Extrações e UI

- `artifacts/reference/arcan-wiki/2026-10-11`: 466 monstros distintos/491 linhas, 1.887 missões distintas/1.888 linhas, 1.707 receitas, 186 famílias de skills/2.666 níveis/6 classes. Manifest com URLs, horários, contagens e hashes de 2.361 arquivos. Missões/receitas/simulador são referência futura, sem regras de gameplay implementadas.
- Itens/skills: ícones de informação acessíveis para 43/37 campos; faixas de armazenamento e significados comprovados. Campos desconhecidos não ganham enums inventados. Itens filtrados por categoria/classe; agrupamento de skills antes da paginação, nome+família de classe, com seletor de nível e índices nativos preservados.
- Drops: UI usa grupos da wiki, aceita decimais, informa modelo/chance geral, backup e conflitos; CSV `chance,itemId,quantity[,group]`. API antiga é bloqueada na tela. Lista vazia não seleciona outra lista.

## Atributos e verificação

- Revertidas apenas as mudanças desta tarefa em CharacterRepository/CharacterCreationService/CharacterStatusService e expectativas dos testes antigos. Valores anteriores para novas classes e movimento 40 restaurados; acerto `Truncate(AGI*0.15)`, esquiva `Truncate(AGI*0.05)`. Personagens já persistidos não foram reescritos. Guardas de regressão cobrem seis classes, recálculo, nível e debuff negativo.
- 49 testes de servidor passaram, incluindo leitura real SQL a 25%, HP/ataques/defesas persistidos, perfis anexados e ausência de entradas legadas. Studio: 66 passaram/4 opt-in ignorados inicialmente; integração de drops depois passou em schema descartável, com valor 0,03085%, backup, conflito e item inválido. Cinco testes CSV, build/lint frontend e build GameServer passaram. UI real confirmou taxa rara, edição decimal/desfazer sem SQL e layout.
- GameServer compilado; gameplay conectado após a mudança não foi validado. Não executar suíte geral de escrita usando o banco operacional. Documentação vigente: `docs/ARCAN-WIKI-IMPORT-2026-10-11.md` e `docs/INITIAL-CLASS-ATTRIBUTES-2026-10-11.md`.

## Histórico substituído

A proposta de 11/10 usava overlay JSON e atributos de jogadores da imagem/wiki. Ambas foram substituídas pelo pedido de 12/10. O diagnóstico inicial de MySQL indisponível também foi resolvido: porta correta 3307 e credenciais locais configuradas; importação e auditoria SQL foram executadas. Não reproduzir instruções de copiar ArcanMonsters.json para AIKA_WORLD_DATA.

## Consolidação e limpeza — 12/10/2026

- xUnit é agora o único runner: cinco projetos console fora da solution/checkout, testes Node/Python/PowerShell separados arquivados. Cobertura de binários migrada para NativeBinaryDocumentTests; CSV, ajuda dos 80 campos, paginação, geometria e rascunhos frontend para FrontendContractTests. Node 24+ apenas avalia os módulos TypeScript; assertivas e execução pertencem ao xUnit.
- Corrigidos os dois casts que falhavam por MySQL: IsolatedGameplayDatabase cria/remove aika_catalog_tests_* e restaura a configuração, sem escrita no banco de operação. Corrigida a restauração no teste de drops após LocalSecretsLoader.
- Perfis SQL rejeitam entradas nulas, eventos em grupos errados e chance geral divergente. Instalação nova inclui mob_drop_profiles via recurso SQL incorporado; install-arcan-drops adiciona a extensão a v1 sem alterar checksum/versão da baseline. Grants novos: jogo SELECT, editor CRUD, sem DDL de runtime. Importador reutiliza a instalação.
- Verificação: GameServer completo 546 passou/2 opt-in ignorados; schema/grants 2 passaram separadamente; Studio 93 passou/1 opt-in ignorado, criação de contas depois habilitada; Token 5; MasterTool 21/1 integração de container ignorada; FileCrypto 12. Auditoria Arcan SQL real passou. Nenhuma integração escreveu no catálogo operacional.
- Checkout caiu de 7,927 para 1,295 GiB (83,7%), 9.441 arquivos, após testes/builds. Arquivo reversível em C:/Projetcts/aika-og-archive/2026-10-12; 15 executáveis antigos verificados por SHA-256. Exclusão permanente bloqueada pela revisão automática; não alegar liberação equivalente de espaço físico no disco. Scripts de publicação agora guardam novos outputs/backups fora do checkout. Documentação: docs/WORKSPACE-CLEANUP-2026-10-12.md.
- Graphify atualizado: 4.165 nós/11.407 arestas/210 comunidades; cache antigo removido pelo CLI. 55 dados sem nós e 8 SQL sem parser; auditorias JSON/SQL continuam obrigatórias.
- Nova auditoria D:/aika: quatro itens seguem sem definição compatível; 8739 estrangeiro é outro item. CapturedDetails tem 32 espécies, nenhuma das 103 ausentes. Wiki não fornece contratos de gameplay de missões/fabricação e não há handlers desses fluxos no servidor; preservar referência e exigir mapeamento de NPC/pacotes antes de ativar.
