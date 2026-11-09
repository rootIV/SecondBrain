---
tags:
  - second-brain
  - debt
  - knowledge-quality
updated: 2026-11-04
---

# Knowledge Debt

## Aika OG — ativação e rotas após terreno, 2026-11-04

- [[Aika OG - Terreno nos Mobs 2026-11-04]] integra ATT/HGT na source, com139testes/22.620checks e coordenadas/altura reconciliadas. Homologar nova build no jogo sem assumir ativação: não houve restart. Revisar550retas ativas recusadas em terreno coberto e3origens custom ativas9999/9999, preservando catálogo até decisão explícita.8origens com flags bloqueantes podem sair da própria célula; não desativar automaticamente. Faltam busca de caminho/recuperação quando uma rota encontra barreira, LOS de ataques/colisão3D, regras por modelo/voadores, zonas sem ATT/HGT e medição do tick completo. Supercover é conservador em tangências; asset ausente não equivale a terreno validado. Dados de cliente ficam em snapshot local somente leitura no startup, separados dos catálogos editáveis do banco.

## Aika OG — colisão nativa confirmada e integração, 2026-11-04

- [[Aika OG - Colisao e Movimento Client 2026-11-04]] confirma ATT01/40/200 e altura no movimento local (534checks nativos offline), mas faltam amostras reais para reconciliar origem/chunks/buffer de altura e política de dados ausentes;200também é dinâmico. Restrição condicional de região não deve virar bounds universal. Recepção0301não chama os mesmos validadores nos corpos examinados, porém chamadas virtuais/atualizações posteriores não foram esgotadas. Implementar consulta do segmento no servidor em patrulha/perseguição/retorno após reconciliar dados; LOS de ataques, colisão3D e NVI continuam não comprovados. Sem publicação de gameplay nesta investigação.

## Aika OG — homologação da curva PvE e conteúdo, 2026-11-04

- [[Aika OG - Curva PvE Mana e Area 2026-11-04]] resolve na source mana inicial, área hostil e curva PvE4×, sem publicar catálogo/reiniciar. Escolher política de conteúdo para25modelos declarados100–150 que conciliam com49–56 nas fontes; não inflar ataques nem reduzir níveis automaticamente.15divergências Ghoul/Lore de ATK/DEF impedem importação indiscriminada; Cadáver80 tem potência baixa em todas fontes não-zero. Testes controlados não comprovam TTK real. Faltam captura de cores/telegraph de mob, contratos NVI/ATT/HGT para LOS/navegação, aliados/self-heal/bosses e calibração de perfil/leash/velocidade/cadência/controle/cap65535. Ativação no runtime e homologação no cliente permanecem pendentes.

## Aika OG — potência dos mobs, mana e nível, 2026-11-04

- [[Aika OG - Lacunas IA e Dano por Nivel 2026-11-04]]: definir contrato de mana na carga de mobs; MP0 padrão bloqueia10slots que ficam elegíveis apenas suprindo mana em7modelos.31slots Area em20modelos ativos precisam de dispatcher,25com custo0; não resolver convertendo área em single-target. Revisar26modelos70–150com ataques pequenos e identidades Mina Invisível4934/Aron1373 sem inventar nível/modelo. Curva PvE com banda±5 e teto4/8 foi apenas estudada; cobrir DoT/splash/adicionais/transferência/reflexão, proteger zero e separar PvP antes de implementar. Limiares de cor, telegraph, terreno/LOS, leash, velocidades e TTK precisam de captura/gameplay. Nenhuma regra ou dado foi publicado nesta análise.

## Aika OG — aplicação global de rascunhos, 2026-11-04

- [[Aika OG - Studio Gravacao Itens e Aplicacao Global 2026-11-04]]: journal real conciliado com arquivo/banco iguais, cópias preservadas e zero publicação do item. Builds desconhecidos permanecem bloqueados; o hash local 194f2367... foi aceito somente após seis comparações de código nativo com o original. Combinar editores do mesmo recurso exige conciliação antes da revisão global (ItemList/preços, Dialog/diálogos, missões/drops condicionais, perfil/lista manual); não rebasear ou descartar silenciosamente. A aplicação entre catálogos é sequencial e preserva etapas concluídas em falhas. Ativação resolvida após fechamento manual: Studio 23648/3388, backend/bundle novos e rascunho/patch preservados. Falta homologar publicação no jogo.

## Aika OG — guardas duplicados e restauração pré-Raiz, 2026-11-03

- [[Aika OG - Studio Perfis de Spawn e Customs Ghoul 2026-11-02]]: a reversão inicial dos perfis preservava 108 cópias de guardas inseridas pela importação Raiz, pois elas já estavam no primeiro snapshot. O usuário escolheu restaurar integralmente os 5.623 spawns/rotas anteriores a Raiz; 277 extras excluídos e 5.584 registros restaurados em transação, com teste isolado e conferência do plano no principal. Não reaplicar os planos históricos. Se houver nova importação Raiz, ampliar a conciliação NPC/mob além da exclusão especial do Guarda Real de Regenshein; o importador não foi alterado nesta correção de dados. Homologação visual após início dos servidores continua pendente; NPCs guardas originais devem continuar presentes.

## Aika OG — IA, combate e nível, 2026-11-03

- [[Aika OG - IA Combate e Niveis Referencias 2026-11-03]]: a fórmula atual de aplicação de controle aumenta a chance com o nível da vítima quando a resistência fica constante (rating 100: 58,33% no nível 10, 75% no nível 50). Confirmado no probe; falta decidir se essa direção é intencional. Não confundir com penalidade de dano por diferença de nível, ausente no núcleo examinado.
- Nova `D:\aika\AIKA Source`: fontes/DPR e tabela candidata StatusPoint identificados; associação do EXE compilado aos fontes/carga real de dados não comprovada. Não portar curva crítica de 100% com resistência zero, aleatório após defesa, regras Pheltas ou guardas sem calibração e captura própria.
- Validação estática, testes existentes e probes isolados com catálogos locais; faltam gameplay/TTK/carga, referência oficial de diferença de nível e comparação com os catálogos efetivamente carregados no MySQL. Notas de 19/10 são históricas; não reintroduzir o antigo fator K/(K+DEF) por confundir parâmetros mantidos com uso efetivo.

## Aika OG — framing TCP de entrada, 2026-11-02

- Resolvido em código em2026-11-03 por [[Aika OG - Rede Heartbeat e Desconexao 2026-11-03]]: acumulador linear, consumer aguardado e regressões de fragmentação/coalescência. A investigação original está em [[Aika OG - Buffers Pools e Framing TCP 2026-11-02]]. Permanecem homologação real de login/mundo/morte/troca/.lag, renderização, launcher e guerra100players; carga de echo/emulação não provam gameplay. Cliente instalado e validado por hash, GameServer precisa recompilar/iniciar no Visual Studio. Watchdog client15s não negocia alteração de timeout: recalibrar ambos se o valor for modificado.

## Aika OG — Sonar e transporte do TokenServer, 2026-11-02

- [[Aika OG - Sonar Servidores 2026-11-02]]: usuário decidiu manter HTTP8090 nesta etapa; alerta aceito, risco real preservado. Confirmar proxy/certificado e homologar TLS no cliente antes de removê-lo. Prehash MD5 do TokenServer antecede PBKDF2 e exige migração versionada de credenciais/cadastro; aceitação no Sonar não significa algoritmo forte. Resultados locais de análise/testes não comprovam implantação, MySQL condicional ou homologação do jogo. Não usar contagem zero de hotspots ou quality gate OK como sinônimo de ausência de problemas.

## Aika OG — Raiz e mapas sem textura, 2026-11-02

- [[Aika OG - Sessao Studio Perfis e Raiz 2026-11-02]]: 212 linhas Raiz ainda sem modelos/estatísticas seguros e quatro sentinelas não importáveis;16guardas são NPCs, não mobs duplicáveis. Importação parcial aplicada/verificada:5.867conciliadas/5.900spawns totais, não6.099. Mantidos modelos desativados. Catálogo Studio66entradas contém23grades sem JIT; não prova terreno ou área jogável. Perfis são pools adaptados, sem promessa de taxas oficiais de cada fork. Falta homologação de gameplay/colisão no cliente real.

## Aika OG — proveniência dos CSVs e limites de mapas, 2026-11-02

- [[Aika OG - Auditoria Catalogos e Mapas 2026-11-02]]: sem baseline oficial de drops/modelos de servidor para certificar conteúdo vanilla; maior cobertura e pasta original não provam autenticidade. Reconciliar Raiz de 6.099 spawns com nomes/modelos antes de importar. Limites extraídos de Map.bin são extensões UI, sem colisão/navegabilidade comprovadas; não usar LimitIndex como server map ID. Mapas CSV _ok leem área de nomes após80slots; descartar80+ e não transportar Distrito Glacial do BR para OG só pela existência do nome.

## Aika OG — apresentação, Pran e drops, 2026-11-02

