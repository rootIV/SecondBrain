---
tags:
  - project/aika-og
  - reverse-engineering
  - data-quality
updated: 2026-11-02
---

# Aika OG - Auditoria Catalogos e Mapas 2026-11-02

Auditoria somente leitura de 148 CSVs listados pelo usuário, 46 versões por SHA-256, mais três Map.bin. Artefatos em `C:\Projetcts\aika-og\artifacts\reference-catalog-audit-20261102\final`; relatório `docs\analysis\REFERENCE-CATALOGS-AND-MAPS-2026-11-02.md`.

- Melhor base conjunta comparativa: `D:\aika\Aika Rafinha Server\Arquivos antigos\Bin1\Data\data original`: 373 modelos, 5.865 spawns sem referências de nomes ausentes no par, 34 missões reais. Não prova conteúdo oficial; nome `original` não foi aceito como certificado.
- Lore tem pools de drops mais amplos: 75/35/38/48 itens distintos nas faixas 21–40/41–60/61–80/81–99. Coluna 2 é grupo de raridade, não quantidade. MasterEditorBin/old_drops são pools menores para comparação, sem baseline oficial de servidor.
- AllMobsInfo Rafinha atual: 375 linhas, mas inclui teste1/BossMundial/Teleporte. Legados AllMobs de 18 campos não podem ser importados no loader atual de 27 sem conversão. Fonte Lore usa Data/Mobs; cópias na raiz e Win64/Debug não são automaticamente a mesma versão.
- MonsterListCSV_Raiz: 6.099 spawns/384 nomes, cabeçalho e esperas variadas. Lore atual uniformizou todas as esperas em 8 e deslocou destino −10/−10 em 4.061 correspondências inequívocas. MasterEditorBin preserva os destinos nas 4.435 correspondências por nome/início com Raiz. Não misturar modelos atuais e Raiz sem reconciliar grafia/codificação e cobertura.
- Quests: 100 linhas físicas não são 100 missões. Rafinha tem 34 IDs positivos, Lore 33, MasterEditorBin 11; o resto são placeholders. Lore aumentou XP das missões 14/149 de 3000/5000 para 30000/60000 e mudou requisitos. Quests_raiz tem cinco linhas em formato legado de 29 campos.
- Os quatro ItemList.csv são idênticos e vazios, só cabeçalho de 33 campos. Não inferir a cobertura dos ItemList.bin por esses CSVs.

## Contrato e erros de mapas

- OG: 80 retângulos int32[4], nomes em offset1280/stride28; 65 nomeados.
- Brasil: mesmo layout, 66 nomeados. Somente slot65 difere: Distrito Glacial `[1792,3328,2048,3584]`, zerado no OG.
- GoLevel: 64 retângulos, nomes em offset1024/**stride64**, 62 nomeados. Usar stride28 produz fragmentos falsos.
- maps_decrypted.csv em Data: 59 linhas corretas (0–58), incompleto. maps_decrypted2: 58, falta14. Logs/maps_decrypted: 67 registros corretos (65 nomeados,2reservados), mais linha67 truncada.
- maps_decrypted_ok: primeiros80 corretos, mas lê slots80/81 na área de nomes e termina82 truncado. DWORD1701274962=`Rege`,1701344110=`nshe`: é Regenshein interpretado como coordenadas. Nome/sufixo não certifica integridade.
- Saída limpa OG: maps_decrypted_corrigido.csv com80slots; mapas_nomeados_og/br/golevel.csv com nomes e limites. LimitIndex zero-based e MapTextureId index+1 não são IDs confirmados de mapa do servidor. Retângulos UI não provam colisão/área caminhável;22 entradas OG nomeadas não têm textura.

Hashes das 148 fontes e dos três Map.bin reconferidos sem mudanças. Não houve importação ou homologação de gameplay/navegação.

Relacionadas: [[Aika OG - Imagens de Mapas 2026-10-11]], [[Aika OG - Lore Community Combate Atributos 2026-10-19]], [[Aika OG - MOC]].
