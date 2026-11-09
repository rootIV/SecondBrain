# Aika OG - Missoes Premium Pocoes e Studio 2026-10-31

Projeto: `C:\Projetcts\aika-og`. Complementa [[Aika OG - Studio Rascunhos e Categorias 2026-10-23]], [[Aika OG - Pocoes e Consumo Seguro 2026-10-23]] e [[Aika OG - Diamantes Catharina e Modo Teste 2026-10-23]].

## Contratos implementados

- Lilola Hawn2442: somente bênção gratuita35 entre as opções de buff; opções pagas65/77 removidas. Teste do NpcHandler confirmou8500 persistido e +74físico/+96mágico/+10velocidade; falha de aplicação relatada não reproduzida na fonte atual.
- Roze2549/quest2808: cidadania da nação recomendada obrigatória para oferta, aceite e entrega, inclusive modo teste; oferta amarela11. Revalidar cidadania persistida dentro da transação protege sessão desatualizada.
- Diárias: completed_at permite reaceitação após meia-noite America/Sao_Paulo. QuestRepeat separa diária de repetível imediata; estado entregue deixa de bloquear no dia seguinte. Marcador de NPC visível acompanha alteração de disponibilidade. Missão pronta para entrega tem nome vermelho no menu.
- Lilly/quest2103:250 personagens de nação inimiga, item26901×50Caveira-II e repetição imediata. Objetivo nativo100 com parâmetros estritos. Identidade de morte por vida + recibos persistentes impedem contar a mesma morte novamente; integração cobre golpes, reflexão e dano redirecionado/periódico.
- Quest2823 Asteria: objetivo97 executável, recompensa19019, diária e exige8250 ativo, sem consumir o benefício. Não estender suporte97/100 a parâmetros desconhecidos apenas para remover aviso do Studio.
- Auxílio Poderoso8250: retirada do cash inicia720horas, item sem selo no inventário pessoal; dono/slot desbloqueado/expiração verificados para quest e loja2307. Item gerado por chat conserva Time0. Removida a ativação automática global durante ExpireAsync. Pacote0x14F16bytes estado1/0 acompanha login e mudanças, mas apresentação PREMIUM PC ainda depende de homologação.
- Poções:0x103flag1 deve anteceder snapshots silenciosos de HP/MP; ordem anterior zerava o delta verde calculado pelo cliente. Textos HP/MP/ambos usam o nominal solicitado, preservando os máximos reais.
- Studio: filtro opcional com seis classes; busca única de itens; ícones na lista; modal para navegar e selecionar pasta; categorias por ID com fallback nativo por tipo.166IDs únicos classificados pelas observações do XLSX fornecido, sem excluir/renomear itens sugeridos no documento. Mapa da aba NPCs deixa de desenhar !/?; isso não remove os marcadores do jogo.

## Publicação e reversão

Runtime usa snapshots MySQL de CatalogResources; mudar JSON de seed isoladamente não publica a configuração. Ferramenta seletiva `patch-reported-gameplay-catalogs plan|apply|rollback` faz merge de somente3recursos, preserva personalizações fora do escopo e usa hash/revisão, lock, transação e auditoria. Não usar importador global para essas correções.

Aplicado em `localhost:3307/aikaria`: npc-menus, npc-menu-actions e studio-item-categories, revisão1→2. Plano/bytes anteriores/propostos em `artifacts/reported-gameplay-20261031/catalog-plan.json`. Leitura posterior confirmou revisão2 e nenhum delta adicional. Reversão recusa mudanças posteriores ao plano publicado.

Recurso local `D:\aika\Aika OG\UI\strdef4.bin`: slot81 Data→Dias, apenas3bytes diferentes. Backup integral `strdef4.bin.20261031-153400-124629.duration.bak`. Executável preservado; ferramenta valida arquivo/vizinhança e cliente fechado.

Binários normais da solução compilados. Nenhum GameServer/TokenServer/cliente do usuário iniciado ou reiniciado; instância isolada5294 usada apenas na QA e encerrada ao final.

## Evidência e limites

GameServer completo:1663aprovados,10condicionais e1expectativa antiga de menu paga; após corrigir somente a fixture,48/48testes focados aprovados. Não chamar a execução completa inicial de verde. Studio158aprovados/15condicionais; poções51/51, ferramenta Python2/2, seletor/categorias9/9. Build AikaOG.sln0erros/34avisos de testes; frontend build/lint aprovados. Playwright desktop/390px: ícone4155 carregado em Benefícios/XP, seis classes, busca única, modal e71NPCs sem símbolos de missão. Falha HTTP500 simulada confirmou autoabertura sem loop e recuperação pelo botão.

No build originale1104, consumidor0x103 calcula o número pela diferença real em cache. Esse limite foi posteriormente resolvido para o cliente local com extensão de apresentação+patch calibrado74a63, preservando HP/MP reais. Ver [[Aika OG - Recuperacao Nominal Textos e Studio Desktop 2026-11-01]] para aplicação, hashes, reversão e emulação. Homologação visual dentro do jogo permanece pendente; clientes sem patch mantêm o delta original.

Consumidor0x14F confirmado estaticamente, mas animação PREMIUM PC e fundo vermelho da logo, cores/marcadores de missões e retirada/expiração ainda não foram homologados no jogo. Regras solicitadas pelo operador não equivalem a captura do servidor oficial.

Fonte canônica da entrega: `docs/operations/GAMEPLAY-STUDIO-2026-10-31.md`; evidências específicas em `docs/operations/POTION-FEEDBACK-2026-10-31.md`, `docs/reverse-engineering/QUEST-NPC-FIXES-2026-10-31.md` e `docs/SELECTIVE-GAMEPLAY-CATALOG-PATCH-2026-10-31.md`.