- [[Aika OG - Apresentacao Missoes Pran e Drops 2026-11-02]]: cliente `4442e955...` publicado e testado offline; falta homologar GPU/mundo/sessão real para anúncios, RichText do diário, Local da missão 3075, marcha do guarda e troca/XP da Pran. Não inferir homologação visual pelos 10 testes x86 ou pelo Playwright do Studio. O gate de prefixo não oferece navegação a objetivos sem alvos implementados. Preservar e conferir o rascunho mesclado que recebeu autosave na primeira navegação QA; não houve publicação de catálogos por essa navegação.

## Aika OG — missões GM e direção, 2026-11-01

- [[Aika OG - Comando GM Missoes e Direcao Studio 2026-11-01]]: 1.907 missões exportadas não são 1.907 missões homologadas; 924 possuem gameplay definido e as restantes informam dependências. `.mi` aceita inspeção de IDs conhecidos, mas não inventa regras de objetivos/recompensas. Bypass é de sessão GM e deve ser revogado também no fluxo normal de NPC após demissão. Testar no cliente caminhada longa, navegação estática e `.mi`. Nomes relacionais de itens 26604/26603 possuem controles/fragmentos; no XLSX foram usados IDs/quantidades sem modificar os catálogos. A origem desses textos permanece pendente de análise específica.

## Aika OG — revisão dos itens anotados, 2026-11-01

- [[Aika OG - Itens Anotados Buffs e Eventos 2026-11-01]]: restam1.344descrições eTEST10000 sem texto íntegro; substitui a contagem anterior1.370.17itens bloqueados não equivalem a benefício implementado:14255–14258 apontam para skills nocivas de combate,21682/21683 para resistência em vez de cura,20130–20135/20464 precisam de concessão de título transacional. Animações15968/26035/26038/29347, skill de criação de água divina, negociação e teste real do cliente continuam abertos.4505novas ativações720h, mas arquivo legado9999h e prazos ativos preservados por falta de início de ativação. Não generalizar8124=4x:8001é2x, exceção8034/8046. Raiz OneDrive citada pelo modelo operacional é histórica; seguir `C:\Projetcts\SecondBrain` informado pelo usuário.

## Aika OG — missões, premium e recuperação, 2026-10-31

- [[Aika OG - Missoes Premium Pocoes e Studio 2026-10-31]] e [[Aika OG - Recuperacao Nominal Textos e Studio Desktop 2026-11-01]]: nominal HPverde/MPazul/mistos implementado por extensão de apresentação e patch calibrado local, com execução x86 emulada; homologar renderização no jogo, PREMIUM PC/fundo vermelho, marcadores/nomes de missões e retirada/expiração30dias. Emulação e consumidor estático0x14F não provam renderização. Clientes sem patch conservam delta. A falha original de bênção da Lilola não foi reproduzida na fonte atual; teste confirmou buff e atributos, e menus locais foram publicados seletivamente.
- [[Aika OG - Descricoes Conjuntos e Avisos 2026-11-01]]:restam1.370descrições e o nome interno TEST10000 sem fonte/modelo confiável após as duas referências disponíveis e reconstrução de mais12descrições nativas. Lista atual em artifacts/item-descriptions-pt-20261101-v2/remaining.json; manifesto anterior de1.382é histórico. Usuário confirmou que não possui outra fonte. Não inventar conteúdo de caixas/flags desconhecidas; distinguir textos oficiais, traduções e descrições editoriais.
- [[Aika OG - Descricoes Conjuntos e Avisos 2026-11-01]]:CharacterExperienceService fixa387positivo em4x, mas SkillData possui2/4/8. Reconciliar regra de XP com evidência antes de ampliar modelos descritivos; não foi alterado gameplay nesta entrega. Skill9087 precisa representar faixas4x/3x/2x, não apenas278=2. Homologar dentro do jogo os cabeçalhos de conjuntos e novo aviso de criação; dados/SQL/pacotes/Studio já verificados não comprovam a renderização final.

## Aika OG — diamantes da Catharina, 2026-10-23

- [[Aika OG - Diamantes Catharina e Modo Teste 2026-10-23]]: homologar a entrega das missões 1521–1524 no cliente real. A fórmula da recompensa tipo 60 foi observada no cálculo de exibição do cliente; o limite a 100% foi implementado conforme o diálogo 7784 e ainda não está comprovado por captura do servidor oficial. Não ampliar o suporte a outros parâmetros nem implementar repetição automática sem evidência.

## Aika OG — munição, avisos e câmera, 2026-10-22

- [[Aika OG - Municao Aquisicao Movimento 2026-10-22]]: validar tiro com munição cash e câmera com botão direito no cliente real; testes e evidência estática não substituem renderização/gameplay. Guardas Reais têm perseguição/retorno e efeitos documentados, mas sua IA específica de combate ainda não foi implementada e a patrulha ociosa completa continua sem captura suficiente. Manter a distinção entre regra de emulador e comportamento oficial comprovado.

## Aika OG — documentacao oficial do client

- [[Aika OG - Client - Documentacao Oficial]] concentra a referência vigente do executável instalado. As funcionalidades e interpretações incompletas estão em [[Aika OG - Client - Verificacao e Pendencias]]; promover o estado somente com a evidência correspondente, incluindo homologação no jogo quando aplicável.
- A verificação das seis notas resolve seus 46 wikilinks e os destinos das seções/fontes. O health check global do vault indica zero wikilinks quebrados, duas referências de workspace ausentes e três nomes de nota duplicados. Tratar esses itens na manutenção do vault; nenhum workspace ou nome de nota foi alterado para esta documentação.

## Aika OG — referencia de atributos do cliente, 2026-10-22

- [[Aika OG - Auditoria Atributos Client 2026-10-22]]: nomes de gameplay A..F, tipos de aliases globais, ABI/retornos, signedness fora do dominio nominal e tamanho completo do objeto continuam nao provados. A pasta D: contem referencia parcial, nao fonte original compilavel; nao transferir formulas para o servidor nem homologar Premium Store a partir dessa auditoria estatica. Evidencias e pendencias estao no documento revisado e em `audit-2026-10-22/verification.md`.

## Aika OG — Studio e missões, 2026-10-21

- [[Aika OG - Studio Refinado e Visibilidade Missoes 2026-10-21]]: 93 missões referenciam NPCs sem vínculo local validado; 97 outras não informam NPC de início/entrega. As 190 permanecem acessíveis no editor pelo filtro Sem NPC vinculado. Não criar associação por nome/offset ou spawn sem evidência. Gameplay de visibilidade e restrições de cidadania ainda precisa de cliente conectado.

## Aika OG — relíquias, 2026-10-21

- [[Aika OG - Reliquias 2026-10-21]]: falta validar gameplay de aura, caixa/coleta, altar, item link, combate nas pedras e transferênciaF05/F06/150. Extensão instalada no banco local `aikaria`, conforme [[Aika OG - Instalacao Schema Reliquias 2026-10-21]]. Verificar zonas seguras adicionais antes de anunciar PvP completo.
- [[Aika OG - Instalacao Schema Reliquias 2026-10-21]]: smoke real passou pelo startup e saiu com código 0 após ENTER, mas stderr contém quatro mensagens `Unhandled exception.` sem stack trace no encerramento. O script de smoke não valida stderr. Investigar fechamento/callbacks de accept em `TcpGameServer`; a ausência de verificação de cancelamento em `ProcessAccept` é hipótese, não causa confirmada. Caminho de rede preservado nesta correção.
- Aprimoramento: RU.bin contém receitas/pontos, mas contribuição/custo/resultado não têm semântica completa confirmada;64E/64F/650 bloqueados sem consumo. EF395/396 e habilidades especiais contra pedras permanecem pendentes. Não afirmar sistema de upgrade funcional.

## Aika OG — grupo solo e menus NPC, 2026-10-21

- [[Aika OG - Grupo Solo Menus NPC 2026-10-21]]: menus, grupo solo, bênçãos/trocas e permissões implementados; abertura de painéis conferida estaticamente e por testes de pacote, sem gameplay. Validar renderização e fluxo de diálogo no cliente alvo.
- Viagens Valhalla/Leopold exigem transferência de canal; Asteria/aliança/nação ainda sem destinos comprovados. Não substituir por coordenadas locais inventadas.
- Relíquias957 abrem slots vazios; faltam estado nacional, melhoria e definição das recompensas5/10/20. Evolução avançada com núcleo e cerco também permanecem pendentes. Não classificar esses serviços como concluídos porque a janela abre.
- Divergência preservada nos dados originais: quests 1516/1520 usam 2/20 Heroísmo, apesar dos rótulos 25/250. A nova troca aplica 25/250 conforme pedido e não altera o catálogo oficial bruto. As quests oficiais eram carregadas como jogáveis: `QuestHandler.FindQuest` agora exige que o menu efetivo ofereça missões, bloqueando o caminho antigo no Harald. Regressões exercitam comandos diretos de aceitar/concluir com 2/20 medalhas. Se um menu personalizado reativar essas quests, alinhar o consumo à regra do operador.

