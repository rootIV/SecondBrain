---
title: Preferencias de Engenharia e Reverse Engineering
tags:
  - second-brain
  - governance
  - engineering
  - reverse-engineering
updated: 2026-10-14
---

# Preferencias de Engenharia e Reverse Engineering

Relacionadas: [[Second Brain - MOC]], [[Knowledge Operating Model]], [[ReverseEngineering]], [[Aika OG - Referencias Externas AikaEmu e Delphi]].

## Origem e alcance

Preferencias explicitas do usuario registradas em 2026-10-14. Aplicam-se ao trabalho de engenharia e ao uso de referencias, incluindo projetos legados e analises no Ghidra/x64dbg.

## Avaliacao critica das referencias

- Referencias podem ajudar e funcionar, mas isso nao demonstra qualidade da implementacao. Avaliar o merito tecnico, sem presumir competencia ou incompetencia dos autores.
- Conferir necessidade da solucao, corretude, algoritmos e estruturas de dados, complexidade, desempenho, seguranca, clareza, manutencao e aderencia aos contratos do projeto.
- Sempre que houver melhoria justificavel, preferir a implementacao mais simples e correta, com boas praticas de programacao e engenharia de software. Reutilizar recursos existentes quando forem adequados.
- Nao copiar automaticamente hardcodes, TODOs, duplicacoes, algoritmos ineficientes ou arquitetura de uma referencia. Separar evidencias de formato/comportamento das escolhas de implementacao.
- Otimizar com beneficio demonstravel ou problema de complexidade identificado; medir quando a justificativa depender de desempenho. Evitar complexidade especulativa e abstracoes sem necessidade.
- Preservar contratos e comportamentos esperados. Verificar mudancas com testes, capturas ou cliente real conforme o risco; referencias isoladas nao comprovam compatibilidade binaria.

## Nomes durante reverse engineering

- Quando houver evidencia suficiente, renomear funcoes no projeto de analise do Ghidra e atribuir labels descritivos aos enderecos correspondentes no x64dbg.
- Salvar as alteracoes no projeto/database de analise quando a ferramenta permitir, e verificar a persistencia. Registrar limitacoes quando o acesso disponivel nao permitir salvar.
- Preservar nomes originais significativos. Para nomes automaticos como `FUN_...` ou `sub_...`, escolher um nome coerente com o comportamento observado, usando comentarios para a evidencia.
- Marcar nomes inferidos como provisorios, por exemplo `Candidate_...`, e registrar a hipotese. Nao apresentar inferencia como funcao confirmada.
- Manter rastreabilidade: binario/build ou hash, modulo, RVA/endereco, nome anterior, novo nome, evidencia e grau de confianca. Usar modulo+RVA para evitar confusao por ASLR ou outra build.
- Renomear simbolos/labels de analise nao requer alterar o executavel. Separar esse trabalho de qualquer patch no binario.

## Limite da verificacao nesta interacao

Foi registrada a preferencia; nenhuma funcao foi renomeada nesta interacao. A consulta de sessoes retornou nenhuma instancia ativa do x64dbg; nenhum projeto Ghidra foi inspecionado.
