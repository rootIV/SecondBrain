---
type: architecture
project: Aika OG
date: 2026-10-22
status: implemented-local
---

# Aika OG - Catálogos MySQL e Drop

O GameServer/Studio passaram a carregar os catálogos auxiliares do MySQL, além das tabelas relacionais existentes. A extensão `server-catalogs` contém `server_catalog_resources` (JSON/BIN/CSV preservados), `server_runtime_settings` (drop/XP) e `server_catalog_audit`. Não há DDL nem importação automática no runtime.

`.drop chance 45%` aceita o sufixo e grava chance absoluta, separada de pesos de raridade e `.xp`. Publicação em memória após commit, CAS por hash/revisão, parâmetros preparados para BINs grandes e backup anterior no histórico. Snapshot em memória evita consulta por kill. O bootstrap segura `CatalogWriteLock`.

29 seeds substituem tabelas embutidas de menus/submenus, painéis, bênçãos/trocas, viagens/acessos, presets/crescimento/inventário de classes, regiões, relíquias e ajustes de habilidades. `server_channels` passa a controlar endpoints; os quatro valores antigos foram importados porque a tabela estava vazia. TokenServer não apresentou catálogo de jogo embutido. Contratos do protocolo e algoritmos permaneceram em código.

Comando: `dotnet run --project Database -- import-server-catalogs`, em manutenção e na raiz de `C:\Projetcts\aika-og`. Reimportação preserva recursos/configurações existentes; não serve para publicar seeds sobre dados editados. MySQL local: 964 recursos + 2 configurações + 4 canais. Novos grants de game/editor aplicados.

Studio usa o banco para missões/títulos e sincroniza recursos importados ao gravar BINs/Premium Store. Gravação binária incerta mantém `.catalog-pending.json`, backup e `.next`; conferir banco/arquivo antes de remover bloqueio. Títulos mantêm o próprio journal e atualizam suas tabelas na mesma transação.

Verificado: GameServer 1547 aprovados/10 ignorados; 42 focados finais; Studio 130/1 ignorado e 1 teste premium excluído por falha da proteção de hash já existente; 22 focados; Token 19/1 ignorado. Smoke real sem arquivos locais de catálogo: 21084 itens/7695 skills/743 NPCs/5623 mobs, quatro listeners e encerramento zero. Studio normal 3388 retornou 1907 missões/2010 associações/25 painéis/141 títulos, sem erro JS/overflow.

A importação inicial preservou checksums das 73 tabelas anteriores. Após retomada da sessão/testes/smoke, foram observadas alterações no estado dinâmico (`active_buffs`, `relic_world`, `relic_events`), além do preenchimento de canais; estado não revertido. Não tratar a evidência inicial como congelamento do mundo após executar serviços.

Limites: gameplay manual não executado; executável atual do cliente não corresponde ao hash aceito para gravar loja premium. Não remover a proteção sem validar o novo build. Graphify AST atualizado; SQL não indexado pela ausência do parser.

Fonte: `C:\Projetcts\aika-og\docs\operations\DATABASE-CATALOGS-2026-10-22.md`, TRXs e snapshots em `artifacts/catalog-migration`.

Relacionados: [[Aika OG - Banco de Dados v1 2026-10-11]], [[Aika OG - Studio Refinado e Visibilidade Missoes 2026-10-21]], [[Aika OG - Eventos Drop e XP 2026-10-21]].
