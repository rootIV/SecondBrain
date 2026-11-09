---
tags:
  - project/aika-og
  - debugging
updated: 2026-10-22
---

# Munição, aquisição e movimento — 22/10/2026

Relacionado: [[Aika OG - MOC]], [[Aika OG - Economia Inventario 2026-10-14]], [[Aika OG - Movimento Guardas Reais 2026-10-16]].

Munição cash agora usa tipo52/duração do catálogo em vez de IDs restritos; compatibilidade por família21–24/31–34. Casos7947/7953 (CategoriaC30dias) cobertos, incluindo expiração. Avisos de aquisição centralizados no0xF0E notice=true após commit e antes de refresh silencioso: cliente produz toast+linha sistema na cor da raridade. Não criar cores emC# nem enviar markup por0x984: este usa texto simples.

Cliente SHA256`e1104cbb8d313ec9b07e18c5529ac6865d1eda92e429355185617a4f805ff002` inspecionado viaREA/Ghidra12.1.2:004a10f0/0068ccf0/00667a70/0066cee0/0066d630. Pseudocódigo confirma ambos os destinos e cores deItemList+390; executável preservado.

Movimento/rotação não devem ecoar ao próprio jogador: controle local já aplicado. Referências Rafinha PacketHandlers948/1057 e TheMu913/1020 usam SendToVisible false. Correção preserva observers, speed, payloads, cast cancel e stun/root;6regressões passaram.

Guardas: skill6470 lentidão50%20s; ataque remove famílias153/386, consome cargas19/91 conforme block/miss. Perseguição/retorno comprovados; patrulha ociosa completa continua não comprovada. Implementação específica de combate deNPC não foi adicionada. Não copiar diretamente Rafinha/TheMu (hostilidade/IDs/coleções inconsistentes).

Mercador esquerdo desativado no MySQL: NPC 2480, Premium Shop, 3458/933. NPC 2307, Loja Auxílio Poderoso, 3475.4/940.4, integralmente preservado. Backup e SQL reversível disponíveis; execução repetida idempotente.

Build padrão: zero erros/avisos. Suíte completa: 1.559 aprovados, 10 ignorados, zero falhas. Verificação posterior: 215 testes afetados passaram; revisão de swap do mesmo template teve 4 regressões red/green e 42 testes finais aprovados. Baús usam o retorno explícito de NativeStorageService.Move para anunciar itens retirados mesmo quando o saldo do template não muda. Smoke do executável normal carregou catálogo MySQL, iniciou quatro canais e encerrou com código 0/stderr vazio. Servidor deixado parado para início pelo fluxo habitual. Gameplay visual de câmera/tiro/avisos continua pendente; IA específica de combate de Guarda Real não foi implementada.

Relatório: `C:/Projetcts/aika-og/docs/operations/AMMO-ACQUISITION-MOVEMENT-2026-10-22.md`.
