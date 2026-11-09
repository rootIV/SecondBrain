---
tags:
  - project/aika-og
  - studio
  - runtime
  - decision
updated: 2026-11-04
---

# Aika OG - Caps Studio e Politica Runtime 2026-11-04

Relacionadas: [[Aika OG - MOC]], [[Aika OG - Studio Perfis de Spawn e Customs Ghoul 2026-11-02]], [[Aika OG - Menus Efetivos e Lilola 2026-11-03]].

Fonte de contrato: `C:\Projetcts\aika-og\docs\operations\STUDIO-CAPS-2026-11-03.md`. Esta nota registra o estado e a verificação informados pela sessão em 04/11/2026.

## Decisão e limites

Caps é um recurso novo de perfis de conteúdo por limite de nível, independente dos antigos WorldProfiles de spawn removidos. Não restaura os seletores/perfis antigos nem suas mudanças de população de mundo.

O usuário escolhe o cap em edição no seletor abaixo da logo, edita seu rascunho, revisa o resultado e ativa explicitamente em manutenção. Selecionar ou salvar não publica. O catálogo `server-cap-profiles.json` inicia com seis rascunhos vazios, caps 50/60/70/80/90/99, e `Published: null`; sem publicação, o servidor conserva o conteúdo anterior. Não foram inventadas listas oficiais por cap, nem alterados nível do personagem ou distribuição de XP.

Publicar cria um snapshot independente do rascunho e exige motivo, revisão, GameServer/TokenServer parados e cliente fechado. O runtime deve ser reiniciado após a publicação. A comparação de versão/evidência usa CAS; publicação, projeção de itens, auditoria e suspensões são atômicas. Falha da auditoria desfaz tudo.

## Conteúdo e permissões

- Mobs: o limite vale para carregamento e novos spawns em runtime; templates continuam disponíveis para consulta.
- NPCs: regras explícitas controlam presença, loja, missões e opções. IDs restringem vínculos/ações existentes, sem criar gameplay nem transferir missão entre NPCs. `null` herda; `[]` desabilita os vínculos desse tipo.
- Loja: até 40 slots, preservando ordem, zeros como espaços vazios e IDs repetidos. Posições, textos e preços unitários continuam compartilhados.
- Itens, skills e títulos: somente `Allowed: false` proíbe; ausência de regra preserva a permissão anterior. Skills usam o ID nativo da variante/nível; títulos usam IDs 1–255.
- Skills proibidas não podem ser aprendidas/usadas nem aplicar buffs/passivos; títulos proibidos não podem ser equipados. Buffs persistidos e aquisição de títulos permanecem armazenados, com efeitos/exibição suprimidos enquanto proibidos. Lojas e compras/retiradas cash recusam itens explicitamente proibidos antes da entrega.

## Suspensão, instalação e recuperação

Somente proibição explícita de item causa suspensão. A posse é verificada em quatro fontes: inventário/equipamento de personagem não excluído, armazém da conta, inventário cash e equipamento/inventário da Pran. Armazém de guilda não atribui a posse a todos os membros.

Oito triggers, INSERT/UPDATE nessas quatro fontes, registram violações no commit da gravação. Contas 0/1 passam a 10 e têm token revogado; banimentos 8 são preservados. Na expiração de ban temporário, o TokenServer reavalia a posse atual; histórico isolado não justifica nova suspensão. GameServer valida instalação/projeção ao iniciar e encerra sessões suspensas a cada 5 segundos usando o cleanup existente.

`Database install-cap-policy` instala tabelas, oito triggers e a view `cap_policy_health`, sem publicar cap. A view verifica oito triggers e doze tabelas InnoDB. O instalador mantém o definer; runtime/editor recebem SELECT da view, sem TRIGGER. Grants aditivos mínimos ficam em `Database/least-privilege.sql`, incluindo a reavaliação de ban expirado pelo TokenServer. O instalador não troca engines nem concede permissões automaticamente.

O snapshot ativo usa revisão/hash em `server_catalog_resources`; `server_catalog_audit` guarda bytes anteriores exatos, motivo e operador. `cap_item_violations` registra conta, cap/hash, item, fonte, proprietário e slot; Studio mostra os 200 mais recentes. Não há exclusão de itens nem liberação automática de contas ao trocar cap. Recuperar perfil anterior exige auditoria, revisão e ativação em manutenção; suspensões precisam de revisão individual. Não restaurar só JSON por SQL: `cap_policy_items` deve corresponder ao mesmo snapshot. Voltar a `Published: null` exige restaurar snapshot e projeção vazia juntos, com backup e auditoria.

## Verificação observada em 04/11

- QA de navegador aprovado: seletor abaixo da logo; rascunhos 50/60 isolados; slots de loja vazios 0 e itens repetidos preservados; menu efetivo da Lilola; loja ativa; direção de mob 153→154→153 ao editar/desfazer; zero erros de console.
- Preview bloqueou gravações em catálogos reais e manteve seus rascunhos apenas em RAM.
- GameServer: 1.900 testes passaram e 10 foram ignorados na execução padrão; o teste SQL adicional de persistência de loja NPC passou.
- Studio: 231 testes passaram e um foi ignorado, incluindo os oito testes SQL Caps e as novas regressões de menus NPC.
- TokenServer: 25 testes passaram e um foi ignorado na execução padrão; o teste SQL adicional de autenticação passou.
- Frontend: TypeScript, Vite e oxlint passaram, com zero warnings no lint.
- A instalação real `install-cap-policy` foi concluída; a view de integridade está válida, há seis perfis, `Published: null` e zero violações. Instalar a política não publicou um cap nem suspendeu contas reais.
- A antiga instância Studio 3388 já estava encerrada: PID 25108 ausente e porta fechada foram confirmados antes da abertura. O executável atualizado foi aberto no PID 64340, sem interromper/reiniciar processo do usuário.
- Após a abertura: assets novos; menu Lilola 35/65/77/2 com acentos; API cash 849/235; rascunhos comparados antes/depois com igualdade exata de bytes. Backups em `C:\Projetcts\aika-og\artifacts\cap-final\studio-wwwroot-before.zip` e `C:\Projetcts\aika-og\artifacts\cap-final\studio-drafts-before-open.json`.
- Nenhum cap foi ativado; gameplay no cliente real continua sem homologação.

> [!warning] Limite de validação
> Testes e QA local não comprovam ativação em produção nem comportamento completo no cliente real. Homologação de renderização, efeitos e gameplay continua pendente; selecionar, editar ou revisar cap não ativa conteúdo.
