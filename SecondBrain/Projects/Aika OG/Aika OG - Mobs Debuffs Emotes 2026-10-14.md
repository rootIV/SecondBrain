---
tags:
  - project/aika-og
  - protocol
updated: 2026-10-14
---

# Aika OG - Mobs Debuffs Emotes 2026-10-14

Detecção/assistência5, melee1,5; alcance de patrulha11 não identifica ranged. Preservar ataques básicos nativos conhecidos e perseguição10..50. Debuffs sem dano inicial precisam gerar ameaça após aplicação aceita; venenos continuam em lote prioritário enquanto houver ticks. Estripador/131 só dispara em crítico básico, incluindo Atacar com ID não zero, repetindo1s durante debuff10s; skills não disparam.

DOT usa0x103/32 com flagDWORD28=1: FUN_0049FD10 calcula delta deHP, branco em outros alvos; flag0 é sincronização silenciosa.0x1002 usado antes era uma variante/efeito de skill e não é o contrato correto para mostrar ticks neste cliente. Cura completa no retorno permanece0x103/flag0.

0x304/20 envia açãoDWORD12/loopDWORD16; UI/emotion.bin comprova39,40,42,43,59..65,67,69..71; emissor também25. Validar allowlist, loop e usar ID da sessão.0x3F33 é multiplexado: somente etapa7 na seleção inicia exclusão, layout24/slot16/conta20. Resposta20,8/0. Binário emissor5BE617 comprova7/slot/conta;603/28 final comprova conta12,slot16,bool20,PIN24. Não registrar2403(AikaEmu outra variante),3E05(cupom) ou B52(item) como aliases de exclusão.

Exclusão lógica valida ownership/PIN/slot no SQL, gate compartilhado com entrada no mundo, desconexão/guilda e três erros de PIN. Preserva itens/dependentes, libera slot, nome continua reservado; recuperação exige checar conflito de slot. Nunca testar apagando personagem real.692 testesGS+25 direcionados+2 SQL passaram,1 condicional ignorado (há sobreposição). Captura visual/teclado numérico ainda pendente. x64dbg falhou conexão; análise estática Capstone em artifacts foi usada, sem dependência nova do servidor.

Relatório: `C:\Projetcts\aika-og\docs\operations\MOB-DEBUFF-EMOTES-2026-10-14.md`. Relacionadas: [[Aika OG - Buffs Dual IA 2026-10-14]], [[Aika OG - PacketDispatcher e Protocolo]].

Ativado13:24:34 America/Sao_Paulo, PID47984;17 hashes conferidos, backup artifacts/mob-debuffs/activation-before.zip e manifesto activation.json. Startup pronto, stderr vazio, portas8831/8822 em loopback; sem migração do banco.
