---
type: verification
project: Aika OG
created: 2026-10-15
status: applied-gameplay-pending
---

# Expansão do mundo pela captura maior

Relacionado: [[Aika OG - MOC]], [[Aika OG - Captura Paineis NPC 2026-10-15]], [[Aika OG - Guardas e Logs Aplicados 2026-10-15]], [[Knowledge Debt]].

- Lote aplicado:120NPCs novos (113guardas/pedras/sepulcros+7NPCs de serviço),36lojas adicionais,53bindings de painéis. Totais743NPCs/1722slots de produtos/53bindings.38NPCs existentes receberam só menus/capacidades/store; aparência e posição dos623anteriores preservadas.
- Novos conjuntos incluem Sigmund/Cahill, Basilan61Combatentes, Hekla9, Mirza7, Sigmund6Combatentes/16Reais,6Pedras,6Guardas do Devir e2Sepulcros. NPCs novos:Eki,SinghRuol,Caçador de Tesouros da Mina,PietroSutherland,WalrondeuFever,MoaAmpelos,Taki. Nome de região não prova ID de mapa/canal.
-141atores condicionais/objetos de missão/evento/portais/criaturas não foram convertidos em população fixa. Entidades dentro de1unidade deduplicadas; sóprimeira aparição, sem rotas. Personalizações e metadados StoreData preservados. Nenhuma mudança de item/preço/mob/IA.
-54eventos de painel conferidos nos bytes geram53vínculos únicos, associados no máximo0,821s ao pedido. Novos seletores23/43 têm caminho no OG e sóabrem painéis de montaria; operações econômicas ainda pendentes. UpgradeCHECK instalado e verificado em clone/ativo.
- Backup: `C:/Projetcts/aika-og/artifacts/world-expansion/2026-10-15/backup-20261015-221854`; plano pronto e imutável emready-final, restore viaImport-WorldAlignment. Clone passouApply/Verify/Restore/FKs/rollbackforçado;43testesPython e verificação de743NPCs/158spawns/36lojas/53bindings no runtime passaram.
- Mobs somente análise:1785atores/163NameValues;8identidades semtemplate local:Pazira12,YorkFaminto26,SaqueadorDread159,Golems251/253,Smilodon359,BraveSanja1499,EspíritoHalloween3427. Dos1301atores comatributosraw,49levelRaw>255: não copiar semânticaOGparaBR. Tabelas/arquivos de mobs preservados.
- Fonte e detalhes: `C:/Projetcts/aika-og/docs/operations/WORLD-EXPANSION-2026-10-15.md`; verification.json compara todos os campos e normaliza só JSON/precisão de coordenadas. Gameplay e nomes/renderização no cliente pendentes.
