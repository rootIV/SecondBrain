# Aika OG - MasterEditor File Crypto

## Origem

Fonte Delphi analisada:

- `C:\Users\Vitor\Documents\Projects\aika\Tools\MasterEditor\Src\Functions.pas`
- funcoes: `SaveEncriptedFileKey1`, `SaveEncriptedFileKey2`, `SaveDescriptedFile`

Este conhecimento e sobre criptografia de arquivos de dados do client/editors. Nao e o mesmo contrato de pacote de rede `EncDec`.

## Algoritmo

O MasterEditor usa uma tabela de bytes derivada de string hexadecimal e aplica uma transformacao byte-a-byte pelo offset do arquivo:

- encrypt: `byte = byte + (key[i % keyLength] + i)`
- decrypt: `byte = byte - (key[i % keyLength] + i)`
- a aritmetica e de byte com wrap-around, equivalente ao comportamento Delphi.

Alguns arquivos do cliente possuem um cabecalho de 12 bytes antes do payload criptografado:

```text
42 52 30 30 30 32 32 49 00 00 00 00
```

Em ASCII, os 8 primeiros bytes sao `BR00022I`. Para descriptografar, esse cabecalho deve ser removido antes da transformacao por chave. Para criptografar arquivos que precisam desse formato, o cabecalho deve ser adicionado antes do payload criptografado.

## Chaves

Key1 (`ItemList`):

```text
BEC6C0CCC5DB20B8AEBDBAC6AE20C0CEC4DAB5F920B7E7C6BEC0D4B4CFB4D92E20B7EAB7E720B6F6B6F32E2E2E20C0B82E2E2E20C1A4B8BB20C1A4B8BB20B1CDC2FAB4D92E20B1D7B7A1B5B520C7D8BEDFC7CFB4CF20BEEEC2BF20BCF620BEF8C1D22E2E2E20
```

Key2 (`SkillData`):

```text
C0CCB0C520C0D0C1F620B8B6BCBCBFE42E20C0D0C0B8B8E920B3AABBDBBBE7B6F7B5CBB4CFB4D92E20C1A6B9DF20C0FDB4EB20C0D0C1F6B8BBB0ED20C2F8C7D120BBE7B6F7B5EEB7CE20BBE7BCBCBFE42E20BEC6BCCCC1D23F20C1C1C0BABCBCBBF3B8B8B5ECBDC3B4D92E
```

## Arquivos conhecidos

- `Data\ItemList.bin` -> `Client\ItemList6.bin`: usa Key1.
- `Data\SkillData.bin` -> `Client\SkillData6.bin`: usa Key2.
- `Data\Title.bin` -> `Client\UI\Title.bin`: copia sem criptografia.

## Utilitario .NET

O projeto `AikaFileCrypto` em `C:\Users\Vitor\Documents\Projects\aika_og` implementa esse algoritmo em terminal:

- arquivos arrastados para o exe entram como argumentos;
- saida fica na pasta do proprio executavel;
- decrypt gera `${nomeDoArquivo}.dec.bin`;
- encrypt gera `${nomeDoArquivo}.enc.bin`;
- nomes conhecidos detectam operacao/chave automaticamente;
- flags manuais: `--encrypt`, `--decrypt`, `--header`.
- a escolha de chave nao e opcao publica: `SkillData*` usa a chave de skill internamente, `Title.bin` copia sem crypto, e os demais `.bin` usam a chave padrao de item.
- decrypt remove automaticamente o cabecalho `BR00022I 00 00 00 00` quando presente;
- encrypt adiciona esse cabecalho somente quando usado com `--header`.
