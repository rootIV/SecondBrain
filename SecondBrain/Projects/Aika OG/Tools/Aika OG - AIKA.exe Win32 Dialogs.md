---
tags:
  - project/aika-og
  - reverse-engineering
  - client
  - tools
updated: 2026-07-08
---

# Aika OG - AIKA.exe Win32 Dialogs

Relacionado: [[Aika OG - MOC]], [[Aika OG - SkillService]], [[Aika OG - PacketDispatcher e Protocolo]]

## Alvo

- Executavel: `C:\Users\Vitor\Documents\Projects\aika\AIKAClient\AIKA.exe`
- SHA-256 original: `BC2C9E45A977CA605E3A763F7D2C2E971DC79D0DEEB78B84F20C2BFFBC337BF9`
- Ghidra: `C:\Users\Vitor\Downloads\ghidra_12.1.2_PUBLIC`
- Projeto Ghidra usado na investigacao: `C:\Users\Vitor\Documents\Projects\tools\ghidra-projects\AikaAIKAExe`

## Recursos Dialog encontrados

O executavel contem 16 recursos `Dialog` no idioma `1042`:

`103`, `132`, `134`, `138`, `141`, `148`, `151`, `152`, `153`, `154`, `160`, `162`, `163`, `164`, `199`, `200`.

O `WindowsResourceReference` do Ghidra encontrou referencia real de codigo somente para o dialog `154`.

## Dialog 154 Material

- Titulo: `Material`.
- Criacao confirmada em `FUN_0065eb70`.
- Chamada original:

```text
CreateDialogParamA(DAT_007465bc, MAKEINTRESOURCEA(154), NULL, FUN_00660480, 0)
```

- Dialog proc original: `FUN_00660480`.
- A proc trata `WM_INITDIALOG`, `WM_COMMAND`, mouse move/click, le `.\MaterialEditorSample.ini` e usa controles como `0x63a`, `0x63d`, `0x63e`.
- Nao foi encontrado caller direto para `FUN_0065eb70`; portanto o editor parece existir no binario, mas sem caminho normal de abertura no client atual.
- Patch experimental criado anteriormente: `AIKA.dialog154.exe`, abrindo o recurso por gancho no startup.

## Dialog 103 Skill Effect

- Titulo: `Skill Effect`.
- Recurso grande, com controles de lista, botoes e campos de edicao; aparenta ser ferramenta interna/debug de efeitos.
- Nao foi encontrada chamada original `CreateDialogParamA` para o recurso `103`.
- Nao foi encontrada dialog proc original para esse recurso.
- Patch experimental criado anteriormente: `AIKA.dialog103.exe`, que abre a janela com uma proc neutra. Resultado: a janela aparece, mas sem logica original nem dados populados.

Importante: este dialog Win32 `103` nao e a janela normal de skills do jogo. A janela de skill do jogo continua sendo controlada por pacotes do servidor, principalmente `0x106`, `0x107` e `0x31C`.

## Loader real de SkillEffect.bin

O binario contem loader real para `Effect\SkillEffect.bin`.

- Funcao candidata: `FUN_00437d90`.
- Chamadas confirmadas:
  - `0x004062a7`
  - `0x00408362`
- Arquivo esperado: `Effect\SkillEffect.bin`.
- Tamanho esperado: `0x37000` bytes.
- Layout observado: `0xA00` registros de `0x58` bytes.
- Strings relacionadas:
  - `Effect\SkillEffect.bin`
  - `Cannot read SkillEffect file : Size Error`
  - `Error Init Skill Effect`

O loader zera uma area grande do manager de efeitos, abre o arquivo, valida tamanho e copia os bytes para a estrutura interna do client. Isso prova que os dados existem e sao carregados pelo client, mas ainda nao prova que o dialog Win32 `103` tenha uma proc original ligada a essa estrutura.

## Viewer funcional implementado em 2026-07-08

Primeiro alvo pratico: viewer read-only do dialog `103`.

- Preservar `AIKA.exe` original.
- `AIKA.dialog103.viewer.exe` foi criado a partir do original.
- `AIKA.dialog103.viewer.dll` foi criada como DLL 32-bit sem CRT, usando Win32 direto.
- Patch do exe carrega a DLL depois da criacao da janela principal.
- DLL cria o dialog `103` usando os recursos do proprio `AIKA.exe`.
- DLL le `Effect\SkillEffect.bin`, popula a listbox `900` e preenche os campos `1034..1049` com dados hex do registro selecionado.
- A DLL aceita `AIKA_DIALOG103_VIEWER_FILE` como override de caminho para teste de erro de leitura sem quebrar o loader original do client.

Fora de escopo nesta etapa:

- editar/salvar `SkillEffect.bin`;
- renderizar efeitos em 3D;
- reconstruir a ferramenta original completa;
- alterar protocolo, opcodes, `EncDec` ou fluxo de skill do GameServer.

## Artefatos conhecidos

- `AIKA.dialog154.exe`: abre `Material`.
- `AIKA.dialog103.exe`: abre `Skill Effect` com proc neutra.
- `AIKA.dialog103.viewer.exe`: variante que carrega a DLL viewer. SHA-256 `87FF2553F569E2EDDA2730700A11D23E6F2DD97F0EA08B1568382D66EE93A49D`.
- `AIKA.dialog103.viewer.dll`: viewer read-only que popula o dialog `103`. SHA-256 `BCD3EF0FA95744ECB26538F0CA5D02C3E4C1738F15C5B40982E38FCFB9652918`.
- `AIKA.dialog103.viewer.cpp`: fonte da DLL viewer. SHA-256 `AEDE2CCEB16E16FA4514B5F3FE7E702CEBB7C2A52713E7DC3CF307FA5E090C8E`.

## Verificacao 2026-07-08

- `AIKA.exe` original preservado com SHA-256 `BC2C9E45A977CA605E3A763F7D2C2E971DC79D0DEEB78B84F20C2BFFBC337BF9`.
- `AIKA.dialog103.viewer.exe` contem a secao `.dlg103v`.
- Hook em `0x00407e7f`: bytes `e9 7c 31 fc 02`.
- Runtime com `RunAsInvoker`: janelas visiveis `Skill Effect` e `AikaClient`.
- `GetDlgItem(dialog, 900)` retornou listbox valida.
- `LB_GETCOUNT` no controle `900` retornou `2560`, equivalente a `0xA00` registros.
- Teste de falha com `AIKA_DIALOG103_VIEWER_FILE` apontando para arquivo inexistente: dialog abriu, processo permaneceu vivo e a listbox exibiu `SkillEffect.bin not loaded`.

## Proximos passos

- Confirmar em runtime se a listbox `900` recebe entradas de `SkillEffect.bin`.
- Mapear campos de `0x58` bytes por registro para nomes reais.
- Procurar referencias adicionais ao buffer carregado por `FUN_00437d90`.
- So depois avaliar editor com persistencia, sempre mantendo backup do asset original.
