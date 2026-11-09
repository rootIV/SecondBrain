---
tags:
  - project/aika-og
  - reverse-engineering
  - auth
updated: 2026-10-17
---

# Aika OG - Patch e Contrato Login 2026-10-17

Relacionado: [[Aika OG - MOC]], [[Aika OG - Sistema de Auth]], [[Aika OG - REA e Protocolo Nativo 2026-10-17]], [[Knowledge Debt]].

## Estado atual v3 e source corrigida

Patch v3 aplicado em `D:\aika\Aika OG`, readback conferido. EXE SHA-256 `e1104cbb8d313ec9b07e18c5529ac6865d1eda92e429355185617a4f805ff002`; tabela mantém o hash patchado abaixo. Backup original v3 `D:\aika\Aika OG\login-message-backups\20261017-174002-921612`; manifesto `C:\Projetcts\aika-og\artifacts\login-flow-fix-20261017\package\patch.json`. Relatório atual/restore: `C:\Projetcts\aika-og\docs\reverse-engineering\LOGIN-FLOW-FIX-2026-10-17.md`. Seções v2 abaixo são históricas.

Conexão recusada, HTTP vazio e timeout TCP usam **Não foi possível conectar ao servidor.** pela mesma rotina interna de toast da senha vazia, sem MessageBox do connect. Login/controles são restaurados e mundos só abrem após reply0x82 positivo. Relocation antiga RVA64994 neutralizada para evitar corromper cleanup com ASLR; 13 testes x86/patch passaram, incluindo três bases e timeout. Reabrir o client. Renderização real/login positivo/API/MySQL não verificados; assinatura original inválida e updater pode repor arquivos.

Source servidor/API compilada/testada em saída isolada, **não implantada/reiniciada**:0x81 valida ticket+status;0x685 exige variante longa1120/accountId/username/ticket e impede rebinding;0x82 tem28bytes/Nation+25. Client PT patchado envia builder longo existente com ticket+96. Distribuir patch junto à mudança do servidor: client curto antigo é recusado. API usa-1 para ID/senha inválidos e não expõe detalhes de exceção. Tokens não ganharam TTL/one-use arbitrários porque o client reutiliza ticket. Risco real de impersonação foi identificado no código antigo por vínculo somente por username, sem testar exploração; relato de invasão não foi confirmado.

Packets: colisão de seed consecutiva resolvida na ordem real de envio sem mutar broadcast; coletores suportam0x0101/14 sem campo inventado.35 testes GS+5Token+31Python captura+2568checks crypto passaram.0x039D/layouts universais0x0101 permanecem em investigação. Docs específicas `PACKET-FIXES-2026-10-17.md` e apêndices de `LOGIN-SERVER-PLAN-2026-10-17.md`. Integração MySQL não executada; pendem TTL/ban/custo uniforme/rate limit/TLS. Projeto Ghidra segue original com14símbolos; ver pseudocódigo pelo Decompiler, sem nova conversão manual.

## Estado histórico v2

Aplicado em `D:\aika\Aika OG\AikaClient.exe` e `UI\strdef4.bin`. Conexão recusada: **Não foi possível conectar ao servidor.** Credencial inválida: **Login ou Senha Incorreto**. Fechar/reabrir o client para carregar. Não houve execução de jogo/requests de login ou patch em memória; processo já aberto não foi encerrado.

Relatório e restore: `C:\Projetcts\aika-og\docs\reverse-engineering\LOGIN-CLIENT-PATCH-2026-10-17.md`. Reconstrução explicativa: `LOGIN-HIGH-LEVEL-2026-10-17.md`. Plano ligado ao código atual: `LOGIN-SERVER-PLAN-2026-10-17.md`, na mesma pasta. Script `tools/patch_client_login_messages.py`; oito testes offline passaram em `tools/test_client_login_patch.py`.

