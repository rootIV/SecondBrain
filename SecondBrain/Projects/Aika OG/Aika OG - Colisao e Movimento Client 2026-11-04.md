---
tags:
  - project/aika-og
  - client
  - reverse-engineering
updated: 2026-11-04
---

# Colisão e movimento do cliente

[[Aika OG - MOC]], [[Aika OG - Client - Formatos e Recursos]], [[Aika OG - Curva PvE Mana e Area 2026-11-04]].

Cliente atual SHA194F2367C7A6D1F6F4846B4A0ECBD833DA629AF2281745DF877AE7B741B38D0C reanalisado via REA/Ghidra12.1.2, sem patch/execução do jogo. Diferente das builds antigas da documentação.

- Confirmado:00519210→00416600→004164D0 valida trajeto local com ATT/altura;005194D0 barra bit01antes de enviar0301. Célula bloqueia01/40/200; limites estritos de altura e coordenadas inteiras0<coord<4096 no trajeto.
- ATT loader005D3F50:256×256WORDs/chunk em grade dinâmica768×768. Índices=int(world)−origem; origem032444C4/C0,ATT00B19040. Getter fora da grade retorna0, não autoriza navegação desconhecida no servidor.
- Predicado004164D0 exige deltaAltura<step e−deltaAltura<3step. Parâmetro13do caso comum não é medida física homologada. Restrição D00/200 condicionada a00F3E22C não é bounds universal.
- Bit80isolado não bloqueia esse predicado;200também é modificado dinamicamente por005FC450. Não equiparar bits desconhecidos a paredes.
- Recepção0301:004BFC40→0049EC60→005E9C70/interpolação ou posição direta. Esses corpos não chamam os validadores locais; caminhos virtuais posteriores não completamente cobertos. Compatível com mob ultrapassar limites, sem alegar ausência de colisão em todo o client.
- SourceMobAiService/MobCombatPositionService consulta outros mobs, sem ATT/HGT/LOS. Patrulha/retorno não ganham terreno por haver bounds de mapa.

534checks nativos offline aprovados, com bytes originais/Unicorn2.1.4 e hash antes/depois:512flags+4extras+9altura+5região+4fora da grade. Não há gameplay real. [Relatório](C:/Projetcts/aika-og/docs/reverse-engineering/CLIENT-MOVEMENT-COLLISION-2026-11-04.md), [artefatos](C:/Projetcts/aika-og/artifacts/client-movement-collision-20261104/README.md).

Próximo: validar chunks/origens/buffer de altura com coordenadas reais, resolver flags dinâmicas e integrar validação do segmento em todo movimento de mobs. LOS de ataque/colisão3D/NVI não comprovados; [[Knowledge Debt]]. Nenhum gameplay, binário, banco ou serviço modificado.
