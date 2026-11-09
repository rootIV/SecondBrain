# Aika OG - Comparacao Combate IA Referencias 2026-10-19

**Correção posterior no mesmo dia:** ao analisar [[Aika OG - Lore Community Combate Atributos 2026-10-19]], confirmou-se que `SendMobDamage/GetMobDamage` não tem chamada do dispatcher localizada nas unidades Src examinadas de Rafinha/TheMu. O caminho confirmado player→player ou mob normal é `BaseMob.SendDamage → GetDamage`. O relatório-fonte foi corrigido; valores da rotina legada não descrevem dano final do dispatcher.

Análise solicitada após implantação da V1+49extras/cap11. **Somente comparação, sem alteração de runtime/banco/cliente/binários instalados.** Relacionado: [[Aika OG - Balanceamento Classes e Progressao 2026-10-19]], [[Aika OG - MOC]].

Fonte e evidências: [COMBAT-AI-REFERENCE-COMPARISON-2026-10-19.md](C:/Projetcts/aika-og/docs/analysis/COMBAT-AI-REFERENCE-COMPARISON-2026-10-19.md). Hashes de14 fontes-chave em `artifacts/combat-reference-comparison/source-manifest.json`; fonte atual agregada permaneceu `c6a817aaf0297d2285462dc736a8cc4bf3f0bbaf877f018a000b7a3efddb3ed5`.

## Conclusão durável

- Manter o núcleo atual de defesa/ratings/ameaça/patrulha e aproveitar seletivamente conteúdo Delphi. Rafinha/TheMu são forks próximos:99,03% de similaridade textual de linhas em MOB.pas e94,34% em BaseMob.pas. Não são evidências independentes da fórmula oficial.
- Conferir **AikaServer.dpr→Src**, porque Graphify do Rafinha também encontra backups antigos. Não confundir fontes históricas com as unidades selecionadas pelo projeto.
- Atual: IA500ms; detecção6, assistência5, melee2/2s, ameaça por personagem/provocação, retorno andando com cura na tolerância do spawn, pausas aleatórias. Os registros antigos de alcance10/15 e assistência12 não descrevem o código atual.
- Referências Delphi: rotaçãoSkill01..05, guarda6470, instâncias/timer/dificuldade de DG e consumo de Reinforce2 são materiais úteis ainda sem equivalência completa no atual. Neighbors sugere distribuir atacantes ao redor, mas não demonstra reserva estável nem pathfinding.
- Não copiar cálculos cegamente: GetMobDamage legado tem DEF/8+random5..103; AttackPlayer de mob usa metade de DNFis, defesa escolhida pela classe da vítima e adicional17..45; BaseMob.GetDamage tem piso seguido de25..134 e participa de SendDamage contra jogadores ou mobs normais. O método GetDamageByPlayer separado não é o cálculo usado pelo corpo de AttackPlayer.
- Um mesmo ATK hipotético400/DEF1200/L50 dá atual119, rotina GetMobDamage legada255..353, mob→player67..95. O valor legado não mede o fluxo ativo player→mob; não comparar templates sem conferir preenchimento do score e modificadores do chamador.
- Problemas demonstrados por tradução isolada: patrulha0→10 pode estacionar em9 por limiar2/passos1,5/chegada exata; GetDamageType3 reutiliza sorteio e sobrescreve crítico com duplo, dando0duplos-críticos no exemplo de ratings0. UInt64 em GetMobDamage pode sofrer underflow; cláusula>1milhão→1 é inadequada como regra geral.
- Diferenças importantes entre forks: Rafinha IDs de atacanteWORD, TheMuBYTE (risco acima255); TheMu probabilidadesInteger, RafinhaWORD (sinal importa antes do clamp). Ampliar array não prova IA mais completa.
- AikaEmu examinado tem entidades/spawn/visibilidade e eco de mensagens de skills, sem engine equivalente de dano/aggro/patrulha localizada nos309 fontes C# do GameServer. Enums e pacotes não comprovam comportamento autoritativo.
- NationIDAlly nos Delphi foi encontrado em declaração/leitura/gravação, sem consumo no caminho de ataque examinado. Não usar esse campo como prova de política completa para liberar PvP.

## Próximos passos recomendados, não implementados

1. Skills de monstros por IDs/natureza/alcance/cast/cooldown/efeitos, reutilizando matemática atual.
2. Catálogo comprovado de guardas/posse/instâncias/dificuldade e mecânicas de boss.
3. Navegação/linha de visão com dados de colisão e formação melee estável. Movimento direto dos Delphi também não resolve obstáculos.
4. Comparar Reinforce2 nativa com itens/cliente atuais antes de trocar curva; conferir valor total versus adicional e preservar cap11.
5. Calibração pareada das seis classes; não misturar ATK/ratings de escalas diferentes.

## Verificação e limites

63 testes atuais passaram sem skips:15matemática,13patrulha,12grupo e23ranged.14 hashes conferidos sem divergências. Sem compilar/executar servidores Delphi/AikaEmu, sem benchmark, sem gameplay e sem prova de equivalência ao oficial. Não foi feita auditoria integral de todas as skills/DGs ou de backups históricos.
