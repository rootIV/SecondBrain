---
tags:
  - project/aika-og
  - reverse-engineering
  - tooling
updated: 2026-10-10
---

# Aika OG - Coletor Passivo de Mundo

Relacionado: [[Aika OG - MOC]], [[Aika OG - Depuracao Realtime x64dbg]], [[Aika OG - NPC Spawn]], [[Aika OG - MobService]], [[Knowledge Debt]].

Entrada: `C:\Projetcts\aika-og\Coletar-Mundo.cmd`. Launcher PowerShell detecta AIKABR/AikaClient/AIKA e sua conexão. `tools/live_world_collector.py` captura ao vivo com raw socket Windows, `SIO_RCVALL`, modo IPLEVEL=3. Usa biblioteca padrão e `analyze_live_packets.decode_wire/load_keys`. Elevação do Windows necessária; nenhuma pergunta de origem/mapa/canal/IP. Sem debugger, attach, injeção ou leitura de memória. Não modifica GameServer, banco ou bins.

Com o jogo no mapa, iniciar, aguardar CAPTURA PRONTA, abrir lojas/passear; Ctrl+C encerra. Salva ao vivo em `artifacts/world-collector/auto-<IP>-<porta>/catalog.json`. CSV de lojas inclui NPC/itens/nome/XY; variantes têm StoreData.json e NpcObservation.json. Metadados enviados antes da captura ficam pendentes até nova aparição. Catálogo deduplica listas/itens/posições entre execuções. Mapa/canal unidentified, sem inventar contexto; reiniciar se a conexão do jogo mudar.

Contratos OG preservados: NPC 349/508, mob 35E/84, movimento 301/32 tipo zero, remoção 101/16, loja 106/96 com DefByte 0xC ou 1006/96. BR observado: NPC 3049/512, classe zero em 84, nome/índice em 12, XY em 56; movimento 30BF/32; remoção 3005/16. Nomes numéricos são resolvidos pelo UI/MN.bin do executável detectado (128 bytes/registro, subtrair índice do byte). Personagens excluídos. Mobs BR ainda não validados.

Cripto BR: primeiro DWORD XOR 0x3F1E0A0D, key acrescida de seed^4, shifts aritméticos de 32 bits. Modelo unsigned produzia opcodes com bit 0x8000 e coordenadas corrompidas em seeds altos; corrigido no Python. Tabela de keys e C# preservados. Revisar separadamente PacketTool/EncDec.cs, cujo modelo unsigned não serve como prova nativa desses seeds.

Primeira observação não confirma respawn; destinos não são trajetória amostrada ou patrulha neutra. Runtime ID pode ser reutilizado, e versões externas podem usar outros formatos/cifra. Dados são candidatos para revisão, sem SQL/importação automática. Source não deve usar todas as variantes de loja ao mesmo tempo, pois o loader recursivo sobrescreve listas do mesmo NPC.

O modo ao vivo não usa filtros/PktMon/ETL. Filtra o socket exato em memória; não salva corpos de login/chat nem dumps brutos. TCP limitado trata fragmentação de frames, retransmissões, ordem, wraparound e lacunas; divergência interrompe. O leitor offline anterior permanece para PCAP/NDJSON. Uma trava impede dois launchers gravando no mesmo catálogo.

Verificações: 34 testes Python e integração PowerShell aprovados. Captura real 2026-10-10 de AIKABR.exe em D:\CBMgames\AikaOnlineBrasil\AikaBR.exe, 45.134.141.86:8822. Friedrich Kroeger 2229, MN 832, em (3364.40,638.40), 13 itens; Camila Baran 2066 em (3529.40,730.40), itens 18092,18720,18722,20841; Yopi Arnold 2482 em (3545.40,730.40), 30 itens. Snapshot 64 NPCs/40 lojas sem repetição. Temporários únicos preservam os abandonados e permitem reiniciar após interrupção. Registros pendentes aproveitam uma única identidade histórica de NPC; múltiplas identidades para o mesmo ID impedem essa associação. Nenhuma operação no debugger. NPCs/lojas validados; mobs BR/patrulhas continuam pendentes.

Guia detalhado: [WORLD-COLLECTOR.md](C:/Projetcts/aika-og/docs/reverse-engineering/WORLD-COLLECTOR.md).

## Revisão final: importação de Regenschein

