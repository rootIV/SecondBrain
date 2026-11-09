---
type: implementation
project: Aika OG
updated: 2026-10-17
status: implementation-tested
---

# Abandono de missões — 17/10/2026

Relacionado: [[Aika OG - MOC]], [[Aika OG - Missoes Recuperadas e Studio 2026-10-16]].

Pacote `0x032F`: 16 bytes, header 12 + QuestID DWORD no offset12, comprovado por `TAbandonQuestPacket` e `TPacketHandlers.AbandonQuest` no Rafinha Src. Dispatcher valida tamanho/ID. GameProtocol/EncDec preservados.

Abandono usa gate e lock de personagem/proprietário, relê DB e apaga somente missão não recompensada mais recibos de eventos na mesma transação. Reaceitação começa sem progresso/recibos reutilizados. Repetir abandono é inócuo; claimed nunca é apagado nem permite ganhar recompensa duas vezes. Falha de commit incerta bloqueia persistência para reconciliar.

Depois do commit: confirmação 0x032F, invalidação da escolha pendente da missão e refresh de marcadores compartilhado. Receber recompensa registra console com nome/ID/NPC/char somente após confirmação do commit; rollback/replay não registram conclusão.

17 testes focados aprovados, incluindo DB temporário isolado e rollback SQL real. Documento: `C:/Projetcts/aika-og/docs/operations/QUEST-ABANDONMENT-2026-10-17.md`. Sem publicação/produção nesta etapa; validação visual no cliente pendente.
