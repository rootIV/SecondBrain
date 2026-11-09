---
type: implementation
project: Aika OG
updated: 2026-10-17
status: active-awaiting-gameplay
---

# Progressão, Pran e locais salvos — 17/10/2026

Relacionados: [[Aika OG - MOC]], [[Aika OG - Missoes Mapa e Nivel 2026-10-17]], [[Aika OG - Missoes Recuperadas e Studio 2026-10-16]].

## Contratos

- Operador escolheu progressão normal: `OfficialQuests.TestMode=false`. Preservar requisitos em overrides do Studio. Catálogo com 1907 missões, 1242 com pré-requisitos e 589 com faixa nativa de nível. Tipo 4 = faixa inclusiva; 5 = classe; 9 = anteriores obrigatórias; 48 = ramos alternativos (inferência sustentada por ramos de classes mutuamente exclusivas); 29 = `case_equippran` (parser nativo comprovado, orientação 0/1 inferida dos registros).
- Sem Pran equipada, missões de nível mínimo acima de 7 não são oferecidas/aceitas, exceto repetitiva de marca 9. A exceção ignora somente Pran positiva; mantém nível/classe/pré-requisitos. Qualquer evolução equipada conta; pedra na bolsa não. Equipar/desequipar atualiza cabeça/mapa; progresso aceito permanece. Faixa máxima de aceite não invalida entrega após subir de nível.
- A ativação normal revelou lacuna da cadeia de aquisição da Pran. Missões 38–41 recebem tratamento específico pelos blocos nativos: três itens de quest 38 em alvos interpretados como NameValue 2/5/14; 39–41 consomem 5×5502 e criam fogo/água/ar na central, junto com XP/gold na mesma transação. Título 17 apenas na 39, conforme Reward79. Os IDs de alvo e a chance de 25% dos drops são reconstruções do catálogo, não execução oficial comprovada. Preservar esses campos ao salvar ou ler overrides do Studio.
- Opção NPC47 salva NPC+(1,1), sem teleportar. Confirmação via mensagem16 (sistema+anúncio) somente após commit SQL. `character_saved_locations`: chave(char,region), regiões0Lakia/1Leopold/2Karena/4Disckeroa. Nunca reutilizar `TeleportPositions`: slots da feiticeira. Preservar legado de outro continente antes de atualizar compatibilidadeLakia.
- Retornos4521/4582/11430/14801/15521 e renascimento usam ponto do continente atual. Retornos14800/11429/11401/4581/4520 usam a mesma coordenada da skill Retornar3399,564. Viagem consome uma unidade e persiste posição na mesma transação/receipt.
- Portal208 usa índice de linha SPosition.bin,100×208bytes; grupo nativo não é UIMapID. Só destinos do continente atual.8079tipo304exigeLV51 e usa hubLeopold do mundo únicoOG; legado transfere canal.15954é caixa714/Pack1784 e entrega200×8189 conforme arquivo, apesar de nome20. Preservar dados até decisão explícita de alteração.
- Geometria comprovada não cobre todos os mapas/dungeons. Retorno desconhecido não consome. Revive desconhecido mantém fallback legado antigo; âncoras regionais são escolhasOG, não prova de todos os defaults oficiais.

## Evidência e verificação

Executável OG desta análise SHA256 e1104c...ff002; evidências REA/RVAs completas nos documentos do repositório. Não confundir com o hash7eca...1aa da análise anterior do mapa. Não houve patch do cliente.

Fontes e logs: `docs/operations/RELEASE-PROGRESSION-TRAVEL-2026-10-17.md`, `QUEST-PROGRESSION-PRAN-2026-10-17.md`, `PRAN-QUEST-ACQUISITION-2026-10-17.md`, `SAVED-LOCATIONS-2026-10-17.md`, `PORTAL-SCROLLS-2026-10-17.md` e `docs/reverse-engineering/WORLD-REGIONS-2026-10-17.md`. Suíte final GameServer: 1052 aprovados, nenhuma falha, 10 condicionais ignorados. Inclui 16 testes de local salvo (2 SQL), 11 de retornos e 23 de cadeia Pran/contratos com SQL isolado. Studio: 118 aprovados/10 ignorados e uma falha ambiental de guard de build do cliente; o mesmo teste passou em fixture suportada, sem desabilitar a proteção. Ajuda do Studio compilada e conferida renderizada.

Ativado após parada confirmada pelo operador. Backup `artifacts/save-travel-20261017/backup-20261017-230357`; migração aditiva idempotente executada duas vezes e hashes dos três aplicativos conferidos. GameServer 55924 e Studio 28692 iniciados; quatro configurações/listeners conferidos. API confirmou 1907 missões, modo de teste desligado e cadeia 37–42 habilitada/suportada. Tabela regional existe, ainda vazia antes do primeiro uso real. Gameplay continua pendente; não houve criação de Pran nem mudança de ponto em personagem de produção para testar.
