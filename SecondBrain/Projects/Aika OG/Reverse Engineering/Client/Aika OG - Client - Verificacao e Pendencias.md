---
title: Aika OG - Client - Verificacao e Pendencias
tags:
  - project/aika-og
  - client
  - verification
updated: 2026-10-22
---

# Aika OG - Client - Verificacao e Pendencias

Critérios, evidências e pendências da [[Aika OG - Client - Documentacao Oficial]]. Esta nota sustenta os contratos publicados para o executável instalado. As fontes de pesquisa são consultadas por assunto; a documentação principal descreve o estado atual.

## Critério de publicacao

Um campo é documentado com offset/tipo quando há leitura, escrita ou layout comprovado. Um sistema implementado é ligado ao caminho correspondente na source. A confirmação no jogo é uma etapa específica de homologação.

Aliases de análise não são apresentados como símbolos originais. Lacunas de semântica e de gameplay permanecem identificadas como pendências.

## Verificacao tecnica

Conferência realizada em **22/10/2026**:

| Verificação | Resultado e alcance |
|---|---|
| Identidade do executável instalado | SHA-256 `e1104cbb8d313ec9b07e18c5529ac6865d1eda92e429355185617a4f805ff002`; 3.667.888 bytes |
| PE | x86/PE32, base preferencial `0x00400000` |
| Código das regiões publicadas | 53 intervalos em entradas de rotinas, comparados byte a byte; todos coincidem com a referência de código analisada |
| Tabela TCP | 512 bytes em `0x0070EFE0` coincidentes com a referência |
| Manifesto de atributos | 34 entradas associadas ao mesmo hash do executável instalado; nomes documentais e Evidence IDs preservados |
| Arquivos de dados | 23 arquivos conferidos por existência, tamanho e SHA-256 |
| RandItem | Os 720.000 bytes do arquivo instalado estão zerados |
| Testes .NET focados | **115 aprovados**, exit 0 |
| Estrutura das notas | Seis arquivos, 46 wikilinks resolvidos e links de seções/fontes conferidos |
| Compilação durante os testes | 34 warnings reportados pelo build |
| Alterações desta documentação | Somente notas do Second Brain e vínculo no MOC; código e binários preservados |

A referência de código usada na comparação tem SHA-256 `7eca8e1e6573dc439cc803ef6cafe91aaca53e6c60d4b3bfd82ab267a7ad81aa`. Ela existe em `C:/Projetcts/aika-og/artifacts/opcode-alignment-20261018/client/AikaClient.original.exe`. O projeto Ghidra disponível contém essa imagem de referência. A correspondência das 53 regiões vincula seus exports ao cliente instalado; não autoriza transportar automaticamente qualquer outra região ou um fluxo de login modificado.

Os comprimentos comparados são os valores de tamanho do inventário, aplicados como intervalos contínuos a partir da entrada. A comparação não afirma cobertura de todos os blocos de funções com corpo não contíguo. A decompilação específica de atributos usa seu manifesto com intervalos próprios.

### Testes executados

Projeto: `GameServer.xUnitTest/GameServer.xUnitTest.csproj`.

Classes selecionadas:

- `ClientBinaryRegressionTests`
- `LoginAuthenticationTests`
- `OutboundSeedTests`
- `NativeBuffRefreshRegressionTests`
- `BuffWorldEntryRegressionTests`
- `NpcQuestMapTests`
- `NpcMarkerPriorityTests`
- `NpcRefinementProtocolTests`
- `NativeTitleAndEffectsTests`
- `PranContractTests`
- `SkillDamageContractsTests`
- `SkillVisualPacketTests`
- `NpcReductionTests`
- `GuildCreationTests`

Saída de build isolada em `C:/Projetcts/aika-og/artifacts/client-official-docs-validation/bin/`. A seleção verifica contratos e comportamento de implementação; não representa execução de todos os sistemas no cliente conectado.

### Identidade dos dados instalados

A capacidade e os layouts estão em [[Aika OG - Client - Formatos e Recursos]].

