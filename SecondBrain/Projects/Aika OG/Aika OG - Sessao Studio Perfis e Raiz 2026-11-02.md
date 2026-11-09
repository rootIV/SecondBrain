---
tags:
  - project/aika-og
  - validation
  - studio
updated: 2026-11-02
---

# Aika OG - Sessao Studio Perfis e Raiz 2026-11-02

[[Aika OG - MOC]], [[Aika OG - Auditoria Catalogos e Mapas 2026-11-02]]. Relatório: `C:\Projetcts\aika-og\docs\operations\STUDIO-SESSION-PROFILES-RAIZ-2026-11-02.md`.

## Contratos verificados

- Sessão de ItemList4 tinha zero mudanças, mas RestoreDrafts recusava sua origem antiga e deixava o ID do frontend sem sessão no backend. Sessão limpa agora reabre a origem atual; registros realmente editados continuam com CAS estrito. sourceVersion no Describe permite atualizar documento e item selecionado; campos pendentes bloqueiam aplicação até descarte explícito. Reopen faz backup antes de descartar um BinaryDraft, sem limpar outras áreas.
- Backup inteiro do rascunho real em artifacts/studio-recovery-20261102/draft-before-publication. Versão2FB51E83... preservada durante QA; nenhum rascunho precisou ser apagado. QA de navegador interceptou a persistência antes da primeira navegação.
- Perfis Atual/Lore/Rafinha/TheMu/Master: dropdown só prepara rascunho; revisão global com manutenção/CAS/transação/backup para aplicar. Pools adaptam as chances atuais por raridade, não taxas oficiais. Eventos/específicos e grupos ausentes são preservados com avisos. Snapshot pinado1.501modelos/50pools/1.535entradas/54hashes. Navegador: Master26/Rafinha90/Lore92 e Atual64; não validar o DOM por /api/drafts imediato, pois o autosave tem debounce1,2s.
- Operador escolheu MonsterListCSV_Raiz6.099linhas. Plano reviewed-v1 concilia5.867(277inserts,5.584updates,6overrides preservados), rejeita212sem modelos seguros+4sentinelas;16guardas permanecem NPCs. Preserva376modelos e33extras. Total esperado5.900spawns;1.934selecionados continuam inativos. Nunca inventar HP/IDs para fechar cobertura.
- Studio lista66entradas no OG auditado:43imagens+23grades. Distrito Glacial vem de overlay BR incorporado e condicionado ao hash; nenhum Map.bin/terreno/textura alterado. Tabelas customizadas preservadas. Grade indica imagem indisponível, não área jogável nova.

## Verificação e estado

Correção posterior de escopo: o dropdown agora seleciona um plano para o catálogo inteiro, com contagens globais e tabelas derivadas; trocar de mob não volta para Atual. Prévia global é somente leitura; edição individual fica em Atual. Revisão aplica o mesmo plano via CAS. Busca/faixa/lista foram unificadas numa barra lateral de280px. Navegador1280/1920 confirmou Lore92/Master26/Atual64 para dois mobs, seleção salva após reload, filtro/busca e ausência de overflow. Só frontend/documentação alterados; bundle servido pelo Studio aberto confere com o testado, sem necessidade de reiniciar processos. Nenhum perfil gravado no banco pela QA.

Studio completo212aprovados/1condicional; frontendTypeScript/build/lint; navegador1280/1728sem overflow/errosJS; importador7Python+cloneMySQL aplicar/verificar/restaurar, rollback SQL forçado e guard de modelo alterado. GameServer real não executado.

Publicação concluída em2026-11-02 após encerramento confirmado do Studio. Plano `artifacts/raiz-import-20261102/review-v1/plan.json` aplicado com -ResolvedOnly:5.861alteraçõesSQL,0arquivos,5.900spawns totais. Verify passou todas as mudanças e415guards; backups/marker no mesmo diretório. Build normal0avisos/erros e assemblies iguais aos testados.

O operador salvou versão4EC87B44... ao fechar; backupnovo draft-at-publication preservou essa versão, sem reaplicar snapshotantigo. Reparo via API CAS atualizou somente items.document/items.opened, sem mudanças no item ou outras áreas; versãofinal62427AAA..., backup draft-after-publication. API normal confirmou21.529itens/zeroavisos, quatro perfis e66mapas(43imagens). Nenhum perfil aplicadoautomaticamente; processos de homologação não iniciados.

## Perfil Ghoul acrescentado

O snapshot `Data/ServerCatalogs/studio-drop-profiles.json` passou a oferecer o perfil `ghoul` / **Ghoul**, extraído de `D:\aika\Data`: 463 modelos de mobs com DropIndex explícito, 13 pools e 378 entradas, sem linhas rejeitadas. O gerador `tools/build_studio_drop_profiles.py` inclui essa origem. Os quatro perfis anteriores foram preservados integralmente; o total é 1.964 modelos, 63 pools e 1.913 entradas.

Verificação: 9 testes `DropProfileTests` aprovados; reprodução integral dos cinco perfis a partir dos CSVs; igualdade dos quatro perfis anteriores com o snapshot versionado; 14 arquivos de Ghoul com SHA-256 e tamanho conferidos. O AllMobsInfo tem SHA-256 `283ddcbefbe67dd4fc2683b0c68075041d0bf2b819b4379a7aab4c177ebb1821`. Foram usados somente os pools CSV do contrato existente 0–12; `AllDrops.txt` e subpastas de dungeon não foram importados. Nenhum drop foi aplicado ao banco. Interface e gameplay não foram executados nessa inclusão; um Studio já aberto exige reinício porque o catálogo usa cache por processo.
