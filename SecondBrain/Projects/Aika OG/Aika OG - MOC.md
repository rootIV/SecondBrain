---
tags:
  - project/aika-og
  - architecture
  - game-server
updated: 2026-11-04
---

# Aika OG - MOC

- [[Aika OG - Textos dos Paineis Oficiais 2026-11-04]]: 2.341 textos pt-BR aplicados em três recursos; layouts/exe/menus personalizados preservados,24 testes e leitura pós-aplicação aprovados. Auxiliares e validação visual pendentes.

- [[Aika OG - Terreno nos Mobs 2026-11-04]]: ATT/HGT integrados a patrulha/perseguição/retorno/medo e formação;139testes/22.620checks reais.550retas ativas com restrições precisam de revisão ou pathfinding; sem editar rotas/reiniciar serviços.

- [[Aika OG - Colisao e Movimento Client 2026-11-04]]: validação nativa ATT/altura encontrada, bits01/40/200 e trajeto local;534checks dos bytes originais aprovados. Recepção0301 segue outro caminho. Sem patch/gameplay; integração de terreno no servidor e homologação pendentes.

- [[Aika OG - Curva PvE Mana e Area 2026-11-04]]: curva custom PvE4× pós-defesa, MP finito pelo HP e despacho de área por destinatário; teste mob80×player40 depende de armadura/vida. Auditoria de26modelos sem importar atributos; fonte testada isoladamente, sem restart/SQL e com homologação pendente.

- [[Aika OG - Studio Gravacao Itens e Aplicacao Global 2026-11-04]]: journal de ItemList recuperado sem publicar a edição; cliente local aceito após seis comparações nativas; revisão global e contagem de registros. 240 testes Studio, 42 focados finais, build/lint e navegador aprovados. Studio atualizado reaberto após fechamento manual; rascunho/patch do item preservados, arquivo/banco idênticos. Gameplay pendente.
- [[Aika OG - Caps Studio e Politica Runtime 2026-11-04]]: Caps novo, separado dos WorldProfiles removidos; seis rascunhos e política instalada, Published null/zero violações. GameServer 1900, Studio 231 e Token 25 testes passaram, SQL extras e frontend verdes. Studio atualizado aberto após confirmar instância anterior encerrada; rascunhos idênticos em bytes, backups preservados. Nenhum cap ativado; gameplay real pendente.

- [[Aika OG - Menus Efetivos e Lilola 2026-11-03]]: Studio projeta menus efetivos e preserva submenus; acentos e buffs Lilola exatos de três horas publicados via CAS. Preços10000/50000 preservados,35testes focados; Studio3388 sem restart e gameplay pendente.

- [[Aika OG - Studio Perfis de Spawn e Customs Ghoul 2026-11-02]]: perfis de spawn removidos e Studio atualizado/reaberto em 03/11; banco revertido aos 743 NPCs/376 modelos/5.900 spawns anteriores, drops e rascunho preservados. 196 testes Studio, clone SQL e validação visual aprovados; exclusão de builds históricos bloqueada por política.

- [[Aika OG - Rede Heartbeat e Desconexao 2026-11-03]]: framing linear, transporte aguardado, RTT opt-in e cliente com aviso/retorno ao login; .lag GM/Admin testa a própria sessão. Testes/x86/carga local passaram; ativação do GameServer e gameplay real pendentes.
- [[Aika OG - Buffers Pools e Framing TCP 2026-11-02]]: investigação histórica de RingBuffer/ObjectPool; framing posteriormente implementado com acumulador linear, sem ativar as duas classes.

- [[Aika OG - Sonar Servidores 2026-11-02]]: gate OK, zero achados abertos e 84,9% de cobertura nova; 67 correções iniciais, sete falsos positivos e dois riscos legados aceitos. Prehash/HTTP e homologação separados de vulnerabilidades corrigidas, protocolo preservado.

- [[Aika OG - Sessao Studio Perfis e Raiz 2026-11-02]]: recuperação de sessão limpa sem perder rascunhos editados, perfis de drops revisáveis, Raiz com cobertura parcial comprovada e66entradas de mapas com grades onde falta imagem.

