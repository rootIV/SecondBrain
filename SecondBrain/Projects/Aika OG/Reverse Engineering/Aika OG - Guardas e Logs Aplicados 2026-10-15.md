---
type: verification
project: Aika OG
created: 2026-10-15
status: activated-gameplay-pending
---

# Guardas e logs aplicados — 15/10

Relacionado: [[Aika OG - MOC]], [[Aika OG - Captura Missoes Guardas e Lojas 2026-10-15]], [[Knowledge Debt]].

- Operador esclareceu que caixas/baús e Hagnesia/Hagnensia são coletáveis de missão, e ossos/lápides de Halloween são evento que pode gerar mobs e itens. Não converter todos os atores ausentes em NPCs permanentes. Dos 70 atores ausentes na auditoria, 38 eram guardas/pedras/Sepúlcro e 32 outros objetos. Não foram removidos objetos existentes.
- A terceira missão exige um Max Mutante e escolha de recompensa, segundo relato; a ordinal não confirma ID3. A captura de missão1 anterior não demonstra esse painel. Coletor agora usa marco3 genérico de objetivo concluído.
- Lote aplicado: 63 NPCs novos; 623 NPCs totais e 560 antigos preservados campo a campo. Novos: 23 Guardas Reais Amarkand,16 Verband,1 Regenshein;8 Combatentes Amarkand,4 Verband;4 Guardas da Pedra Protetora;3 Guardas do Devir;3 Pedras Guardiãs;1 Sepúlcro Amarkand. 150 atores selecionados viraram133 pontos canônicos após dedup de nome/posição1;70 já existiam. Não importar rotas/reaparições como spawns extras.
- SQL e Data/NPCs sincronizados, IDs nativos livres2601..2665; nenhum preço/loja/personagem/mob alterado. Body WORD3072 é preservado por SQL e CapturedDetails, apesar do byte legado do arquivo4815. HP inicial cheio; MP capturado.
- Backup: `C:\Projetcts\aika-og\artifacts\guard-import\2026-10-15\backup-20261015-135848`. Plano ready-final com cópia imutável da captura e arquivos staged. Clone passou Apply/Verify/Restore e rollback forçado depois de uma inserção. Revisão independente sem bloqueio. Runtime carregou e decriptou63spawns508/349 com ID/posição/Body/HP corretos; startup confirmou623NPCs. Mapas/canais, combate de guerra/posse e validação visual continuam pendentes; ponto2601 próximo a guardas existentes pode exigir ajuste.
- Coletor não travava necessariamente quando ficava silencioso: logs cobriam poucos eventos e não havia heartbeat; conflitos TCP podiam encerrar o loop. Agora há collector.logUTF8, atividade5s/status periódico, etapas e ressincronização com perda explícita. Erros de configuração/socket continuam fatais. QuickEdit é desativado só na janela quando suportado; launcher resolve Python instalado sem instalar software.
- Trinta testes Python finais e ambos os launchers-Check passaram no Windows. Reabrir só o coletor aplica os logs; não precisa fechar o jogo. Captura longa real e seleção manual QuickEdit não foram realizadas. Fonte: docs/operations/GUARDS-APPLIED-2026-10-15.md e COLLECTOR-LOGGING-2026-10-15.md no repositório.

Caveat: SQL e arquivos não são transação distribuída; falha após commit e antes do marcador exige reconciliar pelo backup antes de reaplicar/restaurar.
