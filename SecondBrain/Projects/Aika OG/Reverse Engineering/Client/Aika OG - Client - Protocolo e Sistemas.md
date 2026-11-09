---
title: Aika OG - Client - Protocolo e Sistemas
tags:
  - project/aika-og
  - client
  - protocol
updated: 2026-10-22
---

# Aika OG - Client - Protocolo e Sistemas

Contrato do cliente identificado em [[Aika OG - Client - Documentacao Oficial]]. Inteiros multibyte usam little endian. Offsets são contados a partir do início do frame, salvo indicação expressa. C→S significa cliente para servidor; S→C, servidor para cliente.

## Transporte TCP

### Header de jogo

| Offset | Tipo | Campo |
|---:|---|---|
| 0 | uint16 | Tamanho total declarado |
| 2 | byte | Checksum |
| 3 | byte | Seed |
| 4 | uint16 | Sender/índice da entidade ou conexão |
| 6 | uint16 | Opcode |
| 8 | uint32 | Tick/contexto temporal |
| 12 | bytes | Payload específico |

O header tem 12 bytes. O prefácio de socket é `11 F3 11 1F`, DWORD `0x1F11F311`. O parser trata o fluxo recebido antes de entregar os pacotes à cena ativa.

### Cifra e framing

O primeiro DWORD permanece externo à transformação. A tabela de 512 bytes fica em VA preferencial `0x0070EFE0`. A cifra processa DWORDs completos a partir de `+4`, com aritmética módulo `2^32`.

```text
position = keys[seed * 2]
key = keys[(position & 255) * 2 + 1]

DWORD de offset 4: i = 1
i % 4 == 0: delta =  4 * key
i % 4 == 1: delta = -(key >> 1)
i % 4 == 2: delta =  2 * key
i % 4 == 3: delta = -(key >> 2)

wireDWORD = plainDWORD + delta (mod 2^32)
checksum = (soma dos wireDWORDs - soma dos plainDWORDs) & 255
position avança a cada DWORD
```

O receptor desfaz a transformação e confere o checksum. Seus estados incluem `1` para checksum divergente, `2` para prefácio/tamanho inválido e `4` para seed consecutiva repetida. O chamador deve considerar o estado devolvido junto ao ponteiro de pacote.

O envio nativo exige atenção ao alinhamento: sua cópia para a fila trabalha com DWORDs completos. Os layouts de produção devem ser definidos pelo contrato específico. Frames capturados com tamanho particular não autorizam padding arbitrário.

O servidor controla a seed na ordem final de envio de cada conexão, incluindo concorrência e broadcast. A mesma tabela e transformação são conservadas.

### Cenas

| Cena | Vtable preferencial | Recepção no slot `+0x20` |
|---|---|---|
| Login | `0x0071BEF8` | `0x005A90B0` |
| Seleção de personagem | `0x0071C7CC` | `0x005C0D00` |
| Mundo | `0x0071AC34` | `0x004BFC40` |

`0x0040A340` bombeia os pacotes para a cena. `0x005AE9C0` trata caminhos compartilhados. A tabela de recepção do cliente é S→C; o `PacketDispatcher` do servidor recebe C→S.

## Autenticacao

### Sequência de identidade

1. O cliente solicita o ticket por POST em `/member/aika_get_token.asp`, campos `id` e `pw`.
2. O socket de conta envia `0x0081`, com usuário e ticket.
3. A resposta `0x0082` informa o resultado da autenticação da conta.
4. O cliente abre a seleção de mundos no ramo positivo dessa resposta.
5. O novo socket de jogo envia `0x0685` e autentica novamente a identidade/ticket.

| Mensagem | Direção | Layout implementado |
|---|---|---|
| `0x0081` | C→S | 1.116 bytes; username em `+12`, ticket hexadecimal de 32 caracteres em `+44`, NUL em `+76` |
| `0x0082` | S→C | 28 bytes; AccountId int32 `+12`, tick uint32 `+16`, Nation DWORD `+20`, byte zero `+24`, Nation byte `+25`, zeros `+26..27` |
| `0x0685` | C→S | 1.120 bytes; AccountId `+12`, username `+16`, ticket `+96` |

`0x0685` autentica o socket de jogo. A validação vincula o ID à conta correspondente e conserva a identidade da sessão já estabelecida.

No contrato da rota de token, a senha recebida é transformada em MD5 UTF-8/hex minúsculo antes da validação das credenciais persistidas. O nome do parâmetro não altera esse contrato. O ticket aceito é opaco; o servidor persiste seu fingerprint SHA-256.

### Comportamento de interface

- Falha de conexão, resposta HTTP vazia e timeout TCP apresentam `Não foi possível conectar ao servidor.` pela rotina interna de aviso `0x00668020`.
- As falhas de usuário/senha usam `Login ou Senha Incorreto`.
- A interface restaura a tentativa e os controles após falha.
- O tratamento do timeout considera o limite de 10.000 ms; há regressão para 10.000/10.001 ms.

