# Aika OG - Recuperacao Nominal Textos e Studio Desktop 2026-11-01

Projeto: `C:\Projetcts\aika-og`. Complementa [[Aika OG - Missoes Premium Pocoes e Studio 2026-10-31]] e [[Aika OG - Studio Rascunhos e Categorias 2026-10-23]]. O usuário esclareceu que o número verde deve mostrar o máximo nominal da poção, mana deve ser azul e poções mistas devem exibir ambos. Também pediu Studio exclusivamente desktop e recuperação dos textos usando somente os dois clientes oficiais disponíveis.

## Apresentação nominal no cliente

Servidor mantém opcode0x103,32bytes, layout, chaves, criptografia e totais reais. O DWORD de apresentação+28 recebe marca/tipo/quantidade; patch específico do cliente usa os caminhos verdes/azuis existentes e preserva comportamento legado quando a marca está ausente. Não simula HP anterior nem aumenta HP/MP além dos máximos. Poções mistas mostram ambos mesmo com recuperação efetiva menor ou HP/MP cheios.

Aplicado em `D:\aika\Aika OG\AikaClient.exe`: hash e1104cbb8d313ec9b07e18c5529ac6865d1eda92e429355185617a4f805ff002→74a63ac6533047dd3aa4341a8e86a6a6170d180fbbc97240b4f7056ab1df6a4b. Backup integral `AikaClient.exe.20261031-213226-390384.potion.bak` e manifesto ao lado. Ferramenta `tools/patch_client_potion_feedback.py` valida hash/bytes/processo fechado e permite restauração. Adiciona194bytes em seçãoRX.potfx e dois desvios calibrados; autenticação anterior, dados/overlay e demais bytes originais preservados, salvo intervalos PE declarados.

8testes nativos emulados,53.NET e2de idioma passaram. Emulação cobre valores/cores, cap, morte, ASLR, login/rollback, pilha e registradores. Não equivale a renderização no jogo. Cliente sem patch continua mostrando deltas; servidor e cliente corrigidos precisam ser usados juntos. Evidência REA antiga refere-se ao basee1104, preservado no backup; usar manifesto/RVA da nova seção ao estudar o build74a63.

PremiumStore: quatro rotinas byteidênticas entre os três builds sustentam inclusão estrita do novo hash. Seed e recurso MySQL studio-premium-tabs atualizados seletivamente, revisão2→3, SupportedClients2→3 e um registro de auditoria.6testes com SQL passaram, incluindo rejeição de executável desconhecido sem alterar PI. Restrição global de BinaryDocument preservada.

## Ícones e desktop

JT20=TGA após4bytes: pixels22+ImageIDLength, orientação pelos bits4/5. O atlas10 usa origem inferior e8bytes finais; o decoder anterior tratava a orientação e o offset incorretamente. Corrigido em JitImage, compartilhado por Studio/PacketTool. Os ícones24952/24953/25084 ficaram completos e iguais pixel a pixel ao decoder TGA independente; atlas idêntico nos três clientes.12testes passaram. O mapaJT20 map64 também passa a respeitar sua orientação; arquivos/calibrações não foram modificados.

Alinhamento: estilo compartilhado `.recordButton span` vazava margem/padding/fundo para ícone e resumo. Linha de item agora tem duas colunas com os filhos diretos sem esse estilo. Verificados centros alinhados e coluna de texto constante.

Removidos seletor de navegação móvel e breakpoints até1200px de todos os editores. Largura mínima1280px; mantidos ajustes desktop1400/1700/1800 e movimento reduzido. QA somente desktop1280/1366/1920; as verificações antigas390px são históricas, não requisito atual. Navegador usou rascunhos mockados sem gravar fixture no banco.

## Recuperação textual seletiva

Clientes oficiais: C:\GoLevel\AikaOnline e D:\CBMgames\AikaOnlineBrasil. Os dois também possuem perdas literais0x3F; trocar encoding não recupera esses caracteres. Plano final recuperou3.053nomes e1.759descrições. Fontes incluem textos equivalentes com identidade comprovada, nomes originais legíveis, efeitos binários, conteúdo de pacotes e atributos de equipamentos. A recuperação inicial incluiu nomes espanhóis/ingleses;600nomes espanhóis foram posteriormente traduzidos conforme [[Aika OG - Nomes de Itens em Portugues 2026-11-01]]. Descrições editoriais pt-BR são identificadas por origem, sem apresentá-las como transcrição oficial.

4211:XP30%,HP5%,ataques20%,3dias;4212:XP10%,HP5%,ataques10%,3dias;4217:XP50%,HP10%,ataques10%,30dias. Descrições antigas divergentes/truncadas não foram copiadas como autoridade. Hashes de SkillData físico/cliente/snapshot e PackItem físico/snapshot coincidem. Nenhuma estatística foi alterada.

Aplicado aos arquivos cliente/servidor, dois snapshots MySQL e3.053nomes de item_templates.31000registros preservam bytes64:128 e256:464; cliente decodificado==Data. Dois snapshots terminaram na revisão4. Backup/plano correto é `artifacts/item-text-recovery-20261031-applied`; a pasta anterior -final foi revertida com CAS para corrigir agrupamento de IDs em sete descrições de pacote.

Data SHA256 D4E125ECB2F211F6BB8F46C24B24963E1121173768700D21DBAE3BFEA0473742; cliente400F09477F388D0FF9A14245DA982FF52A3A7C9100B434AA0DB629296A41C60D. Os planos guardam bytes anteriores/propostos, hashes, nomes e origem por campo. Merge preserva textos legíveis e dados personalizados; SQL usa transação/auditoria e CAS de hash/revisão/nome/tipo/efeito/nível/classe.7testes.NET e6Python passaram, incluindo drift/rollback e quantidades de pacotes.

Restam1.382descrições sem fonte confiável e o nome interno TEST10000, listados em remaining.csv/json. O usuário confirmou que não possui outras referências. Não apagar esses campos nem inventar efeitos de caixas aleatórias/flags desconhecidas.

## Verificação e operação

Studio completo com SQL habilitado:182aprovados,1condicional,0falhas. Build normal da solução0erros/34avisos existentes; frontend build/lint aprovados. Três exemplos conferidos na interface final. GameServer/TokenServer/cliente do usuário não foram iniciados/reiniciados; QA isolada encerrada. Binários normais compilados para a próxima inicialização habitual.

Documento canônico: `docs/operations/CLIENT-RECOVERY-STUDIO-DESKTOP-2026-10-31.md`. Evidências adicionais em `docs/operations/POTION-FEEDBACK-2026-10-31.md`, `docs/reverse-engineering/PREMIUM-CLIENT-COMPATIBILITY-2026-10-31.md`, `artifacts/icon-crop-20261031`, `artifacts/potion-feedback-20261031` e `output/playwright/desktop-*.png`.
