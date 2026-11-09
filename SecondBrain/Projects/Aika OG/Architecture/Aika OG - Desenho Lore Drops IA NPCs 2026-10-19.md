---
tags:
  - project/aika-og
  - design
  - drops
  - npc
updated: 2026-10-20
status: implementacao-parcial
---

# Aika OG - Desenho Lore Drops IA NPCs 2026-10-19

Relacionado: [[Aika OG - MOC]], [[Aika OG - Desenho Lore Combate 2026-10-19]], [[Aika OG - MobService]], [[Aika OG - NPC Titulos e Menus 2026-10-10]], [[Aika OG - Studio Catalogo Menus Drops 2026-10-12]].

## Entrega e estado

Desenho original comparando `D:\aika\Aika Lore Community` com `C:\Projetcts\aika-og`: `docs/design/LORE-WORLD-DROPS-NPCS-2026-10-19.md`. Usuário autorizou implementação e escolheu revisão local. Registro atual: `C:\Projetcts\aika-og\docs\operations\LORE-WORLD-IMPLEMENTATION-2026-10-20.md`. Código alterado; serviços não publicados/reiniciados e cliente não alterado nesta entrega.

## Implementação20/10

- Studio prepara rascunho Lore30%/67/20/12/1, com versão otimista, sem escrita no preview; eventos, cotas e pity anterior preservados. Não houve ativação global dos perfis.
- Melee e ranged móveis reservam20posições no seu alcance, separam círculos0,6 e verificam segmentos; desvio lateral local, liberação na morte/retorno/troca de alvo. Ranged sozinho não foge de alvo próximo; estático continua atacando sob root no alcance. Terreno e modelos grandes seguem sem calibração.
- Refino0x32D/tipo0 e redução/tipo3 usam transação nativa e resultado0x32E. Contexto NPC revalidado dentro da transação, validações de posse/bolsas/material/rank/gold/limites/flags. Preserva nibbles, identidade e efeitos. Usuário pediu temporariamente sempre sucesso para testar: `Data/ItemUpgradePolicy.json` com`AlwaysSucceed=true`, custos e consumo continuam ativos. False restaura chance Lore do refino e bloqueia redução até definir falha.
- Guild0x341: pedido0/confirmação2,50.000gold,líder nível10,grupo6,mesma nação,sem guild. Migração aditiva guilds/guild_members; vínculos do baú e débito atômicos; snapshots nativos e relog. Roles precisam dos grants novos. Não inclui administração completa/skills.
- Portais2093/2111/2196 oferecem Úrsula/Basilan/retorno conforme Lore, somente em menu original3; customizações preservadas. Custo e posição são atômicos. Rotas anteriores também migradas para transação. Exigem confirmação de destino em gameplay. Samuel2060/opção25 usa salvamento persistente.
- Evidência estática em`artifacts/lore-world-implementation/20261020/protocol`: as25regiões comparadas coincidem entre cliente original e instalado. Fortification426,Reduction425,Expires328; Easing105×120 com custos de redução, sem algoritmo servidor de falha comprovado. Divergência de custo A01/W01 nos UseEffect88/92/93/94 entre servidor e cliente permanece explícita.
- Testes de transação usam bancos temporários. GameServer final:1361passaram,10ignorados,0falhas. Studio:127passaram,1ignorado,1falha emPremiumStore pelo hash do cliente alterado; proteção preservada. Fluxo de drops passou isoladamente. Studio renderizado em1440/390px com API isolada, sem POST; prévias refino/redução conferidas em390px. TRX na pasta de evidências; não substituem gameplay OG.

## Evidências duráveis

