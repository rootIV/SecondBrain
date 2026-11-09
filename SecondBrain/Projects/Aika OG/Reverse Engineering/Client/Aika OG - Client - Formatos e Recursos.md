---
title: Aika OG - Client - Formatos e Recursos
tags:
  - project/aika-og
  - client
  - binary-formats
updated: 2026-10-22
---

# Aika OG - Client - Formatos e Recursos

Formatos do cliente definido em [[Aika OG - Client - Documentacao Oficial]]. Os caminhos desta nota são relativos a `D:\aika\Aika OG`. Contagens de registros representam capacidade física, não quantidade de entradas jogáveis.

## Transformacoes

Item e Skill usam chaves distintas, localizadas em VA `0x0073F9A0` e `0x0073F580`. Para o payload transformado:

```text
plain[i]   = (encoded[i] - key[i % keyLength] - i) & 255
encoded[i] = (plain[i]   + key[i % keyLength] + i) & 255
```

O índice é global dentro do payload. Nos arquivos com envelope de 12 bytes, o envelope fica fora da transformação. Em Quest e Dialog, o índice coincide com o offset absoluto. A leitura de um registro isolado preserva essa posição.

`SL.bin` usa subtração de `i % 5`. `MN.bin` usa subtração de `i`. Arquivos sem transformação são lidos diretamente. A extensão `.bin` não identifica uma cifra única.

## Catalogo de tabelas

Tamanhos físicos conferidos no cliente em 22/10/2026.

| Arquivo | Transformação | Registros / stride | Estrutura adicional |
|---|---|---|---|
| `ItemList4.bin` | Item | 31.000 × 464 | Envelope 12 + footer 4 |
| `SkillData4.bin` | Skill | 12.000 × 720 | Envelope 12 + footer 4 |
| `UI/PI.bin` | Item | 6.000 × 376 | Footer 4 |
| `UI/quest.bin` | Skill | 7.168 × 2.696 | Sem envelope |
| `UI/Dialog.bin` | Skill | 10.940 × 5.508 | Sem envelope |
| `UI/MakeItems.bin` | Skill | 26.000 × 52 presentes | Loader solicita 31.000; ver pendências |
| `UI/Recipe.bin` | Skill | 3.000 × 92 | Registros |
| `UI/Reinforce2.bin` | Skill | 2.880 × 128 | Registros |
| `UI/SetItem.bin` | Item | 1.024 × 216 | Footer 4 |
| `UI/RandItem.bin` | Direta | 4.000 × 180 | Registros |
| `UI/PackItem.bin` | Direta | 5.000 × 90 | Registros |
| `UI/MN.bin` | Índice | 4.096 × 128 | Nomes |
| `UI/MM.bin` | Direta | 1.024 × 520 | Registros |
| `UI/NH.bin` | Direta | 80 × 7.876 | Blocos |
| `UI/MobPos.bin` | Direta | 4.096 × 416 | Registros |
| `UI/SPosition.bin` | Direta | 100 × 208 | Destinos do painel de portal |
| `UI/npcpos.bin` | Direta | 2.048 × 12 | Header DWORD; 24.580 bytes totais |
| `UI/Title.bin` | Direta | 256 × 224 | Textos adicionais; 155.648 bytes totais |
| `UI/Easing.bin` | Skill | 105 × 120 | 12.600 bytes |
| `UI/ReinforceA01.bin` | Skill | 105 × 48 | 5.040 bytes |
| `UI/ReinforceW01.bin` | Skill | 105 × 48 | 5.040 bytes |
| `SL.bin` | Índice módulo 5 | 224 × 72 | Sete grupos de 32 |
| `Nation.bin` | Direta | Oito bytes ASCII | Seletor de localização/build |

Loaders e endereços estão em [[Aika OG - Client - Assembly e Funcoes]].

## ItemList

O envelope é `BR00022I` seguido de quatro NULs. O registro tem 464 bytes (`0x1D0`). Texto em CP1252.

