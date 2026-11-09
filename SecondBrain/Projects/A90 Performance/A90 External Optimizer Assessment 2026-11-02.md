# A90 External Optimizer Assessment 2026-11-02

## Decisão

Foram clonados em `C:\Projetcts\a90-test\A90-Performance\third-party` os repositórios `cavaleiro-ai/android-optimizer` no commit `d67f333b35264c1530c03aefb7b2afe438c57d98` e `SchneeSchmitt/ADB-Android-Optimizer` no commit `554a5d554c126a341a87775c28bd0a013d1ca637`.

Os perfis genéricos não devem rodar no itel A90 A6610L: a plataforma confirmada é Unisoc e o segundo repositório inclui caminhos Qualcomm e perfis que assumem mais aquecimento. O instalador do primeiro repositório é destinado ao Claude, não ao Codex, portanto não foi instalado globalmente.

## Estado seguro

- Nenhum perfil externo, Fastboot, root, desbloqueio OEM ou flash foi executado.
- O ambiente Python do segundo repositório foi isolado no clone; não alterou o ADB ou o aparelho.
- `speed-profile` de um único app é apenas hipótese futura, condicionada a telefone naturalmente frio, baseline comparável e reversão documentada.

## Referências

- [[A90 Performance - MOC]]
- [[A90 Initial Diagnostic 2026-11-02]]
- `C:\Projetcts\a90-test\A90-Performance\documentation\06-External-Optimizer-Assessment.md`
