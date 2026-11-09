---
tags:
  - project/aika-og
  - protocol
  - debugging
updated: 2026-10-10
status: ativado-aguardando-gameplay
---

# Criação, títulos, chat e Studio

Relacionadas: [[Aika OG - MOC]], [[Aika OG - CharacterService]], [[Aika OG - SkillService]], [[Aika OG - Aika Studio Web]], [[Aika OG - NPC Venda e Bloqueio de Arma 2026-10-09]].

- CharacterCreationService define nível 1; ausência de atribuição gerava byte zero.
- GetSkillIndex usa base zero para guerreiro e soma nível uma vez. Básicos 1/17/33/49/65/81 e primeiro Other 97 são nível 1 no SkillData. As demais skills não aprendidas continuam com Level=0. Não rebaixar skills treinadas nem todos os personagens existentes.
- Títulos têm tiers nativos 0–3; `.t 1` usava 1 (segundo tier verde). Agora concede/equipa 0. A lista 0x1086 empacota um bit por tier, e 0x361 transmite o índice nativo.
- Chat de drop usa notice=true do 0x0F0E; o client monta nomes, quantidades e cor pela raridade +390 do ItemList. Evidência: handlers 004a10f0 e 0068ccf0. Não inventar tags de cor no texto do 0x0984.
- Chat de EXP usa 0x0984 com flags zero; bit 0x10 produz banner. Texto limitado a 126 bytes ASCII com campo 128 e pacote 144, conforme terminadores +142/+143 do handler 005ae9c0. O handler 0x0108 não anuncia ganho no chat.
- Studio tem abas Itens e Skills que reutilizam o editor BIN; rascunhos sobrevivem à navegação. Troca de pasta bloqueada enquanto houver rascunho. Não houve gravação no client durante QA.
- 422 testes aprovados, zero falhas e dois skips SQL condicionais; frontend build/lint/quatro testes aprovados. Revisão de 320/768/1024/1920 px sem overflow, console sem erros/warnings.
- Endpoints do GameServer: 127.0.0.1/2/3:8822 e 127.0.0.1:8831. Não iniciar instância em segundo plano enquanto o operador roda no Visual Studio: erro 10048 AddressAlreadyInUse. A instância criada pela ferramenta foi retirada sem clientes; operador retomou pelo VS.

Relatório detalhado: `C:\Projetcts\aika-og\docs\reverse-engineering\GAMEPLAY-FIXES-2026-10-09.md`. Validação visual de venda/buff/título/drop após ativação ainda depende da execução pelo operador.

## Conferência da captura salva em 2026-10-10

- Commit atual: `2584fdc`. O log da solução confirma 422 aprovações e dois skips; a auditoria por pedido está no relatório detalhado.
- `realtime-gameplay-fixes-client2` tem 446 eventos. 0x0361 com status zero transmitiu título ID 2, tier 0; não comprova a aparência de `.t 1`. A lista 0x1086 tinha byte 0x12, misturando bits de títulos diferentes.
- Dois 0x0F0E com notice=0 e ausência de 0x0984/OUT 0x0320 deixam chat de drop/EXP e uso do buff sem validação nessa captura. Dois eventos IN com status não zero foram excluídos das conclusões.
- Nenhum GameServer/AikaClient/x32dbg ou sessão de debugger estava ativo na conferência. A captura skills está vazia; collector-status residual não prova execução. Rearmar somente com processo e sessão confirmados.
- Verificação visual restante: `.t 1`, personagem recém-criado nível 1 com Ataque poderoso nível 1, e aquisição/EXP após matar um mob. As abas Itens/Skills já têm QA visual; não houve gravação nos BINs.
