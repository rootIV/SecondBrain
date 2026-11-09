# Aika OG - Nomes de Itens em Portugues 2026-11-01

Continuação de [[Aika OG - Recuperacao Nominal Textos e Studio Desktop 2026-11-01]]. O usuário pediu traduzir os nomes espanhóis recuperados dos clientes oficiais para o mesmo padrão dos demais itens brasileiros.

600nomes traduzidos entre os668marcados como fonte espanhola no manifesto anterior.68nomes próprios/termos já portugueses/nomes ingleses sem espanhol foram preservados. Não foi aplicado tradutor indiscriminadamente sobre o catálogo nem alteradas descrições.

Glossário baseado em itens existentes: Poção, Caixa, Baú, Brinco, Bracelete, Pran, Kaize, Símbolo de Prática Intensiva e nomes brasileiros das classes. Números, níveis, quantidades, códigos regionais e sufixos foram mantidos. Limite63bytes CP1252 validado; sem truncamento automático. Exemplo4211: Poção de Batalha PC Bang [3 dias] [TH] [Pago].

Aplicado a ItemList4.bin do cliente local, Data/ItemList.bin, snapshots client/itemlist4.bin e data/itemlist.bin e600nomes relacionais. Dois snapshots na revisão5, integridade SHA2 verificada e600nomes conferidos independentemente no MySQL.31.000registros preservam todos os bytes fora do nome0:64.

Reutilizado o fluxo de reparo textual com aprovação explícita por ID/antes/depois em NameTranslations; modo tradução recusa alterações de descrição/outros campos. CAS de nome/tipo/efeito/nível/classe e hash/revisão protege personalizações e reversão. Auditoria registra tradução para pt-BR.

Backup/plano final: artifacts/item-name-pt-20261101-final. Data SHA256901D066F22E03198D2F46B2B5093F69B66CAB6F4417DBF0EDFED12CC986C6C38; cliente82C72B3AC84658F7B540040E4E3B49FF282FACD4C4A2F33DB33F8A5E9FB4BC2F. A reversão do reparo anterior agora recusará revisão desatualizada; não forçar plano antigo sobre esta tradução.

9testes.NET,4Python de tradução e6do reparo anterior passaram; build Database0avisos/erros. UI desktop1366px conferida para4211,8833,14862, console limpo e captura preservada. Nenhum processo do jogo do usuário iniciado/reiniciado; QA isolada encerrada. Reabrir Studio para invalidar documentos/snapshots antigos. Gameplay visual não executado.

Documentação canônica: docs/operations/ITEM-NAMES-PT-BR-2026-11-01.md. Glossário: tools/localization/item_names_es_pt.json. As1.382descrições sem fonte íntegra da etapa anterior continuam pendentes.
