---
type: project-note
project: Aika OG
updated: 2026-10-10
status: verificado
---
# Aika OG - MobService

## Fluxo atual

`MobCsvParser` carrega `Data/Mobs/AllMobsInfo.csv` (templates/skills) e `MonsterListCSV.csv` (spawns/alcance). `MobService` delega pacotes de spawn/movimento ao factory e visibilidade ao serviço existente. `MobAiService.TickMob` decide alvo, alcance, deslocamento, ataque e retorno; `MobPlayerDamageResult` transporta dano e ID da skill básica até `CombatPacketFactory`.

## Ataques básicos à distância — 2026-10-10

As famílias indicadas pelo operador usam alcance mínimo 11: Toupeira→6123; Mago Ilusionista Cla Leao Branco→6290; Mago Chepa Mavek/Feiticeiro Chepa Tahn→6462; Cubo→6344; Espectador→6465; Feiticeiro Esqueleto das Ruinas→6203. Prefixos incluem variantes e nomes normalizados do loader. Slots especiais/buffs do CSV foram preservados.

- Toupeira tem slots zerados: exigir `HasAnySkill` a convertia em melee mesmo com spawn range 11.
- Tahn tem cura 6463 no primeiro slot: não usar o primeiro slot como ataque básico.
- `0x0102` mantém 84 bytes; DWORD SkillId em +12. O client consulta SkillData pelo ID. `0x1002` também recebe o ID em seu campo existente, em vez de zero.
- O perfil Magic já existente usa ataque mágico/defesa mágica; os sete templates reais têm stats de ataque zerados, portanto o dano oficial não foi calibrado por essa mudança.
- Os seis registros SkillData foram comparados ao bin atual do client e são idênticos. Skill 6123 tem Index=0 nativo válido, com animação 36.
- Cast ainda é imediato: validar timing nativo antes de acrescentar fila.

Verificação: 23 casos específicos (12 falharam antes), suíte completa 472 aprovações/zero falhas/dois skips SQL condicionais; build legado sem erros/avisos. Build ativada às 11:22 de 2026-10-10 (São Paulo), PID 61692. Operador confirmou ataque à distância com efeito; não nomeou o mob específico. Não inferir validação visual de todas as famílias.

Relatório: [Loja J/CASH e ataques de mobs](C:/Projetcts/aika-og/docs/reverse-engineering/RANGED-MOBS-AND-SHOP-CURRENCY-2026-10-10.md).

Relacionadas: [[Aika OG - MOC]], [[Aika OG - SkillService]], [[Aika OG - Buff Refresh e Opcodes 2026-10-10]].

## Spawn de comando — 2026-10-10

`.s <id>` agora usa o NameValue real do template (ushort; exemplo 19/Toupeira ou 432/Ilusionista), registra o mob no WorldDataService/índice espacial e atribui threat ao jogador vivo mais próximo, até 35 unidades. A posição fica três unidades ao lado do invocador; HP/aparência/stats/skills/drops vêm do template. ID runtime único desde 3048, incluindo prevenção de colisão com mobs mortos, NPCs e personagens. Visibilidade usa MobVisibilityService; dano usa o tick normal da IA. Spawns são temporários em memória e, conforme esclarecimento do operador, morrem uma única vez: CanRespawn=false. Mobs normais mantêm respawn habilitado por padrão; os mortos de comando deixam a seleção da IA, com ID reservado na sessão.

Verificação final: duas regressões novas RED/GREEN testam morte/HP zero e ticks até uma hora; suíte completa 496 aprovações/zero falhas/dois skips SQL; runner legado compilado sem erros/avisos. Build padrão concluída após encerramento confirmado e portas livres; DLL SHA-256 473BBF549C0B46F9602549035D717753787DAD76FF353E5CFD2DC6458CC5F86A. Operador solicitado a iniciar com F5 e confirmar morte/espera de 60 segundos; gameplay ainda pendente. Sem verificação de terreno no deslocamento de spawn.

Catálogo de títulos relacionado: Title.bin tem 256 registros de 224 bytes e quatro tiers de 56 bytes, conforme loader nativo 0042E8A0. Parser anterior 256/64 lia descrições como títulos. Data/Title.bin antigo foi salvo em artifacts/backups/spawn-title-20261010/Title.bin e sincronizado com o client; SHA-256 FC9A624B77EF022B62853B40A14CB83C1230233EF6FDE1244D0AE5E17C6B1CDE. `.t 126` deve sugerir 125 e 127, `.t 200` somente 134; `.t 35` é válido (Marechal). IDs inválidos não mudam ownership/SQL.

Relatório: [Spawn e títulos](C:/Projetcts/aika-og/docs/reverse-engineering/SPAWN-TITLE-COMMANDS-2026-10-10.md).
