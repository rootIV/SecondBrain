---
tags:
  - project/aika-og
  - tool
  - reverse-engineering
updated: 2026-10-09
---

# Aika OG - BinEditor Sessoes e Seguranca

Executável independente em `C:\Projetcts\aika-og\AikaBinEditor.exe`; código em `AikaBinEditor`; testes em `AikaBinEditor.Tests`. Manual versionável: `docs/reverse-engineering/BIN-EDITOR.md`. Cliente de referência: [[Aika OG - Cliente OG 2026-10-09]].

## Contratos do editor

- Seletor de 16 formatos locais. Trocar seção preserva documento, alterações, undo, seleção e busca. Salvar grava somente a seção atual; fechamento considera todas as alterações pendentes.
- Tamanho, IDs, contagem, envelope, crypto e footer preservados. Sem deslocar ou aumentar tabelas. Quantidade não nativa impede salvar alterações mesmo em modo bruto. MakeItems curto permanece bloqueado.
- Campos comprovados editáveis; desconhecidos protegidos por padrão, visíveis em hex por offset. Modo bruto é escolha explícita e não implica semântica validada. Novos registros e limpeza nas seções auxiliares requerem esse modo.
- Diálogos: 40 textos de 128 bytes em `72 + linha*136`; stride 5508. Metadados/substituições preservados. Evidência nativa: `005359b0`, `00535c90` e leitura lazy `005357f0`.
- Windows-1252 para edição; contador de bytes no editor de texto, terminador nulo obrigatório inclusive via raw. UTF-8/CP949 são inspeção. Backups, gravação via temporário, proteção de hash contra mudança externa, JSON transacional e revisão de mudanças.
- PI→ItemList: checar referências alteradas contra dependências **em disco**, não só sessões pendentes. Criar item antes da oferta; remover oferta antes de limpar item. Sem dependências, gravação de itens/PI exige modo bruto. Relações não comprovadas não são apresentadas como verificadas.
- SL: host editável apenas como IPv4 literal; atualizar cache no offset 32 com os quatro bytes do endereço. Não confundir cache com porta.
- Build conhecida por SHA-256 do AikaClient: `7eca8e1e6573dc439cc803ef6cafe91aaca53e6c60d4b3bfd82ab267a7ad81aa`. Outra hash presente bloqueia gravação normal.

## Checksums e imagens

SetItem confirmado por emulação escalar/SIMD/reference: cobertura 64–215, buffer `007eb200`, loop `00443b9c`→`00443d1a`; stored `961fabe7`, calculado `961fae19`. Soma `byte[slot,offset]+slot*offset` mod 2³², footer cru. Item/Skill/PI já confirmados. `tools/verify_native_table_checksum.py`: 20 checks. Comparações com salto incondicional observadas no original; nenhum patch no cliente.

Decoder C# JT20/JT31/JT33/JT35 conferido integralmente com Pillow em 16 atlas. Preview automático tem associação **inferida** (24 colunas, passo 42, conteúdo 40; 576 itens/288 skills por folha). Offset 0 de skill é candidato visual, não ID do slot. Não converter esse campo automaticamente para o índice do registro. Confirmar os descritores/renderizador nativos antes de anunciar associação definitiva.

## Verificação e limites

65 checks sintéticos; 144 incluindo os 16 formatos reais com round trip, save/reopen em cópias e preservação dos demais registros. Smoke tests do executável publicado de sete seções em 1360×900 e 1024×720, edição, switch com dirty state, seleção e undo, todos exit 0. Originais somente lidos. Sem sessão de gameplay; sem mudanças nos servidores, protocolo, keys, ambiente global ou bypass. Campos desconhecidos e relações com servidor ainda precisam de testes no jogo.

Regressão verificada no single-file: callbacks de RetrieveVirtualItem podem ocorrer na troca de tabelas enquanto os nomes já foram substituídos. Esvaziar a lista antes de reconstruir nomes, proteger acesso durante binding/índices inválidos e invalidar após publicar a lista. Smoke usa ThrowException para erros de eventos, evitando diálogo do .NET que bloquearia o processo de teste.

Relacionado: [[Aika OG - MOC]], [[Aika OG - MasterEditor File Crypto]].
