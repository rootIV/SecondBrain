---
tags:
  - project/aika-og
  - drop
  - experience
updated: 2026-10-21
---

# Aika OG - Eventos Drop e XP 2026-10-21

[Contrato e exemplos](<C:/Projetcts/aika-og/docs/operations/EVENT-RATES-2026-10-21.md>). **Correção explícita do operador:** `.drop` deve calibrar a chance-base global e os pesos de raridade do algoritmo real, sem multiplicador de evento. Somente `.xp` continua sendo multiplicador.

- GM/Admin: `.drop chance 30` ou `.drop 30` define30%; `.drop pesos 67 20 12 1` define normal/superior/raro/lendário e exige soma100; `.drop` consulta; `.drop catalogo` remove a calibração. Não aceitar sufixox no drop.
- `DropAlgorithmService` usa `DropAlgorithm.json`, com chance e pesos inicialmente nulos para preservar o catálogo. A base absoluta substitui a base dos perfis normais e a constante global do legado. Pesos repartem a base entre grupos e preservam a proporção interna dos itens; entradas zero ficam desativadas e grupos ausentes não transferem sua massa a outros grupos.
- `TypeItem` não comprova a raridade do pool. Usar o grupo cadastrado. Perfis específicos, eventos, missões e seladas continuam independentes; não aplicar a calibração de quatro raridades a dados sem essa classificação.
- Quantidades/cotas permanecem; bônus pessoais/nacionais compõem a nova base pelo teto existente. O perfil original é preservado e a cópia usada no abate é auditada. Não criar novas linhas `server_event_drop`; histórico preservado.
- `.xp [multiplicador]` segue GM/Admin,1..1000x;1restaura normal. `EventRates.json` guarda somente XP. Compõe mapa/DG, premium, relíquias e missões; preserva1XP por diferença extrema de nível e satura overflow. Configuração persiste após reiniciar.
- Arquivos separados, snapshots imutáveis e gravação antes de publicar evitam mistura entre calibração e evento. Sem migração do banco real nem mudança de protocolo. Gameplay pendente; artefatos atuais em `artifacts/drop-calibration-20261021/`.

Verificação desta correção: build da solução sem erros; 58 testes focados aprovados; suíte completa do GameServer com 1.531 aprovados, 10 ignorados e zero falhas. A cobertura separa `DropAlgorithmCommandTests` de `EventRateCommandTests`. Resultados TRX e contrato detalhado no relatório do repositório. Estes resultados substituem a validação da versão anterior de multiplicadores.
