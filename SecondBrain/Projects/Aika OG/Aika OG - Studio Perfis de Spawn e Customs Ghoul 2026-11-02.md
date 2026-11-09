---
tags:
  - project/aika-og
  - studio
  - validation
updated: 2026-11-03
---

# Studio: perfis de spawn e Customs Ghoul

> [!info] Funcionalidade removida em 2026-11-03
> O usuário solicitou voltar ao editor original de NPCs/mobs. Seletor, revisão, APIs, serviço, snapshot, gerador e testes de perfis de spawn foram excluídos. Os perfis de drop permanecem, incluindo Ghoul. O posicionamento de Alinhar mapa à direita de Ajustar mapa foi preservado. Os números e caminhos abaixo são históricos, não uma funcionalidade disponível; não executar os builds antigos `world-profile-*` para ativar perfis.
>
> Remoção validada com build/lint, 196 testes Studio aprovados e 17 condicionais não executados; navegador em 1280/1920 confirmou editor original, edição/desfazer e revisão de drop Ghoul. Foram encontrados três backups de aplicações reais Lore/Ghoul/MasterEditor. Reversão sem conflitos, testada em clone e aplicada em manutenção: 254 modelos/324 spawns restaurados e 94 modelos/1.277 spawns inseridos pelos perfis removidos. Estado final: 743 NPCs, 376 modelos, 5.900 spawns, iguais ao primeiro snapshot. Tabelas de drops e auxiliares de NPCs preservadas por hash. Evidência em `artifacts/spawn-profile-removal-20261103/`.
>
> Ativação concluída após fechamento manual do Studio pelo usuário: build normal sem erros/avisos, Studio reaberto (PID 41736), rascunho com mesmo conteúdo/versão, cinco perfis de drop e antiga API de spawn retornando 404. Evidência em `artifacts/spawn-profile-removal-20261103/activation.json`. A exclusão de builds/caches históricos foi bloqueada pela revisão automática (`blocked by policy`); não confundir esses artefatos com arquivos ativos da funcionalidade.