- 2026-10-20, [[Aika OG - Arquitetura Atual]] e [[Aika OG - Sistema de Auth]]: autenticação e startup separados localmente; não equivale à migração completa dos serviços estáticos de gameplay. Os estados aceitos no TokenServer e GameServer continuam divergentes por compatibilidade; TTL/rate limit/TLS seguem fora desta refatoração. Cliente real e integrações MySQL não executados. A suíte completa reproduz falha de movimento do Cubo/6344 também na compilação pré-refatoração, mas o grupo isolado passa; investigar estado/ordem e índice espacial antes de atribuir regressão ao login. Evidências em `docs/design/SERVER-RESPONSIBILITIES-REFACTOR.md`.

- 2026-10-20, [[Aika OG - Implementacao Lore Combate 2026-10-20]]: núcleo/normalização instalados e smoke aprovado;1.269+119testes passaram,10condicionais não executados por suíte. Pendentes gameplay, hierarquia real dos itens(Superior6732ATK351>Rare2549ATK253+32,Quest28/Honor35–45 eAcademiaLv1 de conteúdo posterior), navegação/colisão/LoS e mecânicas de boss/área/aliados/telegraph. Não alegar implementação de todo conteúdo nem natureza nativa completa dos124mobs: razões vêm doV1 ativo. Sem reescrita global de relógioUTC. Backup/rollback conjunto preparado; caminho de falha de cópia não foi injetado contra banco real.

- 2026-10-20, [[Aika OG - Desenho Lore Drops IA NPCs 2026-10-19]]: implementação parcial autorizada, revisão local. Drops em rascunho, ocupação melee/ranged estático, refino/redução de teste, criação de guild e viagens implementados; sem publicação/gameplay. `ItemUpgradePolicy.json` está temporariamenteAlwaysSucceed=true por pedido do usuário; não esquecer esta política ao sair dos testes. Custos A01/W01 divergem do cliente emUseEffect88/92/93/94; redução fora do modo de testes não tem regra de falha comprovada. Guild nova precisa da migração e grants; não inclui administração/skills completas. Separação0,6/desvio local não prova terreno/modelos grandes. Detecção6 preservada, cooldown3s veio do combate20/10; corrigir notas históricas de MobService conforme evidência atual. Lore não demonstra cota diária; censo68/43 não cobre todo SQL/cidade.2050Valhalla conflita com ThomasHenrikson; batalha/Valhalla, híbridos de Hessen, relíquias e demais seletores exigem contratos/captura. Janela não comprova operação/persistência. Registro canônico emdocs/operations/LORE-WORLD-IMPLEMENTATION-2026-10-20.md.

- 2026-10-19, [[Aika OG - Desenho Lore Combate 2026-10-19]]: proposta ainda em revisão, sem implantação. DEF/8 sem fatorK exige rebasear ATK/skills/cura e dados junto; conservar400ATK atual pode aumentar dano.30.180checks usam perfis sintéticos, não verificam itens/skills/IA/protocolo reais. Restam mapeamento de unidades e refino, coeficientes/custos por habilidade, navegação/linha de visão e bosses. Curvas suaves propostas não são fórmulas oficiais comprovadas; preservar essa distinção.

- 2026-10-19, [[Aika OG - Lore Community Combate Atributos 2026-10-19]]: calibração/gameplay das seis classes e refino seguem pendentes. Lore tem salto de crítico14→61% com1rating e inversão de resistência a duplo; SendDamage/AttackParse ainda acrescentam dano após defesa. Não transplantar fórmulas. GetMobDamage de Rafinha/TheMu foi reclassificado como legado sem chamador do dispatcher localizado; não usar exemplo255..353 como dano final ativo. Grafo inclui alternativas e links inferidos;20entradas sem nós,1SQL sem parser e2self-loops DFM. Conteúdo de altar/ranked/DGs não auditado integralmente.

- 2026-10-19, [[Aika OG - Comparacao Combate IA Referencias 2026-10-19]]: faltam rotação/cast/efeitos de monstros por IDs estáveis, mecânicas de boss/guardas/DG com catálogo comprovado, navegação/linha de visão e formação melee. Reinforce2 exige confronto com versão do cliente e valores totais antes de substituir curva+11. NationIDAlly declarado nos Delphi não comprova política de combate/alianças.63 testes atuais e traduções isoladas não equivalem a executar os forks ou medir gameplay/performance; não apresentar cálculos customizados como oficiais.

- 2026-10-19, [[Aika OG - Desenho Atributos e Combate 2026-10-19]]: catálogo ativo conferido (376 templates,13 totalmente zerados); adicional25..134 após defesa removido na implementação autorizada. Fórmula oficial de mitigação/ratings ainda não recuperada; V1 é customizada. CSV zerado não prova runtime zerado. Forks e calculadoras divergem e não autorizam apresentar coeficientes como oficiais.

- 2026-10-19, [[Aika OG - Balanceamento Classes e Progressao 2026-10-19]]: operador descartou v1.1 e autorizou primeira V1+49extras/cap11.1.270 IDs e124 mobs mapeados,56 instâncias auditadas sem refino>11; integração e ativação registradas no relatório operacional. Pendem gameplay/rotações/recursos/CC nas seis classes, IDs comprovados de dificuldades de DG, famílias desconhecidas e medição pareada com oficial.25.924 verificações isoladas não provam balanceamento real; feiticeiro18,8s não atinge a referência20s. Orçamento de máximo não concede efeitos novos automaticamente.

- 2026-10-17, [[Aika OG - Progressao Pran e Retornos 2026-10-17]]: ativação/migração concluídas; gameplay pendente. Geometria não cobre todos os mapas/dungeons: manter fallback antigo de revive em região desconhecida e não consumir pergaminhos sem região comprovada. Portal 8079 mantém LV51; caixa 15954 nome20/conteúdo200 está inconsistente nos arquivos local/oficial. Daily/repeat ainda não renovam periodicamente. Condição 48 OR, orientação 29 e chance/alvo de drops da quest38 são reconstruções documentadas, distintas da prova do parser. Cadeia Pran 38–41 implementada e validada em SQL isolado; não a manter como bloqueio antigo não resolvido.

- 2026-10-17, [[Aika OG - Patch e Contrato Login 2026-10-17]]: identidade0x81/0x685 e reply0x82 corrigidos/testados na source; v3 do client aplicado. Falta implantação coordenada do servidor e login real/UI, TTL/ban/custo/rate limit/TLS. Assinatura Authenticode inválida; reabrir client. Guardas históricos continuam exigindo o original preservado.

- 2026-10-17, [[Aika OG - REA e Protocolo Nativo 2026-10-17]]: confirmar finalidade de0x039D, branches de0x0101 com DWORD+16 versus frames históricos14 e limites receiver0x6000/emissor0x5fff. Seeds consecutivas corrigidas/testadas na source; coletores agora reconhecem14 sem inventar campos. Projeto Ghidra recriado porque artefatos históricos faltavam; exports antigos não foram todos regenerados. Caminhos C:\Users\Vitor/OneDrive históricos estão obsoletos; usar caminhos atuais, sem reorganizar vault.

- 2026-10-17, [[Aika OG - Patrulhas e Simbolos NPC 2026-10-17]]: símbolos próximos corrigidos pela ordem349→10D e byte93/estado5, com refresh ao login. Não há evidência de que10D produza ícones globais para NPCs fora da área carregada; se o mapa continuar divergindo, capturar abertura/login OG e oficial em vez de inventar histórico/BIN. Patrulhas manuais usam linha reta, sem navegação; validar no jogo antes de definir rota atravessando construções. Versão ativa e testes aprovados, mas renderização visual/carga ainda não comprovadas.

- 2026-10-16: health check do vault retornou zero wikilinks quebrados, mas falhou por referências existentes de workspace a `Untitled.canvas` e `Untitled.base` ausentes. Também apontou três grupos de nomes duplicados; não reorganizados para preservar os links e o workspace do usuário. Evidência: `C:/Projetcts/aika-og/artifacts/full-quests/2026-10-16/second-brain-health.log`.

- 2026-10-16, [[Aika OG - Missoes Recuperadas e Studio 2026-10-16]]: supera nota antiga de ausência total de progresso de missão. Há persistência e recompensa atômica para regras suportadas;994registros continuam pendentes. Das913regras disponíveis,241dependem de mobs ausentes e2de itens ausentes.54missões OG têm conflitos de diálogos oficiais; não habilitar sem reconciliar. Falta gameplay completo, repetição periódica e semântica de objetivos/eventos/drops específicos. Modo de teste explicitamente ativo; desligar antes de uso normal da progressão. Vault foi usado em C:/Projetcts/SecondBrain; o Operating Model ainda cita raiz OneDrive antiga, não reorganizada nesta tarefa.

## Mobs, DOT, emotes e exclusão — 2026-10-14

[[Aika OG - Mobs Debuffs Emotes 2026-10-14]]: regras/packets e SQL passaram; ativado PID47984 com17 hashes e backup. Validar no cliente distância visual, ticks brancos0x103/flag1, pose do Estripador e teclado/diálogo3F33 etapa7→603. Exclusão lógica mantém nome reservado e dependentes; recuperação não pode ocupar um slot já reutilizado. Personagens sem PIN ou com3 erros exigem configuração/desbloqueio antes de excluir. Outros tipos de ranged ainda precisam de evidência de ataque básico; não derivar perfil do alcance da patrulha. x64dbg não conectou; emissores foram verificados por análise estática do binário, sem teste destrutivo em personagem real.

