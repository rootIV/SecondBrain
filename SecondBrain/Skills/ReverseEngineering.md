# Reverse Engineering

Relacionado: [[Second Brain - MOC]], [[Aika OG - MOC]], [[Aika OG - PacketDispatcher e Protocolo]].

## Uso neste Second Brain

Reverse engineering deve ser usado para interoperabilidade, documentacao de formatos, preservacao de contratos e compreensao tecnica legitima.

## Regras praticas

- Nao implementar bypass de anti-cheat, evasao, abuso ou acesso indevido.
- Documentar estruturas observadas, offsets, opcodes, tamanhos e hipoteses.
- Separar fato observado de inferencia.
- Validar mudancas de protocolo com cliente real quando houver contrato binario.
- Preservar implementacoes sensiveis ate haver evidencia tecnica suficiente.

## Aplicacao por projeto

- Aika OG: preservar `GameProtocol`, `EncDec`, keys, opcodes, packet sizes e layouts. Ver [[Aika OG - MOC]].

## Nomes no Ghidra e x64dbg

Aplicar [[Preferencias de Engenharia e Reverse Engineering]]: renomear funcoes no Ghidra e atribuir labels no x64dbg quando sustentados por evidencia; salvar no projeto/database e verificar persistencia quando possivel. Documentar binario/build, modulo+RVA, nomes anterior/novo, evidencia e confianca. Nomes inferidos devem ser marcados como provisorios; preservar simbolos originais significativos.

## Template minimo de descoberta

- Entrada observada:
- Estrutura inferida:
- Evidencia:
- Hipotese:
- Risco:
- Validacao necessaria:
