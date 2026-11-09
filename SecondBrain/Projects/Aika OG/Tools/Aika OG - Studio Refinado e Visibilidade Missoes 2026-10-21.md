# Aika OG - Studio Refinado e Visibilidade Missoes 2026-10-21

[Contrato e evidências](C:/Projetcts/aika-og/docs/operations/STUDIO-REFINEMENT-2026-10-21.md).

- Studio 3388 atualizado: navegação por tarefa, tipografia legível, formulários com seções avançadas recolhíveis, seleção de NPC por nome e seletor de área em telas pequenas. Rascunhos/revisão/backups preservados; formulário inerte durante operações. As 11 áreas abriram sem erros no navegador; larguras 320/768/1024/1440 verificadas.
- Missões dos NPCs passaram a consultar o catálogo recuperado/verificado/editor, incluindo início, entrega, aliases e missões não executáveis. 1.907 missões, 2.010 associações, 1.717 com vínculo. Das 190 sem vínculo, 97 não informam NPC e 93 exigem resolver NPCs locais; não inventar spawns ou vincular apenas pelo nome.
- `HiddenQuests` no EditorQuests.json persiste ocultação independente de habilitação e modo de teste, inclusive para missões não executáveis. Após reinício do GameServer, bloqueia oferta/marcadores, aceitação, entrega, progressão por abate/interação e drop de missão da Pran; histórico permanece. API validada em cópia isolada, com versão antiga recusada e configuração real intacta.
- Neutros não recebem relíquias em mobs/DGs/sorteio independente; coleta exige cidadania na sessão e no estado transacional. Ataques às pedras/PvP continuam exigindo nações válidas. Seladas legadas neutras expiram sem autorizar ações ou renovar prazo.
- Corrida no carregamento local de configuração foi reproduzida (15/16 consultas iniciais falhando) e corrigida com Lazy; 16/16 passaram. Teste concorrente isolado de Shared incluído. Variáveis externas continuam prevalecendo; credenciais/protocolo preservados.
- Studio foi reiniciado em 3388; prévia 3389 encerrada; GameServer ficou parado. Gameplay e NPCs sem vínculo permanecem pendentes. Logs/TRX em `artifacts/studio-refine/`; capturas em `output/playwright/`.

Relacionados: [[Aika OG - MOC]], [[Aika OG - Aika Studio Web]], [[Aika OG - Instalacao Schema Reliquias 2026-10-21]].

Validação final: Studio 121 aprovados/10 ignorados; TokenServer 19/1. GameServer completo: 1.543 aprovados/10 ignorados e uma divergência no texto alterado da Lilola; texto preservado, expectativa atualizada e 21 testes de menus/concorrência aprovados no rerun focado. Sem testes suprimidos. A suíte completa anterior à mudança concorrente de texto tinha 1.543 aprovados/10 ignorados. O relatório do repositório distingue as execuções.
