---
project: Aika OG
status: ativado
updated: 2026-10-12
---

# Studio: catálogo, menus e drops

Ativado: raridade editável, menus/painéis por NPC em lote, economia com chance igual+bônus+teto global diário, drops relacionais e explicação de títulos. Fonte de verdade: `C:/Projetcts/aika-og/docs/STUDIO-CATALOG-2026-10-12.md` e `tasks/todo.md`.

- 17 treinadores existem em `npcs`; alguns nomes são índices numéricos de `UI/MN.bin`. Exemplos2051/2052/2053, nomes44/45/46. Busca por título no Studio resolve a descoberta; não duplicar NPCs.
- Coluna correta é `option_texts_json`; dez opções nativas guardam ID/ordem. Menu/Painel em lote validado no navegador e em SQL descartável, incluindo rollback, versão e backup; API principal ativada.
- Leilão: opção48 no `NPCOptionsText.bin`, servidor Pascal `NPCHandlers.ShowActionHouse` envia0x310/26. 71→23 é desconhecido. Operações de leilão não estão implementadas; abertura visual ainda não testada no cliente real.
- `title_templates` é pai de identidade; nomes/níveis são `title_levels` e efeitos `title_effects`. Consulta142 títulos/568 níveis/538 efeitos.
- `mob_drop_profiles` relacional + `mob_drop_entries` ativados em aikaria:466 perfis/21708 entradas preservados. Ordinal global, DOUBLE e duplicatas; FK só entrada→perfil, pois há modelos/itens históricos ausentes. Migração/rollback/ciclos/retomada verificados em schema descartável. JSON antigo mantido em mdp_json_d475ea33f8c7416293841e672dc628b4 e registrado no ledger.
- Baseline v1/checksum não muda; extensões explícitas em `Database`. Importador/editores não executam DDL. Locks de banco compartilhados, backups únicos por geração e ledger. Rollback preserva edições recentes e recusa perda de precisão antes do corte.
- Economia escolhida: chance base igual, bônus explícitos e teto global diário por raridade; usuário delegou valores iniciais. DDL20.000/4.000/2.000/400/20.000/5.000 unidades UTC dia, bônus máximo+100%, calibráveis. Configuração/auditoria no Studio, sampler/CSPRNG, efeito283 ativo no atacante e integração nos ataques/skills implementados e testados.
- Não portar fórmula legada/contador da quarta tentativa. Efeito283 original é do atacante, não do mob. Auxílio8250 original ativa premium15dias; não há percentual próprio confirmado. Catálogo atual de Gato Preto tem tipo716/UseEffect8573.
- Receipt por morte, ordinal, claim atômico/pending, quota+inventário+XP/pontos em uma transação, reconciliação de commit incerto e coordenação por ID com autosave/desconexão/reload implementados. Sem envio de pacotes dentro do gate de persistência para evitar Close reentrante. Role mínima sem DDL verificada em banco descartável.
- Consumíveis nativos0x31D/24bytes: Gato30% e Auxílio20% por duração configurada, bônus relativos customizados. Consumo+boost+auditoria atômicos, bolsa/pilha/vivo validados. Mesma família prolonga tempo; percentual ativo diferente recusa renovação sem consumir. Relíquia10% inicialmente inativa, posse manual por nação; não há conquista automática nem novo benefício premium além do drop.
- Menu/Painel podem entrar no lote junto com lojas e outros NPCs. Prévia skills/loja usa SQL; receitas usa CSV atual com ID na primeira coluna. Loader Pascal antigo tem ordem diferente; o runtime C# não consome fabricação. Aparência final pertence ao cliente, operações de anvil/leilão não implementadas.
- Comandos .i/.e/tp/s/t agora exigem GameMaster/Admin e são aguardados pelo dispatcher; contas Player/Founder/Sponser/Moderator não podem emitir itens/efeitos administrativos. Troca de personagem faz Unbind antes de voltar à lista.
- Evidência final:581 testes GameServer;19 verificações relevantes de economia/migração/schema com MySQL;104 Studio em manutenção sem exclusões; UI em320/768/1024/1440. API/UI real:Alen Sinclair2051,3 opções/31skills de guerreiro, prévia original sem criar rascunho. Buff snapshots/Clone de arrays sincronizados com mutadores; falha de captura não deixa mob preso.
- Backup anterior em artifacts/studio/catalog-activation/20261012-223948-933f05e0, dump8.028.927 bytes+ZIP4.452.522 bytes/hash manifest; permissões atualizadas, Studio/GameServer ativos. Graphify code-only4462 nós/12733 relações; parserSQL opcional ausente, sem instalação adicional.
- Revisão Codex CLI falhou por inicialização MCP; usuário escolheu revisão independente local. Preservar auth/config/plugins. Outra tarefa edita skills/cast simultaneamente no mesmo workspace; preservar suas alterações.

Relacionadas: [[Aika OG - Aika Studio Web]], [[Aika OG - Studio NPCs e Mobs 2026-10-11]], [[Aika OG - Banco de Dados v1 2026-10-11]], [[Aika OG - Arcan Wiki e Catalogos 2026-10-11]].
