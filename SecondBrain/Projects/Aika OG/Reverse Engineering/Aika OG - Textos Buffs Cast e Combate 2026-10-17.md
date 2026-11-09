---
tags:
  - aika-og
  - protocol
  - verification
updated: 2026-10-17
---

# Aika OG - Textos Buffs Cast e Combate 2026-10-17

## Decisões e evidência

- Buffs persistidos precisam de snapshot `0x16E` depois do spawn `0x349`, que substitui o estado visual do ator. Aplicado a login, observadores e reviver, usando o ID runtime correto; expiração salva não é reiniciada.
- ACK de fim de cast pode chegar antes do prazo do servidor. Guardar um único pedido e aguardar sem manter PacketGate; readquirir o gate e validar a identidade exata da sessão/personagem/cast antes de consumir MP e executar. Cancelamento, movimento, morte e troca de personagem impedem o callback antigo.
- Mobs aproximados diagonalmente podiam parar em 2,0000488 unidades para alcance 2. Parar 0,01 dentro do alcance elimina o travamento sem aumentar o ataque. Em retorno, agressivos podem adquirir outro jogador; o alvo que escapou fica ignorado até o spawn ou até atacar diretamente.
- Pedido do operador: detecção na média do alcance básico de rifle/pistolas. ItemList e getter nativo `0x422420` confirmam 18 e 12; detecção = 15. Ataque melee permanece 2, perseguição 10–50, assistência 5 e visibilidade 50.
- Revisão posterior do operador no jogo: 15 detectava longe demais. A configuração nova volta para **6**, pequeno aumento sobre o valor antigo 5. A média 15 acima é histórico substituído, não o alvo atual. Fronteiras 6/6,01 e rejeição de 15 verificadas em `artifacts/mob-aggro-six-green.log` (198 testes aprovados); ativação acompanha a correção dos marcadores no mapa.
- Mensagens `0x984` mantêm 144 bytes/Latin1/126 bytes úteis; envio compartilhado separa em linhas de até 45 para evitar as quebras nativas de 46/50. Quebras explícitas viram mensagens separadas. Aparência final ainda precisa de gameplay.
- `.txt <tipo> <mensagem>` é teste privado para GM/Admin; não transmite aos demais jogadores nem concede cargos. Canais e subtipo de governo usam o layout existente de `0xF86`; sistema/anúncio usam `0x984`. Veja o mapa de tipos no documento do repositório.
- Revisão nativa: `FUN_004a0440` descarta chat acima de 90 bytes; validar 90 no chat e 126 em sistema/anúncio. `FUN_005ae9c0` interpreta texto como formato no ramo `0x20`; variantes de teste 102/103 rejeitam `%` para evitar falha do cliente. Demais estilos preservam percentuais literais.
- Missões no Studio têm guia, limites, nomes ao lado dos IDs e seletor de cor. BINs continuam fonte de textos/painéis; consumos de entrega originais são preservados. Mudar objetivo de coleta ou escolhas só no servidor pode divergir do painel/consumo: avisos explícitos, sincronização BIN futura.

## Verificação e limites

- Ativado após backup `artifacts/skills-world-20261017/backup-20261017-014724`, sem migração SQL/cliente. Suíte completa: 867 GameServer e 119 Studio aprovados, 20 testes de banco ignorados, nenhuma falha. Hash GameServer testado/publicado/runtime conferido; HTTP e listeners prontos.
- Frontend: build/lint e QA no navegador em 1280/390 pixels, revisão cancelada/desfeita sem gravar catálogo.
- Operador testou uma missão de James Ron e uma de Ronire em Regenschein; IDs não informados. Não generalizar para todo o NPC/catálogo.
- Gameplay de anúncio, ícones restaurados, casts e múltiplos ataques ainda depende de teste no cliente. Canalização especial não foi implementada por esta correção.

## Fontes atuais

- `C:/Projetcts/aika-og/docs/operations/RELEASE-TEXT-SKILLS-WORLD-2026-10-17.md`

- `C:/Projetcts/aika-og/docs/operations/TEXT-QUEST-HELP-2026-10-17.md`
- `C:/Projetcts/aika-og/docs/operations/BUFF-LOGIN-RESTORE-2026-10-17.md`
- `C:/Projetcts/aika-og/docs/operations/SKILL-CAST-ACK-2026-10-17.md`
- `C:/Projetcts/aika-og/docs/operations/MOB-GROUP-COMBAT-2026-10-17.md`
- `C:/Projetcts/aika-og/docs/operations/CHAT-TEXT-TEST-2026-10-17.md`
- [[Aika OG - MOC]]