| Arquivo | Bytes | SHA-256 |
|---|---:|---|
| `ItemList4.bin` | 14384016 | `82ea2edb2a5cebccfdde60d8c9ff93c640d5f2ea4ff4db91eb65df202f53692b` |
| `SkillData4.bin` | 8640016 | `821c8a836c6545a433c35f126bfed28f0ddfe3b237ff7965733dea417ec0badc` |
| `UI/PI.bin` | 2256004 | `45d58a18ef846e687808351b406489d11452d43ffe58775294b60be7052cf2d9` |
| `UI/quest.bin` | 19324928 | `ba988371db83ba3b41f6faec2f3dd42d5de439d3fa395c8fc8e954f4476dcc71` |
| `UI/Dialog.bin` | 60257520 | `e9fe6e7f84ba8ff209575cc6b9724b9fc0f68f599336ddb364ac6d965a7dd2ac` |
| `UI/MakeItems.bin` | 1352000 | `c0e50e896e7dfd28289c8d032c115d64f8fb5647809ce34434bd789bd0da68a5` |
| `UI/Recipe.bin` | 276000 | `6b61cb5658b50ed642f18fbf54c1f3975a743604a037ef90df2a0ffa555b9603` |
| `UI/Reinforce2.bin` | 368640 | `0702d9c6f3e0cafe604326dc784579358252f0713416cf48c8afa19ae5babe8a` |
| `UI/SetItem.bin` | 221188 | `79382342071f9dd337b210719fd774c8e54ed606a6ae8c0316c4d353feb8a65a` |
| `UI/RandItem.bin` | 720000 | `943696a366338cdf1765680dd633ef600abb4a015c7c6bd3d41cd7d585bc98c8` |
| `UI/PackItem.bin` | 450000 | `3c9e25d04fd1ee30220485897ece4ca143e3c09ca00cf88109e7433e296b40f4` |
| `UI/MN.bin` | 524288 | `e8bab65888fcee3d4906087c3836fadb46f718749e19c43c786d48401247f18d` |
| `UI/MM.bin` | 532480 | `44181ce67e319a6d6cbcba1aff62777920d8c93f6a1428f931838d536b0220fe` |
| `UI/NH.bin` | 630080 | `7f8e52f78384291151b1938d5ffce0d3eb9a42faebbe6b51d14915d766d976f8` |
| `UI/MobPos.bin` | 1703936 | `14a65239a238c54891232049325067db99e898478e26f2ab54fe5716192bed92` |
| `UI/SPosition.bin` | 20800 | `de93aa0d3a6236f8739980a800fdc863275a2098d88840a49054819dfbfd6389` |
| `UI/npcpos.bin` | 24580 | `405c52d3391a2bd3af101e8b8330eb8626b21d03620f4b64688ac5f96deeb6fb` |
| `UI/Title.bin` | 155648 | `2f3283c37b985a9ca9c42571b3b5af71eeb51fac390ef651a9bb218dc3f14789` |
| `UI/Easing.bin` | 12600 | `a29b2311603c623ca2ae1feb84df65badeca3495658e29bddccd9305fe7f1e33` |
| `UI/ReinforceA01.bin` | 5040 | `5000bdf47e62e80ca1eb3516b1aa3831e8d438903a9836524273e11aa6bef0c7` |
| `UI/ReinforceW01.bin` | 5040 | `dc0d9db8b329d93234871e7280618ecc9c4d6ab282a953fc188bb97b2eb05375` |
| `SL.bin` | 16128 | `1bc1c50319d98126fb5d3a1255b9fdd4dabd2e70a8af1a2f130f4534be46019b` |
| `Nation.bin` | 8 | `48e3df3d4fe7b9c7a0ca7ff6e3ed9483ad6aac25de46a9246a7879b134c318f6` |

`UI/strdef4.bin`: 396.288 bytes, SHA-256 `396dfedcf270eec14a5a1866cd035b033489db376cdc83f0e77c596a6d95bcb1`. Slots 3 e 4 conferidos como `Login ou Senha Incorreto`; slot 27 como `Senha Incorreta`.

### Fingerprints das regioes de codigo

O início, o RVA e o comprimento estão em [[Aika OG - Client - Assembly e Funcoes]]. O hash abaixo é o SHA-256 dos bytes do intervalo correspondente no executável instalado.