| Offset no registro | Tipo / tamanho | Campo usado |
|---:|---|---|
| 0 | Texto 64 | Nome localizado |
| 64 | Texto 64 | Nome original |
| 128 | Texto 128 | Descrição |
| 256 | byte | Agrupável |
| 258 | uint16 | Tipo de item |
| 268 | uint16 | UseEffect |
| 276 | uint32 | DelayUse |
| 284 | uint32 | Preço em honra |
| 288 | uint32 | Preço em medalha |
| 292 | uint32 | Preço em ouro |
| 296 | uint32 | Preço-base de venda |
| 300 | uint16 | Classe/requisito de classe |
| 328 | byte | Expires |
| 330 | uint16 | Nível |
| 358 / 360 / 362 / 364 | uint16 | Ataque físico / defesa física / ataque mágico / defesa mágica |
| 372 / 374 | uint16 | HP / MP |
| 390 / 393 | byte | TypeItem / TypeTrade |
| 406 | byte | Durabilidade |
| 412 / 414 / 416 | uint16 | Tipos dos três efeitos |
| 418 / 420 / 422 | uint16 | Valores dos três efeitos |
| 425 / 426 / 427 | byte | ReductionDisabled / Fortification / Rank |
| 440 / 442 | uint16 | Moeda-item / quantidade |

O preço de venda usado pelo cliente é o DWORD em **296**. `0x00425270` aplica durabilidade; `0x004252F0` calcula a dedução tributária. O cliente recebe as taxas por `0x0128`; o servidor valida o preço no próprio catálogo.

## SkillData

Envelope `BR00010S` e quatro NULs; stride 720 bytes (`0x2D0`).

| Offset | Tipo / tamanho | Campo |
|---:|---|---|
| 0 | uint32 | Índice |
| 20 / 84 | Texto 64 | Nome original / localizado |
| 148 / 152 / 156 | uint32 | Pontos / custo / classe |
| 172 | uint32 | MP |
| 184 | uint32 | Cooldown |
| 208 | uint32 | Alcance |
| 236 | uint32 | DamageEffect |
| 248 | uint32 | Dano/parâmetro de dano |
| 292 | uint32 | Duração |
| 320 | uint32 | CastTime |
| 344 | Campo lido como WORD no produtor | SelfAnimation |
| 428 | Texto 288 | Descrição |

O produtor de conclusão de cast lê a animação em `+344` e a grava em `0x0302 +28`. Os campos devem ser interpretados com os consumidores correspondentes; seus nomes não definem sozinhos uma fórmula de dano de servidor.

## PI quest Dialog e nomes

| Tabela | Campos confirmados |
|---|---|
| PI | Índice DWORD `+0`; nome 64 bytes `+8`; descrição 256 bytes `+72`; preço DWORD `+328`; quantidade WORD `+334`; item WORD `+336`; outra quantidade WORD `+352` |
| Quest | Nome 64 bytes `+16`; mínimo de nível byte `+1243`; stride `0xA88`; condições de 48 bytes |
| Dialog | Registro `0x1584`; leitura pontual por `id * 0x1584`; limite de ID abaixo de `0x2ABC` |
| MN | Nomes em slots de 128 bytes |
| MM | Stride `0x208`; strings em `+8` e `+0x108` |
| MobPos | Busca pelo primeiro DWORD; bloco de POINT começa em `+16`; stride 416 |

Um registro PI descreve o produto local. A venda e a retirada dependem do catálogo e da persistência do servidor. Posições em MobPos não definem por si só respawn, patrulha ou autoridade de mundo.

## Checksum das tabelas

O footer é uint32 LE, fora da transformação do payload.

```text
checksum = soma(payload[slot * stride + offset] + slot * offset) mod 2^32
```

| Tabela | Offsets incluídos por registro |
|---|---|
| Item | 192..463 |
| Skill | 72..719 |
| PI | 320..375 |
| SetItem | 64..215 |

O editor recalcula o footer ao salvar. Bytes desconhecidos e padding são preservados.

## EXP e conjuntos

`ExpList.bin`, no formato de 1.220 bytes, contém 101 uint64 em `0..807`, marcador DWORD `0xFB705891` em `808`, DWORD adicional em `812` e 101 uint32 em `816..1219`. O carregamento de experiência usa os 101 limiares alinhados do primeiro bloco. O parser também suporta o formato de 1.212 bytes e tabelas simples de uint64 conforme suas validações.

