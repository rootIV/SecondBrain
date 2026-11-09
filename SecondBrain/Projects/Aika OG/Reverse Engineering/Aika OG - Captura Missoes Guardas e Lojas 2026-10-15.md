---
type: verification
project: Aika OG
created: 2026-10-15
status: verified-with-gaps
---

# Captura de missões, guardas e lojas — 15/10

Relacionado: [[Aika OG - MOC]], [[Aika OG - Auditoria Regenshein e Verband 2026-10-11]], [[Aika OG - Cash Label e Coletor Quests 2026-10-14]], [[Knowledge Debt]].

- Auditoria somente leitura: catálogo acumulado de 366 atores NPC, 41 lojas e 306 entradas de menu. Primeira observação hoje de 175 atores: 57 alinhados, 48 com posição não alinhada e 70 observações de 17 identidades ausentes de NPCs. Não transformar histórico em população/respawn. Snapshot SQL às 12:59:30 BRT: 560 NPCs, 1008 slots de loja, 376 templates de mob e 5623 spawns.
- 58 novas entradas de menu em 18 NPCs. Comparação efetiva: 18 iguais, 34 rótulos diferentes, uma opção raiz ausente (77/Poder Avassalador/500 Honra/Lilola), duas entradas de Portão Oculto sem NPC e três submenus não equiparados ao menu raiz. Rótulos não provam custo ou condição de ativação.
- Loja Thomas Henrikson/2081, posição 3649.4/1191.4: 39 produtos em 40 slots; posições localmente vazias. Preço enriquecido do ItemList é base, não débito confirmado.
- Posições de aparição de Guardas Reais: Verband 31 (6 alinhadas), Amarkand 25 (0), Regenshein na entrada de Verband 18 (16). Contagens de posições não são população fixa. Templates de mob 313/314 existem, mas sem spawns. Devir Amarkand: três guardas, três Pedras Guardiãs e um Sepúlcro ausentes no comparativo NPC.
- Nenhuma aparição retida dentro dos limites locais de Halperin/Sigmund; entradas podem estar do outro lado ou faltar evidência. Não atribuir ID de mapa/canal pela aparência. MapCandidates vazio: recursos BR exportados não contêm UI/Map.bin; a auditoria usa limites públicos OG como inferência explícita.
- Erro TCP conflitante às 00:33:46 BRT é anterior aos eventos até 12:52:33 BRT; último status stopped, com 52 lacunas. Não invalidar toda a captura pelo error.json residual nem afirmar completude.
- Missão 1/Domesticação errada/NPC 2048: cinco mortes, 30 XP/30 gold notificados, marcadores 3→4→8→1→8. Uma anotação vermelho associa fortemente marcador 8 ao ícone vermelho nesta configuração; outras cores não confirmadas. Frames BR3031/3012/3C0E foram descartados; sem PCAP, payloads de progresso/recompensa não são recuperáveis.
- Coletor corrigido para preservar candidatos brutos sem afirmar layouts deduzidos; oito testes Python passaram, incluindo exclusão de login/PIN. Servidor, banco e capturas originais preservados; reabrir launcher para carregar o código.

Evidência: `C:\Projetcts\aika-og\docs\operations\WORLD-CAPTURE-2026-10-15.md`, `docs\reverse-engineering\QUEST-CAPTURE-2026-10-15.md` e `artifacts\world-audit\2026-10-15\analysis.json`/`guard-positions.csv`.

Caveat histórico: o relatório antigo referencia `artifacts/world-audit/2026-10-11/alignment.json`, que não está presente nesta sessão. Não foi reconstruído nem usado como snapshot atual; o novo comparativo usa SQL somente leitura próprio.