- [[Aika OG - Auditoria Catalogos e Mapas 2026-11-02]]: 148 CSVs/46 versões, melhor base conjunta Rafinha data original, drops Lore mais amplos, ItemList.csv vazio e mapas_decrypted_ok com leitura além da tabela; nomes/limites exportados por cliente.

- [[Aika OG - Apresentacao Missoes Pran e Drops 2026-11-02]]: quebra nativa por pixels, navegação Evolução, cadência contínua da patrulha, XP da Pran limitada ao dono e regras globais de drops; publicado com backup, homologação visual pendente.

- [[Aika OG - Comando GM Missoes e Direcao Studio 2026-11-01]]: `.mi` por sessão GM com preparação/entrega transacional, planilha de 1.907 missões, filtro de relíquias do Moa e orientação de NPCs/mobs no Studio.
- [[Aika OG - Patrulha e Menu Nativo 2026-11-01]]: velocidade efetiva do cliente evita atraso e reposicionamento em patrulhas longas; navegação de menu não reabre a câmera. Homologação no jogo pendente.

- [[Aika OG - Itens Anotados Buffs e Eventos 2026-11-01]]:179anotações organizadas, XP por nível/variantes e poções revisados,39descrições/7nomes publicados,503itens de evento no Studio;17itens mitigados por bloqueio e fluxos nativos pendentes separados da implementação.

- [[Aika OG - Diamantes Catharina e Modo Teste 2026-10-23]]: missão 1522 e variantes com recompensa percentual de XP; limites, preservação de overrides e testes; homologação no jogo pendente.

## Documentacao oficial do client

- [[Aika OG - Client - Documentacao Oficial]]: referência do executável atual, assembly, protocolo, arquivos, atributos, funcionalidades implementadas e pendentes; identidade binária e verificações técnicas próprias.

- [[Aika OG - Opcodes e Simbolos 2026-10-18]]: catálogo245/245 sem gaps de source identificados; T121=estado de cerco,CCCCdesconhecido;11renomesC# e27símbolosGhidra persistidos; Studio verificado, clientinteiro ainda em investigação.

- [[Aika OG - Patch e Contrato Login 2026-10-17]]: v3 aplicado com toast/retry/timeout/mundos após auth; source valida tickets0x81/0x685, reply0x82 alinhado e seeds corrigidas; servidor ainda sem implantação, gameplay pendente.

- [[Aika OG - REA e Protocolo Nativo 2026-10-17]]: REA instalado, projeto Ghidra recuperado, sete símbolos persistidos, crypto validada e triagem de 0x039D/0x0101/seeds.

## Referencias

- [[Aika OG - Lacunas IA e Dano por Nivel 2026-11-04]]: catálogo SQL376/5623; modelos100/150com ataques200/300,10slots em7modelos bloqueados só por mana e31slots Area sem dispatcher.227testes/545asserts; curvas PvE4×/8× estudadas, sem instalar regra ou editar banco; corrigir conteúdo/mana/ações antes de calibrar nível.
- [[Aika OG - IA Combate e Niveis Referencias 2026-11-03]]: nova AIKA Source cadastrada; impacto atual sem fator direto de delta de nível, progressão/equipamento e controle/XP separados. IA e fórmulas comparadas com quatro forks; 189 testes, 841 asserts C# e 844 checks escalares Delphi, sem alteração de gameplay.

- [[Aika OG - Studio Refinado e Visibilidade Missoes 2026-10-21]]: UI minimalista, vínculos de início/entrega e ocultação persistente; coleta/relíquias bloqueadas sem cidadania; corrida de configuração corrigida. 93 missões exigem mapear NPCs locais.

- [[Aika OG - Instalacao Schema Reliquias 2026-10-21]]: extensão `relics` instalada no banco local; verificações de schema do startup e idempotência aprovadas, dados existentes preservados. Gameplay pendente.

- [[Aika OG - Grupo Solo Menus NPC 2026-10-21]]: grupo solo38F, menus/submenus pedidos, paineis nativos, bencaos e trocas atomicas; permissao de nacao/governo configuravel. Viagens de canal, reliquias nacionais, evolucao avancada e gameplay permanecem pendentes.

- [[Aika OG - Implementacao Lore Combate 2026-10-20]]: núcleo instalado com DEF/8, HP/MP Lore,49extras/cap11, refino nativo e IA/skills individuais.1.269+119testes passaram;123mobs normalizados e smoke real aprovado. Serviços parados; calibração de itens/bosses e gameplay pendentes.

