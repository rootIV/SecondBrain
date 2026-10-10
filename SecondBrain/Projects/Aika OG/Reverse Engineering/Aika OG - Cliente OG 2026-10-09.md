---
tags:
  - project/aika-og
  - reverse-engineering
  - protocol
updated: 2026-10-09
---

# Aika OG - Cliente OG 2026-10-09

Cliente lido: `D:\aika\Aika OG\AikaClient.exe`. SHA-256 `7eca8e1e6573dc439cc803ef6cafe91aaca53e6c60d4b3bfd82ab267a7ad81aa`. Workspace atual: `C:\Projetcts\aika-og`.

Relatório detalhado e evidências: `docs/reverse-engineering/CLIENT-RESEARCH.md`, `artifacts/client-analysis`, `artifacts/client-tables`, `artifacts/client-resources` e projeto Ghidra `artifacts/ghidra-projects/AikaOGClient.gpr`.

## Contratos confirmados

- Crypto TCP: 512 bytes em `0070efe0` iguais à tabela do servidor; envio `00464ee0`, recepção `00464c30`. 2.568 assertions executam bytes x86 em Unicorn. Opcode em 6/uint16; tamanho 12–0x5fff; copiar somente DWORDs causa perda de cauda em tamanho sem alinhamento. Evitar seed consecutiva repetida; respeitar status 1/2/4 mesmo com ponteiro não nulo. Nenhuma mudança em EncDec/protocolo do servidor.
- Dispatch S2C: JFieldScene `004bfc40`, JLoginScene `005a90b0`, JSelCharScene `005c0d00`; chamadas via slot +0x20. Catálogo: 140 casos explícitos de campo, 163 casos/condições totais. Não comparar diretamente com PacketDispatcher C2S como se fossem a mesma direção.
- Tabelas Item/Skill: transformação por byte com índice global no payload, envelope 12, footer cru 4. Skill real tem stride 720, não 716. Checksum e recálculo estão em [[Aika OG - MasterEditor File Crypto]].
- Quest: 7.168×2.696, Skill, sem envelope/footer. Dialog: 10.940×5.508, Skill; leitura pontual usa offset absoluto id×5508. PI: 6.000×376, Item, footer cru.
- Recipe: 3.000×92 Skill; Reinforce2: 2.880×128 Skill; SetItem: 1.024×216 Item/footer; RandItem: 4.000×180 sem crypto (todo zerado); PackItem: 5.000×90 sem crypto.
- Upgrade BinEditor: [[Aika OG - BinEditor Sessoes e Seguranca]]. SetItem checksum emulado escalar/SIMD/reference, offsets 64–215; stored `961fabe7`, calculado `961fae19`. Decoder JIT comparado integralmente em 16 imagens; associação ID/atlas inferida, não definitiva.
- MN: 4.096×128; subtração do índice do byte, sem chave. MM: 1.024×520, sem crypto; NH: 80×7876 sem crypto; MobPos: 4.096×416 sem crypto. Campos e autoridade do servidor exigem evidência específica.
- SL: subtrair i%5; sete grupos de 32 slots×72. Offset 32 contém IPv4 derivado do host, não porta. Host strings locais coexistem com IPv4s antigos. Nation.bin é seletor de locale/build (`E0010404`), não nação do personagem.
- HGT/ATT de chunk: 256×256 words/131072 bytes sem header; HGT consumido como int16 com sinal. World HGT separado: DWORD + 0x2000000 bytes. Escala/eixos/flags completos ainda não confirmados.
- JIT: 11.910 arquivos auditados; comuns BC1/2/3 e raw BGR(A), três variantes separadas. JT41 permanece codec inferido pelo conversor local; AKM/MS3/MSH/AN2/BON incompletos.

## Caveats e verificação

- MakeItems possui 26.000×52 bytes; loader solicita 31.000×52. Não importar cauda ausente como válida.
- Checksum nativo Item/Skill/PI diverge do footer armazenado. Esta hash tem JMP incondicional após comparações; achado observado, nenhum patch aplicado. Não extrapolar para outros checks/builds.
- 15 tabelas extraídas com 47 checks; recursos 355. Upgrade editor: 16 formatos incluindo SL, 65 checks sintéticos e testes de round trip/edição/save/reopen/preservação em arquivos reais; checksum nativo 20. Original somente lido; sem sessão do jogo, tráfego externo, bypass ou mudança nos servidores.
- Python isolado/JDK portátil no workspace. Ghidra launch.properties tem override antigo inválido; resolver JAVA_HOME por comando, sem editar instalação global.
- Relacionar novas descobertas aos hashes e offsets; C decompilado pode perder SIMD e convenções thiscall. Confirmar aritmética no assembly/emulação antes de nomear campos.

Relacionado: [[Aika OG - MOC]], [[Aika OG - PacketDispatcher e Protocolo]], [[Aika OG - Sistema de Auth]].