Original EXE SHA-256 `7eca8e1e6573dc439cc803ef6cafe91aaca53e6c60d4b3bfd82ab267a7ad81aa`; versão final instalada `3ad626f7777212a7be0b6af29eb60c91959cfa53ea44836b2c91774192c220ed`. `strdef4.bin` original `ce1a139d841cffd893136cfc75acea774152c7d5a8cc36ae0fded8bf6c06f9aa`, instalado `396dfedcf270eec14a5a1866cd035b033489db376cdc83f0e77c596a6d95bcb1`.

Backup original final: `D:\aika\Aika OG\login-message-backups\20261017-141743-791015`. Pacote/manifesto: `C:\Projetcts\aika-og\artifacts\login-patch-20261017\package`. Assinatura Authenticode original invalidada pela modificação; overlay preservado. Não houve bypass de verificação de launcher/anti-cheat. Launcher/updater pode repor os arquivos.

## Evidência do patch

- API retorna códigos, não a frase. `004433e0` lê `UI/strdef%d.bin` sem transformação para `0299ce40`, records de 128 bytes. Tabela portuguesa em CP1252; slots 3/4 foram trocados. Slot27 e outros idiomas preservados.
- Referência de format em `00464972` redirecionada para texto em padding `.rdata`/VA `0073c590`; VirtualSize estendido dentro do raw padding, checksum PE recalculado e relocation HIGHLOW mantida.
- HTTP exatamente `0` era falha silenciosa em `005a7eb0`. Salto de cinco bytes em `005a83d7` para `005a841b` reutiliza a apresentação da falha `-1`. Não muda resposta da API nem autenticação. Testes emulam `0`/`-1`, tokens começando por 0/a e ban -8; branch de token preservado.
- Bytes nativos do erro de conexão reproduzidos primeiro com erro antigo e teste falhando; depois mensagem nova passou. Testes verificam slots, hash guards, relocação, checksum, overlay e rollback de falha parcial.

## Símbolos e retomada

Sete nomes de login adicionais persistidos e conferidos após reabrir; total14 no projeto Ghidra **original**. Novos: Client_ConnectGameSocket 004647a0, Client_LoadLocalizedStrings 004433e0, JLoginScene_HandleUiEvent 005a6880, JLoginScene_RequestHttpLoginToken 005a7eb0, JLoginScene_HandleAccountReply 005a9810. Variantes de falha A 005a9490/B 005a9600 têm nome de variante provisório e confiança média. Manifestos `artifacts/login-patch-20261017/renames.{applied,reopened}.json` guardam VA/RVA, nomes antigos/novos, confiança e evidência.

Não substituir a identidade do projeto Ghidra original pela nova sem reimportação. Ferramentas históricas verify_native_client_crypto.py/verify_native_table_checksum.py rejeitam o EXE modificado porque são presas ao hash original; não enfraquecer os guards para fazê-las passar. Usar a imagem original preservada para análise histórica e os novos testes para o patch.

## Plano servidor/API e dívidas

Sem alteração em runtime C#, banco, opcodes, chaves ou estrutura de packets. A API está no TokenServer deste repo; baseline PBKDF2 e token CSPRNG/SHA256 continua atual, enquanto o corpo antigo da nota Auth é histórico.

- Prioridade P0: no fluxo atual analisado, AccountLogin0x81 descarta campo32 e SelectedNation0x685 vincula ActiveAccount por username sem validar token/status nesse caminho. Não foi feito teste de exploração; deployment/proxy não analisados.
- Reply0x82 atual serializa25 bytes, NationDWORD em+20, zero em+24. Client005a9810 lê signed byte+25 num branch de accountId positivo. Divergência do frame lógico confirmada; crash ou leitura fora da alocação não comprovados. Corrigir só com contrato/captura da build correta.
- Próximos trabalhos: TTL/revogação/status no consumo de token, ban desacoplado de tokenCreationTime, erros sem ex.Message público, transporte/TLS compatível e prevenção de enumeração por corpo/custo. Plano tem fontes primárias e critérios de testes; não foi implementado por este patch visual.

Renderização no jogo e login vivo com API não verificados; pseudocódigo explicativo não é source original nem prova de equivalência integral.