- [[Aika OG - Desenho Lore Drops IA NPCs 2026-10-19]]: desenho para revisão sem implementação; Lore30%/quarta80%, categorias67/20/12/1, cotas transacionais atuais, formação melee/ranged/híbrida e censo local68NPCs/43opções. Painéis separados das operações; Valhalla/batalha e gameplay pendentes.

- [[Aika OG - Desenho Lore Combate 2026-10-19]]: proposta solicitada com Lore como base, HP/MP conservadores, DEF/8,49extras/cap11, curvas/IA corrigidas.30.180checks sintéticos; não implementado, catálogo e gameplay ainda exigem calibração conjunta.

- [[Aika OG - Lore Community Combate Atributos 2026-10-19]]: Graphify1834nós/3821relações/119comunidades; fluxo final ainda adiciona dano após defesa, curvas de crítico/duplo inconsistentes e HP mais conservador.13checks isolados; sem alteração de runtime. Corrige classificação legada de GetMobDamage na comparação anterior.

- [[Aika OG - Comparacao Combate IA Referencias 2026-10-19]]: atual versus Src de Rafinha/TheMu e AikaEmu; manter defesa/ameaça/patrulha atuais, aproveitar skills de monstros/DGs/refino nativo com validação.63 testes passaram; análise sem alteração de runtime.

- [[Aika OG - Referencias Externas AikaEmu e Delphi]]

Servidor open source otimizado para Aika, dividido em `GameServer`, `TokenServer`, `Shared` e `PacketTool`.

## Notas principais

- [[Aika OG - Auditoria Atributos Client 2026-10-22]]: 34 funcoes localizadas no build e1104cbb, seis correcoes da referencia C++ e evidencias REA/Ghidra; nomes de stats, ABI e gameplay ainda pendentes. Sem patch no executavel/servidor.

- [[Aika OG - Missoes Verificadas Ativas 2026-10-15]]: quests 1/5/7 executáveis e persistentes, recompensas atômicas, versão publicada e ativa.

- [[Aika OG - Expansao Mundo 2026-10-15]]:120NPCs/36lojas/53painéis aplicados; mobs sóanalisados, preservados.

- [[Aika OG - Guardas e Logs Aplicados 2026-10-15]]: 63 NPCs novos aplicados, objetos de missão/evento separados e logs dos coletores corrigidos.

- [[Aika OG - Captura Missoes Guardas e Lojas 2026-10-15]]: auditoria de nova captura, loja Thomas, menus, guardas/Devir, perda de payload de missão e coletor corrigido.

- [[Aika OG - NPC Skills Patrulha 2026-10-13]]

- [[Aika OG - Arcan Wiki e Catalogos 2026-10-11]]

- [[Aika OG - Arquitetura Atual]]
- [[Aika OG - Banco de Dados v1 2026-10-11]]
- [[Aika OG - Sistema de Auth]]
- [[Aika OG - CharacterService]]
- [[Aika OG - ItemService]]
- [[Aika OG - MobService]]
- [[Aika OG - SkillService]]
- [[Aika OG - Dual e Cast Nativo 2026-10-12]]
- [[Aika OG - NPC Spawn]]
- [[Aika OG - WorldDataService]]
- [[Aika OG - SessionManager]]
- [[Aika OG - PacketDispatcher e Protocolo]]
- [[Aika OG - AIKA.exe Win32 Dialogs]]
- [[Aika OG - Cliente OG 2026-10-09]]
- [[Aika OG - Auditoria Servidor Client 2026-10-09]]
- [[Aika OG - Depuracao Realtime x64dbg]]
- [[Aika OG - Coletor Passivo de Mundo]]
- [[Aika OG - Importacao Regenschein 2026-10-10]]
- [[Aika OG - NPC Titulos e Menus 2026-10-10]]
- [[Aika OG - BinEditor Sessoes e Seguranca]]
- [[Aika OG - AikaMasterTool Central e GM]]
- [[Aika OG - Aika Studio Web]]
- [[Aika OG - Studio Catalogo Menus Drops 2026-10-12]]
- [[Aika OG - Studio NPCs e Mobs 2026-10-11]]
- [[Aika OG - Criacao Titulos Chat e Studio 2026-10-09]]
- [[Aika OG - Buff Refresh e Opcodes 2026-10-10]]
- [[Aika OG - Atualizacao Oficial Compativel 2026-10-11]]
- [[Aika OG - Lojas e Recaptura 2026-10-11]]
- [[Aika OG - Alinhamento Aplicado Regenshein e Verband 2026-10-11]]
- [[Aika OG - Imagens de Mapas 2026-10-11]]
- [[Aika OG Development Skill]]
- [[Aika OG - Sistemas Nativos 2026-10-14]]
- [[Aika OG - Buffs Dual IA 2026-10-14]]
- [[Aika OG - Mobs Debuffs Emotes 2026-10-14]]