| VA de início | SHA-256 da região |
|---|---|
| `0x00464c30` | `006f22540174a1fa1775638d14842d8df26aaef8a83a2fca2a3c8b8ae404a993` |
| `0x00464ee0` | `d5146f4f57297b404f6fd6a0e23ae20b77202611d8cd734d3457e7c2f3233a5a` |
| `0x0040a340` | `c9d5d8187c3007c2bbc3719416bb8b7805ac3ca64333bbd57edd03ae6b22f51d` |
| `0x004bfc40` | `4e855ce06cc2a67dbcf88c9db35db9febcca88757fb7e41a9e82347ea054e4c6` |
| `0x005a90b0` | `7cd13776572b42b26aa550aa2e4cd61a2ba974df05975102709b3ad9ae1c09e2` |
| `0x005c0d00` | `0b1bbe4198ea83aa283a29e2155e0dd4b94bcca9a4ad57ec267653c3a1c2380a` |
| `0x0049e650` | `61e7a6669a21961b00d74f1f1498ae7a41a457d21c70b7fba76027a49039745c` |
| `0x0049fa40` | `eaa4a5f457386ad26108d4a9f06413ffe782591a00cd4ec4b7939a6d8903bc92` |
| `0x0049fd10` | `3d16eeac89d91459225111af4ab9551bb86ef9f2c8de08eb2cf95757f5d1797e` |
| `0x004a7a60` | `ad68ddad4daed272f64778ed8f7be26de006b56ecfc9ecfcf8305d3ec99b2fe3` |
| `0x004a9ee0` | `4c8cb675df4caf649c619ea9743215410e70d33eb9664c62bde8b748443edd0c` |
| `0x004a9fd0` | `af29be967cf56ea1b316b01d84fde2a04401feca038ec0d725c9ac976dcb3549` |
| `0x004aa080` | `5895145f5d037688c67d20c6e52f47a84f3b31c0095b876b9032cea4cabaf4fe` |
| `0x004aa150` | `598d01f74f64f32613bac6462bbe7201beffabd3886e4be3b5e2facec9f0758e` |
| `0x00499f90` | `913d714547176097d8731400abc587eb1470a3642fa8b666b9b9c6183a217c75` |
| `0x004b6b10` | `3b394910fbf547fcea17d3d2dfdfa478154726f26a9eef02dbe9571931ce7394` |
| `0x004b6ad0` | `0b9f0db26bd41a39e11898691731f756e3c154479361d0897c86e910529549a7` |
| `0x00580760` | `b69b07a274c0cc2284ac6e0bad152593a813927f055e25e1f1a6ad695d2ca342` |
| `0x00589710` | `06bc2395040d999045c445f26799909b1a8db411a5947a704ee391e83255acac` |
| `0x004a5230` | `d2480794c9ababc237d7ae873cda68b030777bb99c72042de9d99ae3f6c21aa6` |
| `0x0051e330` | `eaa021fb5193f325729e686f300697e21506591ca928386f23a52d60d2ba045a` |
| `0x0049b290` | `778310c66485fed6834d6911e07a30aba649946e81621e903b901409b0fadb8d` |
| `0x00425270` | `8ff0fe361c59017f8bfd29ae0bdd6253518c6cab6e9d6c33c3b0de696b5fcc8d` |
| `0x004252f0` | `113b25bb8dafebb2cf51f5c7091ded5b29af9c54248d9ecd008f2268e84ff560` |
| `0x004437a0` | `e0d8a57790f21bb4a3fbcf2692e5ef16758465f74196b9f861b0032da9e0d9d0` |
| `0x00443ef0` | `c2dcbfaa9b2b18f357beec5eebfaa0fcb15821abe56d0608e70a0b48b9de8ba7` |
| `0x004434d0` | `a9778b6f10ce152e67443fd5bc016e4fae7847a6905d5913128e194b81f12a3b` |
| `0x00444740` | `8630b62096a202c065bd8383956a66537dbc8c8fc8ccf8af22363e72e3032919` |
| `0x00444670` | `9c523cfb89073f2c6236651fabb340b3e6d6485b63d50794bf99a7e3d26f708b` |
| `0x005357f0` | `da0f4e2603d0ad16c4ea843e7dad3ecbb12c3f82d72d8849b17eb6f24129cc94` |
| `0x00444810` | `efa60bb6fa177cdf6c5a39955d23d9be2a76701f4a869df041533234b51b6f4f` |
| `0x004448a0` | `3a1562a5535761ad37366b8c26ba2e93a766875d3450c06389d7f1ec4a2f22ed` |
| `0x00444b70` | `03fa67e6b45332d06f76aee82e0469517e6174c55a37ba00d060e411ffdc43af` |
| `0x00443ad0` | `1a5930e49201b15434e37d648323a30f00e514a0029e3e3b9f730876f3606658` |
| `0x0044b730` | `3fda6c2df7fac65ca2d24e11ff9d8ccf40ba8a04208c20ed18e35f583f87f6fa` |
| `0x0044b780` | `f25763c51a4725048196ac09b3f57749a1631b5aaaf99d788007d05b87d34665` |
| `0x00415a70` | `af27d6f1392daa84cd120885081d97f70ac20780b6a9b2415b951940e937d03a` |
| `0x0044aaa0` | `b446d5ef6eecf36435f5ea4bec3e7afbcdb5c7074c993245c69e8c7ab5e9aeb7` |
| `0x0044a270` | `821657bca6d2c0971e1a1f0d65de256e19555fd957fd39c0cce8aa793c460834` |
| `0x004433e0` | `a3e6f08d1896d8e0b6c0f007ad81537f70824cf97ed26ac1252d2f37d4859d83` |
| `0x0042e8a0` | `aac2db63deca5e2863a50cc570f7c539efef7d3c299451cde50f6df3da718fe9` |
| `0x00443da0` | `2b2a5357cd5c64fb7fc292c90b52fcf13804cf4e32dbcb96e0282338bc5fc078` |
| `0x004f4530` | `0c452a931f8ad9d30062809ac5a91da45745aa5ef47983922dcdd78aa026637d` |
| `0x004f4690` | `0a727edd843012f3e8d1ef3406a1260600dddd891cf7b0b5c5646c80a739768b` |
| `0x004f5460` | `5ee92d4c4be14900a7373107901a6e23dec85cd0b11fb056b85d1d3b1ced1773` |
| `0x004f5510` | `f53c40b281a94c7a6c539066e762e830bf6bf465d9a184bc619f3451a3570baf` |
| `0x004e5f20` | `f155ccb4f7cfb9bac9abe3d1b8ba9d99c10320cfb2a8e672fcf26ed0e3ab62ee` |
| `0x00522170` | `06ecd1e02932bcdaa049cdbb8b6a48814477738c85014d48b70e359d31434b5f` |
| `0x004a30f0` | `48d6f02cd26e8722aac4f8d24e6fbe074f3cf3e3b53c0b3c8bf5161f443fb7e9` |
| `0x004b0d40` | `3b0ee7d91fbb9e19c4b9fc2bbb8b4db0a3694d420ef5c0787db2385a71bf712a` |
| `0x00569fb0` | `39b90b63b0c1591d2b4187d1e297a2195b08f9179590ac9a523099d91e52a1a1` |
| `0x00444c90` | `d89195589a0d598f94500187e4ebf50a1ebc623578ea5bac9e5fb6e308789af8` |
| `0x0056feb0` | `4d1739b8ad334bd0e518e6e04899954013f37a169d90e8dd2c4d675ee13b4b59` |

