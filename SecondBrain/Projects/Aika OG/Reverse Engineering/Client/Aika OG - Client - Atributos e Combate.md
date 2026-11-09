---
title: Aika OG - Client - Atributos e Combate
tags:
  - project/aika-og
  - client
  - combat
updated: 2026-10-22
---

# Aika OG - Client - Atributos e Combate

Operações nativas do executável definido em [[Aika OG - Client - Documentacao Oficial]]. Os identificadores `Char_*`, `Combat_*` e `BattleZone_*` são nomes documentais. O catálogo de VA/RVA está em [[Aika OG - Client - Assembly e Funcoes]].

## Equipamentos efeitos e conjuntos

| Operação | Acesso confirmado |
|---|---|
| Construção da lista de sets | Equipamentos com stride de 20 bytes; ao avançar dez ushort, avança um registro |
| Percurso de slots | Índices 1..15; a representação que inclui índice zero precisa de 16 entradas |
| Tabela de sets | Stride de `0x6C` shorts, equivalente a `0xD8` bytes |
| Efeitos de equipamento | Tipos de efeito avançam dois bytes a cada tentativa; consulta considera os três efeitos |
| Fontes de bônus | Arrays de 20 slots em `+0xD4`, `+0x1010` e `+0x1088`; procura maior valor e pode adicionar bônus de set |
| IDs de buff relacionados a set | Começam em `+0x157C`; percurso admite índices 0..10 |
| Representação mínima do objeto acessado | Inclui o byte `+0x1586`, exigindo pelo menos `0x1587` bytes |

A representação dos equipamentos preserva o campo `equipSlots` em `+0x290`. Os dez IDs de saída da lista de sets são valores de 32 bits. Tipos de ponteiros e convenções de chamada precisam acompanhar o assembly de cada rotina.

## Seletores de campos de item

`0x00422A40` acessa a tabela de itens na base `0x0193E700` com stride `0x1D0`. Nos caminhos sem refino:

| Seletor | Offset do campo uint16 |
|---|---|
| `0x02` | `+0x166` |
| `0x03` ou `0xD7` | `+0x16A` |
| `0x08` | `+0x168` |
| `0x09` | `+0x16C` |
| `0x0D` | `+0x174` |
| `0x0E` | `+0x176` |
| `0x0F` | `+0x18A` |
| `0x12` | `+0x190` |
| `0x13` | `+0x192` |
| `0x2E` | `+0x17A` |
| `0x31` | `+0x184` |
| `0x35` | `+0x182` |

A rotina também aplica requisitos, tipo de item, refino, efeitos adicionais e variância nos respectivos ramos. O mapeamento acima documenta leitura de campo, não uma fórmula completa.

## Curvas nativas

As rotinas identificadas usam dois conjuntos de entradas, nos offsets `+0x1E` e `+0x20`. A condição `(uint32_t)(entrada - 1) < 2000` admite valores **1..2000**, inclusive. O deslocamento observado na tabela é de 100 bytes por entrada.

| Rotina documental / VA | Operação observada |
|---|---|
| A / `0x004256E0` | Base `+0xC6`, entrada `+0x1E`, bônus `0x14/0x1A7`, clamp 0..500 |
| B / `0x00425830` | Base `+0xC8`, entrada `+0x1E`, bônus `0x15`, clamp 0..500 |
| C / `0x004240A0` | Seed `+0x28`, entrada `+0x1E`, bônus `0x0D/0xB8`; estágio adicional com `+0x20` e multiplicador `0x196` dividido por 100 |
| D / `0x004242A0` | Seed `+0x28`, entrada `+0x20`, bônus `0x0E/0xB9` |
| E / `0x00424410` | Bônus `0x40/0xBF`, entrada `+0x1E`, gate de classe e valor `+0xB0`, máximo com bônus `0x24` |
| F / `0x00424590` | Bônus `0x41/0xC0`, entrada `+0x20`, gate de classe correspondente |

O grupo de classe usa divisão por dez do byte `+0x15`. O teste de resto `%10 > 2` tem finalidade própria nos buffs de set. O assembly faz extensão de sinal desse byte.

A associação definitiva de A..F a nomes de estatísticas de gameplay é uma pendência explícita. Até sua confirmação, estes identificadores designam operações e offsets.

## Ciclo de cast

