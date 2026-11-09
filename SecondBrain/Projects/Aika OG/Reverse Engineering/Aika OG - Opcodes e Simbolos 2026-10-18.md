---
tags:
  - project/aika-og
  - reverse-engineering
  - protocol
updated: 2026-10-18
---

# Aika OG - Opcodes e Simbolos 2026-10-18

Relacionado: [[Aika OG - MOC]], [[Aika OG - REA e Protocolo Nativo 2026-10-17]], [[Aika OG - Patch e Contrato Login 2026-10-17]], [[Aika OG - Sistema de Auth]], [[Knowledge Debt]].

## Estado atual

Relatório principal `C:\Projetcts\aika-og\docs\reverse-engineering\OPCODE-ALIGNMENT-2026-10-18.md`. Catálogo `Opcodes.txt` e `OPCODE-AUDIT.json/md` atualizados: **245 registros /245 opcodes**, sem incoming/outgoing identificados fora do catálogo e sem linha perdida.50 entradas com corpo identificado,55 saídas com caminho estático,133 não encontrados pelo extrator C#,5 construtores sem caminho,1 entrada vazia e1 explicitamente ignorada. Duplicação histórica31F consolidada em Combat.

Studio deixou de usar relatório10/out obsoleto. Auditor resolve classes/overloads, constantes/decimais/bindings genéricos e separa entrada/saída/ignored/vazio/não resolvido. Hashes de223 fontes e fingerprint delimitam snapshot; não é prova de execução e não atualiza automaticamente após editar source. Para regenerar: `.analysis-venv\Scripts\python.exe tools/audit_opcodes.py`. Aliases/semântica são mantidos em `docs/reverse-engineering/OPCODE-NAMES.json`,14 registros com evidência independente de implementação.

## Semântica recuperada

- **0x0121 CastleSiegeStateSnapshotPacket**, aliasT121:004B4130→004E1670/004E18E0, estado/UI de cerco com torres, portões, selos, filiação e contador. Consome28bytes; tamanho dewire ainda não capturado. Stringsstrdef4 slots309–311/333–337 corroboram domínio; nibbles/índices parciais continuam inferidos. Não há implementação C# identificada.
- **0xCCCC UnknownLegacyCCCCPacket**: construtor16bytes/DWORD1, referênciaDelphi no ingresso ao mundo, sem consumidor/finalidade comprovados. Não chamar ACK/ping.0xCCCCC não cabe emuint16; alias apenas para busca. SentinelCCCC em payload107 é distinto.
- **0x16E BuffSnapshotPacket** exige252bytes/40IDs/40deadlines no readerOG004A9EE0. Buffer interno372/60slots não implica suporte372 na rede. SourceBuffPacketFactory já usava252; catálogo/comentárioGhidra corrigidos.016F24/017032 usam consumidor comum004AA150.
-101RemoveEntity (não sómob),102DamageResult,103EntityHpMpUpdate,107SkillLevelsSnapshot,12CSkillCooldownSnapshot,81AccountTokenRequest,82AccountLoginResult e685GameConnectionAuthentication possuem nomes sustentados por consumo/produção.0121/CCCC continuam sem captura nos1544registros/5capturas consultados; ausência limitada à amostra.

## Source e símbolos

Onze símbolos C# renomeados viaSerena, referências/testes conferidos, semalterarwire/lógica. Principais: SelectedNation→AuthenticateGameConnection; SendToWorldSends→CompleteWorldEnter; UpdateCharInfo→IgnoreOpcode0306; CreateSendDataPacket→CreateUInt32SignalPacket; CreateInitialConfirmationPacket→CreateUnknownCCCCPacket; helpers12C/33D/128/138→nomesde cooldown/mapa/taxas/inventárioPremiumvazio. TokenServer preservado por corresponder às rotasASP nativas. Tabela completa `OPCODE-SERVER-ALIGNMENT-2026-10-18.md`.

Projeto Ghidra `artifacts/ghidra-projects/AikaOGClient.gpr`: **27 símbolos manuais persistidos,13 novos nesta rodada**, verificados após reabrir; comentários/VA/RVA/hash e evidência nos manifestos `artifacts/opcode-alignment-20261018/renames.{applied,corrected,reopened}.json`. Snapshotprévio `ghidra-before/`. Nomeação descritiva, não sourceoriginal. Não houve label aplicado em x64dbg.

Build analisada originalSHA256 `7eca8e1e6573dc439cc803ef6cafe91aaca53e6c60d4b3bfd82ab267a7ad81aa`, base00400000,9933funçõesinventariadas em`client/functions.json`. Inventário não é9933funçõesdecifradas. REAEvidence0121 `ev_bc3ddbe7de3df7765ee37e54fa59c6bf415979dcd32749224a695d52eda55655` persistidaem`rea/0121-evidence.json`; sessão temporária fechada. Usar Decompiler do Ghidra para pseudocódigo; não produzir conversão manual desnecessária.

Os backupsD: de17/out não estavam mais disponíveis; imagemoriginal recuperada porGhidraFileBytes e hashconferido em`artifacts/opcode-alignment-20261018/client/AikaClient.original.exe`. Não é recriação dos backupscompletos; comandos antigos de restore dependem de arquivos agora ausentes. Clientativo continuaSHA v3 `e1104cbb8d313ec9b07e18c5529ac6865d1eda92e429355185617a4f805ff002` e não foi alterado nesta rodada.

## Verificação e continuidade

13testesPythonauditor+41GS passaram;frontendbuild/lint eAPIbuild semerro. Studio verificado em browser real comAPIreal de sessão/auditoria, outrasáreascomfixtureparaevitarDB:245registros, aliases/filtros,contrato16E,ignored39D,estado vazio,320/1440px, zeroerrosJS e zerowrites. Capturas `output/playwright/opcodes-320.png` e`opcodes-1440.png`. Sem gameplay,MySQL,authrequests ourestart deprodução.

Graphify atualizou6465nodes/18035edges apósrenomes/auditor. Cobertura parcial:94arquivossemnodes e20SQLsem tree_sitter_sql;HTMLomitidoporlimite5000. Não usar grafo como prova dessesarquivos. Vault/dívidas atualizados sem reorganização.

Restam12helpersnuméricos com papelinsuficientementecomprovado e133registros semC# localizado,além39D/CCCC/306 ecerco semimplementação. Avançar por subsistema/captura de evento, preservarbuild/offsets/unidades e comparar bytes antes de alterarprotocolos. Memória/rede/desempenho exigem baseline de alocações/buffers/fila,bytes/frequência e latência/tempo de frame; renomes não demonstram ganho. SegurançaTTL/revogação/rate limit/TLS/ban permanece backlog registrado, não proteção nova implantada.
