---
tags:
  - aika-og
  - inventory
  - security
updated: 2026-10-23
---

# Aika OG - Pocoes e Consumo Seguro 2026-10-23

Relacionados: [[Aika OG - MOC]], [[Aika OG - Catalogos MySQL e Drop 2026-10-22]], [[Aika OG - Sistemas Nativos 2026-10-14]], [[Aika OG - Economia Inventario 2026-10-14]].

## Contrato

`C:/Projetcts/aika-og/docs/operations/POTIONS-2026-10-23.md` contém o escopo e a instalação. Catálogo por ID/tipo/UseEffect com 764 candidatos: 473 habilitados e 291 bloqueados, incluindo falsos positivos, efeitos sem consumidor comprovado, antídoto, Pran e habilidades/durações ausentes. Não afirmar que todas as poções estão funcionais. Benefícios automáticos também obedecem à lista de habilitados; não ativar parcialmente um item.

Os seeds `potions.json` e `potion-effect-aliases.json` são importados para `server_catalog_resources`; runtime usa o snapshot MySQL. Migração `20261023_potions.sql` aplicada localmente. Recargas por personagem/família e recibos são InnoDB, com grants específicos na role existente.

HP/MP absolutos usam UseEffect como quantidade; buff usa habilidade. HP e MP são independentes, HP+MP ocupa ambas. Buffs agrupam por família. Tipo 741 remove somente habilidade 6471: o nome Elixir da Ressurreição não prova ressuscitar. Efeito 111 recupera MP para origem de poção; a drenagem hostil permanece. Aliases 377/378/379 afetam ambos os stats correspondentes sem duplicar buff nem curar durante recálculo.

## Segurança e limites

O cliente fornece posição, não decide efeito/quantidade/duração. Posse, sessão, fonte SQL, pilha, nível, recarga persistente, validade e slot desbloqueado são conferidos. Gate do personagem e locks SQL serializam consumo. Inventário divergente ou commit não confirmável bloqueiam a entidade e encerram sessão. Token bucket limita rajadas antes da transação.

Consumo + recarga + recibo são atômicos. Efeito só após consumo confirmado, no personagem atual, sem restaurar snapshot antigo de HP sobre dano recebido durante SQL. Vitals/buffs são persistidos em uma segunda transação: crash entre fases pode gastar a unidade sem benefício. Não declarar atomicidade total de item e efeito. Timestamp nativo é relógio compartilhado, não nonce; repetição válida após recarga paga outra unidade.

0x31D mantém 24 bytes; 0x21B usa 16 bytes e recebeu rota com a mesma política; 0x103 mantém layout e usa flag 1 para apresentação de item. Não alterar EncDec/GameProtocol. Evidência nativa em `artifacts/potions-20261023/native-evidence.md` e bundle adjacente.

## Verificação

MySQL importado e verificado; build normal sem warnings/erros; quatro canais iniciaram e encerraram, deixando servidor parado. Suíte ampla antes dos últimos ajustes defensivos: 1.613 aprovados, 10 ignorados, zero falhas. Checagem final focada: 51 aprovados. Mais seis testes de runtime/parada passaram após reproduzir e corrigir callbacks de accept cancelados em `TcpGameServer.ProcessAccept`, falha anterior descoberta no smoke. GameProtocol preservado. Graphify atualizado; SQL ainda não é indexado pela ausência de tree_sitter_sql. Gameplay real e carga concorrente com cliente não foram validados.
