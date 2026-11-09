---
tags:
  - project/aika-og
  - reverse-engineering
  - npc
updated: 2026-10-15
---

# Aika OG - Paineis Montaria 2026-10-15

Captura BR Kim2275: opção44 `Encantar Montarias`→seletor23; opção83 `Transmutar Montaria`→43. Pacotes3010/16 após request300F/24 continuam aliases candidatos no coletor. O decompilado OG `D:/aika/aika-cliente-reverse-engineer/AIKA.exe.cpp`, SHA256 `55CC54DCD076A3DD8EF0ECC70A461E113C2E9A6ED52052847830641585480E1E`, confirma `FUN_004a5e50` lendo DWORD+12:23→`FUN_0053d480(0)`,43→`FUN_00575e90`. A referência Pascal `TNPCHandlers.ShowMountEnchant` confirma310/23. O hash/build do binário de origem do texto não foi verificado e nenhum símbolo foi renomeado.

Catálogo Studio/runtime adicionado: `enchant_mount`23 e `transmute_mount`43. Apenas abertura de interface, sem operações de transformação/consumo. Vínculo porNPC/opção é necessário; não remapear44/83 globalmente. O CHECK de `npc_menu_panels` é ampliado pelo instalador idempotente existente, sem editar recursos SQL registrados e seus checksums. Não aplicado ao banco ativo nesta subetapa.

8 testes passaram, incluindo abertura310/16, fechamento10F e proteção de listas de habilidades11/13. Renderização real pendente.

Evidências e alcance: `C:/Projetcts/aika-og/docs/operations/NPC-MOUNT-PANELS-2026-10-15.md`.

Relacionado: [[Aika OG - Captura Paineis NPC 2026-10-15]], [[Aika OG - MOC]].
