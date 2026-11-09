---
tags:
  - project/aika-og
  - npc
  - protocol
updated: 2026-10-21
---

# Aika OG - Grupo Solo Menus NPC 2026-10-21

Implementação a pedido do operador, preservando a mudança preexistente em AccountHandler. Referências, tabela por NPC, configuração e limitações: [relatório do repositório](<C:/Projetcts/aika-og/docs/operations/NPC-SOLO-MENUS-2026-10-21.md>).

## Contratos implementados

- Grupo solo `0x38F` → `PartyService.CreateSolo`, um líder/membro, alocações1/1 e refresh326; convite e saída permanecem no serviço atual. Supera a ausência registrada na investigação de20/out em [[Aika OG - PartyService]].
- Menus por identidade e submenus com opção/escolha no30F; padrão nativo2093/3 usa escolhas1,9,53,54. Menus personalizados pelo Studio preservados. Conversas vazias sempre oferecem Fechar; conversas reais oferecem Menu/Fechar. Entendido da Catharina preserva progresso da missão84.
- Lilola35/65/77 aplica8500/8501/9284 por3600s e cobra0/10000gold/500honra. Harald2199 troca4202/4203 por4204 nas razões25→1 e250→10. Ascoles2438 troca10/100Coragem por3000/30000honra.
- Transação única do inventário nativo para itens/gold/honra/buffs/recibo; teste MySQL de rollback e concorrência. Wallet312 enviado após commit: a suíte com socket detectou sua ausência inicial e a correção foi retestada.
- Quests oficiais 1516/1520 do Harald cobram 2/20 Heroísmo, embora o menu solicitado exija 25/250. A revisão reproduziu a conclusão barata por comandos diretos22/24; `QuestHandler.FindQuest` agora exige uma entrada de missões no menu efetivo. Dois testes com socket verificam o bloqueio. Catálogo original e menus personalizados foram preservados.
- `Data/NpcServices.json`: nação recomendada e governo por IDs de personagem/nação; padrões0/lista vazia não autorizam ninguém. Não atribuir cargos por nome, título, buff ou flagGM. Roze usa a mensagem exata solicitada e restringe abertura/compra/venda.

## Painéis

Fonte estática `D:/aika/aika-cliente-reverse-engineer/AIKA.exe.cpp`: seletor310 em112673–112902; pedras40/41/42, evolução normal38, transcendência47, núcleo48. Pran35, reforço5, encanto6, aparência7, redução8 e desmontagem17 preservados.

Ranking usa119/24bytes, dungeon12 e mínimoWORD71 em+18; a struct Delphi usa outro offset e não foi portada cegamente. Relíquias usam957/712bytes (25×28): slots vazios, sem inventar posse/progressão nacional. EntradaRU zero validada na tabela atual; não enviar IDs inexistentes, pois o renderer da referência pode indexar−1.

A0180 Lead é placa local em UI/woodensign.bin, registro36/ID481; não é conversa de missão da Rigel. Janela de inscrição do castelo é aberta localmente pela opção9 no cliente de referência, já oferecida por Roberto2073. Essas observações não comprovam execução/renderização do BR atual.

## Limites e dívida

Não houve gameplay, captura nova nem alteração de binários do cliente. Valhalla/Leopold exigem transferência de canal nos forks; Asteria/aliança/nação sem destinos comprovados continuam recusadas sem cobrança. Rigel→Disckeroa, Úrsula e Basilan usam rotas existentes verificadas. Relíquias nacionais/recompensas5/10/20, evolução avançada, inscrição de cerco e operações internas dos novos painéis continuam pendentes. Abertura de painel não equivale a implementação de operação econômica.

Verificação final: GameServer com 1.435 testes aprovados, 10 ignorados e zero falhas; solução compilada sem erros; `git diff --check` aprovado. Resultados em `artifacts/npc-solo-20261021/gameserver-reviewed.trx`. Sem implantação/reinício dos serviços e sem validação visual em gameplay.

Relacionados: [[Aika OG - MOC]], [[Aika OG - PartyService]], [[Aika OG - Referencias Externas AikaEmu e Delphi]], [[Knowledge Debt]].