### Fontes de implementacao conferidas

| Arquivo relativo ao repositório | SHA-256 |
|---|---|
| `GameServer/Presentation/Packets/PacketDispatcher.cs` | `d70e17254065f47e5cd3e54a33080973488f4d1c8afc89e98f69aeb3c0dd9f0c` |
| `GameServer/Network/EncDec.cs` | `55265f72d8797663ebe8ebd877c0886974e98d096c590402dc616779b7e43a79` |
| `GameServer/Application/Services/Characters/CharacterWorldService.cs` | `43c6952bcdad3f24d433e3577a07d44b05de4d2d9b284d4a7dff7267dfc52d6e` |
| `GameServer/Application/Services/Characters/CharacterPacketFactory.cs` | `2fca926a5686a99890cf30a3bc375f9fdf484a5138d332a363b67650ef0fe102` |
| `GameServer/Application/Services/Items/ItemTemplateParser.cs` | `c60e75dddbe777fcd4e60ee36003b9e194155593b6fcc6d07b12bf8dde3aa585` |
| `GameServer/Application/Services/Skills/BuffPacketFactory.cs` | `418ab7e1d46d49c87252a7b477c879c7c4704ef17b7a9a7eec6ad76b684df1f6` |
| `GameServer/Application/Services/Items/ItemReductionService.cs` | `b9cc70ab46f5e90bc08df5f15765c85576dc6ed5d8087158e3ad9ea30f4b726a` |
| `AikaStudio/PremiumStore.cs` | `dfe9b87168b789fa4095cb8cc9c6c0f44ce55b205598909984e198d302a667e3` |

