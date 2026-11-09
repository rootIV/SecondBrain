---
type: project-note
project: Aika OG
date: 2026-10-14
status: activated-capture-pending
---

# Cash, coletor de missões e itens iniciais

- Causa adicional do saldo J zero confirmada no assembly real OG: 0x3AE atualiza saldo de validação de compras; **0x139/16bytes atualiza o texto Cash restante**. Dispatcher004C0B90 ->004B6B10; DWORD12 -> UI+E6BA4; widgetUI+E6B34. Enviar ambos, inclusive ao abrir/atualizar a loja. Isso corrige a conclusão anterior de que somente o modo1 de3AE resolveria a exibição.
- Melee2 unidades com último passo limitado à distância de ataque; não confundir alcance com percepção/limite de perseguição.
- `Coletar-Missoes.cmd` inicia captura passiva IPv4 com privilégios administrativos e sem debugger/injeção. JSONL guarda eventos e frames selecionados, progresso, NPC, escolhas, itens/XP/gold; comparação offline em tools/quest_capture.py. Captura real oficial ainda será feita pelo operador.
- Vermelho na imagem Diego Nobaro é evidência visual do operador. O código do ícone está em spawn349byte93/atualização10D; cores não devem ser atribuídas pelo código sem associar renderização/estado. O coletor aceita anotações V/A/Y/R e marcos1–5.
- Cliente envia330com20bytes no eventoUI3057/FUN004EC190, doisDWORD12/16. Preservar seletores brutos para resolver a escolha de recompensa pela captura;333é também usado para separar pilhas na referência e não prova ação de missão.
- Novos personagens recebem25431(PacoteElterNv1, linhaPackItem3376),4350x10,4390x10. Removido apenas o inventário inicial AmanhecerPaladinaNv80, preservando personagens existentes e equipamentos de treino. Variante27415 tem linha de pacote vazia; não usar. AberturaNv1 é atômica; pacotes seguintes continuam sem handler.

Detalhes verificáveis: `docs/reverse-engineering/CASH-LABEL-2026-10-14.md`, `docs/operations/QUEST-COLLECTOR-2026-10-14.md`, `docs/operations/STARTER-JOURNEY-2026-10-14.md` em `C:\Projetcts\aika-og`.

Ativação concluída após constatar GameServer/AikaStudio parados: backup `artifacts/economy-inventory/activation-20261014-211852`,17 arquivos conferidos, novoPID66380. Cobertura consolidada740GS/17Python, com regressão da sequência de login atualizada para139. Captura oficial e confirmação visual do cash ainda dependem do operador.
