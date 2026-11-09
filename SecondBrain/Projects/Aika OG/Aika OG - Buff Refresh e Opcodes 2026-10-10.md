---
tags:
  - project/aika-og
  - protocol
  - debugging
updated: 2026-10-10
status: corrigido-remocao-manual-validada
---

# Buff refresh e opcodes

Relacionadas: [[Aika OG - MOC]], [[Aika OG - PacketDispatcher e Protocolo]], [[Aika OG - SkillService]], [[Aika OG - NPC Venda e Bloqueio de Arma 2026-10-09]], [[Aika OG - Depuracao Realtime x64dbg]].

- Contrato nativo confirmado em 004a9ee0: 0x016E somente com tamanho 0xFC/252, 40 IDs WORD em +12 e 40 durações DWORD em +92. Uma estrutura interna de 60 slots não comprova um pacote de 60 slots. A source enviava 372 bytes, ignorados pelo client, e podia deixar ícones de buff presos após remoção/consumo/expiração.
- BuffService e BuffPacketFactory compartilham o limite de 40. Pedidos 0x0329 para buff já ausente reenviam o estado atual para limpar ícones desatualizados, sem excluir registros por ID inexistente. Remoção normal mantém persistência e recálculo.
- Cinco regressões falharam antes e passaram depois; suíte completa 438 aprovações, zero falhas, dois skips SQL condicionais. Runner legado recompilado sem avisos/erros. Build ativada pelo operador às 11:01 de 2026-10-10 (PID 8244, DLL com limite 40 e ressincronização). O operador confirmou a remoção manual de Bloqueio de arma em ClasseRuim antes de receber dano. Consumo por dano e expiração ainda sem confirmação visual nesta rodada.
- 0x0327: cancelamento/interrupção de skill, 16 bytes, DWORD SkillId em +12. Emissor 004e5f20, receptor 004a8fa0. Não é remoção de buff; falta handler e modelo de casts canceláveis no servidor que aplica skills imediatamente.
- 0x03AE: consulta de valor/saldo, 20 bytes, DWORD zero em +12 e seletor 1/2 em +16; resposta valor em +12. Investigação posterior confirmou atalho J→00580760→00589680→seletor 2, lista UI/PI.bin e recurso loadtext com Loja Premium/CASH. Seletor 2 pertence ao fluxo CASH da loja J; seletor 1/coluna financeira ainda sem prova. Não responder aos dois com o mesmo saldo por suposição. [Evidência](C:/Projetcts/aika-og/docs/reverse-engineering/RANGED-MOBS-AND-SHOP-CURRENCY-2026-10-10.md).
- 0x020A: header de 12 bytes, enviado por 004F3010 ao abrir a Loja Premium e por 004F2FA0 em outras atualizações. Snapshot Premium recebido por 0x0138/204 bytes: 24 registros de 8 bytes, WORD inicial índice PI.bin. Receiver 004B6AD0 copia +12 por 192 bytes; 00507B10 percorre/cacheia os ícones. Sem handlers 0x020A/0x03AE na source; Create138Packet envia somente zeros. Não implementar como 24 itens convencionais de 16 bytes. [Evidência](C:/Projetcts/aika-og/docs/reverse-engineering/PREMIUM-SHOP-INVENTORY-2026-10-10.md).
- 0x0329: remoção de buff pelo ID da skill presente no ícone (005ec270). Log buff=33 com lista vazia não demonstra leitura de slot incorreta.
- Debugger restaurou três logpoints próprios da base salva ao anexar ao PID 54520. Foi observado pausado e liberado; operador reiniciou para PID 67772. Os RVAs correspondem aos exports; a suspeita de endereços incompatíveis foi descartada. Não se confirmou o evento que causou a pausa.
- Bases .dd32/.bak, contendo somente três logpoints AikaCapture e hash, foram preservadas fora do carregamento automático em artifacts/backups/debugger-stale-capture-20261010. Não rearmar assumindo que collector-status residual prova execução.

Relatório: `C:\Projetcts\aika-og\docs\reverse-engineering\BUFF-REMOVAL-OPCODES-2026-10-10.md`.
