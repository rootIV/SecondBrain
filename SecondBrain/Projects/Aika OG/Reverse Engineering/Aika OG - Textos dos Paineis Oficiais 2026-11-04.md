---
tags:
  - project/aika-og
  - reverse-engineering
  - localization
updated: 2026-11-08
---

# Aika OG - Textos dos Paineis Oficiais 2026-11-04

Aplicados em 08/11/2026 2.341 campos pt-BR: strdef4 (553), FieldScene4 (755), FieldSceneB4 (1.033). Login/SelChar já coincidem com BR. Fontes locais: D:/CBMgames/AikaOnlineBrasil (locale 6), C:/GoLevel/AikaOnline (locale 12, inventário apenas); OG em D:/aika/Aika OG (locale 4).

Loader 004433E0 lê strdef 3096x128. Loader de cenas 005AD8D0 confirma payloads e campos de 128 bytes; tipo 4 tem caption +48 e tooltip +176. Executável SHA256 194f2367c7a6d1f6f4846b4a0ecbd833da629af2281745df877ae7b741b38d0c preservado. Recuperação exige identidade única tipo/ID/pai e bytes não textuais iguais. Preserva printf, tags, números/sinais, URLs e slots locais 3/4/28/81/860/1709.

Inventário: 355 nomes UI .bin; quatro cenas OG completas com 6.339 registros/5.453 campos e 303 contêineres tipo 3. Não afirmar 303 painéis funcionais. Recursos novos ou com layout não confirmado não foram copiados. Textos asiáticos em auxiliares continuam como dívida de investigação.

24 testes passaram; publicação com CAS, backups, staging validado, recuperação após falha e preservação de edição concorrente. Leitura pós-aplicação confirmou somente campos permitidos; referências e executável inalterados. Cliente estava fechado; sem restart, SQL, protocolo ou gameplay alterados. Renderização real, cortes de texto e cobertura de funções de painéis permanecem pendentes.

Menus do servidor: NpcMenuCatalog.Text e NpcOptionTextService, opções 0x112/64 bytes e seletor 0x310. Preservar menus personalizados/capturados; recursos fixos de UI não são catálogos SQL do servidor. Arquivos locais não equivalem ao banco ativo.

Relatório: [PANEL-TEXTS-OFFICIAL](C:/Projetcts/aika-og/docs/analysis/PANEL-TEXTS-OFFICIAL-2026-11-04.md). Artefatos/backup: C:/Projetcts/aika-og/artifacts/panel-texts-official-20261104/. Ferramenta: tools/recover_panel_texts.py (prepare/apply/verify/restore); não restaurar por cópia cega após edições posteriores.

Relacionados: [[Aika OG - MOC]], [[Knowledge Debt]], [[Aika OG - Grupo Solo Menus NPC 2026-10-21]].