`SetItem.bin` contém registros de 216 bytes iniciados no offset zero. No formato com checksum, os últimos quatro bytes são footer. O passo nativo de cada set é `0xD8` bytes.

## Titulos e localizacao

`Title.bin` começa com `0xE000` bytes de registros: 256 títulos × 224 bytes, quatro tiers × 56 bytes. Seguem seção de hints de `0x10000` bytes e descrições de `0x8000` bytes.

Por tier: Type byte `+1`, Goal WORD `+2`, Category byte `+48`, Index byte `+49` e Color DWORD `+52`. Type + Index identifica o evento; Category organiza a UI.

`UI/strdef4.bin` usa slots de 128 bytes CP1252. Seu hash atual é `396dfedcf270eec14a5a1866cd035b033489db376cdc83f0e77c596a6d95bcb1`; tamanho 396.288 bytes. Slots 3 e 4 contêm `Login ou Senha Incorreto`; o slot 27 contém `Senha Incorreta`.

`Nation.bin` seleciona localização/build. `SL.bin` organiza os servidores:

| Offset em SL | Campo |
|---:|---|
| 0 | Host, área de 32 bytes |
| 32 | IPv4 em quatro bytes |
| 36 | Nome, área de 24 bytes |
| 60 | Estado int32 |
| 64 / 68 | DWORDs adicionais |

Os destinos de conexão identificados usam portas 8822 e 8831. O consumidor do campo deve orientar a escolha do host; `+32` é endereço IPv4.

## Posicoes de NPC e portal

`npcpos.bin`: header DWORD seguido de registros `<uint32 NameValue, uint32 X, uint32 Y>`. O endereço do registro é `4 + indiceNativo * 12`. Um mesmo NameValue pode representar posições distintas.

`SPosition.bin`: 100 registros de 208 bytes. DWORD Index `+0`; WORDs X/Y/MapIndex/LocationIndex em `+4/+6/+8/+10`; grupo continental DWORD `+12`; textos de 64 bytes em `+16/+80/+144`. O filtro do painel consulta o byte do grupo em `+12`.

O pedido de portal `0x031D` tem 24 bytes: slotType DWORD `+12`, slot DWORD `+16`, seleção DWORD `+20`. Para o painel de tipo 208, seleção é o índice físico em SPosition.

## Recursos graficos e sonoros

| Família | Interpretação suportada |
|---|---|
| JT31 | Width/height uint32 em `+4/+8`; pixels após `+12`; BC1/DXT1 |
| JT33 | Mesmo envelope; BC2/DXT3 |
| JT35 | Mesmo envelope; BC3/DXT5 |
| JT20 | Dimensões uint16 em `+16/+18`; pixels BGR/BGRA |
| Sound BIN | Identificação por assinatura de MP3/WAVE |
| Shader BIN | Bytecode Direct3D; tokens `01 01 FE FF` ou `01 01 FF FF` |
| AN2/MSH/MS3/BON | Recursos de animação, mesh e ossos; parsers semânticos completos pendentes |

Os loaders identificados incluem `0x0043E760` para caminhos AN2, `0x00606BF0` para MS3 e `0x0043D540` para recursos/JIT. As variantes gráficas incompletas estão em [[Aika OG - Client - Verificacao e Pendencias]].

## Terreno

Chunks usam nomes `Z<zona:02><x:02><y:02>`.

- ATT de chunk: 131.072 bytes, grade 256 × 256 de WORDs, sem header; loader `0x005D3F50`.
- HGT de chunk: 131.072 bytes; altura representada como short no export.
- HGT de mundo: DWORD separado e `0x2000000` bytes de dados; loader `0x00417650`.
- AKM: carregamento de vizinhança em `0x005B0BE0`, `0x005B3510` e `0x005B3640`.

Os exports preservam valores crus e sua representação signed/unsigned. A escala física, os eixos mundiais e as flags completas de colisão têm status próprio nas pendências.
