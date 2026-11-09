# Aika OG - Descricoes Conjuntos e Avisos 2026-11-01

Continuação de [[Aika OG - Nomes de Itens em Portugues 2026-11-01]] e [[Aika OG - Recuperacao Nominal Textos e Studio Desktop 2026-11-01]]. O usuário apontou a descrição ilegível do Scroll of Solo Practice, cabeçalho estranho em conjuntos/acessórios e pediu aviso de criação no chat de sistema.

## Descrições

O pergaminho é15519/15520, tipo716, habilidade9055, efeito387=4, validade168h. Pares brasileiros24591/24593/24595/24597 comprovam o multiplicador4x de XP ao derrotar monstros. Reparado para XP de monstros4x, faixas1–60/61–70 e7dias. O modelo anterior desconhecia esse efeito, por isso preservava as interrogações literais.

583descrições aplicadas:571traduções revistas e12reconstruções nativas.31.000registros preservam bytes fora128:256;600nomes portugueses anteriores verificados no SQL, sem atualizar item_templates.name. Cliente/Data idênticos após decodificação, checksum válido; dois snapshots MySQL na revisão6, duas auditorias. Backup em artifacts/item-descriptions-pt-20261101-v2.11testes.NET e15Python passaram.

Data SHA256161ADD36D142D3ABA58AC3E1739C61DB406B3DAF86FDCF097C06614758696159;clienteE6D948961837DB1F81EFFDF9A49A75F7FB92CB65BA80C9781A8A624C9A5FEC4D. Planos anteriores dos nomes/recuperação não podem ser forçados sobre a revisão atual. Permanecem1.370descrições sem fonte/modelo fiel e o nome interno TEST10000; lista em remaining.json.

Caveat: CharacterExperienceService fixa qualquer387positivo em4x, enquanto SkillData possui2/4/8. Não houve mudança de gameplay; novas reconstruções de387 só aceitam4. Habilidade9087 tem regra4x/3x/2x por faixa, não representável por um único278=2, e continua excluída do modelo simples. Multiplicadores não são percentuais; duração7200s da habilidade não substitui a validade de7dias do benefício automático.

## Conjuntos e acessórios

O cliente monta o cabeçalho a partir de UI/SetItem.bin, não do servidor nem do ItemList. Nome Big5 como AF65ADB7B06CB1FEAACCAE4DB8CB era interpretado em CP1252. Comprovado no executável74a63..., ponteiro de nomes0x007EB200, chamada0x0067D5AF e formato%s(%d/%d). Corrigidos584nomes do cliente a partir do catálogo BR, incluindo31recuperados por irmãos com OriginalName idêntico. Esses31também corrigidos em Data/SetItem.bin e item_sets.name.

IDs303/338/358 agoraConjunto do Caçador da Tempestade. Inspeção integral dos1.024registros: cliente decifrado==Data, nenhum nome??, identidade/efeitos/membros preservados, checksum válido e footer inalterado. Não recodificar o arquivo inteiro: layout216bytes e offsets de nome0:64 devem ser preservados.

strdef4.bin slot860 mudou deConfigurar efeito paraEfeito de conjunto. Oficial BR repetia o erro; oficial espanhol strdef12.bin tinhaEfecto de conjunto. Consumidor0x0067D81D, endereço0x029B7C40, formato%s(%d) preservados. Somente esse slot128bytes foi alterado; Dias do slot81 continua preservado.

Snapshot data/setitem.bin revisão2/hashCE6A67D365A17A61D16B450D7D03B46863CCD5FE5BA95C9A4C553F3D27C0BB24, uma auditoria e31nomes relacionais. Chaves client/ui/setitem.bin e client/ui/strdef4.bin não existem no banco; não foram criadas. Backups integrais, SQLantes/depois e prova em artifacts/set-tooltip-20261101.4testes Python e verificação física/SQL passaram. Executável e fontes oficiais permanecem intactos.

## Criação de item

Comando existente `.i <id> [quantidade]` envia após persistência confirmada, somente ao dono no canal sistema0/0: `[Nome] Criado, Qtd. 1500 (ID: 6179)`. Quantidade é o total criado, não número de slots; nome usa o snapshot de templates da criação. Mantidos permissão GM/Admin e aviso nativo de aquisição. Falha SQL não anuncia sucesso.16testes de comandos passaram, incluindo pilha1500,3itens não empilháveis e falha de persistência. Template de mensagem usa o fracionamento seguro existente para nomes longos.

## Operação e verificação

Usuário fechou AikaClient/GameServer/TokenServer/Studio após trava inicial recusar atualização em uso; nenhum processo foi encerrado automaticamente. Publicação seletiva com CAS/transação/auditoria, sem importar catálogos globais. QA isolada do Studio confirmou texto15519 e console limpo, com rascunhos mockados. Build normal da solução sem erros; GameServer contém novo aviso. Recursos e binários serão carregados na próxima abertura habitual.

Ainda falta conferir renderização dos conjuntos/aviso dentro do jogo. Não declarar gameplay homologado por testes de pacote ou renderização do Studio.

Fonte canônica: docs/operations/ITEM-DESCRIPTIONS-SET-CHAT-2026-11-01.md. Detalhes: ITEM-DESCRIPTIONS-PT-BR-2026-11-01.md e SET-TOOLTIPS-PT-BR-2026-11-01.md na mesma pasta.