## Studio: painéis e economia — 2026-10-12

[[Aika OG - Studio Catalogo Menus Drops 2026-10-12]] foi ativado com backup e preservação de466 perfis/21708 entradas. Pendências de produto fora da configuração de painéis/drops: validar aparência/abertura no cliente Aika real; implementar operações de fabricação/encantamento/leilão e conquista automática de relíquias (posse atual manual por nação). Tetos iniciais são calibráveis, não prova de equilíbrio; precisam de população/consumo. CSVs atuais ligam ingredientes ao ID da primeira coluna de MakeItems, enquanto o loader Pascal antigo usa outra ordem; não reutilizar o loader por suposição. Graphify não extrai SQL neste ambiente por faltar parser opcional; o grafo atualizado é de código, não evidência de todas as relações de schema.


## Aika Arcan e atributos — 2026-10-11

[[Aika OG - Arcan Wiki e Catalogos 2026-10-11]]: atualização 12/10 resolveu acesso MySQL e importou 466 perfis a 25% no banco como única fonte de drops; 363 templates correspondentes atualizados. Overlay JSON removido e atributos de jogadores restaurados aos anteriores, sem migração de personagens. Permanecem 103 perfis sem modelos locais e itens 5595/8739/15300/20635 ausentes; confirmar assets/identidades antes de criar ou remapear. 337 taxas normais são estimativas; dependência entre específicos/calendário dos eventos não publicados. Gameplay pós-importação não validado. Preservar os backups SQL e a raiz atual C:/Projetcts/SecondBrain/SecondBrain.

## Banco de Dados Aika OG v1 — 2026-10-11

- [[Aika OG - Banco de Dados v1 2026-10-11]]: AccountLogin TCP descarta um campo de 32 bytes; faltam captura do cliente e validação do significado antes de mudar autenticação. PIN numericToken em texto, expiração de tokens e banDays baseado em tokenCreationTime seguem abertos.
- active_buffs tem dono polimórfico sem FK: remoção física de personagens deve limpar seus buffs explicitamente. Credenciais antigas precisam ser rotacionadas; remoção do código não limpa o histórico Git.
- A baseline foi validada em MySQL local e bancos temporários. Não houve benchmark com carga nem login no cliente real.

## Studio NPCs e Mobs — 2026-10-11

- [[Aika OG - Studio NPCs e Mobs 2026-10-11]]: cabeçalho de quest.bin atual não fornece vínculo direto ao ID runtime de NPC do catálogo SQL. Usar as 34 associações não vazias de Quests.csv; 17 definições estão ausentes no cliente. Ampliar somente com associação comprovada. TalkId/seletor não comprova slot de diálogo.
- Calibração por mapa implementada, mas alinhamento in-game de todas as regiões ainda pendente. Filtro usa coordenadas, pois não há mapa explícito nas entidades; regiões sobrepostas podem compartilhar pontos. Patrulha configurada não valida movimento observado nem comportamento após edição em gameplay.

## Aika OG: imagens e coordenadas dos mapas — 2026-10-11

- Referência: [[Aika OG - Imagens de Mapas 2026-10-11]]. Exportação de 46 PNGs validada, incluindo os 16 mapas solicitados; fontes preservadas.
- Aberto: rastrear associação nativa de nomes/texturas, distinguir índices de UI dos IDs do servidor e calibrar coordenadas/pixels/margens no cliente antes de permitir posicionamento de hordas por clique.

## Caminho operacional do vault — 2026-10-11

- As instruções atuais indicam `C:\Projetcts\SecondBrain`; o MOC e as notas foram encontrados em `C:\Projetcts\SecondBrain\SecondBrain`. [[Knowledge Operating Model]] ainda declara a raiz histórica em OneDrive. Confirmar o caminho canônico e atualizar a governança em tarefa própria; nenhum arquivo foi movido ou renomeado.

## Aika OG: atualização aditiva do oficial — 2026-10-11

- Referência: [[Aika OG - Atualizacao Oficial Compativel 2026-10-11]]. Aplicados 1.533 itens, 403 habilidades, 136 definições de conjunto, nove títulos, 156 nomes MN e 448 arquivos de recursos; 504 testes C# e 11 Python aprovados, 18 tabelas protegidas intactas e reversão validada em clone.
- Corrigido: cabeçalhos `USE aikaria` das migrações desviavam conexões temporárias para o banco normal. Runtime/catálogo agora respeitam o banco configurado; regressão antes de persistir e isolamento explícito do testhost.
- Aberto: gameplay visual/combatente dos recursos novos; ativação por índices globais de modelos/animações; associações dos conjuntos novos; mecânicas oficiais além das regras já existentes no OG. Nomes MN não equivalem a novos NPCs/spawns.
- Aberto: 31 definições legadas de título do antigo parse 256/64 preservadas no banco; personagens ainda referenciam 225/226/230. Mapear ownership somente com evidência, sem apagar ou converter por suposição. Data/client e títulos nativos MySQL alinhados em 224/56.

## Regenschein importada — 2026-10-10

- Resolvido: [[Aika OG - Importacao Regenschein 2026-10-10]]. 68 NPCs/40 lojas/882 slots aplicados e comparados ao catálogo MySQL/Data/client local. 21 templates de itens acrescentados, MN 2847 preenchido, footer local corrigido, 17 registros antigos da área removidos. SQL/arquivos anteriores preservados. 40 testes Python, integração PowerShell e 72 testes C# específicos aprovados.
- Corrigido: contagens históricas de 112 registros não eram 112 NPCs; 44 Prans/personagens BR com nome literal/classe zero foram excluídos. Classe zero isolada não distingue NPC de Pran; filtro exige identidade MN numérica.
- Aberto: captura antiga sem aparência dos NPCs BR; 15 modelos provisórios, opções de serviço não capturadas e visual pós-importação sem validação. Item 1521 de Alen Sinclair vazio no bin oficial; não inventar definição. Outros NPCs fora do retângulo percorrido não foram removidos. Não extrapolar a lista de lojas para preços/serviços/patrulhas oficiais completos.

## Aika OG: patrulha independente dos mobs — 2026-10-10

- Referencia: [[Aika OG - MobService]]. Esperas por passo, oscilacao na volta e atraso de mobs visiveis pelo round-robin corrigidos no servidor; 407 testes aprovados.
- Aberto: ativar a build nova no GameServer em execucao e confirmar visualmente no cliente o movimento continuo, partidas independentes e retorno ao ponto inicial. Passos e velocidade de packet foram preservados; nao inferir calibracao visual apenas pelos testes de estado.

## LotoJogo: asserções antigas na fila operacional — 2026-10-09

- A suíte completa do frontend apresenta duas falhas em `DashboardWorkQueue.test.tsx`: espera “Estratégias configuradas” e “Pronto para gerar”, enquanto `DashboardWorkQueue.model.ts` usa “Configuradas” e “Pronta”. Ambos os arquivos estavam sem alterações nesta tarefa de combinações.
- Pendência: alinhar as asserções ao contrato atual de texto da fila; não mudar o produto para atender expectativas antigas. Lint, build, testes focados de combinações e os 491 testes do backend passaram.
- A divergência de caminhos OneDrive/vault já registrada abaixo permanece: o vault acessível e utilizado foi `C:\Projetcts\SecondBrain\SecondBrain`.

## Aika OG: referências de caminhos e tamanhos antigos — 2026-10-09

- O MOC e notas herdadas apontam para `C:\Users\Vitor\Documents\Projects\aika_og`; o workspace desta verificação é `C:\Projetcts\aika-og`.
- O Knowledge Operating Model ainda cita a raiz OneDrive, enquanto as instruções atuais do usuário apontam para `C:\Projetcts\SecondBrain`, com conteúdo em `SecondBrain/`. Não houve migração ou reorganização nesta tarefa.
- `T_SkillData` Delphi tem 716 bytes; o cliente OG observado usa slots de 720. A divergência está documentada em [[Aika OG - MasterEditor File Crypto]], sem alteração da referência antiga.
- Pendência técnica: estabelecer o significado dos quatro bytes finais de ItemList/SkillData e validar arquivos editados numa sessão do cliente. O editor preserva esses bytes.

## 2026-10-05 — metadados de records na importacao historica

- Ao corrigir o registro de quota, a busca identificou DataAnnotations com `property:` nos construtores primarios de `HistoricalBetImportRequest` e `HistoricalBetInputDto` em `lotojogo-api/Models/HistoricalBetDtos.cs`. O MVC exige atributos nos parametros de records; ha risco do mesmo erro de validacao na importacao historica. Esses DTOs tambem podem ser validados diretamente por DataAnnotations, portanto revisar os consumidores e adicionar cobertura MVC antes de alterar. Fora do escopo da correcao de estrategias/combinacoes.

## 2026-09-22 — avisos e agendamentos antigos de concursos