## Pendencias funcionais

| Área | Estado atual / trabalho necessário |
|---|---|
| Homologação integrada | Executar login positivo real, verificar a UI e testar os fluxos no cliente conectado com API/MySQL compatíveis |
| Renderização de sistemas | Conferir animações, painel de buffs, cast, saldo J, menus, operações de inventário, Pran e exclusão com prazo nas ações correspondentes |
| Cerco `0x0121` | Consumidor `0x004B4130`, avisos `0x004E1670` e UI `0x004E18E0` identificados; completar produtor, campos e operação no servidor |
| Buff triplo `0x0170` | Cliente exige 32 bytes: três IDs WORD em `+12/+14/+16` e três deadlines DWORD em `+20/+24/+28`; integração de produção no servidor pendente |
| Pedido `0x0306` | Rota atual `IgnoreOpcode0306` não executa ação de gameplay; determinar finalidade antes de implementar |
| Pedido `0x039D` | Ignorado explicitamente; falta estabelecer a semântica do payload e seus chamadores |
| Opcode `0xCCCC` | Há construtor de 16 bytes com DWORD 1 em `+12`; consumidor/efeito obrigatório não estabelecidos |
| Remoção `0x0101` | Verificar compatibilidade completa das variantes de 14/16/20 bytes com cada produtor e consumidor; conservar limites por layout |
| Detalhes de combate `0x03BD` | Completar a interpretação dos bytes ainda sem mapeamento na resposta de 68 bytes |
| Relíquias: aprimoramento | Rotas `0x064E/0x064F/0x0650` apontam para `UnavailableUpgrade`; faltam contrato econômico e operação habilitada |
| BattleZone | Rotinas e mensagens do cliente identificadas; falta integração completa do sistema no servidor |
| Premium Store no Studio | Escrita depende do guard de build em `PremiumStore.cs` e de homologação para o hash instalado; preservar a barreira |
| Atributos A..F | Associar seletores, consumidores e textos às estatísticas de gameplay antes de publicar nomes definitivos |
| ABI e estruturas de referência | Completar retornos, aliases globais, signedness fora do domínio nominal e tamanho integral dos objetos |
| Equivalência de sets | Comparar o primeiro efeito correspondente por set no cliente com a acumulação dos efeitos elegíveis no servidor, usando as mesmas tabelas e seletores |
| Fórmula completa de dano | Relacionar cálculo do servidor, campos transmitidos, consumidores e apresentação; a referência de atributos não prova todo o caminho skill → morte |
| Segurança do login | Homologar políticas de expiração/revogação/reutilização do ticket, limites e transporte com o comportamento do cliente |
| Cobertura do assembly | Prosseguir por subsistema, com produtores, consumidores, offsets e evidência de execução; o inventário de entradas não equivale à recuperação semântica integral |

### Campos de cerco identificados

O consumidor de `0x0121` copia 28 bytes incluindo o header. Esse consumo não define, sozinho, o tamanho fixo de wire.

| Offset | Uso observado |
|---|---|
| 12..14 | Nibbles de estado/filiação de três entradas de torre; nibble alto alimenta barra ×10 |
| 15..19 | Cinco estados/filiações associados à UI de objetos/selos |
| 20 | 0 Inativo, 1 Ativo, 2 Selar |
| 21 | Countdown em segundos, convertido para milissegundos |
| 22 | Máscara de sete marcadores |
| 23..27 | Nibbles de estados dos pares de portões |

Atribuição de cada objeto, producer e comportamento completo permanecem pendentes. O domínio é sustentado pelos textos de torres/portões/selagem e pelos consumidores de UI.

## Pendencias de formatos e recursos

