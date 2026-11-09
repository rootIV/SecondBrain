---
tags:
  - project/aika-og
  - verification
  - reverse-engineering
updated: 2026-10-13
---
# Aika OG - NPC Skills Patrulha 2026-10-13

Relacionado: [[Aika OG - MOC]], [[Aika OG - Coletor Passivo de Mundo]], [[Aika OG - Studio NPCs e Mobs 2026-10-11]], [[Aika OG - Dual e Cast Nativo 2026-10-12]].

Detalhes/evidência: [NPC-SKILLS-AI](C:/Projetcts/aika-og/docs/operations/NPC-SKILLS-AI-2026-10-13.md).

Studio permite mover NPC no lote existente, mapa/anterior/próximo no topo e agressividade individual/lista filtrada. mob_spawn_behavior guarda override0legado/1passivo/2agressivo por spawn. Instalação explícita/checksum; preservar defaults e recompensas pendentes.

Patrulhas têm pausas intermediárias/finais e retorno imediato aleatórios; idle é do modelo. Percepção melee10(+2), perseguição10–50 desde início do combate e assistência de agressivos num raio12, sem passivos/serviços/mortos/retornando. Retorno não é patrulha: cura apenas na chegada.

Esquiva dual: faltava 0x102 de buff próprio com dano0 e TargetAnimation, comprovado na fonte nativa. Salvar Localização: três capturas concordam EffectType5(offset92), Effects[2]50(494). Importadoscap9/menuBR25 exigem fallback pelo título; flag64 sozinha não identifica. Visual final ainda precisa de client.

Coletar-Skills.cmd conserva eventos públicos conhecidos e variantes candidatas, sem replay/chat/login. skill_capture.py compara original/OG; AIKAOG_SKILL_TRACE registra saída OG mesmo em loopback. Guardas/pedras/sepulcros recebem worldRole/mapCandidates; mapa/canal não são inferidos como certeza. IDs305E baixos são retidos.

Lilly2441: moeda29456 inválida(type0/class8241) causava perda de16ofertas. Reparo seletivo usa definição oficialtype507/class0 e remapeamento de textura. Backup completo artifacts/studio/catalog-activation/20261013-030922-48d620f0; plano artifacts/npc-skills-ai/lilly-repair. Slots capturados são preenchidos apenas se vazios/sem divergência.

587 testes servidor,107Studio comSQL,2esquemaSQL,4Python e QA visual375/1440 aprovados. Revisores independentes falharam por limite; testes/fontes locais cobrem a implementação, revisão externaCLI não ocorreu. Validação em jogo/capturas recentes permanece pendente.
