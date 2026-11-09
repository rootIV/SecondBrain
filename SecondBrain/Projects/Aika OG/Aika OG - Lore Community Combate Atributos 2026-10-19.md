# Aika OG - Lore Community Combate Atributos 2026-10-19

Relacionados: [[Aika OG - MOC]], [[Aika OG - Comparacao Combate IA Referencias 2026-10-19]], [[Aika OG - Balanceamento Classes e Progressao 2026-10-19]]. Somente análise; nenhuma alteração de runtime, banco, cliente ou binários.

Fonte principal: [relatório completo](C:/Projetcts/aika-og/docs/analysis/AIKA-LORE-COMBAT-ATTRIBUTES-2026-10-19.md). Referência: `D:/aika/Aika Lore Community`. Grafo: [HTML](<D:/aika/Aika Lore Community/graphify-out/graph.html>), `graph.json`, `GRAPH_REPORT.md` e `graph-health.json` no mesmo diretório.

## Achados duráveis

- Graphify0.9.26 code-only: 1.834 nós, 3.821 relações, 119 comunidades; 107 entradas de código, 86 arquivos representados em nós. Zero chamadas externas a modelos. Vinte entradas sem nós e um SQL sem parser; documentos/imagens/binários não tiveram extração semântica. Dois self-loops DFM são artefatos de tipos de componentes. Links INFERRED com nome genérico delete não provam chamadas. Grafo não direcionado não prova fluxo.
- Seguir `Server/AikaServer.dpr → Src`. O grafo inclui `BaseMob_old`, unidades2 e `__recovery`; nome de método isolado pode selecionar versão inativa. IDs completos distinguem símbolos.
- Fluxo confirmado player→player ou mob normal: `AttackTarget → SendDamage → GetDamage → AttackParse → modificadores finais/pacote/HP`. `GetDamage` normal retira DEF/8 e tem piso1, mas `AttackParse` soma metade de Skill.Damage+HabAtk após defesa e `SendDamage` acrescenta RandomRange(dano div20,dano div10)+13. Não declarar corrigido o dano final olhando só GetDamage.
- **Correção do relatório anterior Rafinha/TheMu:** SendMobDamage/GetMobDamage não tiveram chamador do dispatcher localizado nas unidades Src examinadas. O exemplo255..353 é rotina legada, não dano efetivo comprovado do dispatcher. BaseMob.GetDamage não é exclusivo de PvP.
- Lore mudou GetDamageType3: sorteios separados, Randomize repetido e blocos de duplo crítico comentados. Crítico13/res0→14%; crítico14/res0→61%; crítico14/res1→14%, condicionados a chegar à etapa e sem overrides. Duplo5/res0→17%; duplo5/res10→25%: resistência maior favorece atacante no ramo negativo. Não copiar curva.
- ATK físico soma2,6FOR e2,6AGI; mágico3,2INT; HabAtk6SOR; crit0,13AGI; duplo0,21FOR; acc0,1AGI; esquiva0,021AGI; pen física0,04FOR/mágica0,34INT; CDR0,25INT. Pen/CDR limitados a70. São unidades/ratings próprios, não coeficientes oficiais comprovados nem intercambiáveis com o atual.
- HP usa Round(constanteClasse×0,3)×nível +27CON, efeitos/refino/percentuais; MP análogo +27SOR. Guerreiro L50 com CON35 igual e sem itens/buffs: Lore3195HP, atual5925HP. Comparação controla CON; não representa duas progressões reais nem comprova equilíbrio. Ramo MP consulta efeito de relíquia HP; requer confirmação de semântica.
- AddLevel concede pontos manuais somente acima50:2por nível e10extras51/61/71/81; subida unitária concede138até99, zero até50 nessa rotina. Não demonstra os49extras pré50 atuais. Atributos vêm do SQL e bases de criação por classe.
- Mob→player em AttackPlayer usa metade de DNFis, skill, DEF/8 e17..45; defesa escolhida pela classe da vítima e sorteios fixos. Lore mantém patrulha que pode parar em9 para destino10 e resets imediatos de posição/HP em ramos de retorno. Movimento inicia600ms, contra3000ms nos forks anteriores; laços por jogador continuam risco estrutural de passos dependentes da população, sem benchmark.
- Conteúdo aproveitável: Skill01..05, efeitos, guardas/pedras, DG/refino e módulos adicionais de altar/ranked. Presença não comprova execução correta ou equivalência ao oficial. Preservar ameaça, mitigação, retorno e tolerância de patrulha atuais; adotar conteúdo por IDs comprovados e adaptar ao núcleo atual.

## Verificação e limites

Treze checks de traduções isoladas passaram; não houve execução Delphi, captura, gameplay ou benchmark. Manifest registra10 fontes-chave Lore e5 fontes atuais;14 hashes-chave do relatório anterior foram reconferidos sem mudanças. Não houve nova execução dos63 testes C# citados no relatório anterior. A matemática atual aprovada,49extras/cap11, permaneceu intacta.

Grafo sem nós sem rótulo de comunidade, links do relatório válidos, hashes reconferidos e git diff --check passou. Health do vault: zero wiki links quebrados;2referências de workspace ausentes e3nomes duplicados preexistentes mantidos, por isso Passed=false global não significa falha nova desta nota.

Não executar instalador ou SQL de `Docs bugs` automaticamente: há correções pontuais e comandos específicos de dados. Não reproduzir credenciais. Pendências de curvas, navegação, integração de eventos e calibração estão em [[Knowledge Debt]].