| Área | Pendência |
|---|---|
| MakeItems | O arquivo tem 26.000 registros de 52 bytes; o loader solicita 31.000. Faltam 5.000 registros/260.000 bytes em relação à leitura solicitada |
| RecipeRate | Completar parser e semântica dos registros |
| Quest e Dialog | Completar todos os tipos de condição, objetivos, consumos, recompensas e gramática de campos |
| Cores de missão | Completar o mapeamento do catálogo para todas as categorias sem inferir a cor apenas pelo nome |
| Variantes JIT | Confirmar JT41 no loader; completar JT30 e o envelope excepcional JT3 com NUL |
| AN2/MSH/MS3/BON | Completar vértices, índices, pesos, keyframes, ossos e hierarquia |
| AKM/HGT/ATT | Completar estrutura de objetos/texturas, escala/eixos de mundo, flags de colisão e regras de navegação |
| MobPos | Relacionar posições à região, escala e ciclo de mundo antes de publicar spawn/respawn/patrulha |
| SL | Completar o significado dos DWORDs `+64/+68` e validar o consumidor de host/IPv4 na conexão |
| ServerTableCheckSum | Loader `0x004C19F0` identificado; completar entradas de 24 bytes e a negociação correspondente |
| Pran `0x096B` | Byte `+12` sem semântica confirmada; os campos de personalidade/comida/devoção estão identificados |
| Refino/redução | Validar preços, resultado visual e política econômica da implementação com os arquivos e a UI efetivamente instalados |

## Evidencias locais

- Manifesto de entradas e referências nativas: `C:/Projetcts/aika-og/artifacts/opcode-alignment-20261018/client/functions.json`.
- Exports C/ASM: `artifacts/opcode-alignment-20261018/native/`, `native-ui/` e `artifacts/rea-20261017/named/`.
- Atributos: `D:/aika/aika-cliente-reverse-engineer/audit-2026-10-22/function-manifest.json`, `rea-evidence.json` e `rea-verification.json`.
- Os Evidence IDs do manifesto de atributos identificam cada entrada e corpo recuperado. O snapshot REA armazena evidência estática; a persistência de um projeto Ghidra é tratada separadamente.
- Contratos de serviços NPC e comparação de regiões: `artifacts/lore-world-implementation/20261020/protocol/`.
- A execução de código x86 com APIs/widgets substituídos serve para verificar blocos específicos. A homologação visual usa o jogo real.

## Fontes tecnicas consultadas

Os documentos abaixo sustentam a pesquisa. Os contratos desta documentação foram consolidados com os offsets corrigidos e conferência da instalação atual; as fontes não são usadas como catálogo automático de funcionalidade.