## Regras sensiveis

- [[Aika OG - Premium Store Cash e Perseguicao 2026-10-14]]: editor de cash em lote, benefícios na retirada, bolsas Pran, perseguição e acentos; ativado, gameplay pendente.

- Nao alterar `GameServer/Network/EncDec.cs`, `PacketTool/EncDec.cs` nem as keys de criptografia sem validacao binaria com cliente real.
- Preservar o contrato do `GameProtocol`: conexao, recebimento, descriptografia, dispatch e fechamento de sessao.
- Evitar mudar opcodes e layout de pacote sem documentar em `Opcodes.txt` e nas notas de protocolo.

## Codigo fonte

- [[Aika OG - Municao Aquisicao Movimento 2026-10-22]]: munição cash por catálogo, avisos nativos coloridos e movimento sem eco ao emissor; mercador duplicado desativado. 1.559 testes passaram e smoke real aprovado; guardas investigados, gameplay visual pendente.

- [[Aika OG - Eventos Drop e XP 2026-10-21]]: `.drop` calibra chance-base e pesos de raridade; `.xp` multiplica XP de evento. Configurações persistentes separadas; sem mudança de protocolo.

- [[Aika OG - Reliquias 2026-10-21]]: posse global transacional, selo20min, furto/caixas/altares, efeitos por cidadania e canal nativo; aprimoramento e gameplay pendentes.

- [[Aika OG - Progressao Pran e Retornos 2026-10-17]]: progressão normal, aquisição de Pran por missão e pontos salvos por continente; ativados, gameplay pendente.
- [[Aika OG - Toca Mundo Desconhecido e Numerica 2026-10-18]]: diária amarela e missão84 preservadas; PIN/hash retirados do fluxo; histórico da exclusão provisória, substituída pelo prazo de cinco dias.
- [[Aika OG - Exclusao Cinco Dias e Pran 2026-10-18]]: contrato nativo de prazoUnix, confirmaçãofinal3E01,espera5dias/cancelamento e guardaPRAN; substitui exclusão direta3F33 anterior.

- [[Aika OG - Missoes Mapa e Nivel 2026-10-17]]: mapa M por0x33D real, limite60, prefixoLVL/paginação8 e detecção final6; ativado, gameplay pendente.

- [[Aika OG - Textos Buffs Cast e Combate 2026-10-17]]: limites de mensagens, teste privado de chat, ajuda de missões, snapshots de buffs após spawn, ACK de cast e combate simultâneo/detecção15.

- [[Aika OG - Patrulhas e Simbolos NPC 2026-10-17]]: patrulhas manuais, símbolos após spawn/login, prioridade de cores e alcance visual50.
- [[Aika OG - Abandono Missoes 2026-10-17]]:0x032F, limpeza transacional de progresso/recibos e log de conclusão pós-commit.

- [[Aika OG - Missoes Recuperadas e Studio 2026-10-16]]: catálogo1907, modo de teste, runtime913regras, editores Títulos/Missões ativos, backup e limites de gameplay.
- [[Aika OG - Indices NPC Missoes 2026-10-16]]:461vínculos de índice nativo comprovados; não confundir índice/NameValue/ClientId.
- [[Aika OG - Movimento Guardas Reais 2026-10-16]]:11GuardasReais com movimento observado; rotas/IA ociosa não reconstruídas.

- [[Aika OG - Cash Label e Coletor Quests 2026-10-14]]: correção139 do texto cash, captura do ciclo de missões e novos itens iniciais.

