---
type: verification
project: Aika OG
created: 2026-10-11
status: verified-with-caveats
tags:
  - aika-og
  - world-collector
  - game-server
---

# Aika OG - Alinhamento Aplicado Regenshein e Verband 2026-10-11

Relacionado: [[Aika OG - MOC]], [[Aika OG - Auditoria Regenshein e Verband 2026-10-11]], [[Aika OG - Coletor Passivo de Mundo]], [[Aika OG - Lojas e Recaptura 2026-10-11]], [[Knowledge Debt]].

Operador autorizou implementar o alinhamento. Aplicado em localhost:3307/aikaria, Data do workspace e client `D:\aika\Aika OG`; original oficial somente leitura. [Relatório e restauração](C:/Projetcts/aika-og/docs/operations/WORLD-ALIGNMENT-APPLIED-2026-10-11.md).

- 184 identidades NPC presentes; 101 novas, incluindo 16 Guardas Reais de Regenshein. Modelos2505–2509 agora vêm do payload oficial. SQL560NPCs/5623spawns/376templates.
- IDs nativos novos2048–3047; TonyKepler2444 preservado e MoaRigel oficial2444 remapeado2187. `OfficialCaptureMap.json` e correspondência por nome/posição permitem recaptura com runtimeIDs diferentes; ambiguidade é rejeitada.
- 32espécies de mobs conferidas;9templates existentes corrigidos;LakiorMN36/template375/spawn8670 acrescentado3399.4/1363.4. Spawns antigos preservados. Aparência completa em sidecar porMN/Name; CSV passa a usar TemplateId da identidade por nome.
- 40lojas/40slots comzeros;849preçosconferidos,158registros alterados emSQL/Data/client. Não substituir registros ItemList completos: seis campos de preço são patchados para preservar as reparações de Classe/ItemType/títulos.
- Cinco conversas; `TalkId` é conversa por opção, `IntroTalkId` é separado. Só Catharina628 entra ao abrir; Deborah/Daniel/Pavol não são transformados em intro automática. BodyNPC WORD e Speed0 continuam compatíveis com pacote OG508.
- Prioridade econômica: item→honra→medalhas→gold. Revenda não anula preço de honra. Medalhas reproduzem OG Pascal (`PriceMedal×qty` honra + `PriceGold×qty` item4204), sem prova de cobrança finalBR. Gold/honra/inventário persistem juntos e voltam em memória em falhaSQL.
- Cloneaplicar/verificar/restaurar734SQL/174arquivos e triggerfalhaSQL aprovados;585testes.NET passaram/5pulados, persistência separadaaprovada;56Python;runtime184/32/40/849 aprovado;comparaçãoindependentecapturaSQLzerodivergênciasna amostra. Checksumsreaischaracters/characterItempreservados.
- Backup `artifacts/world-alignment/2026-10-11/import-reviewed`, `RESTORE.md`, before-imagesJSON/arquivos/binários. Drift de22slotsRonirebloqueouprimeiroplan; snapshotatualfeitoantesApply. Studio recompilado/reiniciado;GameServer recompilado/parado.

Limitesduráveis: posiçõesobservadasnãorespawn/patrulha;missões/serviçosnãoinferidosdelabel;172lacunasTCP. Lakiorvida2204/nível21 usaKmaranOG, semdrops/recompensas/skills atéregrasconfirmadas. Toca6243,taxas/descontosfinais eplayapóslote continuamabertos.