- [CLIENT-RESEARCH.md](<C:/Projetcts/aika-og/docs/reverse-engineering/CLIENT-RESEARCH.md>)
- [CLIENT-RESEARCH-PROGRESS.md](<C:/Projetcts/aika-og/docs/reverse-engineering/CLIENT-RESEARCH-PROGRESS.md>)
- [LOGIN-FLOW-FIX-2026-10-17.md](<C:/Projetcts/aika-og/docs/reverse-engineering/LOGIN-FLOW-FIX-2026-10-17.md>)
- [LOGIN-HIGH-LEVEL-2026-10-17.md](<C:/Projetcts/aika-og/docs/reverse-engineering/LOGIN-HIGH-LEVEL-2026-10-17.md>)
- [REA-PROTOCOL-HIGH-LEVEL-2026-10-17.md](<C:/Projetcts/aika-og/docs/reverse-engineering/REA-PROTOCOL-HIGH-LEVEL-2026-10-17.md>)
- [OPCODE-SEMANTICS-2026-10-18.md](<C:/Projetcts/aika-og/docs/reverse-engineering/OPCODE-SEMANTICS-2026-10-18.md>)
- [DUAL-SKILLS-CAST-2026-10-12.md](<C:/Projetcts/aika-og/docs/reverse-engineering/DUAL-SKILLS-CAST-2026-10-12.md>)
- [NPC-SELL-WEAPON-GUARD-2026-10-09.md](<C:/Projetcts/aika-og/docs/reverse-engineering/NPC-SELL-WEAPON-GUARD-2026-10-09.md>)
- [SPAWN-TITLE-COMMANDS-2026-10-10.md](<C:/Projetcts/aika-og/docs/reverse-engineering/SPAWN-TITLE-COMMANDS-2026-10-10.md>)
- [NPC-QUEST-MAP-2026-10-17.md](<C:/Projetcts/aika-og/docs/reverse-engineering/NPC-QUEST-MAP-2026-10-17.md>)
- [NPC-MARKERS-2026-10-17.md](<C:/Projetcts/aika-og/docs/reverse-engineering/NPC-MARKERS-2026-10-17.md>)
- [QUEST-NPC-INDEX-MAPPING-2026-10-16.md](<C:/Projetcts/aika-og/docs/reverse-engineering/QUEST-NPC-INDEX-MAPPING-2026-10-16.md>)
- [PREMIUM-SHOP-INVENTORY-2026-10-10.md](<C:/Projetcts/aika-og/docs/reverse-engineering/PREMIUM-SHOP-INVENTORY-2026-10-10.md>)
- [CASH-LABEL-2026-10-14.md](<C:/Projetcts/aika-og/docs/reverse-engineering/CASH-LABEL-2026-10-14.md>)
- [TOCA-DAILY-MARKERS-2026-10-17.md](<C:/Projetcts/aika-og/docs/reverse-engineering/TOCA-DAILY-MARKERS-2026-10-17.md>)
- [CLIENT-SHOP-CRASH-2026-10-10.md](<C:/Projetcts/aika-og/docs/reverse-engineering/CLIENT-SHOP-CRASH-2026-10-10.md>)
- [SERVER-CLIENT-AUDIT.md](<C:/Projetcts/aika-og/docs/reverse-engineering/SERVER-CLIENT-AUDIT.md>)
- [CLIENT-SERVER-ATTRIBUTE-VALIDATION-2026-10-22.md](<C:/Projetcts/aika-og/docs/reverse-engineering/CLIENT-SERVER-ATTRIBUTE-VALIDATION-2026-10-22.md>)
- [ATTRIBUTE-LAB.md](<C:/Projetcts/aika-og/docs/reverse-engineering/ATTRIBUTE-LAB.md>)
- [BUFF-REMOVAL-OPCODES-2026-10-10.md](<C:/Projetcts/aika-og/docs/reverse-engineering/BUFF-REMOVAL-OPCODES-2026-10-10.md>)
- [WORLD-REGIONS-2026-10-17.md](<C:/Projetcts/aika-og/docs/reverse-engineering/WORLD-REGIONS-2026-10-17.md>)
- [CHARACTER-DELETION-PRAN-2026-10-18.md](<C:/Projetcts/aika-og/docs/operations/CHARACTER-DELETION-PRAN-2026-10-18.md>)
- [PORTAL-SCROLLS-2026-10-17.md](<C:/Projetcts/aika-og/docs/operations/PORTAL-SCROLLS-2026-10-17.md>)
- [QUEST-PROGRESSION-PRAN-2026-10-17.md](<C:/Projetcts/aika-og/docs/operations/QUEST-PROGRESSION-PRAN-2026-10-17.md>)
- [NATIVE-SYSTEMS-2026-10-14.md](<C:/Projetcts/aika-og/docs/operations/NATIVE-SYSTEMS-2026-10-14.md>)
- [DUAL-BUFFS-AI-2026-10-14.md](<C:/Projetcts/aika-og/docs/operations/DUAL-BUFFS-AI-2026-10-14.md>)
- [FINDINGS.md](<C:/Projetcts/aika-og/artifacts/dual-cast-client/FINDINGS.md>)
- [NPC-NATIVE-CONTRACTS-2026-10-20.md](<C:/Projetcts/aika-og/artifacts/lore-world-implementation/20261020/protocol/NPC-NATIVE-CONTRACTS-2026-10-20.md>)
- [NATIVE-LAYOUT-BASELINE.md](<C:/Projetcts/aika-og/artifacts/portal-scroll-20261017/NATIVE-LAYOUT-BASELINE.md>)

- [Referência de atributos](<D:/aika/aika-cliente-reverse-engineer/sistema_combate_profundo-1.md>).
- [Verificação da referência de atributos](<D:/aika/aika-cliente-reverse-engineer/audit-2026-10-22/verification.md>).
- [[Aika OG - Auditoria Atributos Client 2026-10-22]]
- [[Aika OG - REA e Protocolo Nativo 2026-10-17]]
- [[Aika OG - Opcodes e Simbolos 2026-10-18]]
- [[Aika OG - Patch e Contrato Login 2026-10-17]]
- [[Aika OG - NPC Titulos e Menus 2026-10-10]]
- [[Aika OG - Sistemas Nativos 2026-10-14]]
- [[Aika OG - Buffs Dual IA 2026-10-14]]

## Atualizacao da referencia

Ao alterar cliente, tabela ou implementação, conferir o hash e repetir as verificações dos contratos afetados. Atualizar primeiro a nota técnica correspondente e depois seu estado em [[Aika OG - Client - Documentacao Oficial]]. Somente registrar homologação no jogo quando a ação, o build e o resultado observado estiverem identificados.