Ver [[Aika OG - Importacao Regenschein 2026-10-10]]. Coleta encerrada com 112 registros históricos de aparição, dos quais 68 NPCs MN confirmados e 44 nomes literais/classe zero (Prans/personagens). Classe zero isolada não comprova NPC BR; filtro agora exige nome numérico. Os snapshots antigos de 64/112 devem ser tratados como contagem de registros, não prova de NPCs reais. Captura original preservada. 40 lojas com nome/posição e 882 slots de itens aplicados ao MySQL/Data/client local, com backup. Item 1521 vazio no oficial e aparências de 15 NPCs continuam pendentes; não afirmar reprodução visual completa.

## Ampliação e crash da Catharina — 2026-10-10

O coletor preserva payloads de aparência, coordenadas float32 exatas, variantes deduplicadas, destinos/transições/visitas e timeline. Aparência OG segue factory; rótulos BR derivados do OG são candidatos, e o payload completo é a evidência principal. Patrulha não é deduzida de perseguição: patrolConfirmed=false. Novo fluxo de saída é restrito a requisições OG públicas de NPC; login/chat não são exportados.

Tabelas públicas do executável detectado são lidas automaticamente: ItemList, quest, Dialog, PI, MN, MM e MobPos. Bins completos, índices/strings/offsets, SHA256 e strides preservam campos ainda não interpretados. Preços são base do client, sem inferir imposto/desconto/cobrança real; shop-prices.csv associa NPC/itens. Oficial atual: 18.848 preços, 1.827 registros de quest, 9.975 de Dialog, 1.244 de PI; catálogo visual tem 15.083 hashes de assets Mesh/Texture/Objects. Isso não implementa lógica de quests nem identifica dependências de modelos automaticamente.

A primeira validação ampliada observou 305E/84 próximo a mobs, 100E/16, 1011/16 e 1012/88 em diálogos e 1031/20 em quest. A versão então em execução descartava esses payloads; foi encerrada para atualização. Variantes de diálogo/menu foram acrescentadas; 305E é guardado como candidato compacto, com movimentos de atores não classificados, até validar campos. Captura real desses payloads e interpretação de patrulhas continuam pendentes.

Crash local Catharina Piero, NPC 2113: dois bug reports do próprio client mostram mesma ACCESS_VIOLATION. Análise offline do dump confirmou item 26902, registro local corrompido, Classe em offset300=25710; busca na tabela de conjuntos vai a índice257101 fora dos limites. Registro oficial “Título: Ceifador” usa 0. Reparados seletivamente 31 registros inválidos de lojas em Data/ItemList.bin, ItemList4.bin do client e aikaria.item_templates; 40 lojas/882 itens preservados. Operador confirmou que a loja permanece aberta. Backup em artifacts/client-shop-repair/2026-10-10. Item1521 continua sem definição oficial utilizável.

Recomendação: migrar tabelas/assets específicos após conferir formato/ID/dependências. Não substituir executável/client inteiro sem validar protocolo/loader; opcodes oficiais diferem do OG. Relatórios: [WORLD-COLLECTOR](C:/Projetcts/aika-og/docs/reverse-engineering/WORLD-COLLECTOR.md), [crash Catharina](C:/Projetcts/aika-og/docs/reverse-engineering/CLIENT-SHOP-CRASH-2026-10-10.md).

### Payloads BR validados posteriormente

Confirmado305E/84 com nomes MN e posições/modelos coerentes: Toupeira Covarde6671/MN4/modelo209 em(3401.40,889.40), Max Filhote, Max Domesticado, Merkbee e Toupeira Exilada. Movimento30BF do mesmo runtime para(3404.39990234375,890.4000244140625), velocidade25. Handler de mob BR habilitado;18 snapshots retidos recuperam17 identidades. Movimentos históricos não são ligados em patrulhas sem ciclo de visibilidade completo; campos BR não comprovados permanecem raw/candidatos. Tipos de movimento nãozero também são preservados opacos.

Diálogos/menu confirmados100E/1011/1012,88 opções observadas; seletor6243 do NPC2309/Toca não corresponde diretamente a slot ativo de Dialog.bin. Associação de seletores BR às tabelas permanece aberta, sem adivinhar quest/diálogo pelo número.44 Prans históricos foram movidos para excludedLegacyEntities, preservando evidência e corrigindo contagem/exportações.58 testes Python, integração PowerShell e diff-check aprovados.

Versão final ativa às22:38UTC: snapshot115NPC classificados,74mobs,39com rotas observadas,45lojas e167opções. Evidência atual confirma movimento real em mobs BR; neutralidade/patrulha ainda não é inferida. A captura permanece ativa a pedido do fluxo de validação; o operador pode encerrar com Ctrl+C.
