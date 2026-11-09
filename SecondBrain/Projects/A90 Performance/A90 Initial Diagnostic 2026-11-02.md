---
tags:
  - android
  - adb
  - diagnostic
updated: 2026-11-02
---

# A90 Initial Diagnostic 2026-11-02

## Contexto

Coleta ADB somente-leitura para itel A90 A6610L, sem escrever configuração, pacote, bootloader ou partição. Artefatos brutos locais: `C:\Projetcts\a90-test\A90-Performance\diagnostics\20261102-155358-default-device`.

## Evidência

- Android 14/API 34; patch `2025-08-05`; build `A6610L-SQ372PQRST-UGo-OPPJ-PJ-S3-250811V67`.
- Kernel `5.15.167-android13-8-g1be87894c42b-dirty-ab1217`; oito CPUs lógicas expostas.
- Treble habilitado, A/B habilitado, slot `_a`; bootloader bloqueado e Verified Boot `green`.
- Backup Manager está desativado; transports instalados não comprovam backup de dados. `sys.oem_unlock_allowed=0`, dynamic partitions e Virtual A/B estão presentes, mas não autorizam instalação de GSI/ROM.
- 3,819.68 MB de RAM total, 1,495.38 MB disponíveis; `/data` com 197.3 GiB livres.
- 336 pacotes listados, 47 de terceiros; não há recomendação de debloat nesta etapa.

## Caveat

A amostra de 15 s teve apenas 33.52% de CPU ociosa e encontrou atividade alta em processos de fabricante, Play Store e sistema. Isso não é diagnóstico de causa nem baseline de repouso. Mitigação: repetir com tela apagada, sem interação, por pelo menos 60 s e com janela de bateria de 60 min ou mais.

## Seguimento verificado

Uma baseline de 60 s registrou 92.22% de CPU ociosa e 1,564.57 MB de RAM disponível. A medição de bateria não é válida para descarga porque o nível aumentou de 43% para 51% com USB conectado. Como primeiro ajuste reversível, as três escalas globais de animação foram de 1.0 para 0.5, com valores originais registrados e leitura confirmada. A comparação de CPU pós-ajuste (98.68% ociosa) não prova causalidade; a alteração reduz duração visual, não capacidade de CPU.

## Links

- [[A90 Performance - MOC]]
- `C:\Projetcts\a90-test\A90-Performance\documentation\03-Initial-Diagnostic-Report.md`