> [!important] Correção posterior: catálogo anterior à importação Raiz
> O snapshot de 5.900 spawns usado na reversão dos perfis já continha a importação Raiz de 02/11. Ela havia inserido 108 cópias de guardas já representados por NPCs ativos, incluindo 21 do Altar da Aika (mobs 8807–8827). A exclusão antiga protegia somente Guarda Real de Regenshein. O GameServer observado havia iniciado depois da primeira reversão, portanto não era apenas cache antigo.
>
> O usuário escolheu expressamente restaurar **todo o catálogo pré-Raiz: 5.623 spawns e rotas antigas**. Aplicadas 277 exclusões e 5.584 restaurações em transação; verificação do plano no principal aprovada. NPCs originais, modelos e drops preservados. Os três guardas mob 8583/8584/8585 já existiam no snapshot anterior e foram mantidos. Teste em clone cobriu aplicação/verificação/restauração, erro SQL na quarta exclusão e precondição de NPC obsoleta. Evidências: `C:\Projetcts\aika-og\artifacts\extra-guards-20261103\`; relatório: `C:\Projetcts\aika-og\docs\operations\MOB-PRE-RAIZ-RESTORE-2026-11-03.md`. A contagem de 5.900 nas etapas acima é histórica. Não reaplicar planos antigos Raiz/WorldProfiles, que podem recriar os extras. Renderização final no jogo depende de iniciar os servidores com o catálogo restaurado.

> Conferência final: catálogo principal com o mesmo hash integral do clone restaurado e 24 tabelas protegidas inalteradas. Studio reaberto (PID 25108/3388), 5.623 mobs/743 NPCs, 277 extras ausentes, NPCs guardas originais presentes; rascunho e cinco perfis de drop incluindo Ghoul preservados. Servidores/cliente ficaram fechados para início habitual. Resultados em `verify-live/result.json` e `activation.json`, na pasta de evidências acima.

[[Aika OG - MOC]], [[Aika OG - Sessao Studio Perfis e Raiz 2026-11-02]], [[Aika OG - Guardas e Logs Aplicados 2026-10-15]], [[Aika OG - Movimento Guardas Reais 2026-10-16]]. Relatório: `C:\Projetcts\aika-og\docs\operations\STUDIO-WORLD-PROFILES-2026-11-02.md`.

NPCs/mobs receberam Perfil de spawn à direita do mapa. Mobs: Atual/Lore/Rafinha/TheMu/Master/Ghoul; NPCs: Atual/TheMu/Ghoul, conforme fontes efetivamente disponíveis. Alinhar mapa fica à direita de Ajustar mapa no mesmo grupo. A seleção prepara uma prévia global, preservada na navegação; edições manuais bloqueiam referências sem perder valores. A gravação exige revisão, manutenção, CAS, backup e transação.

Snapshot reproduzível em `Data/ServerCatalogs/studio-world-profiles.json`, gerado por `tools/build_studio_world_profiles.py`: 1.491 hashes/tamanhos de fontes conferidos. Ghoul inclui 477 NPCs elegíveis, 7.113 linhas de spawn, 463 modelos completos e 526 Customs (63 Guardas/463 Monsters). Atributos usam a base da fonte, sem acumular multiplicadores sobre o banco já alterado. Guardas prevalece sobre Monsters no mesmo IntName. Dez nomes de arquivo danificados são conciliados pelo ID único no AllMobsInfo, preservando `fileLabel` e hashes; não corrigir acentos por aproximação.

Sete Guardas sem modelo base: 81/82/117/486/888/1922/1936; não inventar modelos/combatentes. As sete linhas `[Drop]` são evidência e não são aplicadas pela tela de spawn/atributos.

Outras duas identidades de Customs (1260/2999) divergem do catálogo ativo e são recusadas, preservando a identidade atual. Prévia final: 94 modelos novos, 1.277 spawns novos, 7.331 mudanças conciliadas, 183 posições extras preservadas e 270 ocorrências não conciliadas. Esses números foram obtidos em processo temporário somente leitura com a versão final; não representam publicação no banco principal.

NPCs Ghoul: 486 arquivos; 479 de 5.639 bytes e sete de 5.649. Spawn utiliza o layout já reconhecido pelo loader, sem reinterpretar bytes extras. 2215 tem duas versões diferentes; 2707 tem sete arquivos binariamente idênticos, sem prova de sete destinos. Nove duplicados excluídos. `NPCOptionsText.bin` contém 65 textos de 64 bytes (4.160 bytes), compatível com o loader; não substituído. Posições só são conciliadas por ID e nome/índice, com patrulhas manuais preservadas; lojas, diálogos e missões permanecem intactos.

Conciliação cruzada importante: 117 posições de fonte têm nome nativo e distância de até uma unidade de NPCs atuais. Preservar sua classe e aparência; não criar mobs duplicados. O mesmo raio já orientava a canonicalização das capturas de guardas. Há também 114 sobreposições mob/NPC preexistentes no snapshot consultado; não as remover automaticamente nem assumir combate de guerra/posse homologado. Modelos de combate de guardas podem ser capturados sem converter os NPCs existentes.

Verificação: testes unitários de composição e Python; clone MySQL com inserções, FK, CAS, rollback forçado e reaplicação idempotente; TypeScript/build/lint; navegador NPCs/mobs 1280/1920, sem overflow, revisão e preservação de edição manual. QA interceptou rascunhos e bloqueou escritas reais. Nenhum perfil aplicado ao catálogo principal; GameServer/TokenServer preservados. Homologação real de navegação/combate/balanceamento pendente.

Rodada final: 201 testes Studio aprovados/18 condicionais não executados; seis testes focados composição/SQL aprovados separadamente; quatro Python aprovados. Pacote final em `artifacts/tests/world-profile-release/Debug/net8.0/AikaStudio.exe`. Contrato de prévia versão2 bloqueia aplicação no frontend quando o backend é antigo; CAS inclui resultado das mutações e versão do contrato para invalidar revisões entre versões do algoritmo.

Studio reaberto com autorização; conteúdo/versão dos rascunhos persistidos conferidos antes/depois. Backup em `artifacts/studio-world-profile-update-20261102`. Uma tentativa de reinício adicional foi bloqueada por política automática (`blocked by policy`); a publicação final deve ser verificada após fechar o processo antigo, sem contornar o bloqueio. O cache de fontes é por processo.
