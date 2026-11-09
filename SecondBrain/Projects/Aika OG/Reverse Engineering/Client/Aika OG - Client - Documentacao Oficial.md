---
title: Aika OG - Client - Documentacao Oficial
aliases:
  - Documentacao oficial do client Aika OG
  - Assembly do client Aika OG
tags:
  - project/aika-og
  - client
  - documentation
updated: 2026-10-22
---

# Aika OG - Client - Documentacao Oficial

Referência técnica oficial **do projeto Aika OG** para o cliente instalado, seu assembly, arquivos e integração com o servidor. Os contratos descritos pertencem ao executável identificado abaixo. Os nomes documentais das funções servem para navegação técnica; não representam recuperação do código-fonte original do fabricante.

## Identificação do cliente

| Propriedade | Valor |
|---|---|
| Executável | `D:\aika\Aika OG\AikaClient.exe` |
| SHA-256 | `e1104cbb8d313ec9b07e18c5529ac6865d1eda92e429355185617a4f805ff002` |
| Tamanho | 3.667.888 bytes |
| Arquitetura | PE32, x86 |
| Base preferencial | `0x00400000` |
| Endereçamento | `RVA = VA preferencial - 0x00400000`; em execução, `VA = base carregada + RVA` |
| Repositório | `C:\Projetcts\aika-og` |
| Conteúdo do vault | `C:\Projetcts\SecondBrain\SecondBrain` |

## Organização da documentação

- [[Aika OG - Client - Assembly e Funcoes]]: transporte, cenas, consumidores de pacotes, loaders e catálogo das funções de atributos/BattleZone.
- [[Aika OG - Client - Protocolo e Sistemas]]: header, cifra, autenticação, entidades, buffs, NPCs, missões, inventários, refino, guilda e exclusão de personagem.
- [[Aika OG - Client - Formatos e Recursos]]: tabelas BIN, offsets, codificação, checksums, imagens, modelos e terreno.
- [[Aika OG - Client - Atributos e Combate]]: acessos nativos, equipamentos, sets, buffs, cast e apresentação de dano.
- [[Aika OG - Client - Verificacao e Pendencias]]: evidências, cobertura de verificação e trabalho necessário para completar os sistemas.

## Leitura dos estados

| Estado | Significado |
|---|---|
| Contrato verificado | Layout ou operação conferido no binário, nos dados ou em testes de contrato |
| Implementado | Existe caminho na implementação do projeto para a operação descrita |
| Pendente | Falta implementação, interpretação de campos ou homologação indicada na nota técnica |

Uma rotina presente no cliente, um handler registrado e uma operação validada no jogo são verificações diferentes. Cada seção informa o alcance da evidência usada. Esta referência descreve o estado atual, incluindo as pendências necessárias para completar a integração.

## Mapa funcional

| Área | Estado documentado | Referência |
|---|---|---|
| Transporte TCP, header e tabela de cifra | Contrato verificado; tratamento de seed por conexão implementado e testado | [[Aika OG - Client - Protocolo e Sistemas#Transporte TCP]] |
| Login de conta e autenticação do socket de jogo | Contratos e tratamento de falhas implementados; homologação integrada indicada nas pendências | [[Aika OG - Client - Protocolo e Sistemas#Autenticacao]] |
| Entrada no mundo e atualização de atributos | Caminho implementado na source atual | [[Aika OG - Client - Protocolo e Sistemas#Entrada no mundo]] |
| HP/MP, skills, buffs e cooldown | Contratos de serialização e consumidores identificados | [[Aika OG - Client - Protocolo e Sistemas#Entidades skills e buffs]] |
| Cast, conclusão e cancelamento | Caminhos distintos implementados; regressões de contratos e visuais verificadas | [[Aika OG - Client - Atributos e Combate#Ciclo de cast]] |
| Laboratório de atributos do Studio | Ferramenta implementada com cenários, pacotes decodificados e registro de observações | [[Aika OG - Client - Atributos e Combate#Laboratorio de atributos]] |
| NPCs, lojas, marcadores e mapa de missões | Caminhos implementados; contratos de spawn e mapa definidos | [[Aika OG - Client - Protocolo e Sistemas#NPCs e missoes]] |
| Cash, inventários, títulos e Pran | Integração implementada; detalhes e homologações por fluxo nas notas | [[Aika OG - Client - Protocolo e Sistemas#Inventarios cash titulos e Pran]] |
| Refino, redução e criação de guilda | Produtores/consumidores identificados e implementação com testes de contrato | [[Aika OG - Client - Protocolo e Sistemas#Refino reducao e guilda]] |
| Exclusão com prazo e cancelamento | Fluxo implementado com confirmação nativa e prazo de cinco dias | [[Aika OG - Client - Protocolo e Sistemas#Exclusao de personagem]] |
| Tabelas BIN e recursos comuns | Layouts e transformações documentados; formatos incompletos listados como pendentes | [[Aika OG - Client - Formatos e Recursos]] |
| Cerco, variantes desconhecidas e cobertura integral do assembly | Pendentes conforme escopo específico | [[Aika OG - Client - Verificacao e Pendencias#Pendencias funcionais]] |

## Regras de manutenção

1. Atualizar o hash quando o executável mudar e conferir novamente as regiões de código afetadas.
2. Registrar VA, RVA, tipos, offsets, unidades e direção ao documentar um pacote.
3. Preservar `GameProtocol`, `EncDec`, suas chaves, opcodes e layouts até haver validação para a mudança.
4. Associar uma funcionalidade ao produtor, ao consumidor e ao caminho efetivamente implementado.
5. Atualizar a seção de verificação quando uma pendência receber prova de funcionamento no jogo.

Relacionado: [[Aika OG - MOC]], [[Aika OG - PacketDispatcher e Protocolo]], [[Aika OG - Auditoria Atributos Client 2026-10-22]].
