---
type: project-note
project: Aika OG
date: 2026-10-14
status: activated-gameplay-pending
---

# Aika OG — Economia e inventário

Projeto atual: `C:\Projetcts\aika-og`. Fonte da verdade: código e relatórios em `docs/operations/ECONOMY-INVENTORY-2026-10-14.md` e notas específicas de tesouro/armazém.

- Cash J/Auxílio: requisição nativa 0x3AE modo1 antes rejeitada; responder ambos os modos com cash persistido. Cliente interpreta cash como int32.
- Bolsa1 pessoal livre; bolsas2–4 exigem compra Cofre5310 consumida/auditada ou premium vigente. Marcadores antigos80–83 não provam compra; conteúdo permanece preservado. Símbolos Sutherland218 temporários ativam acesso sem converter em direito permanente.
- Gold caps: inventário2bi, pessoal20bi, guild100bi. `accounts.storageGold` deve ser BIGINT UNSIGNED e o login ler UInt64. Preservar saldos legados sem truncamento e permitir redução sem aumento acima do teto.
- Receita nacional: apenas parcela efetiva da taxa NPC, nação do servidor, transação conjunta com dinheiro/itens/recibo. Preço da bênção não é tributo. Roubo de altar futuro.
- Timer nativo temporário: offset328 marca expiração, DWORD336 horas. TItem bytes17–19 = Unix bits8..31; resolução256s. Guardar deadline completo no banco, não reinterpretar stack Refine>=256 de item permanente como relógio.
- Munição ilimitada equipada suspende consumo normal enquanto vigente, excluída após vencer. Skills em área consomem uma vez por uso. Só temporários com lifecycle implementado são liberados na loja.

Relacionadas: [[Aika OG - NPC Missoes e Itens de Evento 2026-10-14]], [[Aika OG - Sistemas Nativos 2026-10-14]]. Validação de pacotes/SQL não prova renderização; confirmar cash, marcadores e expiração no cliente após ativação.

Verificação consolidada antes da ativação: 729 GS aprovados/1 ignorado; 25/25 no filtro integrado SQL/economia/schema. Revisão independente corrigiu concorrência da bênção e gravação de munição antes de dano. Falha SQL de munição não causa dano e encerra a sessão. Publicação isolada pronta; migração e gameplay ainda aguardam parada normal do servidor.

Ativação concluída após parada autorizada: migração oficial, storageGold BIGINT, cinco nações, 17 binários com hash conferido. Backup completo em `artifacts/economy-inventory/activation-20261014-152502`. O teste GS opt-in restante e os quatro do Studio passaram em rodadas específicas: cobertura consolidada 730 GS e 108 Studio aprovados. Gameplay visual permanece pendente; relogar para carregar os marcadores e testar cash/munição.
