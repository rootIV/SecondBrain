---
type: project-note
project: Aika OG
date: 2026-10-14
status: activated-gameplay-pending
---

# Premium Store, cash e persistência da perseguição

- Mob auxiliar incitado abandonava combate porque a distância inicial até o jogador consumia o limite de fuga e a ameaça decaía mesmo com combate ativo. A origem passa a ser a posição inicial do alvo e a ameaça selecionada tem piso enquanto em combate. Preservados melee 2, percepção/auxílio 5 e fuga aleatória 10–50. A referência Delphi mantém AttackerID; não prova superioridade geral de toda a IA. Fonte: MOB.pas 850–1012 em `D:\aika\Aika Rafinha Server\Src\Mob`.
- Mensagens984 e anúncios/chatF86 perderam acentos por ASCII; Latin-1 conserva português sem alterar tamanho de pacote. Autenticação e criptografia permanecem preservadas.
- Inventário cash não ativa benefícios/prazos. Auxílios715/716 ativam na retirada para inventário pessoal; símbolos217/218 exigem clique. Unidades temporárias não empilham prazos. XP EF387x4 prevalece sobre278x2; dropEF283 já consumido pelo serviço econômico. Fontes e testes em docs/operations/CASH-ACTIVATION-PRAN-BAGS-2026-10-14.md.
- Pran tem bolsa5301 gratuita/20slots e segunda bolsa liberada pelo consumo5801. Extensão SQL `pran-bags` persiste direito por Pran, arquiva marcadores legados e conserva conteúdo da segunda bolsa bloqueado até desbloqueio. Não converter marcadores5310 antigos em direito cash.
- Nova aba Premium Store edita lote de ofertas/preços/conteúdos/posições nas sete categorias nativas de PI.bin. Não oferece categorias arbitrárias; isso requer suporte no cliente. `cash_inventory.product_row` ainda ancora a apresentação de compras pendentes: impedir mudança de identidade/movimento/remoção até resgate, inclusive no editor binário genérico. Preços podem ser alterados.
- Backups/auditoria e comparação de versão antes da substituição; bytes desconhecidos preservados. Testes de Save usam cópia do cliente e banco isolado, sem alterar a loja real. Interface desktop/390px validada; API publicada tem849ofertas/seteabas e rejeita manutenção falsa sem gravar.
- Ativação feita com processos encerrados: backup `C:\Projetcts\aika-og\artifacts\economy-inventory\activation-20261014-230243`; migração concluída. Studio113pass/1GMskip; GS742pass mais9SQL inicialmente omitidos, depois aprovados em conjunto11. Startup e listeners conferidos.

Operação e hashes: `C:\Projetcts\aika-og\docs\operations\PREMIUM-STORE-2026-10-14.md`. Gameplay/renderização no cliente continuam pendentes; não confundir round-trip binário/SQL com equivalência visual ao oficial.

## Fonte ativa e cliente atual — 2026-11-03

- `CashCatalogService` usa `CatalogResources` para `client/ui/pi.bin`; com banco carregado, MySQL é a fonte ativa. Studio Read já lia esse snapshot, mas Save comparava o hash do arquivo local. Regressão isolada reproduzida e corrigida: mesma fonte ativa para leitura/edição, CAS separado do banco e arquivo, backups dos dois originais quando divergentes e journal/transação. Outros editores mantêm sua guarda padrão de divergência.
- Cliente `194f2367c7a6d1f6f4846b4a0ecbd833da629af2281745df877ae7b741b38d0c` aceito somente após comparação com baseline `4442...`: quatro janelas premium de 1024 bytes idênticas e teste de preservação exaustiva do patch de rede aprovado. Hash acrescentado por merge seletivo ao recurso MySQL `studio-premium-tabs`, com manutenção, lock, CAS/auditoria e readback; backup `artifacts/studio/premium-fix/catalog-publication-20261104-021533/`.
- PI real preservado, SHA `45D58A18EF846E687808351B406489D11452D43FFE58775294B60BE7052CF2D9`, 849 ofertas/235 marcadas ativas/7 abas. Oito testes focados SQL, frontend build e lint aprovados. Studio do usuário não reiniciado, drafts preservados; código novo requer nova instância/atualização. Nenhuma compra real nem homologação visual no jogo.
- Fonte detalhada: `C:\Projetcts\aika-og\docs\operations\STUDIO-PREMIUM-ACTIVE-SOURCE-2026-11-03.md`. Relaciona [[Aika OG - Catalogos MySQL e Drop 2026-10-22]] e [[Aika OG - Studio Rascunhos e Categorias 2026-10-23]].