- LotoJogo: o aviso genérico de validação do filtro usa qualquer concurso stale da categoria, não somente o selecionado. Pode persistir por causa de registros antigos. A abrangência foi preservada ao corrigir cache, abertura de estratégias e startup da API.
- No runtime local, o control center ainda mostrou alguns concursos antigos como abertos apesar de existirem resultados posteriores. A lista de seleção aplicava a política de encerramento corretamente. Revisar reconciliação de concursos antigos e a escolha do próximo concurso no control center em trabalho próprio; não limpar dados históricos sem conferir referências de lotes/rascunhos.
- Caminhos OneDrive em regras antigas do projeto/vault divergem do MOC atualizado: checkout e vault atuais usados e verificados em `C:\Projetcts\Lotojogo` e `C:\Projetcts\SecondBrain`.

Registro de lacunas, duplicacoes e inconsistencias da base de conhecimento.

## Aberto

### Oferta comercial de planos do LotoJogo

- Detectado em 2026-09-18 durante [[Checkout Mercado Pago]]. A landing anuncia Plus e beneficios ilimitados que nao correspondem aos planos/quotas da API.
- O checkout foi limitado aos contratos implementados: Pro e Bolao, um mes por pagamento, renovacao manual. Reconciliar landing e politicas de quota antes da ativacao comercial.

### Nomes duplicados `Architecture`

- Detectado em 2026-07-25 pelo health check do vault.
- Impacto: wikilinks para `[[Architecture]]` podem ficar ambiguos no Obsidian.
- Arquivos:
  - `SecondBrain/Projects/LotoJogo/Architecture.md`
  - `SecondBrain/Projects/MotionInBet/Architecture.md`
- Mitigacao pendente: desambiguar nomes ou links quando houver contexto suficiente para decidir o padrao por projeto.

### Nome duplicado `Decision Log`

- Detectado em 2026-08-26 pelo health check do vault.
- Impacto: wikilinks para `[[Decision Log]]` podem ficar ambiguos no Obsidian.
- Arquivos:
  - `SecondBrain/Projects/EvoCine/Decision Log.md`
  - `SecondBrain/Projects/LotoJogo/Decision Log.md`
- Mitigacao pendente: preferir links qualificados por projeto ou renomear notas apos verificar impacto no vault.

### Referencias ausentes no workspace Obsidian

- Detectado em 2026-08-26 pelo health check do vault.
- Impacto: `.obsidian/workspace.json` referencia artefatos que nao existem mais, o que mantem o health check em falha.
- Referencias:
  - `Untitled.canvas`
  - `Untitled.base`
- Mitigacao pendente: limpar o workspace ativo do Obsidian ou recriar artefatos apenas se eles ainda forem relevantes.

## Resolvido

### Referencias antigas no workspace Obsidian

- Resolvido em 2026-06-05.
- Justificativa: referencias a `DesignSkills`/`design-skills` foram removidas de `.obsidian/workspace.json` apos verificar que os diretorios nao existem no vault atual.

### Vault raiz vs subpasta `SecondBrain`

- Resolvido operacionalmente em 2026-06-05.
- Justificativa: [[Knowledge Decisions]] definiu a raiz `C:\Users\root4\OneDrive\Documents\Projetcts\SecondBrain` como vault operacional e `SecondBrain/` como namespace principal de conteudo, sem migracao fisica neste momento.

### Arquivos com extensao dupla `.md.md`

- Resolvido em 2026-06-05.
- Justificativa: `AGENTS.md.md` e quatro notas em `Skills` foram renomeados para `.md`; referencias diretas nos workspaces Obsidian foram atualizadas.

### Consent/Handshake sem MOC nomeado padrao

- Resolvido em 2026-06-05.
- Justificativa: criado [[Consent - MOC]] e conectado ao `README.md`, mantendo compatibilidade com a entrada antiga.

### Wikilinks orfaos de modalidades de loteria

- Resolvido em 2026-06-05.
- Justificativa: criadas notas curtas para [[Quina]], [[Timemania]], [[Time Mania]], [[Lotomania]], [[Mega-Sena]], [[Dia de Sorte]] e [[Dupla Sena]].

### Notas vazias de skills

- Resolvido em 2026-06-05.
- Justificativa: as notas vazias foram preenchidas como indices praticos para reduzir orfaos sem substituir as skills reais instaladas.

## FRP Brasil — incidente de pagamento e páginas, 2026-10-09

- Referência: [[FRP Brasil - Investigacao externa 2026-10-09]]. Revisão pública concluída; causa raiz, data da invasão, beneficiário e estado atual do pagamento ainda não confirmados.
- Aberto: coletar e correlacionar auditoria administrativa, logs de hospedagem/deploy, histórico do banco e auditoria do provedor financeiro; verificar persistência e limpeza.
- Aberto: confirmar no backend operações de 2FA/API por GET e os controles CSRF/autorização. Bibliotecas em versões afetadas foram identificadas, sem demonstração de exploração no site.

## Pesquisa Aika OG — 2026-10-09

- Referência: [[Aika OG - Cliente OG 2026-10-09]]. Cliente com hash `7eca8e1e6573dc439cc803ef6cafe91aaca53e6c60d4b3bfd82ab267a7ad81aa`.
- Aberto: MakeItems tem 26.000 slots de 52 bytes; loader espera 31.000. Não preencher a cauda com receitas supostas.
- Aberto: hosts locais de SL coexistem com IPv4s antigos no campo 32; uso efetivo desse campo depende do consumidor/caminho ativo.
- Aberto: origem das diferenças entre footer e checksum nativo; comparações não condicionam rejeição nesta versão, sem evidência sobre outros checks/builds.
- Aberto: aceitação em sessão, campos de quests/crafting restantes, flags/eixos/escala dos mapas, AKM/meshes/animações completos e três JIT excepcionais.
- Resolvido nesta pesquisa: função do footer Item/Skill/PI comprovada por rotinas x86 escalar/SIMD; editor recalcula Item/Skill após edição. A pendência anterior de fórmula do footer não deve ser repetida como desconhecida.
- Resolvido no upgrade BinEditor: checksum SetItem comprovado escalar/SIMD/reference (64–215); editor recalcula também PI e SetItem. Ver [[Aika OG - BinEditor Sessoes e Seguranca]].
- Aberto no upgrade: associação automática de ID de ícone com atlas/célula, especialmente skill offset 0, ainda inferida. Pixels JIT estão verificados; não extrapolar isso para semântica de ícones. Referências cruzadas completas de quests/crafting/skills/NPCs ainda não estabelecidas.

## Aika Studio Web — 2026-10-09

- Referência: [[Aika OG - Aika Studio Web]]. Auditoria estática registra 153 entradas ausentes, três construtores sem fluxo e `0x306` com handler vazio; validar por captura antes de implementar/remapear protocolo.
- Aberto: perfil 10 em conta existente fora do enum 0–5 da source. Preservado e sinalizado; resolução operacional depende do papel pretendido para a conta.
- Aberto: gravações de bins e SQL são operações separadas; não há sincronização automática. Ícones/raridade mantêm as inferências já registradas na pesquisa BinEditor.

## AikaMasterTool GM — 2026-10-09

- Referência: [[Aika OG - AikaMasterTool Central e GM]]. Manutenção é confirmada pelo operador, sem prova de ausência de sessões remotas. Uma administração em tempo real exige um contrato autenticado com o GameServer e aplicação via serviços de domínio.
- Aberto: separar relógio de expiração de banimento de tokenCreationTime antes de implementar banimento temporário. Interface atual oferece somente banimento permanente/suspensão.

## Auditoria servidor/client Aika OG — 2026-10-09

- Resolvido: [[Aika OG - Auditoria Servidor Client 2026-10-09]]. ExpList e SetItem corrigidos com 8 regressões. Catálogo MySQL ativo comparado e sincronizado após autorização expressa: zero diferenças entre client/Data/banco para itens e skills, EXP101 e conjuntos/comportamentos alinhados. Backup SQL/Data e verificação preservados; bootstrap confirmou database.
- Resolvido: 83 vínculos de conjuntos e 17 drops sem referência válida removidos de Data/banco; 352 testes aprovados na solution, 1 ignorado, runner legado exit0. Execuções finais usam banco temporário isolado.
- Aberto: 159 lojas observadas vazias, sem StoreData externo. Preencher exige fonte válida. Semântica do DWORD/bloco secundário de EXP, limite de nível e associação completa de conjuntos novos ainda não comprovadas; não extrapolar paridade das tabelas para essas regras.
- Verificado em captura: ClasseRuim moveu, trocou item de slot e retornou, atacou com animação/dano e reentrou no mapa, conforme operador e 1.098 registros no client. 118 pares de saída completos passaram em payload/checksum; sem prova de compatibilidade completa. Ver [[Aika OG - Depuracao Realtime x64dbg]].
- Aberto: duas recepções de mobs retornaram status 4 por seed consecutiva repetida (`0x50` e `0x17`), com payloads diferentes. Source escolhe seed aleatória antes da fila, sem garantia por conexão. Corrigir no fluxo final por conexão respeitando concorrência/broadcast e validar nova sessão; nenhuma correção de protocolo aplicada nesta captura.
- Aberto: login inicial/autenticação e sistemas/classes restantes não capturados; `0x925` de 6380 bytes limitado aos primeiros 4096. Não extrapolar movimento/inventário/combate para quests, crafting, lojas, trade ou PvP.
- Resolvido: [[Aika OG - WorldDataService]] atualizada para o bootstrap que prioriza MySQL. Aberto: MOC principal e Knowledge Operating Model ainda declaram raízes legadas do vault; a raiz usada e verificada neste trabalho é `C:\Projetcts\SecondBrain`, com conteúdo em `SecondBrain/`. Não houve reorganização de notas.

