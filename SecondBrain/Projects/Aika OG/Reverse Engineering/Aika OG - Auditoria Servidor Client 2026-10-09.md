---
tags:
  - project/aika-og
  - reverse-engineering
  - verification
updated: 2026-10-09
---

# Aika OG - Auditoria Servidor Client 2026-10-09

Relacionado: [[Aika OG - MOC]], [[Aika OG - Cliente OG 2026-10-09]], [[Aika OG - WorldDataService]], [[Aika OG - ItemService]], [[Aika OG - SkillService]], [[Knowledge Debt]].

Auditoria do checkout `C:\Projetcts\aika-og` contra `D:\aika\Aika OG`. Relatório completo: `docs/reverse-engineering/SERVER-CLIENT-AUDIT.md` no repositório. Após autorização do usuário, os defeitos comprovados foram corrigidos em C#, Data e MySQL, com backup e verificação. As métricas iniciais abaixo preservam o diagnóstico anterior à correção.

## Fonte ativa dos dados

`Program.cs` chama `GameCatalogBootstrapService.LoadAsync`. O catálogo MySQL não vazio tem precedência; `CatalogImportService.LoadFromFiles` é fallback e pode ser importado para o banco. O MySQL `aikaria`, porta 3307, foi consultado e atualizado; o bootstrap confirmou `database`, items=19530, skills=7292, npcs=462 e mobs=5622.

A descrição antiga de carga direta de `WorldDataService` pelo Program está desatualizada para este checkout.

## Defeitos de parsing reproduzidos

- `CharacterExperienceService.cs:78` pula quatro bytes e trata todo ExpList como ulongs. O loader nativo `00443da0` lê 808 bytes desde zero, dois DWORDs intermediários e um bloco final de 404 bytes. No assembly C#, slot 1 vira `2310692405248`; primeiro bloco alinhado vale `200`. Corrigir estrutura e contagem, não só offset. Os slots 96–100 diferem nas tabelas e o DWORD em 812 vale 95/99, com semântica ainda não atribuída nesta auditoria.
- `ItemSetTemplateService.cs:64` trata o footer como cabeçalho: começa no offset 4. O set 1 `Preceito do Elter Sênior` vira `eito do Elter Sênior` e perde efeitos. Os registros deste arquivo começam em zero; preservar variantes legadas com identificação explícita.

## Diferenças efetivas nas entidades C#

Comparação executada pelos parsers reais sobre `Data` e payloads decodificados do client, com hashes conferidos:

| Medida | Itens | Skills |
| --- | ---: | ---: |
| Entidades locais | 16714 | 7283 |
| Entidades do client pelo mesmo parser | 19530 | 7292 |
| IDs compartilhados com diferença numérica | 1574 | 487 |
| IDs exclusivos do client | 3139 | 9 |
| IDs exclusivos do servidor | 323 | 0 |

Skills ausentes no servidor: 10290–10298. Exemplos compartilhados: skill 193 Duration `3600/600`; skill 1073 Cooldown `4000/6000` e CastTime `0/1000`; item 1003 SellPrice `42300/43200` (servidor/client, unidades brutas).

Diferenças isoladas não autorizam sobrescrever balanceamento. Nesta correção o usuário autorizou expressamente alinhar C#, banco e binários ao client; os IDs e referências foram verificados antes da migração.

## Verificação e limites

Nove testes existentes de ItemTemplate, SkillTemplate, CatalogImport e CatalogBootstrap passaram. Assembly xUnit desabilita paralelismo. Os dois erros de parsing foram confirmados adicionalmente chamando o assembly C# por reflexão, sem bootstrap nem acesso ao banco. A descriptografia de ItemList/SkillData teve assert de round trip e alinhamento.

Executável conferido: SHA-256 `7eca8e1e6573dc439cc803ef6cafe91aaca53e6c60d4b3bfd82ab267a7ad81aa`.

Sem sessão de gameplay, debugger conectado ou acesso nativo à janela do jogo. `AikaClient.log` estava sem gravação nova; captura completa de pacotes não estava preparada. Próxima etapa: logs preservados, fonte do catálogo confirmada e ações individuais no client. Não extrapolar resultados para combate completo, economia, quests, drops ou todos os bins.

## Correção aplicada e contrato verificado

- EXP: primeiro bloco de 101 UInt64, começando em zero; formato 1220 exige marcador correto, legado1212 e tabelas simples possuem regressões. Slots96–100 vêm do client.
- SetItem: checksum final opcional, nunca cabeçalho. Campos numéricos do client, nomes locais portugueses preservados quando há registro ativo correspondente. Resultado: 578 conjuntos, 2725 efeitos.
- Itens/skills: zero entidades diferentes ou IDs faltantes/extras entre payloads do client, Data e MySQL. 19530 itens, 7292 skills. 323 IDs exclusivos antigos sem referências nas tabelas examinadas foram preservados apenas no backup.
- SkillBehaviors: dados derivados atualizados e novas skills adicionadas usando `FromTemplate`; classificações/regras existentes preservadas. Data e banco coincidem.
- Integridade: 83 vínculos de conjuntos e 17 drops inválidos removidos de Data e banco; zero referências órfãs examinadas. Chances restantes preservadas. A importação não substituiu NPCs, mobs, títulos ou personagens por arquivos.
- Backup: `C:\Projetcts\aika-og\artifacts\catalog-repair\20261009`, incluindo dump SQL completo, arquivos originais, hashes e verification.json. Procedimento de reversão em `docs/reverse-engineering/CATALOG-REPAIR.md`; dump integral inclui progresso de personagens.
- Verificação: 352 testes aprovados na solution, 1 ignorado, zero falhas; runner legado exit0. Testes finais usam MySQL temporário, removido após execução. Dois testes dependentes da antiga pasta AikaEmu foram convertidos para fixtures locais.
- Limite: 159 lojas vazias observadas por ausência de StoreData externo. Não inventar inventários/preços. Sessão real de gameplay, associação completa de conjuntos novos, limite máximo de nível e semântica do segundo bloco EXP exigem evidência adicional.
