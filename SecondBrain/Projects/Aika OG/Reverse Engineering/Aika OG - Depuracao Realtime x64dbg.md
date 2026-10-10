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

Ainda não houve attach ao Aika nem sessão de gameplay. Breakpoints podem pausar o client e causar timeouts. Não confundir setup validado com compatibilidade do jogo validada.

Detalhes: `docs/reverse-engineering/REALTIME-DEBUGGING.md` no repositório e `C:\Users\root4\Tools\x64dbg\README.md`. Remoção seletiva do MCP: `codex mcp remove x64dbg`; não sobrescrever configurações posteriores com o backup inteiro.