- [[Aika OG - Economia Inventario 2026-10-14]]: cash, munição temporária, acesso às bolsas, limites de dinheiro e tesouro nacional.
- [[Aika OG - NPC Missoes e Itens de Evento 2026-10-14]]: menu Missão, marcador acima do NPC e confirmação 0x0359.

- [[Aika OG - Auditoria Regenshein e Verband 2026-10-11]]: nova captura comparada ao MySQL; faltas de identidade, modelos2505–2509, Lakior, slots/preços e caveats de movimento/IDs.

- Projeto atual verificado: `C:\Projetcts\aika-og` (caminho legado: `C:\Users\Vitor\Documents\Projects\aika_og`).
- [[Aika OG - Captura Paineis NPC 2026-10-15]]: abertura/conteúdo vinculados à opção do menu nos dois coletores; protocolo e renderização diferenciados.
- Solucao: `AikaOG.sln`
- Build de verificacao: `dotnet build AikaOG.sln`

- [[Aika OG - Desenho Atributos e Combate 2026-10-19]]: diagnóstico do adicional após defesa, refino ausente no recálculo e desenho para revisão; sem alteração de combate. Fórmulas oficiais e catálogo ativo ainda exigem validação.

- [[Aika OG - Balanceamento Classes e Progressao 2026-10-19]]: V1+49extras/cap11 instalada com backup;1.270 IDs/124 mobs/5 metadados de buffs.1.183+119 testes e smoke de quatro portas passaram; PvP bloqueado por zonas/alianças e gameplay/DGs pendentes. V1.1 descartada; modelo25.924 verificações não comprova gameplay.

## Venda ao NPC e Bloqueio de arma — 2026-10-09

- [[Aika OG - NPC Venda e Bloqueio de Arma 2026-10-09]]: preços nativos corrigidos e buff com carga implementado localmente. SQL/rollback verificados em clone e 378 testes passaram; ativação e gameplay pós-correção pendentes.

- [[Aika OG - Catalogos MySQL e Drop 2026-10-22]]: catálogos auxiliares e canais no MySQL, drop com `%`, editores sincronizados, importação aditiva/idempotente e smoke sem arquivos locais. Bloqueio premium do cliente atual revisto em [[Aika OG - Studio Rascunhos e Categorias 2026-10-23]]; gameplay manual pendente.

- [[Aika OG - Studio Rascunhos e Categorias 2026-10-23]]: rascunhos MySQL com servidores abertos, efetivação em manutenção, categorias/subcategorias e abas premium corrigidas com evidência nativa restrita.

- [[Aika OG - Pocoes e Consumo Seguro 2026-10-23]]: escopo explícito de 764 candidatos, 473 habilitados; consumo e recargas persistentes com proteção contra repetição/concorrência. Itens sem efeito comprovado bloqueados; gameplay e janela de perda de benefício após consumo documentados.

- [[Aika OG - Missoes Premium Pocoes e Studio 2026-10-31]]: diárias/nação/PvP, Auxílio8250 de30dias, ordem do feedback de cura e Studio com166categorias por item;3catálogos publicados seletivamente com backup. Número verde nominal e apresentação premium no jogo ainda não homologados.

- [[Aika OG - Recuperacao Nominal Textos e Studio Desktop 2026-11-01]]: patch nominal HPverde/MPazul/mistos aplicado com backup e emulação; JT20 e alinhamento corrigidos;3.053nomes/1.759descrições recuperados,1.382descrições sem fonte. Studio somente desktop1280+;182testes com SQL passaram. Homologação visual do jogo pendente.

- [[Aika OG - Nomes de Itens em Portugues 2026-11-01]]:600nomes espanhóis traduzidos seguindo o glossário brasileiro; cliente/MySQL sincronizados, snapshots revisão5, backup e validação dos31.000registros. Reabrir Studio para carregar nomes atuais.

- [[Aika OG - Descricoes Conjuntos e Avisos 2026-11-01]]:583descrições reparadas/traduzidas;584cabeçalhos de conjuntos corrigidos(Big5→nomesBR) eEfeito de conjunto; `.i` anuncia nome/quantidade/ID após persistência. SnapshotsItemListrev6/SetItemrev2;1.370descrições e divergênciaXP387 ainda pendentes.
