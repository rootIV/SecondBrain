---
tags:
  - project/aika-og
  - skills
  - reverse-engineering
updated: 2026-10-12
status: aplicado-gameplay-pendente
---

# Aika OG - Dual e Cast Nativo 2026-10-12

Relacionados: [[Aika OG - SkillService]], [[Aika OG - Rafinha Server Skills e Animacoes]], [[Aika OG - PacketDispatcher e Protocolo]].

## Contratos confirmados

Disassembly estático do AikaClient.exe atual confirma SelfAnimation em SkillData+344, TargetAnimation em +348 e Anim como campo separado em +356. A nota antiga de SkillService que equiparava SelfAnimation e Anim estava incorreta. Base nativa00f416b0; leitura004f45f0 em00f41808 e gravação004f45f7 em packet+28, confirmadas também por004f48d1. O script recon.py valida hash e bytes do executável.

0x320 inicia o cast; cliente compara elapsed com SkillData+320 e envia0x302 depois do prazo. Servidor agora mantém cast pendente, valida prazo/skill/vida/posição/controle e executa o efeito uma vez na conclusão. Movimento,0x327, reset e desconexão cancelam. Retornar deixa de teleportar antes da barra/animação. MP/cooldown são consumidos na conclusão. Não houve alteração de criptografia, chaves, executável ou layouts nativos.

## Catálogo da dual

Corrigidas112 entradas para Buff/Self/Caster: Esquiva, Tiro Anti-Defesa, Ação Imediata, Maximizar, Ocultar, Rosa Negra e Disparos Rápidos, todos os16 níveis/variantes. Tiro Anti-Defesa é buff preparatório próprio, conforme TargetType1/efeito274.

Réquiem, Choque Súbito e Negar Cura:48 entradas Debuff/Enemy/Target sem dano inicial, preservando efeitos específicos existentes. Explosão Radiante:16 entradas AttackDebuff; DamageRange16 é alcance do lançamento, Range3 é raio da área. Não remover globalmente validação de alvo: escolher comportamento e destino corretos no catálogo editável. Damage0/CastTime0 revisados são valores explícitos aceitos. A carga runtime usa MySQL; seedJSON sozinho não altera o banco ativo.

## Aplicação e evidência

- Repositório: C:\Projetcts\aika-og.
- Relatório: docs/reverse-engineering/DUAL-SKILLS-CAST-2026-10-12.md.
- Evidência: artifacts/dual-cast-client/FINDINGS.md, recon.py e dumpsASM.
- MySQL local aikaria:176 comportamentos e6531 animações reparados; overrides divergentes do antigo import preservados.
- Backup: artifacts/backups/dual-skills-20261012-134808-061.
- MigraçãoSQL e scriptRepair-DualSkillCatalog.ps1 disponíveis. Script consulta por padrão; Apply faz backup e transação.
- Testes:145 específicos aprovados; suíte568 aprovados/zero falhas/três opt-in ignorados. BuildGameServer padrão sem erros/avisos.

## Pendências

Iniciar a build e confirmar gameplay visual de Retornar/Maximizar, cancelamento, buffs próprios e efeitos/alvos da dual. Esta mudança não implementa novas mecânicas especiais dos IDs de efeito nem PvP. Fases especiais de cast usando offset328 exigem análise separada. GrafoGraphify existente usado para descoberta; atualizar seus novos nós após consolidar o trabalho simultâneo no checkout.
