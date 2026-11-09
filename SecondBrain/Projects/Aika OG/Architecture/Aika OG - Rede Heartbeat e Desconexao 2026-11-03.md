---
tags:
  - project/aika-og
  - networking
  - verification
updated: 2026-11-03
---

# Aika OG - Rede Heartbeat e Desconexao 2026-11-03

Relacionado: [[Aika OG - MOC]], [[Aika OG - Buffers Pools e Framing TCP 2026-11-02]], [[Aika OG - Sistema de Auth]], [[Knowledge Debt]].

## Contratos e decisões

Implementado acumulador linear por sessão e transporte com leitura/consumer aguardados, buffer limitado e todos os quadros completos extraídos. Sem RingBuffer/ObjectPool genérico. Escrita também passou a loop assíncrono sem recursão, com buffers preservados em envios parciais e reseed privado de broadcasts. Overflow da fila encerra com motivo; cleanup aguarda receive/send antes de devolver slab. Save duplicado de OnDisconnect foi retirado: SessionManager persiste após drenar handlers.

Heartbeat opt-in AGH1/versão1/opcode7FFE/40B, conferido no dispatch nativo da build autorizada. Offer/Ready e Probe/Ack usam GUID16B; servidor só avalia quem confirmou suporte. Timestamp monotônico no envio efetivo, máximo16probes. Padrão: sonda1s, RTT>500ms continuamente10s, ausência de resposta15s. Recuperação≤500ms zera sequência. Atraso global e handlers>50ms invalidam evidências contaminadas. Ping do chat mostra RTT real ou indisponível, nunca inatividade.

Morte (IsActive=false) mantém heartbeat para personagem ligado ao mundo; troca/desassociação cria nova capability/nonce. Cliente desarma fora da cena de mundo ou ao trocar socket. Fechamento comum anterior ao deadline mantém fluxo nativo; aviso de lentidão exige motivo validado ou watchdog15s. O teste `.lag` é GM/Admin, sem argumentos, só a própria sessão negociada; usa o mesmo Disconnect e diagnóstico lag_test sem falsificar métricas.

Usuário escolheu100jogadores, públicoBrasil, combate no estado atual sem rewind. Infraestrutura regional/rotas/serviços pagos fora do escopo. UDP/GameNetworkingSockets e modificação de interpolação ficam pesquisa; não houve alteração de movimento visual sem gameplay.

## Cliente e evidências

Patch instalado em `D:\aika\Aika OG\AikaClient.exe`, SHA194f2367c7a6d1f6f4846b4a0ecbd833da629af2281745df877ae7b741b38d0c. Preserva baseline4442e955... e patches anteriores. Backup completo em `D:\aika\Aika OG\connection-health-backups\20261103-141310-817438`; manifesto `artifacts/connection-health-client-20261103/package-final2/patch.json`. Rollback validado por hash no script `tools/patch_client_connection_health.py`; não restaurar usando manifesto de versões anteriores do patch.

19testes x86 pós-upgrade: ASLR,15s exatos, mensagem única CP1252, cenas/socket/personagem, fechamento comum, CAS/rollback. Offer/Probe C# passaram no receptor nativo, Ready/Ack nativos passaram no EncDec C#, sem stubs da cifra. Recuperação nativa volta ao login e mostra "Conexão lenta. Desconectado!". Jogo não foi iniciado/encerrado pelo agente.

Suíte completa1865aprovados/10condicionais ignorados em10m24s, antes dos últimos ajustes de lifecycle/ping/.lag; seleção final cobre esses ajustes. Carga:100conexões simultâneas×10roundtrips em cada perfil0/20/120/500/800ms,5000amostras por build, todas byte-a-byte corretas. Echo sem autenticação/gameplay/SQL/capability; não prova guerra nem expulsão de100clientes reais. Comparação Debug/Debug teve p95 variável e maior alocação atual; não alegar ganho causal de desempenho. CPU inclui proxy/clientes. Release tem medição absoluta separada.

## Ativação e limites

Recompilar/iniciar GameServer no Visual Studio e reabrir o cliente para ativação conjunta. Nenhum serviço foi reiniciado e HTTP8090 foi preservado. Watchdog do cliente é15s fixos: mudar timeout/intervalo do servidor exige recalibrar e homologar o patch também.

Pendentes: homologação real de login/mundo/morte/troca/.lag, renderização do aviso, launcher/updater e guerra100players. Não tratar emulação como prova do fluxo completo nem o benchmark de echo como FPS/gameplay. Relatório operacional: `C:\Projetcts\aika-og\docs\operations\NETWORK-HEALTH-2026-11-03.md`; mapeamento nativo: `docs/reverse-engineering/CLIENT-CONNECTION-HEALTH-2026-11-03.md`.
