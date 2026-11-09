---
tags:
  - project/aika-og
  - protocol
  - gameplay
updated: 2026-10-14
---

# Aika OG - Buffs Dual IA 2026-10-14

Relatório operacional: `C:\Projetcts\aika-og\docs\operations\DUAL-BUFFS-AI-2026-10-14.md`. Fontes: relatório de skills do operador,50eventos originais e consumidor do AikaClient.exe, sem alterar bins/criptografia.

## Contratos duráveis

- Buffs usam identidade runtime, não chave SQL; enviar apresentação/timers antes de awaits de banco. Snapshot16E omitindo expirados/compactado. Falha isolada não encerra tick global de personagens/Pran.
- Bênçãos gratuitas/pagas3600s; gratuita preserva extras pagos. Camada NPC longa e camada clériga curta coexistem/persistem; mesma família contribui com valor mais forte, sem duplicação.
- Ataque explícito durante retorno reabre combate com nova origem de perseguição. Invisibilidade não quebra por dano conforme decisão do operador, mesmo contrariando fonte histórica. Passive/service não participam da assistência agressiva.
- Shock151 incapacita além de adicionar dano; fonte Mob.pas confirma bloqueio de ataque/movimento. Esta evidência corrige interpretação anterior de shock como somente dano.
- Réquiem tem componente separado: sete ataques após3095/rank7 trazem DWORD64=226. Layout0x102/1002:3DWORDs60/64/68, não UInt64. Mjolnir retardado disparado uma vez; root/poison separados de dano inicial; cargas Esquiva/Anti-defesa/Negar Cura controladas pelo servidor.
- Morte comunica atuaisHP/MP zero e preserva máximos.

## Painel e limites

Consulta nativa3BD20/20bytes→3BD68/68bytes. Consumidor FUN_0057EBF0 copia6WORD atributos12..22 e44bytes24..67; baselinesregenWORD64/66 confirmados. **40bytes24..63 não mapeados**, seguem zero. Cliente recalcula outros campos; validação/calibração no jogo pendente. Contratoauxiliar ShowAttributeAika23FE12→23FF50/50bytes é separado.

646 testesGameServer,107Studio/SQL,7Python passaram; dois condicionais ignorados. Build sem erros/avisos. Backup `artifacts/gameplay-fixes/activation-20261014`. Coletor/trace agora registram snapshots/timers/detail; captura antiga só efeitos, não comprova timers/painel. Revisão por agente bloqueada por cota; operador escolheu seguir com fontes/testes locais.

Reveal contra jogadores, flash/PvP ofensivo e equivalência de cada animação permanecem pendentes. MP de mobs não cadastrado permanece zero; não criar valores fictícios.

Relacionadas: [[Aika OG - Sistemas Nativos 2026-10-14]], [[Aika OG - NPC Skills Patrulha 2026-10-13]], [[Aika OG - Buff Refresh e Opcodes 2026-10-10]].

## Correção após teste do operador

O usuário confirmou timers incorretos/ícones em0. A semântica antiga estava errada:0x16E/16F enviam **deadlines Unix**, não segundos restantes. FUN_004aa150 subtrai time64+DAT_0323ce24; login0x925 define desvio pelo DWORD6348/0x18CC. Corrigir ambos juntos, mantendo login6380bytes. O campo antes zerado fazia a UI descontar tempo desde login novamente. A expiração deve alcançar os observadores, também para invisibilidade.

Disparos Rápidos:0x106 não reseta cooldowns. Player.pas/DisparosRapidosBarReset e FUN_00499f90→FUN_004cb2f0/004cb570 comprovam0x12C96bytes:modoDWORD12+20DWORD segundos16..95. Reset completo seguido de snapshot com somente o novo cooldown tipo12. Preservar o próprio cooldown no servidor.

Novas regras do operador: todos os ataques/debuffs dual lançam a35unidades (inclusive Fumaça; área5preservada); Maximizar600s; ataque remove Ocultar, recebimento de dano continua sem remover. Posição de Atirador/EF241 é exceção temporária comprovada no BIN2337..2352. Efeito46 deve alterar passo real e velocidade de pacote da IA; restauraçãoHP no spawn precisa enviar0x103 com ID do mob.

Animações de debuffs: captura original usa tipo1/hit26 com dano zero; enviar tipo0/animação0 e deadlines relativos impede apresentação correta. Corrigidos valores padrão sem substituir animações específicas do BIN. Trace passou a registrar saída e deadlines corretamente nomeados expiresAtUnix.

662GameServer+8Python passaram,1SQL condicional ignorado. Runtime anterior preservado em `artifacts/gameplay-followup/activation-before`. Relatório: `docs/operations/GAMEPLAY-FOLLOWUP-2026-10-14.md`. Cliente precisa relogar para nova sincronização; gameplay visual ainda deve ser validado pelo operador. Esta seção substitui contratos/regras conflitantes anteriores.

## Captura de alvo e nova regra de buff

Nova decisão do operador: **usar qualquer outra skill/buff revela a dual oculta**, incluindo Rosa/Esquiva/Maximizar. Ocultar ainda aplica o próprio efeito; usos rejeitados não removem. Persistir remoção por transição de invisibilidade, não só redução de quantidade: Ocultar→outro buff pode manter o mesmo count. Exceção EF241 do atirador permanece.

Disparos usa somente um0x12C mantendo seu cooldown próprio. Primeiro snapshot zerado seguido de outro apaga o início da contagem no cliente (FUN_004cb570), então o prazo seguinte parte de zero. Esta correção substitui o envio duplo da seção anterior.

Coletor associa buffs, animações, movimento/velocidade, HP/MP e remoção do alvo por60s, com geração e limite256usos; cast renova janela e remoção encerra vínculo. Movimento global de mobs continua fora do catálogo. Report JSON inclui targetTimelines e diferenças de buffs/velocidades. Perspectivas client/server normalizadas no comparador; associação temporal não comprova causalidade nem pixels renderizados.

SaldoJ: consulta autenticada lê accounts.cash diretamente; inventário20A envia saldo antes das cargas dependentes. Produção continha99.999cash e não houve concessão/débito. Teste com cachezero/SQL99999 passou; causa do zero original na UI não comprovada por captura. Atalhos de armazenamento pessoal/guild/Pran passam a fechar menu10F após validação e antes do painel.

666GameServer+12Python passaram,1SQL condicional ignorado. Relatório `docs/operations/SKILL-TARGET-CAPTURE-2026-10-14.md`, publicação/backup `artifacts/skills-targets`. Validação visual/saldoJ no cliente pendente; operador confirmou encerramento normal do GameServer para ativação.
