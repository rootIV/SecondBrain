---
type: protocol
project: Aika OG
created: 2026-10-15
status: implemented-gameplay-pending
---

# Captura de painéis dos NPCs

Relacionado: [[Aika OG - MOC]], [[Aika OG - Guardas e Logs Aplicados 2026-10-15]].

- Mundo e Missões compartilham `tools/npc_panel_capture.py`; retêm abertura/conteúdo em `panelEvents.json`, além de catalog.json ou events.jsonl/panelEvidence. Terminal informa PAINEL e opção antecedente. Reabrir apenas o coletor aplica a mudança.
- 310/16 seletor explícito;3010 candidato, nunca assumir loja pelo nome do enum.106/1006/96: WORD NPC12,modo14,40WORDs16;12loja,11/13skills,0update sem painel. A captura BR antiga contém41lojas modo12 e uma lista de skills modo13.
- 137/2024 é snapshot compartilhado pessoal/Pran; pode preceder o seletor. F10/24 abre guild;D58/1020 eD18/24 são conteúdo/saldo.330/3030/20 recompensa candidata,16 fica raw.3F0D/2584 e3F11/784 ofertas de leilão são contratos Delphi candidatos.
- SeleçãoOUT30F/300F e texto do menu vinculados temporalmente até15s, com caveat; contexto30s.10F fecha menu antes de painel: preservar seleção recente; novoNPC/abertura/fechamento explícito/conexão não herdam seleção. Conteúdo isolado não comprova abertura.
- Captura passiva de protocolo; renderConfirmed=false, sem screenshots. Painel inteiramente local pode não ser observado. ZeroOUT impede saber opção selecionada. Não inventar aliases de guild/storage nem importar esses registros automaticamente no banco.
- Fontes e contratos detalhados em `C:/Projetcts/aika-og/docs/operations/NPC-PANEL-CAPTURE-2026-10-15.md`.39testes passaram incluindo transporte/export/merge e privacidade auth/PIN. Revisão independente corrigiu perda deNPC após10F nas capturas somenteS2C, sem inventar escolha. Launchers-Check passaram; gameplay real pendente.
