---
tags:
  - project/aika-og
  - reverse-engineering
  - protocol
updated: 2026-10-17
---

# Aika OG - REA e Protocolo Nativo 2026-10-17

Relacionado: [[Aika OG - MOC]], [[Aika OG - Cliente OG 2026-10-09]], [[Aika OG - Depuracao Realtime x64dbg]], [[Preferencias de Engenharia e Reverse Engineering]], [[Knowledge Debt]].

## Ponto de retomada

Relatório: `C:\Projetcts\aika-og\docs\reverse-engineering\REA-CLIENT-2026-10-17.md`. Leitura em alto nível: `REA-PROTOCOL-HIGH-LEVEL-2026-10-17.md`. Triagem: `REA-PACKET-TRIAGE-2026-10-17.md`, na mesma pasta. Começar por esses índices; não reler o assembly inteiro.

REA oficial `morluto/rea`, npm `rea-agents@6.5.0`, instalado globalmente e registrado somente no Codex. MCP initialize/tools-list passou com 207 ferramentas; provider Ghidra passou no diagnóstico. Reiniciar Codex para carregar a integração no chat. Config anterior preservada por comparação TOML; backup `C:\Users\root4\.codex\config.toml.rea.backup`. JDK portátil `C:\Users\root4\Tools\java\jdk-21.0.12.1+1`, ZIP oficial conferido por SHA-256. Ghidra existente 12.1.2; provider informa validação upstream com 12.1.4.

## Identidade e símbolos

Client `D:\aika\Aika OG\AikaClient.exe`, SHA-256 `7eca8e1e6573dc439cc803ef6cafe91aaca53e6c60d4b3bfd82ab267a7ad81aa`, x86/base 00400000. Hash verificado novamente. Não misturar offsets com `AIKA.exe` ou seu C exportado sem identidade correspondente.

Projeto e exports históricos estavam ausentes neste checkout. Projeto recriado em `C:\Projetcts\aika-og\artifacts\ghidra-projects\AikaOGClient.gpr`; preservar também `.rep`. Sete nomes salvos, fechados e conferidos após reabrir: `Client_EncryptAndQueuePacket` 00464ee0, `Client_TryReceiveDecryptPacket` 00464c30, `Client_PumpScenePackets` 0040a340 e dispatchers JFieldScene 004bfc40/JLoginScene 005a90b0/JSelCharScene 005c0d00. `Provisional_Scene_HandleSharedPacket` 005ae9c0 é inferido, confiança média.

`tools/ghidra/AikaProtocolNames.java` valida hash, entradas, vtables e nomes automáticos antes de escrever. Manifestos `artifacts/rea-20261017/renames.applied.json`/`renames.reopened.json` registram VA/RVA, nomes antigos/novos e evidência. Nove funções exportadas com C/assembly. São anotações no projeto, não patches. REA Windows P0 é somente leitura; não persiste esses nomes em seu banco efêmero nem importa automaticamente os do projeto salvo.

## Evidência nova e limites

- 2.568 checks nativos x86 repetidos com sucesso; chaves conferem. `.analysis-venv` recuperado com versões pefile/capstone/unicorn da pesquisa anterior.
- 203 pares históricos OUT/WIRE completos conferem; oito excluídos. Quatro IN status 4, seed consecutiva repetida. Não comprovam problema na versão atual do servidor.
- `0x039D`: construtor em 004d1146..004d1178, dentro de 004cb7b0, zera 16 bytes e escreve DWORD 1 no payload +12 antes de chamar 0040a270. Finalidade de negócio ainda desconhecida; não renomear a função grande como se só enviasse esse opcode.
- `0x0101`: 90 IN históricos têm 14 bytes. Handler 0049e650 lê WORD +12 e, em alguns branches, DWORD +16; comprimento histórico não prova segurança universal. Correlacionar entidade/branch/produtor antes de mudar layouts ou parsers.
- Receiver aceita estaticamente até 0x6000, enquanto emissor aceita até 0x5fff. Os checks existentes não cobrem esses dois extremos. `0040a340` loga status não zero com ponteiro retornado e pode continuar para dispatch; não atribuir descarte automático a status 1/4.

REA Evidence de envio `ev_f2e96924ec0e600923b3e6658958dff9fb5a645146a047740704ac6c2d286610`; pseudocódigo de recepção `ev_dc6c3ec94baa408eae8a12d209a73f15f930baf90e176d04aa9ddb32665a5bf0`. JSONs completos e snapshot em `artifacts/rea-20261017`. Ler trechos/visões específicos via Context Mode. Nem toda consulta ao snapshot evita reimportar o binário.

Sem jogo executado, captura nova, alteração no servidor/protocolo/banco ou bypass. Não há sessão x64dbg ativa. Frida é dependência npm transitiva; install script ficou pendente e seu runtime não foi validado. O pseudocódigo explicativo não é source original ou reconstrução integral equivalente. GUI Ghidra e renderização desta nota não foram verificados nesta rodada.