## Venda ao NPC e Bloqueio de arma — 2026-10-09

- [[Aika OG - NPC Venda e Bloqueio de Arma 2026-10-09]]: paridade anterior client/Data/banco usava parser com preços deslocados em quatro bytes; não demonstrava semântica correta dos preços. Corrigidos parser/editor e cálculo local, com 378 testes aprovados e migração/rollback validados em clone.
- Resolvido: migração específica aplicada em aikaria, 16.471 preços sem divergências e 16 comportamentos confirmados; servidor/Studio recompilados. Aberto: medir venda/buff no gameplay após ativação.
- Aberto: delta exato da venda informada acima de 12 mil não capturado. Regra de uma carga do efeito 221 implementada conforme descrição/dados, sem validação operacional ou servidor oficial; taxas especiais e stacks realtime não cobertos.

## Buff refresh e opcodes — 2026-10-10

- Resolvido e ativado: [[Aika OG - Buff Refresh e Opcodes 2026-10-10]]. Client exige 0x016E de 252 bytes/40 slots; pacote anterior de 372 bytes era ignorado. Cinco regressões RED/GREEN e 438 testes aprovados. Build ativada às 11:01 de 2026-10-10; operador confirmou a remoção manual de Bloqueio de arma em ClasseRuim. Aberto: confirmar consumo por dano e expiração do ícone no gameplay.
- Aberto: 0x0327 é cancelamento de skill e 0x03AE consulta de valores nas lojas/PI, ambos sem handler. O fluxo J/seletor 2 foi confirmado como CASH da Loja Premium; seletor 1 e associação financeira ainda precisam de prova. O servidor ainda precisa de casts canceláveis; não ocultar os avisos com handlers vazios.

## Ataques de mobs e loja J — 2026-10-10

- Resolvido e ativado: [[Aika OG - MobService]]. Sete famílias indicadas usam skills básicas nativas e alcance 11; Toupeira sem slots de skill não vira melee. Perfil Magic usa stats mágicos. Registros comparados aos bins atuais, 23 regressões específicas e 472 testes aprovados. Build ativada às 11:22 (São Paulo); operador confirmou ataque à distância com efeito.
- Aberto: nome do mob específico testado não informado; não inferir confirmação visual de todas as famílias. Dano oficial dos templates com ataque zero e tempos reais de cast ainda sem calibração. Skills especiais/buffs nos cinco slots não equivalem ao ataque básico.

## Spawn e títulos — 2026-10-10

- Corrigido localmente: `.s` deixava apenas um mob visual sem registro na IA. Agora usa template real, ID único, índice espacial e threat do jogador vivo próximo. Parser de títulos corrigido de 256/64 para 224/56 bytes e Title.bin sincronizado com o client atual; sugestões usam IDs reais.
- Build padrão concluída após encerramento confirmado e portas livres; spawn de comando tem CanRespawn=false. Suíte final 496 aprovações/zero falhas/dois skips SQL. Aberto: operador iniciar com F5 e validar morte/espera de 60 segundos de `.s 19`; `.s 432`, `.t 126` e `.t 200` ainda sem confirmação visual. A posição do spawn usa offset simples sem validar terreno. Títulos antigos já possuídos não foram removidos do banco.

## Inventário Premium — 2026-10-10

- Confirmado no client: J envia 0x03AE/seletor 2 para CASH e 0x020A/header de 12 bytes em fluxo de atualização do inventário. Snapshot 0x0138 de 204 bytes contém 24 registros de 8 bytes; WORD inicial é índice PI.bin (1–5999), resolvido para o ícone. Não confundir com ItemEntity de 16 bytes.
- Aberto: 0x03AE/0x020A continuam sem handler; a source envia apenas 0x0138 vazio na entrada no mundo. Persistência/retirada e os demais campos dos registros de 8 bytes não foram mapeados. Saldo zero e slots vazios da tela não provam conta sem CASH/compras. Pareamento realtime de consulta/resposta com servidor funcional e compra/retirada real ainda não capturados.
- Evidência: [Inventário Premium](C:/Projetcts/aika-og/docs/reverse-engineering/PREMIUM-SHOP-INVENTORY-2026-10-10.md).

## Grafo do lote Studio — 2026-10-12

Também pendente: novos nósPendingSkillCast/SkillCastService após [[Aika OG - Dual e Cast Nativo 2026-10-12]]. Atualizar AST após consolidar o checkout compartilhado. Validação visual da nova build e fases especiais de cast do cliente(offset328) permanecem abertas; os568 testes aprovados não comprovam animação renderizada.

