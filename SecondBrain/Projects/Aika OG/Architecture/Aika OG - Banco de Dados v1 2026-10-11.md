---
title: Aika OG - Banco de Dados v1
date: 2026-10-11
tags:
  - project/aika-og
  - database
  - security
---

# Aika OG - Banco de Dados v1

Relacionado: [[Aika OG - MOC]], [[Aika OG - Arquitetura Atual]], [[Aika OG - Sistema de Auth]], [[Knowledge Debt]].

## Decisão

O usuário confirmou instalação nova, sem dados a preservar. O repositório em C:\Projetcts\aika-og recebeu uma baseline explícita com 28 tabelas e exigência de MySQL 8.0.23+. O redesenho inicial foi validado em bancos descartáveis; a aplicação local posterior está registrada abaixo.

Fonte: Database/README.md, Database/least-privilege.sql, Database/Migrations, Shared/Data/DatabaseSchema.cs e os testes DatabaseSchemaTests/DatabaseAuthTests.

GameDatabase e DatabaseHandler apenas abrem conexões pelo factory compartilhado. Não executam CREATE DATABASE, DDL ou varreduras de information_schema em runtime. Instalação: banco vazio escolhido em AIKAOG_DATABASE, depois dotnet run --project Database -- install.

## Aplicação local — 2026-10-11

O usuário removeu o schema e autorizou a instalação. aikaria foi recriado no MySQL local 8.0.46; baseline v1 instalada às 19:10 America/Sao_Paulo (22:10 UTC), com 28 tabelas InnoDB, 12 FKs e 8 CHECKs. Versão/checksum e liveSlot invisível conferidos; reexecução idempotente passou. least-privilege.sql aplicado às quatro roles, sem criar usuários de login.

Banco sem contas/catálogo. Conexão administrativa anterior usada apenas no processo de instalação, sem senha persistida. AIKAOG_DATABASE/secrets/aikaog.local.env ainda ausente para os serviços; configurar antes de iniciá-los. GameServer mantém importação do catálogo dos arquivos locais.

Configuração posterior no mesmo dia: conexão funcional validada em localhost:3307/aikaria. Corrigido o arquivo local que apontava para 3306; AIKA_WORLD_DATA preservado. Usuário aika_local@localhost criado com as quatro roles para desenvolvimento local compartilhado, sem privilégios administrativos. secrets/aikaog.local.env ignorado pelo Git; nenhuma senha foi registrada neste vault. Serviços não foram iniciados.

## Contratos

- FKs protegem filhos de personagens e hierarquias de catálogo. Substituição do catálogo continua transacional, sem desabilitar FKs.
- Datas em DATETIME(6)/UTC; premiumTime redundante removido.
- liveSlot gerado e INVISIBLE garante uma única ocupação ativa por conta/slot e mantém clones por SELECT * compatíveis.
- Grants por processo: game, token, editor e GM. Runtime sem DDL; token sem alteração de cargo/saldo; auditoria GM permite SELECT/INSERT, sem DELETE.
- Credencial MD5 do contrato é reforçada com PBKDF2-SHA256/600.000 e salt; token entregue ao cliente mantém 32 hex, e somente seu SHA-256 é persistido.
- Renovação de token inválido não muda a conta. Cadastro público restringe accountType=0.
- Buffs têm unicidade por dono/slot, índice de expiração e substituição transacional; leitura não faz limpeza global.
- IDs internos de conta/personagem são lidos como uint, sem estreitamento para ushort no repositório. Nenhum opcode/layout de pacote foi alterado.

## Verificação

Instalação/reexecução, checks, cascatas, importação real do catálogo duas vezes e operação com grants restritos foram exercitados em bancos/usuários temporários. Testes de senha/token passaram com usuário SQL sem permissão de alterar cargo/cash. Solução compilou; resultados detalhados estão em Database/README.md e artifacts/database-tests/results.

Resultado final: 584 testes distintos passaram (513 GameServer, 5 TokenServer, 45 Studio e 21 MasterTool), sem falhas. Uma integração antiga do MasterTool ficou pulada por depender de banco/usuário fixos. Graphify atualizado para C#; SQL validado diretamente no MySQL porque falta o parser SQL no grafo.

Role GM testada diretamente a partir de least-privilege.sql. O grant inclui UPDATE de banDays; a moderação monta apenas atribuições necessárias para não depender de SELECT do token. Mudança de status limpa token/banDays; alteração somente de cash os preserva. Uma execução intermediária falhou no teste legado GameServerEncDecStaysLegacyOnly (cifrador usa semente aleatória); reexecução completa passou, com dívida registrada.

Não confundir integridade/índices com benchmark: capacidade sob carga e cliente real não foram validados.

## Caveats

- Baseline v1 não migra bancos anteriores. DDL do MySQL pode deixar instalação parcial; instalador recusa bancos não vazios e não apaga dados automaticamente.
- AccountLogin TCP descarta o segundo campo de 32 bytes; confirmar significado no cliente antes de alterar autenticação.
- PIN numericToken em texto, expiração automática de tokens e referência temporal de banDays permanecem pendentes.
- active_buffs tem dono polimórfico sem FK; exclusão física do dono requer limpeza explícita.
- Credenciais removidas do código ainda existem no histórico Git e exigem rotação pelo operador.
