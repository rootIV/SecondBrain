---
title: Aika OG - Comando GM Missoes e Direcao Studio 2026-11-01
updated: 2026-11-01
tags:
  - project/aika-og
  - quests
  - aika-studio
---

# Aika OG - Comando GM Missoes e Direcao Studio 2026-11-01

Fonte canônica: `C:\Projetcts\aika-og\docs\operations\QUESTS-NPC-STUDIO-2026-11-01.md` e `GM-QUEST-DEBUG.md`. Relacionado a [[Aika OG - Patrulha e Menu Nativo 2026-11-01]], [[Aika OG - Diamantes Catharina e Modo Teste 2026-10-23]] e [[Aika OG - MOC]].

## Missões de teste

`.mi 10` aceita ou reinicia o ID conhecido para GM/Admin; `.mi p 10` preenche requisitos implementados e gera itens faltantes; `.mi e 10` prepara e entrega pelo fluxo real de recompensas. `.mi e10 1` escolhe a primeira alternativa. A numeração das escolhas começa em 1.

O acesso ignora nível, classe, cidadania, Pran equipada, Premium PC, pré-requisitos, diária, ocultação e habilitação somente para o ID e personagem da sessão. Estado e recompensas persistem; reaceitar permite testar novamente sem desfazer gold/XP/itens anteriores. O bypass não é global nem persiste após reconexão. O catálogo `Known` inclui IDs sem gameplay e sem NPC local, mas eles só aceitam inspeção e informam o motivo exato ao tentar progredir/entregar. Não afirmar que aceitar uma missão implementa regras ausentes.

O vínculo de autorização fica em `ConditionalWeakTable<HashSet<ushort>, WeakReference<Session>>`, usando o conjunto transitório compartilhado por cópias `ShallowCopy`. Confere token, ID, owner, personagem ativo, sessão aberta e GM/Admin em cada acesso. Isso preserva o staging transacional sem capturar a sessão no domínio e revoga o bypass após demissão ou troca/desconexão. A validação também roda antes do commit.

Preparação e entrega usam `NativeInventoryRepository` e `QuestHandler.Claim`, com reload autoritativo de quests, contadores e itens na mesma transação. Falhas não persistem itens sintéticos nem progresso parcial. O limite nativo de 20 missões, propriedade, slots, espaço, overflow, origem autorizada de relíquias e o nível específico de recompensas percentuais permanecem. A recompensa dos diamantes de nível 50 continua exigindo nível 50.

## Moa Antar

NPC 2163 apresenta somente retirada de selo com `RelicUnsealFamily > 0` e todos os itens de remoção realmente presentes em inventário pessoal acessível. Linhas sem gameplay ficam fora desse NPC. O filtro é independente do bypass GM e suprime a opção Missão sem relíquia válida. Marcador nativo 1 significa NPC comum sem missão; não confundir com marcador 0. `Time` de relíquias não é tratado como expiração genérica; `NativeItemLifecycleService.IsExpired` exclui explicitamente relíquias.

## Planilha e Studio

XLSX entregue contém 1.907 missões atuais (1.831 oficiais e 76 locais), ordenadas por nível mínimo e ID. Preserva níveis 0–99, ocultas, desativadas e dependências pendentes. `testada`, `funcional` e `observação` ficam vazios. O arquivo salvo foi renderizado e conferido por XML independente; não comprova gameplay. Evidências em `artifacts/quests-workbook-20261101/` e arquivo em `artifacts/outputs/01a168e6-71d1-7240-95b1-01f65165829e/`.

NPC e mob selecionados exibem triângulo laranja de orientação inicial. A projeção usa a inversão de Y e corrige a escala do zoom. O triângulo deve ser independente do marcador comum, pois mobs com trajetória ocultam esse marcador para desenhar o spawn. A linha da patrulha pode ter direção diferente da orientação inicial.

Novo campo `Direção (graus)` de NPC, inteiro 0–359, grava `npcs.rotation` existente e atualiza o mapa no rascunho. Velocidade de patrulha limitada a 1–127, conforme o byte assinado do cliente. Nenhuma migração de banco ou patch do executável. QA desktop em 1728×1080 verificou NPC a 180°, zoom 125%, mob 3048 a 134°, sem overflow ou console errors; rascunhos foram simulados, sem edição do mundo real.

## Verificação final

Integração de GameServer com todas as classes Quest/Npc/NativeInventory/ChatAuthorization: 434 aprovados e 1 condicional ignorado. Studio completo com MySQL habilitado: 192 aprovados e 1 condicional ignorado. O primeiro lote encontrou fechamento prematuro da bênção; o staging original foi restaurado, preservando o diálogo em falha de persistência, e o lote completo foi repetido com sucesso. TypeScript/Vite e build da solução aprovados. TRX em `.testbin/nov01-quest-debug/results/`.

## Limites de homologação

Necessária homologação no AikaClient real de animação de NPC, caminhada longa e comandos. Evidência binária e testes de socket/SQL não substituem a observação no jogo. O XLSX usa IDs/quantidades para itens: alguns nomes relacionais, como 26604/26603, contêm controles ou fragmentos e não foram propagados ao documento.
