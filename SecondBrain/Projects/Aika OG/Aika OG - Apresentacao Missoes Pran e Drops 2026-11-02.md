---
tags:
  - project/aika-og
  - reverse-engineering
  - validation
updated: 2026-11-02
---

# Aika OG - Apresentacao Missoes Pran e Drops 2026-11-02

Cliente local atualizado de `74a63ac...` para `4442e955bdbd78a96fc87f935f1499caeab12a721c180a3e6040a88164935083`, após 10 testes x86 offline. Gates, timers, ABI/ASLR e quatro rotinas Premium preservados; allowlist dedicada Premium sincronizada com SQL, guard genérico não flexibilizado. Backups/manifesto em `C:\Projetcts\aika-og\artifacts\quest-presentation-final-20261102`.

- Anúncios: medir no HDC real e limitar 480 px evita repetição da textura de 512 px; reutilizar renderer `006684D0` preserva empilhamento.
- Diário: hook exclusivo `005342D3` após formatação/substituições, limite 240 px, cores e metadados preservados, sem reescrever Dialog/quest. 1.759 resumos/7.907 linhas exercitados; máximo 21 linhas expandidas, capacidade nativa 128.
- Local da missão 3075: mobs 29/30 já estavam associados ao item 5749. Gate rejeitava `[Evolução]` porque strdef 1709 dizia `Desenvolver`; só essa string foi corrigida, sem títulos antigos afetados. Não generalizar a navegação para objetivos desconhecidos.
- `011B` é notificação visual/chat, confirmado em `004A4F60`: strdef 282 gera XP, 1358 Gold quando positivo. Não somar aviso `0984`, que duplica o chat. Servidor usa delta real persistido. Valores acima de Int32.MaxValue usam somente `0984` para evitar `%d` negativo/truncamento, sem números flutuantes nesses casos; layouts preservados.
- Pran recebe 10% da XP de abate, piso inteiro, cap no nível exibido do dono e portões de evolução. Pran acima do dono não perde XP. Retornar delta real para chat em ataques normais/skills; XP 1 omite Pran. Avisos de troca só após commit.
- Menu/Fechar brancos; vermelho continua para missão concluída.
- Drops Studio: aba global usa EditorQuests e RelicSettings com CAS/auditoria/backup, `AnyMob` explícito (mob zero é válido), e `MobDropsConfigured` diferencia vazio editado do fallback legado. Relíquias não podem entrar como item comum de regra de missão. Cópia por mob inclui normais+eventos, não globais; colagem substitui rascunho. Gerador Lore removido, combate preservado.

Verificação: GameServer 547+2 condicionais, Studio 185+16 condicionais; SQL opt-in 10 aprovados; frontend build/lint/Playwright desktop. Build da solução sem erros/36 avisos. Primeira navegação QA acionou autosave do rascunho mesclado, preservado; nenhum catálogo de drops foi publicado pelo QA. Homologação no jogo real permanece pendente.

Detalhes e comandos: `C:\Projetcts\aika-og\docs\operations\QUEST-PRESENTATION-PRAN-DROPS-2026-11-02.md`, `STUDIO-DROPS-2026-11-01.md` e `docs\reverse-engineering\NPC-PATROL-INTERPOLATION-2026-11-01.md`.

Relacionadas: [[Aika OG - Patrulha e Menu Nativo 2026-11-01]], [[Aika OG - Comando GM Missoes e Direcao Studio 2026-11-01]].
