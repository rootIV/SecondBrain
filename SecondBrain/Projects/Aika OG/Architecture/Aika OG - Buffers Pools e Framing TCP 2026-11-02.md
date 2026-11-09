---
tags:
  - project/aika-og
  - performance
  - networking
updated: 2026-11-02
---

# Aika OG - Buffers Pools e Framing TCP 2026-11-02

> Atualização2026-11-03: [[Aika OG - Rede Heartbeat e Desconexao 2026-11-03]] implementou framing com acumulador linear e transporte aguardado. Os resultados e recursos descartáveis de Session descritos abaixo são históricos; a escrita atual usa Socket.SendAsync com Memory em vez do SocketAsyncEventArgs de escrita.

Relacionado: [[Aika OG - MOC]], [[Aika OG - Arquitetura Atual]], [[Knowledge Debt]].

## Decisão

Não ativar as implementações atuais de RingBuffer/ObjectPool sem redesenho e medição representativa. Ambas estão sem referências C# locais fora da definição, confirmado por busca e Serena. Não houve alteração em produção nesta investigação.

`PacketPool` já reutiliza escritores com reset, limite de256instâncias e buffers de até2048B. `SocketAsyncEventArgsPool` administra callbacks/tokens; `BufferManager` já usa ArrayPool. Manter essas políticas, sem substituição pelo pool genérico cru.

`ObjectPool<T>` usa ConcurrentBag sem reset, teto, descarte ou guards de devolução. Prova local reproduziu estado preservado, dupla devolução alugando a mesma referência duas vezes e Return(null)→Rent(null). São precondições de uso a resolver antes de adoção, não incidentes observados em runtime, pois a classe não é usada. Não aplicar a Session: o SocketAsyncEventArgs readonly de escrita é descartado por Dispose; limpar propriedades não reconstitui o recurso nem garante isolamento de conta/personagem.

## Medição

Release, .NET8.0.33 x64, Ryzen9 9900X,24threads,GCworkstation,tieringdesabilitado,5amostras após aquecimento, single-thread. Fontes reais linkados, sem nova dependência. Dados/asserções/hashes em `C:\Projetcts\aika-og\artifacts\pool-investigation-20261102`.

- Ring512B:2.217,5ns/op; fila outbound+cópia29,5ns/op; baseline de2cópias+2locks30,5ns/op. O ring atual usa módulo por byte; não extrapolar esse resultado para um ring por blocos.
- Objeto24B:new2,7ns/op, pool44,6ns/op. Payload2048B:new25,3ns/2096B, pool+limpeza64,7ns/0B. Pool reduziu Gen0, mas custou mais CPU nos casos medidos.
- Escritor512B:sem pool1272B/op, PacketPool536B/op; Gen0 por100.000operações7→3. Acima de2048B não houve economia por causa do limite de retenção. Isso não autoriza remover o pool existente sem medir GC/p95/p99 em carga real.
- `PacketStream.Replace` sempre cria outro array, mesmo com capacidade suficiente. Alugar o wrapper continua deixando cópias; reduzir cópias na entrada merece prioridade sobre outro pool.

## Framing de entrada — pendente

Probe isolado usa PacketFactory/EncDec reais e conta a chegada ao dispatcher por opcodes desconhecidos, sem gameplay/banco. Ambos os pacotes12B foram controles positivos isolados. Dois quadros24B na mesma chamada geraram1despacho (esperados2); um quadro12B em6+6 gerou0 (esperado1), com `Packet too small.`.

`TcpGameServer.ProcessReceive`→`GameProtocol.OnReceive`→`GamePacketProcessor.ProcessAsync` não acumula leituras nem percorre todos os quadros; corta para o primeiro tamanho declarado. Prova de caracterização em `artifacts/pool-framing-probe-20261102/results.json`. Não mediu ocorrência em tráfego real do cliente e não implementou correção.

Um acumulador por sessão é candidato concreto para esse contrato. Comparar ring por blocos com buffer linear de índices; antes cobrir cabeçalho partido, fragmentação, coalescência, prefixo encaminhado opcional, limites, overflow, EOF e ordem. O ring atual não tem Peek nem retirada exata de quadro.

Na saída, manter OutboundPacketQueue, fronteiras/seeds e ownership dos arrays até completar todos os envios parciais. `GetBytes()` destaca o payload antes de devolver o escritor; arrays de broadcast podem ser compartilhados. Não retornar buffers alugados antes do último consumidor assíncrono.

Relatório completo: `C:\Projetcts\aika-og\docs\operations\RINGBUFFER-OBJECTPOOL-REVIEW-2026-11-02.md`, com fontes oficiais, tabelas, reprodução, decisões por local e limites dos microbenchmarks.
