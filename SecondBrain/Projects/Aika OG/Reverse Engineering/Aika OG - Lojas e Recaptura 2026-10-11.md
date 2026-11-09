---
tags:
  - project/aika-og
  - reverse-engineering
  - verification
updated: 2026-10-11
---

# Aika OG - Lojas e Recaptura 2026-10-11

Reparados seletivamente 12 registros de itens/moedas em Data/ItemList.bin, client OG ItemList4.bin e MySQL. Corrupção inclui ItemType=0 com Classe=0 e descrições de skills no nome: validar somente Classe não basta. IDs: 26153,26174,26579,26631,26648,26834,26836,26901,29221,29224,29227,29457. Texturas remapeadas por nome; outros registros e todas as outras linhas do banco preservados. Backup SQL/arquivos/plan em `C:\Projetcts\aika-og\artifacts\shop-collector-fix\2026-10-11`.

Mercador LH2296: Sela29222/Cavaleiro29223 válidos; três registros corrompidos eram29221/29224/29227. Ceifador26902 usa7500 CaveirasII26901. Servidor ignorava preço em item e usava4gold; compra agora consome pilhas do inventário desbloqueado e preserva tudo em caso de falta de moeda/espaço. Honra/medalhas ainda sem compra implementada, recusadas sem fallback para gold. Carregamento omite ofertas inválidas sem mudar índices dos slots.

Coletor mantém eventos ordenados completos da conversa e payload/argumentos, incluindo intro antes do menu, limpeza/opções/loja/fechamento. Recursos públicos completos preservam Dialog/quest e offsets. Associação seletor-slot é candidata: Catharina628 contém as cinco falas da imagem; Toca6243 não tem slot ativo correspondente. NPC sem loja permanece perfil sem loja observada. Guardas Reais/MN485 são reconhecidos por aparição pública sem consultar servidor OG; IDs podem exceder3048 e exigem mapeamento antes de importar.

Preço capturado por NPC/variante/slot: gold/honra/medalhas eID/nome/quantidade da troca; fonte explicitamente tabela do client. Pacote de loja só identifica itens; cobrança final/desconto do oficial não comprovado. Slots vazios/IDs repetidos/ordem preservados no catálogo e StoreData. Aparições/remoções, aparência raw/exata, perfil, conversa e lojas relacionados. Inventário visual acrescenta Ani/Effect:21.391 hashes no oficial verificado.

146 arquivos antigos foram movidos para `artifacts/world-collector-backups/2026-10-11-shop-dialogue-reset`; pasta ativa vazia e captura parada para recapturar do zero. Dados do servidor/MySQL preservados. Reiniciar com `Coletar-Mundo.cmd`, esperar CAPTURA PRONTA e revisitar áreas/NPCs/opções. A posição de aparição não prova respawn; páginas/condições não visitadas não são execução observada.

513 testes C# e79 Python aprovados; dois SQL optativos ignorados; integração PowerShell aprovada; build GameServer zero erros/avisos. Bootstrap real MySQL e checksum/cifra nativos aprovados;920 IDs únicos de itens de loja/moedas válidos; executável OG inalterado. Verificação com recursos oficiais confirmou preço7500, cinco falas da Catharina e replay de payload de Guarda Real. Gameplay OG após reparo ainda não verificado.

Detalhes: [Relatório operacional](C:/Projetcts/aika-og/docs/operations/SHOP-COLLECTOR-REPAIR-2026-10-11.md). Relacionado: [[Aika OG - Coletor Passivo de Mundo]], [[Aika OG - Atualizacao Oficial Compativel 2026-10-11]].

Restauração seletiva testada em banco temporário isolado com catálogo clonado e cópias de Data/client; definições/hashes originais recuperados, sem restaurar o banco ou arquivos ativos. Banco de teste removido.
