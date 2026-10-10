---
tags:
  - project/aika-og
  - tools
  - verification
updated: 2026-10-09
---

# Aika OG - Aika Studio Web

Central local em `C:\Projetcts\aika-og\AikaStudio`, iniciada por `AikaStudio.cmd`, em `http://127.0.0.1:3388`. ASP.NET Core .NET 8 serve React/TypeScript e SCSS Modules compilados pelo Vite. O WinForms permanece disponível. Ver `AikaStudio/README.md` para operação e limites.

## Contratos

- Bins reutilizam `BinaryDocument`, `TableSchema` e `JitImage` do editor existente. Campos conhecidos, busca de arquivos/registros, rascunhos, desfazer, slots livres, hexadecimal avançado e JSON conservam as validações nativas. Gravação usa backup `.bak`, validação de layout e detecção de alterações externas. Arquivos desconhecidos mantêm os bytes e o último bloco parcial; não se presume cifra, checksum ou IDs. Alterar client não sincroniza automaticamente o catálogo SQL.
- Drops usam o catálogo real do MySQL e o mesmo resolver de listas do `DropDataService`. Chances inteiras independentes por item, rolagem global de 20%, segundo drop com 10%, limite de dois itens. Não normalizar para 75/24/1 das imagens. Lista vazia pode acionar fallback. SQL exige manutenção, snapshot concorrente, motivo, InnoDB, transação e backup JSON antes da gravação. Reiniciar GameServer após salvar; CSVs de Data não são atualizados automaticamente.
- GM reutiliza `GmDatabase`, com revisão antes/depois e auditoria na mesma transação. Instalação de `masterToolAudit` explícita. Contas, personagens e inventário consultáveis; hashes de senha e tokens não chegam ao browser. Status, perfil e cash são as operações disponíveis; não confundir com implementação dos opcodes GM de rede.
- API exclusivamente loopback, Host/Origin exatos, antiforgery e sem CORS. Detecção local de manutenção verifica processos chamados GameServer; dotnet DLL, remoto ou renomeado depende do operador. Rascunhos são voláteis e fechamento da página avisa sobre alterações.

## Auditoria de opcodes

`tools/audit_opcodes.py` compara `Opcodes.txt`, handlers registrados e construtores de headers, com evidência arquivo/linha e fluxo de chamadas estáticas. Relatórios `docs/reverse-engineering/OPCODE-AUDIT.md` e `.json`; viewer na central.

223 linhas, 222 opcodes únicos, duplicação de `0x31F`: 28 entradas implementadas, 38 saídas alcançadas, 153 ausentes, três construtores sem fluxo e uma entrada sem ação (`0x306`, UpdateCharInfo vazio). Há cinco entradas adicionais na source. `0x685` corresponde a SelectedNation; nomes genéricos da lista não comprovam a semântica. Nenhum opcode/layout foi modificado. A análise estática não comprova gameplay.

## Verificação

361 testes .NET aprovados na solution, um teste legado MySQL ignorado; AikaStudio com nove testes aprovados, incluindo HTTP e SQL em banco GUID temporário. Três testes CSV e três testes de parser de opcodes aprovados. Build e lint do frontend aprovados. Browser validado de 320 a 1440 pixels, sem overflow horizontal da página nem erros de console; importação, rascunho/desfazer, revisão de bins, modo bruto parcial, GM e filtros de opcodes. Nenhuma conta ou bin real foi gravado nesta validação.

Graphify atualizado por AST: 3381 nodes, 9353 edges; configuração JSON sem nodes permanece fora do grafo. Screenshots em `output/playwright/`.

## Pendências

Perfil 10 encontrado em conta existente, fora do enum 0–5 da source; valor preservado e sinalizado. Atlas de ícones e enum completo de raridade ainda inferidos; valores nativos são exibidos. Captura do client e comprovação dos opcodes em sessão continuam pendentes.

## Relações

- [[Aika OG - AikaMasterTool Central e GM]]
- [[Aika OG - BinEditor Sessoes e Seguranca]]
- [[Aika OG - PacketDispatcher e Protocolo]]
- [[Aika OG - Depuracao Realtime x64dbg]]
- [[Aika OG - MOC]]
