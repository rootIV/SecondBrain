---
tags:
  - android
  - itel
  - a90
  - adb
updated: 2026-11-02
---

# A90 Performance - MOC

## Escopo

Projeto local em `C:\Projetcts\a90-test\A90-Performance` para diagnóstico e otimização reversível do itel A90 A6610L. A fase atual não altera o aparelho: sem desbloqueio, flash, root, remoção ou desativação de pacotes.

## Estado verificado

- Diagnóstico ADB de leitura concluído em 2026-11-02; 24 consultas tiveram êxito.
- Android 14/API 34, kernel 5.15.167, Treble e A/B confirmados.
- Bootloader reportado bloqueado e Verified Boot `green`; ROM/GSI/recovery não são elegíveis para instalação.
- O primeiro valor de CPU não é baseline de repouso: a coleta capturou atividade elevada. Repetir protocolo controlado antes de atribuir causa ou benefício a uma otimização.

## Notas relacionadas

- [[A90 Initial Diagnostic 2026-11-02]]

## Regras duráveis

1. Tratar o firmware e a coleta atual como fonte de verdade, não o nome comercial do chipset.
2. Validar backup antes de qualquer alteração futura e registrar valor anterior, reversão e benchmark.
3. Preservar telefonia, câmera, Wi-Fi, Bluetooth e Google Play Services.
4. Não inferir compatibilidade de GSI/ROM pelo Treble; requer documentação específica da build e retorno seguro.
