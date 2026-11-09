---
tags:
  - project/aika-og
  - studio
  - validation
updated: 2026-11-04
---

# Studio: gravação de itens e aplicação global

[[Aika OG - MOC]], [[Aika OG - Studio Rascunhos e Categorias 2026-10-23]], [[Aika OG - Sessao Studio Perfis e Raiz 2026-11-02]]. Relatório: `C:\Projetcts\aika-og\docs\operations\STUDIO-DRAFT-APPLY-2026-11-04.md`.

O erro de ItemList4 tinha duas causas confirmadas: `CatalogFileWrite` deixava o journal após uma falha anterior ao commit, apesar de restaurar arquivo/banco; e `BinaryDocument.Save` recusava o hash do cliente local modificado. Arquivo, banco e backup tinham hash idêntico `65762FAE...`, enquanto `.bak.next` preservava a edição `19128677...`.

A recuperação automática exige bloqueio de catálogo, banco/caminhos/fase válidos, arquivo igual ao banco e correspondência com backup revertido ou conteúdo commitado. Arquiva o journal, mantém cópias e recusa divergências. Rollback explícito e validação anterior à gravação evitam o bloqueio na tentativa seguinte; a sessão editada só é substituída após o commit. O marcador real foi conciliado em manutenção sem alterar arquivo/banco ou publicar o rascunho.

Cliente local `194f2367c7a6d1f6f4846b4a0ecbd833da629af2281745df877ae7b741b38d0c` aceito por hash exato após seis comparações byte a byte de trechos nativos de loaders/cifra/checksum/acesso com o original `7eca8e...`; evidência reproduzível em `artifacts/studio-draft-apply-20261104/client-layout-evidence.json`. Não libera builds desconhecidos nem prova equivalência completa de gameplay.

O usuário escolheu **todas as categorias em revisão única**. Aplicar rascunho fica à direita de Salvar rascunho; status conta registros alterados (`2 NPCs, 1 item, 4 mobs`), sem navegação ou duplicação de registro selecionado/lote/menu. Reutiliza endpoints, versões, manutenção e backups existentes. NPC/mob/menu em lote transacional; catálogos distintos sequenciais, com progresso e retomada sem repetir os concluídos. Falhas preservam os demais rascunhos. Preços/ItemList, dois editores de Dialog, missões/drops condicionais e perfil/lista manual conflitantes exigem conciliação na revisão específica. Caps, contas GM e laboratório mantêm suas ações próprias.

Validação: 240 testes Studio com MySQL isolado; depois, 35 contratos frontend após teste adicional e 42 testes focados finais, incluindo preservação de conteúdo externo durante rollback. Item real gravado em cópia sem modo bruto, preservando os demais 30.999 registros; TypeScript/Vite/lint e build Release aprovados. Navegador 1280/1920, contagens, manutenção/motivo, falha e retomada sem repetir item; todas as escritas de QA interceptadas. Resultado `browser-result.txt` e TRX em `artifacts/studio-draft-apply-20261104/`.

> [!success] Ativação concluída após fechamento manual
> Após o usuário confirmar que fechou o Studio 64340, a versão corrigida foi reaberta em 04/11/2026 (PID 23648/3388). Conferidos mesmo conteúdo/versão do rascunho mais recente `3D60BDDB...`, zero avisos, um registro de item com hex exatamente igual ao patch salvo, metadados novos no backend, bundle da revisão global, arquivo/banco idênticos e ausência do marcador bloqueante. Evidência reproduzível em `artifacts/studio-draft-apply-20261104/Verify-Activation.ps1` e `activation.json`; backup privado antes de iniciar em `draft-content-at-activation.json`. A política havia bloqueado encerrar automaticamente o processo anterior, sem tentativa alternativa de encerramento. Edição do usuário não foi publicada; gameplay continua pendente.
