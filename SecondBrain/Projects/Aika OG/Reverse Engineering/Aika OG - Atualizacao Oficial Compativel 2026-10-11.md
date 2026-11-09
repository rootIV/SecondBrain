---
tags:
  - project/aika-og
  - reverse-engineering
  - client
  - verification
updated: 2026-10-11
---

# Aika OG - Atualizacao Oficial Compativel 2026-10-11

Client OG verificado: `D:\aika\Aika OG`. Fonte local oficial: `D:\CBMgames\AikaOnlineBrasil`. Servidor: `C:\Projetcts\aika-og`.

## Aplicado e verificado

- Importação aditiva: 1.533 itens, 403 habilidades/comportamentos, 136 definições de conjunto, nove títulos, 156 nomes MN; 448 arquivos de recursos ausentes (37 animações, 133 modelos, 238 texturas, 35 efeitos, cinco UI).
- Itens/habilidades ocupados preservados. Client e Data com os mesmos payloads nativos; envelopes, cifras e checksums conferidos. Índices de textura dos novos itens conferidos por nome, sem remapeamento necessário nesta aplicação.
- Títulos nativos usam 224 bytes por slot / 56 por nível. MySQL alinhado aos 142 títulos nativos (incluindo nove novos), mantendo 31 definições antigas sem correspondência comprovada e seus ownerships. Personagens ainda usam 225/226/230; não inventar remapeamento.
- MN acrescenta nomes ao client; não cria NPCs, lojas, serviços ou spawns. Conjuntos novos são definições; `Conjunts.bin`/associações existentes preservadas.
- Onze comportamentos novos receberam a normalização das regras de Templário já usadas pelo OG. `Reviewed=true` segue o contrato atual do catálogo gerado, sem comprovar paridade oficial de mecânicas.
- EXE, anti-cheat, configurações, Nation, mapas, cenas, shaders, protocolo e índices globais de modelos/animações preservados. EXE OG SHA256 `7eca8e1e6573dc439cc803ef6cafe91aaca53e6c60d4b3bfd82ab267a7ad81aa`.
- MySQL: 21.084 itens, 7.695 habilidades, 459 NPCs e 5.622 mobs; bootstrap confirmado como `database`.
- 504 testes C# aprovados, dois ignorados; 11 testes Python aprovados; build GameServer zero warnings/errors; 461 hashes de arquivos conferidos; 18 tabelas fora do catálogo importado intactas. Rollback do catálogo/comportamentos validado em clone descartável, removido ao terminar.

## Contrato durável de isolamento

As migrações SQL standalone tinham `CREATE DATABASE/USE aikaria`. A execução runtime aplicava os cabeçalhos e desviava uma conexão configurada para outro banco. A suíte temporária chegou a criar um buff sintético de personagem 6321/habilidade 1217 no banco do jogo; foi identificado e a igualdade final das tabelas foi comprovada.

`GameDatabase.ReadSchemaStatements` agora omite somente os cabeçalhos de criação/seleção de banco; runtime e `CatalogRepository` compartilham esse filtro. `Test-ClientCatalog.ps1` passa `AIKAOG_DATABASE` explicitamente ao testhost. A regressão verifica o banco temporário antes de persistir e confere os dois scripts de migração. Não executar testes com persistência contra o banco normal.

## Evidências e operação

- Documentação versionável: `docs/operations/OFFICIAL-CLIENT-REFRESH.md`.
- Artefatos privados: `C:\Projetcts\aika-og\artifacts\official-refresh\2026-10-10-compatible` — `REPORT.md`, `RESTORE.md`, manifest, dump integral original, backups dos arquivos/runtime e logs.
- Ferramentas: `tools/refresh_official_client.py`, `tools/Import-OfficialRefresh.ps1`, `tools/test_refresh_official_client.py`. Python precisa de Pillow; runtime local usado: `C:\Users\root4\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe`.
- Reversão normal: parar jogo/servidor, `Import-OfficialRefresh.ps1 -Restore` primeiro, depois `refresh_official_client.py restore`. Recusar drift de arquivos ou tabelas protegidas. Não restaurar o dump integral sobre progresso novo sem reconciliação.

## Limites e dívida

Gameplay pós-importação não foi validado. Recursos novos dependentes de índices globais permanecem sem ativação comprovada; modelos/animações receberam validação estrutural parcial. Mecânicas oficiais avançadas exigem provas e implementação específicas no OG. Não inferir novas associações de conjuntos, entidades, serviços ou ownership de títulos a partir dos arquivos importados.

Relacionados: [[Aika OG - MOC]], [[Aika OG - Cliente OG 2026-10-09]], [[Aika OG - MasterEditor File Crypto]], [[Aika OG - NPC Titulos e Menus 2026-10-10]], [[Knowledge Debt]].
