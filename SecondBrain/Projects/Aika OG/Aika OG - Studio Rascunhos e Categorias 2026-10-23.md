# Aika OG - Studio Rascunhos e Categorias 2026-10-23

Projeto: `C:\Projetcts\aika-og`.

Salvar rascunhos agora persiste no MySQL com jogo e servidores abertos. Efetivar continua uma operação de manutenção (GameServer/TokenServer parados e cliente fechado), com revisão, motivo, backup e proteção contra origem alterada. Não existe hot reload do mundo nesta entrega.

`studio_drafts` guarda estado dos editores e patches binários, por banco/pasta do cliente, com hash/versão e transação. Limites 64 MiB e 24 documentos; recuperar nunca escreve na origem. Rascunhos não recuperáveis são preservados com aviso. GM/contas e laboratório não entram no salvamento global.

Categorias/subcategorias de itens usam tipos nativos e recurso MySQL `studio-item-categories`. Premium usa `studio-premium-tabs`; Auxílio/Roupas/Prans corrigidos. Rótulos inferidos pelo conteúdo, intervalos comprovados por REA: lacunas 500/1000/2000/3000/4000/5000/5301 e fim6000 não podem receber ofertas.

Cliente E1104CBB8D313EC9B07E18C5529AC6865D1EDA92E429355185617A4F805FF002 aceito somente pela PremiumStore após quatro rotinas premium byte a byte iguais às do build anterior. ID da oferta WORD+0, registro376bytes; restrição global do editor binário preservada. Compras pendentes ainda protegem identidade/conteúdo de ofertas.

Verificado: 163 testes Studio passaram,1 condicional de criação de conta não habilitado; testes MySQL em bancos isolados, build/lint/frontend e navegador desktop/mobile. QA com GameServer ativo recuperou preço/NPC sem alterar catálogos publicados; rascunhos de QA restaurados e servidor de teste encerrado. Gameplay de compras publicadas pendente.

Documento operacional: `docs/operations/STUDIO-DRAFTS-CATEGORIES-2026-10-23.md`. Evidência nativa: `artifacts/studio-workspace-20261023/premium-native-evidence.json`. Resultado SQL/unitário: `results/studio-final.trx` nessa pasta.

Instância principal3388 atualizada após encerramento do processo elevado16284 pelo usuário. A falha Endpoint não encontrado vinha de frontend novo com backend antigo sem `/api/drafts`; endpoint200 e interface conferidos após publicação. Binários anteriores preservados em `artifacts/studio-workspace-20261023/before-main-update`; SHA256 novoStudio D570C76DEE119DCFF0801CDE1160986F21F2A1EB2052B2EEF31BBBDC2D52FEA6. Instância temporária3389 encerrada após validação da principal.
