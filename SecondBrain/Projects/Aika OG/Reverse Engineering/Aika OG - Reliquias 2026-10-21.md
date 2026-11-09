---
tags:
  - project/aika-og
  - relics
  - protocol
updated: 2026-10-21
---

# Aika OG - Reliquias 2026-10-21

Fonte atual: `C:/Projetcts/aika-og`; [contrato e operação](<C:/Projetcts/aika-og/docs/design/RELIC-SYSTEM-2026-10-21.md>) e [catálogo de efeitos e evidências](<C:/Projetcts/aika-og/docs/operations/RELIC-REFERENCES-2026-10-21.md>). Código implementado; banco real e gameplay ainda não ativados/validados.

- Unicidade global por `UseEffect`, incluindo seladas, aliases e níveis: registro singleton transacional `relic_world`, auditoria `relic_events` e verificação no salvamento comum do inventário. Não confiar só nos handlers. Recusa legado divergente em inventários/depósitos sem apagar dados.
- Contrato explícito do operador: selada permanece na morte/desconexão, expira20min após drop e libera nova caça; anuncia globalmente nos canais sistema/anúncio. Aberta cai em caixa na morte/logout; coleta10s; caixa20min→primeiro espaço Amarkand/Sigmund/Cahill/Mirza. Furto20min fixos→espaço original reservado, sem renovar por viagem/coleta/queda. Fim da proteção no altar não remove item.
- Missão1297 do Lore não equivale à1297 atual. Recuperadas36missões tipo713→40 no **Moa Antar2163**, mantendo aberta no inventário conforme pedido; quatro missões tipo714 não foram convertidas.
- Client atual: aura117/máscara32; caixas349/Face320/Name914; coleta336/24bytes; altarB52/**276bytes**, incluindo20bytes finais lidos pelo cliente, embora a estrutura Delphi tenha256; item link22D→F6F validando posse.
- CanalF05/F06/150: autorização aleatória32bits opaca ao cliente,20s, usuário/IP/destino, uso único, reserva contra login comum. Falha→recuperação na origem; preserva prazo de furto. Só endpoints ativos. Não confundir canal de destino com cidadania.
- Efeitos nacionais aplicados por cidadania. EF175 prolonga buffs positivos (`BaseMob.pas:3595–3597`), apesar do nome legado associado a cast. Sem salto legado soma>=20→50; EF395/396 sem fórmula inventada.
- Pedras separadas por nação; Mirza3343/3348/3353 com posições3007,1156 /3016,1165 /3019,1153, nome905/aparência221 em `Load.pas:2030–2110`. Ataques básicos integrados; skills especiais pendentes.
- `RU.bin`56bytes, primeiras128linhas: receitas e pontos normais confirmados; campos48/52 e contribuição econômica não confirmados.957 filtra IDs ausentes para não acessar índice−1.64E/64F/650 recusam sem consumo; aprimoramento funcional pendente.
- Configuração operacional inicial: drop0,01%, proteção2h, PvP entre inimigos envolvendo portador nos campos conhecidos, duas cidades protegidas, alianças vazias. Taxa é escolha do servidor, não prova de balanceamento oficial. Não tratar testes estáticos como gameplay.

Não alterar `GameProtocol`, `EncDec`, chaves nem cliente com base apenas em nomes de referência. A extensão `install-relics` deve ser instalada explicitamente com servidor parado.

Verificação: falhas de movimento que passam isoladas podem vir de mobs remanescentes em `WorldEntitySpatialIndex`, porque a separação de combate consulta todos os vizinhos. Fixtures de perseguição/ataque à distância agora iniciam índice vazio e restauram `WorldDataService` no descarte, sem remover asserções ou alterar o combate para satisfazer testes.

Resultado final: build da solução aprovado;1493testes GameServer aprovados,10ignorados,0falhas. Baseline anterior1435/10/0. Resultado em `C:/Projetcts/aika-og/artifacts/relic-20261021/gameserver-verified.trx`; SQL somente em bancos descartáveis. Migração real, aprimoramento econômico e validação de gameplay permanecem pendentes.