- Correção posterior de inicialização em20/10: `aikaria` não tinha `guild-creation`; o guard de startup estava correto. Criado e executado `dotnet run --project database -- install-guild-creation` com serviços parados. Instalação específica/idempotente, 12 testes de guild verdes, incluindo preservação de legado. Snapshot e verificação em `artifacts/lore-world-implementation/20261020/guild-creation-before-install.json` e `guild-creation-install-verification.json`. `RequireNativeSystemsAsync` passou no banco real, sem alterar personagens/gold/itens/baús nem extensões anteriores. Não houve reinício. Outros bancos ainda precisam instalar a extensão e conceder permissões conforme a role.

- Lore `BaseMob.DropItemFor`: roll 1–100, gate >70 = 30%; a quarta chamada elegível recebe +50, ficando em 80%; média 42,5% por ciclo sem outros bônus. Categorias condicionais normal/superior/raro/lendário = 67/20/12/1. `DroppedCount` não é cota diária. Não confundir chamadas com kills universais de party/DG.
- Source atual usa `DropEconomyRepository`, `ArcanMobProfile`, recibos por kill e cotas por `(day_utc, rarity)`, em unidades emitidas. O fluxo antigo 20%/até dois itens ainda existe como fallback, mas não descreve todos os drops atuais. Banco define o dia pelo relógio UTC da transação.
- Seeds 20.000/4.000/2.000/400 são instalação, não estado ativo verificado. Cenário proporcional de revisão preservando 26.400: 17.688/5.280/3.168/264. Não copiar como volume diário oficial da Lore.
- Detecção padrão6 foi preservada; Lore usa8. Melee2 e histerese existente preservados. Cooldown3s e rotação/cast já vieram da implementação de combate20/10 anterior a esta fatia; consultar seu registro, não os números históricos2s/1,2s/15.
- A análise original encontrou ocupação sem reserva; implementação posterior adicionou posições/separação, com limite geométrico explícito. Lore usa `Neighbors[Rand]`, sem exclusividade comprovada.
- Escavador Clã Trapaceiro NameValue569 tem Skill01=6501 nos dois CSVs. Isso não prova abertura ranged nem identidade de todos os híbridos do Monte Hessen. Captura segue necessária.
- 68 arquivos locais no retângulo da captura de Regenschein, 43 seletores distintos. Script verifica censo completo, hashes da Lore e aritmética. Teleporte2093 é adjacente, fora do recorte. Não equivale a censo SQL ativo ou de todo o mapa.
- Painel não equivale a operação implementada. Moa Timur2235 contém opções39/40/41 de relíquia; guild criação10 e baú11 aparecem no2067; source já tem baú/lease, não criação completa. Relíquias, refino/redução, leilão, instâncias e seletores recentes exigem a cadeia menu/painel/conteúdo/comando/commit/refresh/relog.
- Fallback C#2050 chamado Acesso Valhalla conflita com arquivo2050 Thomas Henrikson. Não reaproveitar ID como portal. Campo de batalha/Valhalla permanecem sem identidade ativa/comando confirmados.
- Lore inspecionada não contém `.npc`; comparar implementação por Src não autoriza transplantar spawns ou opções OG. Preservar bindings de capturas já existentes.

## Decisões e pendências

Gate estável30%/67/20/12/1 implementado como rascunho revisável. Quarta chamada e alteração de cotas ficaram fora desta política; cotas finais dependem de medição real. Detecção8 por perfil continua proposta. Relíquias, NPC de batalha/Valhalla, híbridos de Hessen e demais serviços sem contrato completo permanecem pendentes; ver matriz do registro de implementação. Não declarar todos os NPCs funcionais pela abertura de janelas.

## Limites de verificação

Studio127.0.0.1:3388 recusou conexão. Sem leitura direta do SQL ativo, nova captura/client gameplay, execução da Lore ou nova comparação de SkillData. Hashes do Src e auditoria local confirmados; não certificam renderização do cliente. Desenho visual exercitado em navegador: quatro perfis e três guias a320/736px, sem overflow global, erros ou warnings; capturas móveis inspecionadas. Links da nova nota resolvem para notas existentes. Protocolos/criptografia/layouts preservados.