| Fase | Rotina | Mensagem/condição |
|---|---|---|
| Início | `0x004F5460` e `0x004F5510` | Montam `0x0320`, 28 bytes |
| Espera | Caminhos em `0x0051F768` e `0x0051F7D4` | Comparam tempo decorrido ao CastTime de SkillData `+320` |
| Conclusão | `0x004F4530` e `0x004F4690` | Montam `0x0302`, 48 bytes, após tempo decorrido maior que CastTime |
| Animação | Leituras em `0x004F45F0` e `0x004F48D1` | SelfAnimation de SkillData `+344` é gravada em `packet+28` |
| Cancelamento | `0x004E5F20` | Monta `0x0327`, 16 bytes |

O servidor mantém o cast pendente e valida seu tempo antes da conclusão. Skills de cast zero têm o caminho instantâneo correspondente. A remoção de buff pelo ícone usa `0x0329` e um contrato separado do cancelamento de cast.

## Dano e estado exibido

O consumidor de resultado `0x0049FA40` delega às rotinas `0x0052EFD0` e `0x0052F1F0`. O contrato OG `0x0102` transmite três componentes em `+60/+64/+68` num frame de 84 bytes. `0x0049FD10` consome a atualização `0x0103` e limita o HP recebido ao máximo no respectivo caminho.

Na apresentação de BattleZone, `Combat_ShowKillMessage`, VA `0x0054A7B0`, usa a magnitude do dano nas três chamadas intermediárias identificadas. A apresentação não define a política de cálculo do dano do servidor.

## BattleZone

| Rotina | Comportamento confirmado |
|---|---|
| `0x00546FF0` | Copia DWORD de `packet+0x0C` para `scene+0xEB518` e atualiza o label |
| `0x00546CA0` | Formata informação de placar |
| `0x00546D30` | Seleciona faixa e prepara apresentação/expiração |
| `0x00547080` | Lê DWORDs `+0x0C/+0x10`, apresenta nível N+1 e calcula expiração com duração positiva |
| `0x0054B210` | Verifica cooldown; caminho liberado envia `0x039E`; escrita de byte no objeto em `+0x534` |
| `0x005448E0` | Envia `0x0F6A`, buffer de 16 bytes, payload DWORD 1 em `+0x0C` |

O buffer de 16 bytes desses envios contém tamanho, sessão WORD `+4`, opcode WORD `+6`, DWORD zero `+8` e payload DWORD `+12`. A implementação completa de BattleZone no servidor permanece nas pendências.

## Integracao com o GameServer

| Responsabilidade | Implementação |
|---|---|
| Atributos efetivos e derivados | `CharacterStatusService.Recalculate` |
| Fontes de efeitos de equipamento | `CharacterStatusService.CollectEquipEffects` |
| Ataque/defesa de equipamento e refino | `EquipmentCombatService.Calculate` |
| Bônus de conjuntos | `ItemSetTemplateService.AddEffectsForEquips` |
| Serialização de atributos | `CharacterPacketFactory.CreateSendAttributesPacket`, opcode `0x0109` |
| Serialização de status | `CharacterPacketFactory.CreateSendStatusPacket`, opcode `0x010A` |

A comparação funcional segue a cadeia `propriedade do servidor → campo do pacote → consumidor nativo → valor exibido`. Dados, classe, nível, equipamentos, buffs e refino devem ser os mesmos nos quatro pontos.

As fórmulas escolhidas para o servidor pertencem à política do projeto. Sua equivalência com todas as curvas internas do cliente só pode ser registrada após a verificação específica descrita em [[Aika OG - Client - Verificacao e Pendencias]].

## Laboratorio de atributos

O Studio disponibiliza **Administração → Laboratório de atributos**, em `http://127.0.0.1:3388/#attribute-lab`. A ferramenta oferece dez cenários offline usando os calculadores reais do GameServer e decodifica os pacotes `0x0109`, `0x010A` e `0x0103` produzidos por `CharacterPacketFactory`.

Para cada cenário, apresenta equipamento, valores previstos, diferenças em relação ao cenário-base e campos serializados. A área de observações recebe os números medidos manualmente na tela e registra cenário, personagem, versão e hash do cliente. O laboratório não lê a memória nem captura a rede do cliente.

A preparação persistida de personagens exige manutenção e gera backup para restauração. As instruções operacionais e os limites de restauração pertencem ao [guia do laboratório](<C:/Projetcts/aika-og/docs/reverse-engineering/ATTRIBUTE-LAB.md>). O laboratório apoia a homologação das correspondências entre servidor e cliente; a medição real no jogo permanece pendente.
