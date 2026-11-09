---
tags:
  - project/aika-og
  - reverse-engineering
  - debugging
updated: 2026-11-01
---

# Patrulha e menu nativo — 01/11/2026

Relacionado: [[Aika OG - MOC]], [[Aika OG - Movimento Guardas Reais 2026-10-16]], [[Aika OG - Grupo Solo Menus NPC 2026-10-21]].

Cliente x86 atual `D:/aika/Aika OG/AikaClient.exe`, SHA256`74A63AC6533047DD3AA4341A8E86A6A6170D180FBBC97240B4F7056AB1DF6A4B`, REA/Ghidra12.1.2 somente leitura: dispatcher004BFC40 associa0301→0049EC60,010E→004A39A0,0110→004A4830. Símbolos e bytes preservados.

0049EC60 normaliza speed21–25 para20 e usa byte com sinal.005E9C70 calcula duração `distância*10000/speed` em ms. Se excede6400ms, o handler reposiciona o ator diretamente. O servidor avançava speed25 a3unidades/s, cliente a2: atraso acumulado explicava a correção abrupta em trajetos longos. Integração corrigida para`speedEfetivo*.1*elapsed`, 21–25→20; 0/128–255 estacionários e Studio1–127. Wire continua32bytes, opcode0301, MoveType0, speed bruto original e DWORD final0.

010E reinicia câmera/interpolação e entrada dos painéis;0110 só limpa conteúdo/opções. Navegação principal/conversa/missões/submenus usa0110, reservando010E à primeira abertura, NPC diferente ou reabertura após fechamento/painel. Moa2163 omite Missão quando não há missão disponível segundo o catálogo, inclusive com menu personalizado.

Seis regressões de velocidade falharam antes da correção;82testes focados passaram após. Inclui simulação da interpolação nativa em ida/volta de100unidades/200ticks e todos os256speeds. Homologação visual, captura nova, implantação e colisões de terreno não executadas. Não confundir a correção do contrato de movimento com reconstrução da rota ociosa oficial.

Relatório e evidências: `C:/Projetcts/aika-og/docs/reverse-engineering/NPC-PATROL-MENU-2026-11-01.md` e `artifacts/npc-motion-menu-20261101/native/`.

## Atualização: corpo durante a caminhada

Após a primeira correção, o usuário confirmou a chegada ao destino e relatou falha visual no corpo. No mesmo hash, `005E9C70` reinicia o relógio de interpolação em `+1C8` em toda chamada e só seleciona ação de caminhada quando a posição e o destino diferem após conversão para inteiros. Os microdestinos de aproximadamente 0,2 unidade por tick de 100 ms frequentemente não satisfaziam essa condição. A relação com o defeito visual específico é inferida, ainda sem homologação no jogo.

O servidor agora anuncia destino até 4 segundos adiante, renovando com 2 segundos restantes somente quando o alvo muda. Posição autoritativa, índice espacial e integração limitada a 500 ms continuam em cada tick. Spawn de observador novo retoma o destino vigente depois de nascer na posição atual; não duplica o anúncio do mesmo tick. Esperas e inversão dependem da chegada real. A chegada fracionária não para mais em `99.9996` sem inverter. Byte de velocidade, opcode, 32 bytes e flags foram preservados.

O teste de tráfego real falhou antes com 6 anúncios em 6 ticks e passou com 1. A regressão de 1.040 ticks de 100 ms cobre ida/volta, esperas e interpolação; um timer 10 segundos atrasado não produz salto autoritativo nem alvo para trás. 19 testes focados passaram. Sem SQL, implantação, reinícios ou patch binário. Rotas em terreno real, rede e aparência do corpo ainda exigem o cliente real; velocidades muito baixas/rotas dentro da mesma coordenada inteira mantêm a limitação da seleção de caminhada nativa.

Detalhes atuais: `C:/Projetcts/aika-og/docs/reverse-engineering/NPC-PATROL-INTERPOLATION-2026-11-01.md`. Pseudocódigo e evidência de `005F3A10` preservados em `005f3a10.c` / `005f3a10.evidence.json` no diretório de artefatos acima; sem renomes. A função seleciona ação/animação do modelo, mas a leitura não prova que toda repetição reinicie o frame.