Os textos de credencial ficam nos slots 3 e 4 de `UI/strdef4.bin`. Cada slot ocupa 128 bytes em CP1252; o loader `0x004433E0` carrega a tabela na base `0x0299CE40`.

## Entrada no mundo

A fonte normativa do encadeamento é `CharacterWorldService.BuildEnterWorldPackets`. Ela recalcula os atributos, envia dados de entrada, buffs e identidade, status/atributos, dados auxiliares, refresh completo, títulos, inventário Premium inicial, sinal de entrada e cash. Em seguida envia progresso das missões ativas e páginas do mapa de NPCs.

O fim da preparação é sinalizado por `0x0F0B`. O ping lógico C→S é `0xF93A`, tratado por `RequestServerPing`; a resposta textual usa `0x0984`.

O pacote `0x0117` tem contratos por produtor: identidade usa 28 bytes; efeito visual usa 20 bytes. A interpretação deve acompanhar direção, tamanho e fábrica.

## Entidades skills e buffs

| Opcode | Direção | Contrato em uso |
|---|---|---|
| `0x0101` | S→C | Remoção de entidade; o consumidor lê identificador em `+12`; produtores e variantes requerem seu layout específico |
| `0x0102` | S→C | Resultado de dano; layout OG de 84 bytes, componentes em DWORDs `+60/+64/+68` |
| `0x0103` | S→C | 32 bytes; maxHP/HP/maxMP/MP em `+12/+16/+20/+24`, flag em `+28` |
| `0x0107` | S→C | 136 bytes; 60 WORDs de skills a partir de `+12`, SkillPoint WORD em `+132`, padding WORD em `+134` |
| `0x0109` | S→C | Atributos efetivos FOR/AGI/INT/CON/SOR, status e pontos de skill; serializado por `CharacterPacketFactory` |
| `0x010A` | S→C | Ataques, defesas, velocidade, crítico, esquiva, acerto, ataque duplo e resistência; serializado por `CharacterPacketFactory` |
| `0x012C` | S→C | 96 bytes; modo DWORD `+12`, 20 DWORDs de cooldown em segundos `+16..95` |
| `0x016E` | S→C | 252 bytes; 40 IDs WORD em `+12`, 40 deadlines DWORD em `+92` |
| `0x016F` | S→C | 24 bytes; IDs WORD `+12/+14`, deadlines DWORD `+16/+20` |

Os tempos de `0x016E/0x016F` são deadlines Unix. O clock de login correspondente é enviado em DWORD `+6348` no pacote de entrada de 6.380 bytes. O estado normalizado do consumidor de buffs ocupa 372 bytes; o contrato de rede do snapshot permanece 252 bytes.

