---
type: implementation
project: Aika OG
updated: 2026-10-17
status: active-awaiting-gameplay
---

# Missões no mapa e nível no menu — 17/10/2026

Relacionados: [[Aika OG - MOC]], [[Aika OG - Indices NPC Missoes 2026-10-16]], [[Aika OG - Patrulhas e Simbolos NPC 2026-10-17]], [[Aika OG - Textos Buffs Cast e Combate 2026-10-17]].

## Contrato atual

- Mapa M usa `0x033D`, separado dos marcadores de atores `0x010D`. Payload de 52 bytes: página DWORD+12, 12 índices WORD+16, 12 estados BYTE+40. Cinco páginas; página zero limpa o cache de 60 posições. Enviar também as páginas vazias, em ordem, evita resíduos.
- O índice é exatamente o índice lógico base zero de npcpos, sem somar 1 e sem trocar por ClientId/NameValue. Zero é ignorado pelo desenho. Bindings existentes em Data/Quest/NpcQuestBindings.json preservados (461 registros).
- `FUN_004A5230` (RVA A5230) recebe as páginas; `FUN_0051E330` (RVA 11E330) compara os índices ao cache. O bloco de renderização dos NPCs não consulta requisitos de quest.bin. Rotinas conferidas no executável OG SHA256 7ECA8E1E6573DC439CC803EF6CAFE91AACA53E6C60D4B3BFD82AB267A7AD81AA.
- O mock anterior só tinha índice 65 com estado útil 8. O relato visual como Nick Lily não prova a identidade desse índice. A causa comprovada é a lista fixa incompleta, não uma hipótese de requisitos locais do BIN.
- NpcQuestMapService seleciona até 60 índices de missão mais próximos, usando elegibilidade por personagem e a mesma prioridade dos marcadores da cabeça. Deduplica aliases; ordena o resultado por índice para estabilizar o cache. Atualiza login, movimento/teleporte e mudanças de missão, inclusive progresso de item/interação/combate.
- Cache pertence à sessão/personagem e é limpo em Init/Reset/Close. Usa os fluxos existentes; nenhum timer novo. NPCs sem vínculo nativo continuam ausentes do mapa e o limite 60 não foi aumentado.
- Menu: prefixo [LVL X] usa MinimumLevel, não nível do personagem. Nome/ID originais permanecem. Campo 64 bytes com NUL. Paginação caiu de 12 para 8 porque o receptor adiciona controles próprios e descarta opções após o contador 15; rejeita páginas vazias extras.
- Alcance de detecção final é 6, após o operador considerar 15 exagerado. Ataque melee 2 e visibilidade 50 permanecem separados.

## Verificação e operação

887 testes completos GameServer aprovados, 10 condicionais de banco ignorados, nenhuma falha. Publicação e runtime têm hashes conferidos. Ativado sem migração SQL/cliente; backup em artifacts/quest-map-20261017/backup-20261017-125858. GameServer iniciado com quatro configurações e listeners verificados.

Gameplay do mapa/menu continua pendente; não afirmar que todos os NPCs ou todos os mapas foram validados visualmente. Com mais de 60 índices relevantes, mapas distantes podem omitir marcadores até a mudança de posição atualizar a seleção.

Fonte principal: `C:/Projetcts/aika-og/docs/operations/RELEASE-QUEST-MAP-2026-10-17.md` e `docs/reverse-engineering/NPC-QUEST-MAP-2026-10-17.md`.
