---
tags:
  - project/aika-og
  - reverse-engineering
  - tooling
updated: 2026-10-09
---

# Aika OG - Depuracao Realtime x64dbg

Relacionado: [[Aika OG - MOC]], [[Aika OG - Cliente OG 2026-10-09]], [[Aika OG - Auditoria Servidor Client 2026-10-09]], [[Knowledge Debt]].

Setup portable em `C:\Users\root4\Tools\x64dbg`. x32dbg/x64dbg 2026.05.27, Automate plugin 0.8.1 `ghost_fungus` x86/x64 e cliente Python/MCP 0.9.2 em `automation-venv`. O client OG tem PE machine `0x14c`: usar x32dbg.

MCP global `x64dbg` adicionado ao Codex com `X64DBG_PATH` apontando para o launcher x96dbg. Backup: `backups\config.before-x64dbg.20261009-170946.toml`. Igualdade das configurações/entradas anteriores confirmada por TOML; node_repl args vazio restaurado após normalização do CLI. Reiniciar o Codex para carregar as ferramentas novas; Python direto já funciona.

## Evidências

Hashes dos ZIPs conferidos contra os digests publicados. Testes passaram nas duas arquiteturas com cmd.exe do Windows: carga/pausa, registradores, memória e criação/remoção de breakpoint com bytes restaurados. MCP initialize/list_tools/connect/status passou; 48 ferramentas. Ponte restrita a `127.0.0.1`. Os processos de teste foram encerrados.

Runtimes VC++ x86/x64 v14.51.36247.00 e Python 3.14.6 já existiam; não foram reinstalados nem alterado o ambiente Python do projeto. Nenhum plugin de bypass ou driver de captura adicionado.

## Operação

Iniciar o client pela forma habitual; anexar x32dbg ao PID preserva os argumentos do launcher. Conectar ao PID do debugger, conferir hash/base, relocando endereços estáticos por RVA, e correlacionar uma ação por vez com os logs do servidor e handlers C#.

Attach confirmado em 2026-10-09 local: AikaClient PID 28104, x32dbg elevado PID 56540, x86 em execução, base `0x006B0000`, hash igual ao pesquisado. Falha de abertura sem elevação resolvida iniciando x32dbg como administrador. Vinte breakpoints TLS automáticos removidos da sessão nova; nenhum breakpoint software/hardware/memory restante. Servidores permaneceram ativos. PIDs/base são específicos desta sessão.

Essa primeira sessão ficou sem captura após troca do processo do client. Em seguida, AikaClient PID 21808 e x32dbg elevado PID 44460 foram usados para capturar ClasseRuim, base `0x006B0000`, 512 bytes da tabela de chaves em memória iguais à source. MCP carregado e funcional. Breakpoints comuns podem pausar o client e causar timeouts.

## Gameplay capturado — 2026-10-09, 21:46–21:53 local

1.098 registros: 125 OUT antes da cifra, 125 WIRE no buffer cifrado de saída e 848 IN após receiver. OUT/WIRE são duas etapas do mesmo envio. Payloads limitados a uma lista de gameplay e 4096 bytes; corpos de autenticação excluídos. Coletor encerrado sem erro/perda indicada, logpoints próprios removidos, client em execução e debugger anexado.

Operador confirmou movimento sem travamento/desconexão, item 6→11→6 com funcionamento normal, ataques com animação/dano e reentrada no mapa. 36 movimentos de tipo 0 têm coordenadas presentes nas respostas; 16 de tipo 16 são ignorados pelo handler atual. Foram observados 10 ataques e o fluxo `0x668`→`0x901`→`0xF02`→`0x925`; este último declara 6380 bytes, capturados só 4096. Inventário antes/depois manteve 13 itens com todas as propriedades/slots, ignorando IDs SQL reinseridos pela persistência. 118 pares OUT/WIRE completos passaram na comparação de payload/checksum; sete pares omitidos não foram verificados.

**Pendência confirmada:** IN de mobs consecutivos repetiram seed `0x50` (linhas 584/585) e `0x17` (930/931), com remetentes/payloads diferentes; segundo receiver retornou status 4 nos dois pares. O build continua pelo dispatch depois de registrar o status; ausência de desconexão não torna o protocolo limpo. `EncDec.Encrypt` escolhe seed aleatória sem histórico da conexão; factories cifram antes da fila. Uma correção precisa garantir a diferença entre seeds consecutivas no fluxo final de cada conexão, inclusive com concorrência/broadcast. Não alterar keys/opcodes nem aplicar uma variável global como se resolvesse ordenação por sessão.

Relatório: `C:\Projetcts\aika-og\docs\reverse-engineering\GAMEPLAY-VALIDATION-2026-10-09.md`. Evidências: `artifacts/realtime/20261009-ClassRuim-session2/packets.ndjson`, `validation.json`, `session.json`. Login inicial, outros sistemas/classes e payloads truncados ainda não validados. Sem mudança em C#/banco/bins nesta captura.

Detalhes: `docs/reverse-engineering/REALTIME-DEBUGGING.md` no repositório e `C:\Users\root4\Tools\x64dbg\README.md`. Remoção seletiva do MCP: `codex mcp remove x64dbg`; não sobrescrever configurações posteriores com o backup inteiro.