`graphify-out/graph.json` de `C:\Projetcts\aika-og` ainda não contém WorldWorkspace.SaveBatch após [[Aika OG - Studio NPCs e Mobs 2026-10-11#Lote em manutenção e marcadores — 2026-10-12]]. O grafo já tinha alterações locais de outros trabalhos; preservado nesta execução. Atualizar o grafo por AST após consolidar essas alterações e confirmar SaveBatch, ValidateBatch e a rota /api/world/batch; o código atual continua sendo a fonte da verdade.

## Isolamento da configuração MySQL nos testes Studio — 2026-10-12

Na validação de [[Aika OG - Studio NPCs e Mobs 2026-10-11]], a suíte completa com `AIKAOG_STUDIO_MYSQL_TESTS=1` teve falhas em WorldDatabaseTests/DropDatabaseTests por ausência de `AIKAOG_DATABASE`; o teste de mundo isolado passou. Testes guardam o valor original antes de LocalSecretsLoader preencher a variável e depois restauram null, mas o loader só carrega uma vez por processo. Mitigação verificada: fornecer `AIKAOG_DATABASE` explicitamente ao runner, sem imprimir a conexão; 69 testes aprovados e uma integração opt-in ignorada. Correção do isolamento fica fora do escopo do lote; não reduzir assertivas nem excluir esses testes.

## Teste intermitente de criptografia — 2026-10-11

Na validação de [[Aika OG - Banco de Dados v1 2026-10-11]], GameServerEncDecStaysLegacyOnly falhou uma vez ao esperar rejeição do pacote legado pelo PacketTool; a reexecução completa passou. GameServer.Network.EncDec.Encrypt escolhe semente aleatória. A causa da falha não foi confirmada; investigar reprodutibilidade e colisão da verificação antes de alterar o contrato do teste ou o protocolo. Nenhuma mudança de criptografia foi feita nesta tarefa.

## Coletor passivo de mundo — 2026-10-10

- Implementado: [[Aika OG - Coletor Passivo de Mundo]], agora automático e ao vivo com raw socket Windows/SIO_RCVALL IPLEVEL. Detecta AIKABR/AikaClient/AIKA e endpoint; nenhuma pergunta de origem/mapa/canal/IP. 34 testes Python e integração PowerShell aprovados. Captura real BR confirmou Friedrich Kroeger 2229, MN 832, em (3364.40,638.40), 13 itens; Camila Baran 2066 e Yopi Arnold 2482 também associados. Snapshot 64 NPCs/40 lojas sem repetição. MN.bin resolve automaticamente os nomes numéricos. Headers BR mascarados/seed^4/shifts aritméticos tratados; temporários únicos permitem reinício após interrupção. Nenhum debugger, alteração de C#, SQL ou bins.
- Aberto: validar layout de mobs BR e movimento diferente de zero. NPC já visível antes da captura pode ficar com metadados pendentes até reaparecer; runtime IDs reutilizados entre mapas/sessões exigem revisão. Catálogo automático por endpoint usa mapa/canal unidentified. Primeira posição não confirma respawn, destino não confirma patrulha. O PacketTool C# mantém modelo unsigned na key condicional; revisar separadamente antes de usá-lo como prova nativa em seeds altos. Mapear IDs/variantes antes de importar.

## Ampliação do coletor e Catharina — 2026-10-10

Atualização aplicada2026-10-11: [[Aika OG - Alinhamento Aplicado Regenshein e Verband 2026-10-11]] resolve ausência/mapeamento de101NPCs (16GuardasReais), aparências2505–2509,9visuais de mobs e presençaLakior,40lojas/slots e158preços divergentes. Honra/medalhas implementadas e persistência dinheiro+inventário atômica testada; zero divergências na amostra184NPC/32espécies/40lojas/849preços. Permanecem abertos: gameplay nativo após lote, rotas/respawn oficiais, missões e serviços condicionais, taxas/descontosBR, semântica final de medalhasBR, seletor6243/Toca e combate/dropsLakior (baselineKmaranOG2204HP/21, semrecompensas). Histórico de auditoria abaixo não representa mais faltas atuais já resolvidas.

Atualização da nova captura2026-10-11: [[Aika OG - Auditoria Regenshein e Verband 2026-10-11]] comprova100atores NPC sem identidade local e conflito deID2444(Moa Rigel/Tony Kepler), modelos2505–2509ainda provisórios, Lakior ausente,3equipamentos/7alturas de mobs divergentes,20lojas com slots diferentes e72itens com troca diferente.31/32identidades de mobs já têm spawn em Verband; não recriar spawns pelo ID ou pela primeira posição observada. Importação pendente de mapeamento de IDs altos, revisão econômica, serviços/missões e gameplay.189templates de loja da amostra continuam usando honra/medalhas rejeitadas pelo handler. Contagens históricas anteriores não substituem essa comparação.172lacunasTCP limitam a completude.

Atualização2026-10-11: [[Aika OG - Lojas e Recaptura 2026-10-11]] registra reparação de12 definições restantes e compra7500CaveirasII. Contratos: ItemType também deve ser válido; preços capturados são base do client; posições de aparição não provam respawn. Permanecem abertos compra por honra/medalhas, associação seletor6243/Toca, campos/condições não interpretados, mapeamento/importação dos Guardas Reais comIDs altos e validação de gameplay OG após o reparo. A coleta antiga foi arquivada e a pasta ativa zerada; evidência histórica não é nova captura.

- Atualização posterior: [[Aika OG - NPC Titulos e Menus 2026-10-10]] confirma 82 NPCs/77 aparências/37 menus/43 lojas/962 slots. Seletores11/13 são skills; item1521 não é item de loja. OG0x0349 deve manter508 bytes/BodyWORD90/título456; expansão transitória512 causou sumiço e foi corrigida com confirmação do operador. Pendências: aparências2505–2509, menus em etapas2235/2309, acesso às lojas2062/2112, serviços84/88, inspeção visual individual e lógica de missões/patrulhas. Contagens e caveats históricos abaixo não substituem essa auditoria.

- Resolvido: crash ao abrir Catharina2113. Dump offline comprovou corrupção do item26902, campoClasse(offset300)=25710 gerando índice de conjunto fora dos limites. Reparação seletiva de31 registros em Data/client/MySQL, com backup; operador confirmou loja estável. Lojas68NPC/40listas/882itens preservadas, sem alterações de personagens.
- Implementado: aparência com payload completo/float32, variantes, recursos públicos integrais, preços-base e premium, hashes de15.083 assets, opções/IDs de diálogo, payloads de quest e sequência temporal de movimento. Slots/textos não equivalem a lógica do servidor. OG público de NPC também observado no sentido de saída.
- Aberto: payloads BR novos foram descartados pela versão antiga na primeira coleta ampliada. Variantes100E/1011/1012/1031 e candidatos305E/84 passaram a ser preservados após atualização; confirmar em nova captura. Validar modelo BR e associação a assets antes de substituir15 aparências provisórias. MobPos sem semântica de spawn/patrulha comprovada; destinos repetidos podem ser combate, não patrulha. Item1521 continua vazio no oficial. Não trocar executável inteiro sem validar diferenças de protocolo.
- Atualização:305E/84 confirmado posteriormente para nomes MN, modelo/equips e XY de Toupeira Covarde/Max/Merkbee; handler habilitado,18 snapshots recuperam17 identidades sem afirmar patrulha.100E/1011/1012 confirmaram associação a NPC e88 opções. Ainda aberto: seletor6243 do NPC2309/Toca não é slot ativo de Dialog.bin; não mapear seletores BR a slots por suposição.44 registros históricos de Pran foram preservados em excludedLegacyEntities e removidos da contagem de NPCs. Campos visuais BR restantes e lógica de missões/patrulha seguem pendentes de interpretação/importação.

- 2026-10-13: [[Aika OG - NPC Skills Patrulha 2026-10-13]] implementa captura/comparação de skills e corrige ausência de0x102 no buff próprio. Três capturas identificam EffectType5/Effects[2]50 nos NPCs Salvar Localização; layout OG508 preservado. Usuário escolheu validar depois no jogo: comparar Esquiva/Rosa Negra, confirmar glyph/poses e revisar variantes oficiais candidatas antes de afirmar equivalência visual. Guardas/pedras/sepulcros recebem classificação por nome e candidatos de mapa; instância/canal e tipos não observados permanecem não comprovados. Lilly teve moeda29456 reparada e16slots restaurados com backup; abertura/compra no cliente ainda precisa de validação.

- 2026-10-14: [[Aika OG - Sistemas Nativos 2026-10-14]] ativado. Goal numérico/hints de Title.bin divergem em título8 e tiers58/59; manter Goal até evidência de gameplay. BYTE12 de Pran0x96B desconhecido; nome nativo pode truncar a14 embora servidor aceite16. Temporários cash precisam de ciclo nativo (ExpiresBYTE328/DurationDWORD336/CanSealedBYTE460) antes de venda. Guild precisa integrar vínculo/permissões reais. Faltam eventos de títulos e quests/evolução/diálogos da Pran; ações especiais/PvP/escudos genéricos e quebra de sono por DOT incompletos. A revisão independente final e o gameplay nativo não foram concluídos; cinco testes SQLStudio ficaram bloqueados pela manutenção com servidor ativo. Não tratar esses limites como equivalência com o original nem liberar temporários sem revisão.

- 2026-10-14, atualização: [[Aika OG - Buffs Dual IA 2026-10-14]] validou os cinco testes SQLStudio em manutenção. Shock151 também incapacita; captura confirmou dano separadoDWORD64 de Réquiem. Bênçãos/timers/retorno/morte e regressões dual corrigidos. Continuam sem mapeamento40bytes24..63 da resposta nativa3BD68, Reveal/flash/PvP ofensivo e calibração visual. Captura original50eventos não tem timers/detail; coletor atualizado para obtê-los. Revisão independente falhou por cota e operador autorizou fontes/testes locais.

- 2026-10-14, correção após gameplay: [[Aika OG - Buffs Dual IA 2026-10-14]] identificou erro de contrato em0x16E/16F: deadlines Unix e clock de loginDWORD6348, não segundos restantes.0x12C é snapshot20DWORD de cooldown, não lista40WORD de IDs; resolve reset de Disparos. HP do mob no retorno precisa de0x103. Ataque revela, com exceção EF241 do atirador; valores e efeitos corrigidos.662testesGameServer+8Python passaram,1ignorado. Necessário relogar para validar novo clock e confirmar animações; pendências de40bytes/PvP/Reveal continuam.

- 2026-10-14, revisão de captura: [[Aika OG - Buffs Dual IA 2026-10-14]] registra fonte confirmando que reset duplo12C apaga início do cooldown; corrigido para snapshot único. Operador esclareceu que buff próprio também revela a dual. CashJ agora consulta persistido independentemente da carga dos itens/Pran, mas a causa do zero da UI segue sem captura confirmatória. Coletor registra reações do alvo60s e comparação temporal; não equivale a prova de animação renderizada/causalidade.666GS+12Python passaram,1ignorado. Validar saldoJ, cooldown e menus no cliente.
## Aika OG — correções de quests e numérica, 2026-10-18

- Atualização mais recente: [[Aika OG - Exclusao Cinco Dias e Pran 2026-10-18]] substitui a exclusão direta3F33: deadlineUnixrow92,nãoflagDeleted;0normal,futurodata,1vencido. Usuário definiu5dias e confirmaçãofinal3E01/56bytes.603request/cancel,3F33preflight; numérica0. PRANequipadaounabolsadeveirmanualparaespera; espera/pertencesjáporconta sobrevivemúltimochar. Nãoexistiaopcode0x56Bcomprovado,eraabreviação56bytes. Ativado,1089testespassaram,GameServer32056iniciado; artifacts/deletion-pran-20261018/activation.json. Confirmar visualmente data,PossívelExcluir,finalização/cancel e espera apósrecriar.

- Atualização posterior: o operador solicitou retirar a numérica. ADMIN confirmado sem guilda e sem hash; recusa genérica citava guilda quando falhava PIN. Fluxo atual sem PIN,3F33step7 confirma exclusão lógica, mensagem específica por resultado. Tabela/hashlegado preservados sem uso. Supera recomendações anteriores de ativar verificação de PIN; conferir `docs/operations/REMOVE-NUMERIC-2026-10-18.md` e `artifacts/remove-numeric-20261018/activation.json`. Ativado,1069 testes passaram,GameServer15640 iniciado. Validação visual de exclusão e login sem numérica pendente.

- [[Aika OG - Toca Mundo Desconhecido e Numerica 2026-10-18]] ativado: Toca2575–2578 Mark11 e missão84 verificada. Confirmar no jogo a cor amarela, conversa/entrega e cadastro/verificação/exclusão por PIN. Toca continua read-only por consumo gold tipo15; outros Type19 não habilitados genericamente. Cliente contém as rotinas: o servidor invertia ação de exclusão e ignorava PIN. Hash migrado após verificação válida; request2 mudançaPIN não implementado. Não fazer rollback ao servidor com bypass. Análise foi estática, sem excluir personagem real. Hipótese de984 não funcionar na seleção descartada pela rotina comum7533.

## Aika OG — login/packets, atualização 2026-10-17

- 2026-10-18, [[Aika OG - Opcodes e Simbolos 2026-10-18]]: catálogo agora cobre245opcodes/245registros, extraIncoming/Outgoingvazios;133semimplementaçãoC#localizada não equivalem a suporteclient nem ausência provada.0121temconsumerdecerco maswire/comportamentoservidorpendentes;CCCCsemconsumer/finalidade,039Dignorado,0306vazio,12helpersnuméricosaindasemnomesdenegócio. ProjetoGhidra27labels/9933funçõesinventariadas não é clientinteirodecifrado. BackupsD:citados17/out ausentes; imagemoriginalrecuperada porFileBytes/hash emartifacts/opcode-alignment-20261018/client, sem recriarbackupcompleto. Atualizarreferênciasrestoreantesdeusá-las. Graphify94arquivossemnodes/20SQLnãoindexados; otimizações e segurançaextensas dependem debaseline/captura/políticas, não nomes.

- [[Aika OG - Patch e Contrato Login 2026-10-17]]: v3 instalado/readback/x86, mas falta renderização e login completo com API/MySQL. Source de tickets0x81/0x685/reply0x82/seeds compilada e testada sem implantação; notas antigas que diziam identidade TCP ainda não corrigida são históricas. Client antigo curto será recusado pelo servidor atualizado. Permanecem TTL/one-use compatíveis com reutilização do ticket, ban/tokenCreationTime, custo uniforme/rate limit/TLS.0x039D desconhecido e layouts0x0101 sem validação universal. Não atribuir a transição visual de mundos a invasão comprovada. Modelo operacional ainda cita raiz OneDrive histórica; usar raiz atual `C:\Projetcts\SecondBrain` conforme instrução do usuário.

## Aika OG — economia e missões, 2026-10-14

- 2026-10-15, [[Aika OG - Missoes Verificadas Ativas 2026-10-15]]: a nova captura confirmou aceitação, progresso, entrega e escolha da quest 7; substitui a pendência de captura anterior. Quests 1/5/7 implementadas e ativadas com persistência/recompensa atômica. As demais missões legadas, abandono e objetivos compostos ainda exigem mapeamento; gameplay dos três ciclos e marcadores pendente.

- 2026-10-15, [[Aika OG - Expansao Mundo 2026-10-15]]: nova captura confirma conjuntosSigmund/Cahill e vínculos de painéis, superando ausência na captura anterior.743NPCs/36lojas adicionais/53bindings aplicados; gameplay pendente. OitoNameValues de mobs ausentes e49levelRaw>255 permanecem sóevidência; não inferir atributosBR nem importar população cumulativa. Montarias23/43 abrem no caminho nativoOG; operações econômicas ainda não implementadas.

- 2026-10-15, [[Aika OG - Guardas e Logs Aplicados 2026-10-15]]: guardas/pedras/Sepúlcro aplicados como entidades e aparência observadas; combate/posse/guerra e um ponto próximo a guardas antigos exigem gameplay/captura maior. Não converter objetos de missão/evento em NPCs permanentes. Escolha de recompensa pertence à terceira missão de um Max Mutante, por relato. Logger corrigido, mas falta captura longa e confirmação manual de QuickEdit. Recuperação de crash após commit SQL e antes do marcador pode exigir reconciliação pelos backups.

- 2026-10-15, [[Aika OG - Captura Missoes Guardas e Lojas 2026-10-15]]: payloads BR de progresso/itens/recompensa descartados na primeira captura são irrecuperáveis; coletor já preserva candidatos e mede direção, mas painel/escolha exige nova captura. Halperin/Sigmund não identificados por aparições nos limites locais; não inventar spawns. Snapshot BR não inclui UI/Map.bin esperado pelo coletor, deixando mapCandidates vazio. Artefato de auditoria 11/out/alignment.json citado em nota antiga ausente; novo snapshot SQL isolado foi produzido em 15/out.

- [[Aika OG - Premium Store Cash e Perseguicao 2026-10-14]]: ativação cash/Pran/Premium Store e correções de perseguição/acentos concluídas, com testes binários/SQL e UI desktop/390px. Validar em gameplay os benefícios após retirada/manual, expiração, segunda bolsa Pran, persistência do combate e acentos renderizados. As sete categorias são nativas; novas categorias exigem alteração do cliente. Loja real preservada durante os testes.

- [[Aika OG - Cash Label e Coletor Quests 2026-10-14]]: relato de saldo ainda zero levou à identificação de139 como atualizador do texto;3AE sozinho é insuficiente. Verificar renderização após ativar. Captura oficial da missão inicial dos5Max/recompensa e associação visual das cores ainda pendentes do operador; não tratar os seletores330brutos como IDs confirmados.

- [[Aika OG - Economia Inventario 2026-10-14]]: ativação e migração concluídas, GameServer PID42188 iniciado sem erro. Confirmar renderização do saldo J, acesso premium e remoção de munição vencida ao relogar. Cash modo1 identificado na referência nativa e corrigido; isso substitui a hipótese anterior de causa ainda desconhecida. Cobertura consolidada730GS/108Studio aprovada.
- [[Aika OG - NPC Missoes e Itens de Evento 2026-10-14]]: lista/diálogo e marcador disponível implementados; sem progresso persistido de missão, aceitar/concluir/premiar e filtragem por conclusão permanecem pendentes. Altar/roubo de tesouro explicitamente futuro.

- 2026-10-17, [[Aika OG - Textos Buffs Cast e Combate 2026-10-17]]: guia de Missões expõe duas limitações ainda abertas: mudanças de objetivos/recompensas não sincronizam os BINs/painéis, e itens/quantidades consumidos permanecem os originais. Preservar escolhas/ordem e consumos até edição BIN compatível; não afirmar criação de missão arbitrária. Gameplay pós-correções de textos/buffs/cast/combate depende de teste do operador. Uma missão de James Ron e uma de Ronire foram relatadas como funcionando, sem IDs; não extrapolar esse resultado para o catálogo inteiro.

- 2026-10-17, [[Aika OG - Missoes Mapa e Nivel 2026-10-17]]: lista global fixa substituída por0x33D real, independente de10D da cabeça. Detecção15 substituída por6 após avaliação do operador. Ainda pendem gameplay dos marcadores/menus e vínculos nativos não conhecidos. Cliente tem60slots: mapas distantes podem omitir missões quando os mais próximos ocupam o limite. Não atribuir a ausência no M a filtros de quest.bin: o bloco de renderização conferido usa o cache33D. Validação estática/887testes/ativação concluídas, sem alegar cobertura visual de todo o catálogo.

- 2026-10-22, [[Aika OG - Catalogos MySQL e Drop 2026-10-22]]: o AikaClient.exe local difere do hash autorizado pela Premium Store. A suíte SQL completa revelou essa barreira preexistente; validar o novo build antes de permitir gravação. Não enfraquecer a proteção para fazer o teste passar. Gameplay da migração ainda requer operador. Após testes/execução do mundo, checksums dinâmicos de buffs/relíquias mudaram; preservar estado e consultar snapshots, sem restauração automática. Graphify não indexou SQL por parser ausente.

- 2026-10-23, [[Aika OG - Pocoes e Consumo Seguro 2026-10-23]]: 291 de 764 candidatos permanecem bloqueados, incluindo 20 títulos/caixas classificados como tipo 700, antídoto sem conjunto de debuffs comprovado, vitais da Pran ausentes e buffs sem consumidores completos. Não habilitar pelo nome ou portar só parte do efeito. Consumo e efeito usam duas fases: queda após commit do consumo pode gastar unidade sem conceder benefício. Gameplay real e teste de carga permanecem pendentes.

- 2026-11-03, [[Aika OG - Studio Perfis de Spawn e Customs Ghoul 2026-11-02]]: **perfis de spawn removidos posteriormente a pedido do usuário**, com retorno ao editor original e drops preservados; a pendência de ativar WorldProfiles e de indexar esse módulo foi encerrada pela remoção. A investigação histórica identificou sete IDs de Customs/Guardas sem modelo base (81/82/117/486/888/1922/1936), 114 sobreposições mob/NPC preexistentes e NPCs com IDs duplicados. Esses achados não autorizam converter guardas, remover atores ou inferir destinos; continuam dependendo de revisão/captura caso sejam retomados.


## Aika OG — textos dos painéis, 2026-11-08

- [[Aika OG - Textos dos Paineis Oficiais 2026-11-04]]: recuperação aplicada de 2.341 campos nas cenas/tabela principais; confirmar visualmente cortes, acentos e tooltips. Arquivos auxiliares (ConvertCoreDesc, DevirDesc, EventTradeDesc, GCDesc, OverCoreDesc, BTInfoText, EFDesc, loadtext, ActionText e randomoption) exigem contratos de campos/índices/efeitos antes de importar; alguns conservam textos asiáticos. Diferenças de geometria e painéis exclusivos BR/ES não provam suporte no OG. Dados de menus do servidor oficial não foram obtidos; preservar capturas/customizações locais.
