---
tags:
  - aika-og
  - reverse-engineering
  - combat
updated: 2026-10-22
---

# Aika OG - Auditoria Atributos Client 2026-10-22

Relacionado: [[Aika OG - MOC]], [[Aika OG - REA e Protocolo Nativo 2026-10-17]], [[Aika OG - Opcodes e Simbolos 2026-10-18]], [[Aika OG - Desenho Atributos e Combate 2026-10-19]].

## Escopo e identidade

Revisao dos sete arquivos em `D:\aika\aika-cliente-reverse-engineer`, confrontados estaticamente com `D:\aika\Aika OG\AikaClient.exe` via REA/Ghidra 12.1.2. Build x86, base preferencial `0x00400000`, SHA-256 `e1104cbb8d313ec9b07e18c5529ac6865d1eda92e429355185617a4f805ff002`. O hash historico `7eca8e1e...` nao autoriza transferencia automatica de conclusoes.

Documento revisado: `sistema_combate_profundo-1.md`. Evidencias, manifesto de funcoes, snapshot estatico e originais preservados em `audit-2026-10-22/` na mesma pasta. O snapshot REA contem registros de evidencia, nao e projeto Ghidra persistente nem prova de replay de consultas.

## Confirmado e corrigido

- 23 funcoes de atributos + 11 de BattleZone = 34 unicas; a segunda copia Combat e duplicata, preservada e sincronizada.
- `0x00422FB0`: stride de equipamento 20 bytes, nao 2. Stride da tabela de sets e `0x6C` shorts = `0xD8` bytes; preservado.
- `0x00423350`: tipos de efeito avancam 2 bytes; corrigida ausencia de indice no segundo/terceiro efeitos.
- `0x00423170`: acesso ao indice 15 requer representacao com 16 slots; reduzido padding, preservando `equipSlots +0x290`.
- `0x004234C0`: indices de buff 0..10 inclusive; minimo representado `0x1587`, nao prova de tamanho completo do objeto.
- `0x0054A7B0`: magnitude de dano nos tres envios intermediarios de apresentacao.
- `0x0054B210`: escrita de byte em `+0x534`, porque `0x14D` estava em unidades DWORD.
- Curvas admitem entrada 1..2000 inclusive; grupo `/10` e resto `%10` nao sao a mesma condicao.
- `0x00546FF0` atribui valor recebido em `packet+0x0C`, sem incremento local ou decisao de vitoria.

## Limites duraveis

> [!warning]
> Nomes A..F como ATK/DEF/acerto/evasao permanecem inferidos. Nao copiar essas rotinas como formula de dano do servidor. Aliases e tipos externos, ABI, signedness fora do dominio nominal e equivalencia integral continuam pendentes.

Os 34 VAs fornecidos sao entradas de funcao no build atual. `0x0057FC44` e interior da funcao que o Ghidra identifica em `0x0057ECA0`, nao entrada independente. `0x00513990` nao foi comprovado como construtor do buffer. Nao foi observada escrita em uma global `g_FoundSkillId`.

O conjunto recebido nao inclui tipos/globais/helpers nem projeto de build. Testes x86 isolados executam corpos reais com tabelas substitutas; consultar `audit-2026-10-22/verification.md` para resultados, baseline e limites. Isso nao valida compilacao integral, dados reais ou gameplay.

Executavel, servidor, banco e protocolo preservados. Sem execucao do jogo, login, combate, captura nova ou x64dbg nesta rodada. A auditoria de atributos nao homologa este hash para operacoes de Premium Store.

## Comparacao com o GameServer

Roteiro especifico: `C:\Projetcts\aika-og\docs\reverse-engineering\CLIENT-SERVER-ATTRIBUTE-VALIDATION-2026-10-22.md`. Leitura atual confirmou `CharacterStatusService.Recalculate/CollectEquipEffects`, `EquipmentCombatService.Calculate`, `ItemSetTemplateService.AddEffectsForEquips` e envios `0x109`/`0x10A` por `CharacterPacketFactory`. Separar entrada, calculo, serializacao e apresentacao; politica Lore pode diferir intencionalmente da curva cliente.

Candidato para teste, ainda sem correcao autorizada ou conclusao de bug: servidor acumula os efeitos de set elegiveis, enquanto `0x00423170` para no primeiro efeito correspondente por set. Validar com tabela/seletor equivalentes e dois limiares do mesmo efeito antes de concluir incompatibilidade. Nao houve teste com personagem real nem mudanca de formula.

## Laboratorio de atributos no Studio

Implementado em `C:\Projetcts\aika-og\AikaStudio`: 10 cenarios offline reutilizando CharacterStatusService e CharacterPacketFactory, com campos reais decodificados de 0x109, 0x10A e 0x103 e observacoes manuais. Guia: `C:\Projetcts\aika-og\docs\reverse-engineering\ATTRIBUTE-LAB.md`. Sem mudanca de formula ou protocolo; nao demonstra equivalencia nativa nem captura jogo.

ADMIN #1 da conta admin, classe 31, nivel 99, estava excluido. Reativado e preparado no cenario sem equipamento de combate com 14 itens de kit, duas bolsas (40 slots), aparencia preservada; buffs e titulo removidos. Backup original antes da mutacao em `artifacts/studio/attribute-lab/c46a05afbcd1408f8cc2823dee219c5f/before.json`: restaurar devolve inclusive o estado excluido. Classe, nivel, habilidades, dinheiro, armazem e Prans nao alterados.

Validacao: 7 testes especificos (3 MySQL em schemas isolados incluindo rollback e restauracao exata); 63 regressoes de atributos/equipamentos; frontend build/lint e UI desktop/mobile sem erros JS. Suite Studio configurada: 137 passaram, 1 falha PremiumStore por hash nao homologado, 1 condicional nao executado. Login/medicao no cliente continuam pendentes. Catalogos carregados ao abrir laboratorio: reiniciar Studio apos edicao. Detector de manutencao compartilhado procura GameServer pelo nome; operador deve parar tambem instancias dotnet GameServer.dll.