`0x0320` inicia cast, `0x0302` conclui o caminho com ataque/skill e `0x0327` cancela o cast. `0x0329` remove um buff pelo identificador de skill. A sequência está detalhada em [[Aika OG - Client - Atributos e Combate#Ciclo de cast]].

## NPCs e missoes

### Aparência e marcadores

O spawn OG `0x0349` tem 508 bytes. Para NPCs, Body/childID usa WORD `+90`, o marcador de missão usa byte `+93`, e o título usa `+456`. Para personagem, o título e o tier usam `+504/+505`.

O marcador de ator pode ser atualizado por `0x010D`, com estado DWORD em `+16`. O spawn e a atualização devem respeitar a ordem de criação do ator e o estado visual aplicado pelo cliente.

### Mapa M

O pacote S→C `0x033D` tem 52 bytes:

| Offset | Tipo | Conteúdo |
|---:|---|---|
| 12 | DWORD | Página 0..4 |
| 16 | 12 WORDs | Índices nativos de NPC |
| 40 | 12 bytes | Marcadores correspondentes |

A página zero limpa o cache de 60 entradas. Uma atualização completa envia as cinco páginas na ordem 0, 1, 2, 3, 4, incluindo páginas vazias. O índice zero representa slot vazio.

O índice é o de `npcpos`, base zero. A identidade de missão não deve ser substituída por ClientId, NameValue ou índice acrescido de um. Os vínculos utilizados pelo servidor estão em `Data/Quest/NpcQuestBindings.json`.

### Diálogos e progressão

`0x0310` transporta o seletor DWORD de painel em `+12`, num frame de 16 bytes. A abertura visual do painel e a operação executada por ele têm contratos próprios.

As missões usam registros de 2.696 bytes. O nível mínimo fica no byte `+1243`. Os blocos de condição têm 48 bytes. Tipos empregados na progressão incluem faixa de nível `4`, classe `5`, anterior obrigatório `9`, Pran equipada `29` e ramo anterior alternativo `48`.

`0x032F` abandona missão; `0x0330` participa da escolha de recompensa. O servidor conserva estado, requisitos e operações de recompensa de cada missão habilitada. As associações de cores e a disponibilidade dependem do catálogo efetivo; os quatro IDs de Toca 2575..2578 usam marcador diário 11.

## Inventarios cash titulos e Pran

| Fluxo | Contrato |
|---|---|
| Consulta Cash/J | C→S `0x03AE`, 20 bytes, seletor em `+16`; J usa seletor 2 |
| Valor para compras | Consumidor `0x00589710` de `0x03AE` grava o saldo de validação da loja |
| Texto do saldo | S→C `0x0139`, 16 bytes, saldo DWORD `+12`; consumidor `0x004B6B10` atualiza o widget |
| Consulta de inventário Premium | C→S `0x020A`, 12 bytes |
| Inventário Premium | S→C `0x0138`, 204 bytes: header + 24 registros de 8 bytes; WORD inicial identifica a linha de `PI.bin` |
| Compra Premium | C→S `0x0209`, 16 bytes, linha DWORD `+12` |
| Armazém pessoal | `0x0137`, 2.024 bytes: 100 registros de 20 bytes e gold de 64 bits |
| Baú de guilda | Contratos `0x0F10`/24, `0x0D58`/1.020 e `0x0D18`/24 bytes |
| Títulos | `Title.bin`: 256 registros de 224 bytes, quatro tiers de 56; seleção por `0x0361`/`0x3061` conforme produtor |
| Pran | `0x0907`, 1.280 bytes: skills em `+60`, 16 equipamentos em `+76`, 42 itens em `+396`, barra em `+1236` |
| Estado da Pran | `0x096B`, 16 bytes: personalidade em byte `+13`, comida `+14`, devoção `+15` |

Skills de Pran usam 100 bits unários, dez famílias de dez níveis, em 13 bytes com três bytes de padding. A conta suporta duas Prans; identidade, pedra equipada e vínculo de conta são verificados pelo servidor.

Saldo informado pelo cliente e preço exibido na UI não autorizam débito. Compra, retirada, transferências e consumo dependem do estado persistido e das validações do servidor.

## Refino reducao e guilda

### Operações de item

O produtor `0x00522170` monta C→S `0x032D` com 28 bytes:

| Offset | Tipo | Conteúdo |
|---:|---|---|
| 12 | DWORD | Operação |
| 16 | DWORD | Slot alvo |
| 20 | DWORD | Slot de material |
| 24 | DWORD | Slot de proteção; `0xFFFFFFFF` indica ausência no caminho de refino |

Painel 5 seleciona operação 0, refino. Painel 8 seleciona operação 3, redução. Os valores são slots de inventário, e não IDs de template.

A resposta S→C `0x032E` tem 20 bytes: operação DWORD `+12` e resultado DWORD `+16`. O cliente agenda a animação de resultado; itens e dinheiro atualizados são enviados pelos respectivos snapshots.

| Operação | Resultado | Efeito apresentado |
|---|---:|---|
| Refino | 2 | Sucesso |
| Refino | 1 | Falha com penalidade |
| Refino | 0/default | Item destruído |
| Refino | 3 | Proteção contra destruição |
| Refino | 4 | Proteção contra destruição e queda de capacidade |
| Redução | 2 | Sucesso |
| Redução | 1 | Falha |
| Redução | Outro | Backfire/aumento do nível exigido |

O nibble alto de `Refi` representa refino; o baixo representa redução. O custo da redução vem de `UI/Easing.bin`, registro `(UseEffect-1)*120`, custo em `+40 + 4*reducaoAtual`. O custo e a chance escolhidos pelo servidor são política de implementação; o cliente descreve preço/apresentação e envia a seleção.

### Guilda

`0x0341` usa 48 bytes: estágio DWORD `+12`, taxa uint64 `+16`, área de nome em `+24`. O produtor observado escreve no máximo 20 bytes incluindo terminador. O estágio 0 solicita o fluxo, o estágio 1 apresenta a taxa e o estágio 2 confirma a criação. O servidor valida nome, requisitos, saldo e contexto no commit.

## Exclusao de personagem

O prazo configurado pelo projeto é de cinco dias completos em UTC.

| Etapa | Contrato |
|---|---|
| Preflight | C→S `0x3F33`, 24 bytes, step 7; resposta `0x3F33`, 20 bytes, step 8 |
| Solicitar prazo | C→S `0x0603`, 28 bytes, ação 0 |
| Cancelar | C→S `0x0603`, 28 bytes, ação 1 |
| Finalizar após prazo | C→S `0x3E01`, 56 bytes, com intenção válida da sessão |
| Seleção | `0x0901`, 336 bytes, três linhas de 104 bytes |

Na linha de personagem, DWORD `+92` é o timestamp Unix de exclusão: zero significa estado normal, futuro informa prazo, vencido habilita a confirmação final. DWORD `+88` permanece reservado; bytes `+96/+97` ficam zero no fluxo sem numérica. A flag persistida de exclusão é separada do timestamp.

O servidor revalida proprietário, slot, personagem, guilda, Pran, estado online e prazo. A intenção de confirmação expira em um minuto. O projeto preserva os registros para recuperação administrativa.

## Implementação e verificação

Rotas C→S: `GameServer/Presentation/Packets/PacketDispatcher.cs`. Produtores S→C: fábricas de pacotes de Characters, Skills, Npcs, Items e inventário nativo. A relação exata de verificações, fontes e pendências está em [[Aika OG - Client - Verificacao e Pendencias]].
