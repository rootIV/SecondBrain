---
tags:
  - project/aika-og
  - quality
  - security
updated: 2026-11-02
---

# Aika OG - Sonar Servidores 2026-11-02

> [!warning] Correção posterior de compatibilidade
> A flexibilização de `urls` foi revertida: o perfil do Visual Studio podia desviar a API da porta8090 e interromper o login. Restaurado `UseUrls("http://*:8090/")`; usuário confirmou login funcionando, com testes de porta/HTTP/TCP. Veja [[Aika OG - Sistema de Auth]] e `docs/operations/LOGIN-PORT-REGRESSION-2026-11-02.md`. O resultado Sonar abaixo é histórico dessa execução; não houve nova análise porque a instância estava desligada.

Relacionado: [[Aika OG - MOC]], [[Aika OG - Sistema de Auth]], [[Knowledge Debt]].

## Evidência e contrato

SonarQube Community Build 26.10.0.133078 e scanner .NET 11.2.1 executados localmente sobre GameServer/TokenServer atuais. Escopo inicial:39.184linhas,76achados(72GameServer/4TokenServer), sem hotspots. Não é uma nova análise publicada no SonarCloud histórico. Relatório auditável: `C:\Projetcts\aika-og\docs\operations\SONAR-SERVERS-2026-11-02.md`; artefatos ignorados em `artifacts/sonar-20261102` e painel loopback `http://127.0.0.1:9000/dashboard?id=aika-og-servers-local`.

Resultado final: gate OK, zero achados abertos; 67 dos 76 iniciais corrigidos em código, sete falsos positivos contextuais e dois riscos legados aceitos. Três apontamentos intermediários adicionais também foram corrigidos. Cobertura nova 84,9% (gate 80% preservado), global 73,0%; duplicação nova 2,0% (limite 3%). Evidências `gate-quality-gate.json`, `gate-issues.json` ([]) e `gate-metrics.json` no diretório de artefatos.

Corrigidos tipos/acessos de coleções privadas, guards, regexes geradas com timeout, parsing de faixas, cancelamento/I/O assíncronos e validação HTTP. StartAsync TCP retornaTask, falha inicial propaga sincronamente e falha tardia de reciclagem é registrada. APIs públicas de coleções e contratos binários preservados. RentSession/ReturnSession são helpers estáticos com callers TCP atualizados.

`AccountAuthenticationService.CheckLogin` foi removido após confirmar que não tinha consumidor nem contrato de interface; login ativo continua por ticket. O MD5 restante no TokenServer é prehash legado anterior ao PBKDF2-SHA256(600.000iterações,salt16,comparação constante), aceito como restrição que exige migração versionada de credenciais/cadastro. Não classificá-lo como falso positivo nem trocar apenas esse hash.

Sete S1244 foram revisados individualmente como falsos positivos de contexto: identidade de movimento, discriminador estático no CSV, Position.Equals/GetHashCode e identidade de taxa de bônus persistida. Não substituir por epsilon indiscriminadamente; isso pode alterar patrulha, identidade de chave hash e renovação de bônus.

HTTP8090 foi mantido por decisão explícita do usuário nesta etapa e seu alerta foi aceito com justificativa, não marcado falso positivo. Permanece risco real enquanto estiver ativo. A opção de respeitar `urls`/`--urls` foi revertida após a regressão de login; uma futura estratégia HTTPS/proxy deve preservar o endpoint ou alterar o contrato de forma coordenada e homologada. Não registrar o transporte como vulnerabilidade corrigida.

## Verificação

Baseline válido GameServer:1.810aprovados/10ignorados(total1.820,12m33s). Suíte completa sobre fontes finais: 1.811 aprovados/10 ignorados (total 1.821,9m53s), sem falhas; depois 14 casos novos focados também passaram separadamente, sem alterar produção. Última suíte TokenServer: 23 aprovados/1 ignorado (total 24), sem falhas. TRX/OpenCover importados com sucesso. Testes adicionais de resultados vazios, cancelamento/reinício, limite de nickname e parsing elevaram a cobertura nova 49,5% → 78,5% → 84,9%, sem baixar o gate.

Saída de testes deve ficar dentro do checkout: testes procuram AikaOG.sln subindo a partir de AppContext.BaseDirectory. Primeiro ensaio com BaseOutputPath fora do repositório gerou1.047falhas de descoberta de Data; é erro do harness, não evidência de regressão. Builds/testes de projetos foram coordenados sequencialmente e com saídas isoladas.

Coletar cobertura após a última alteração de fontes. A remoção de um método após compilar os testes causou `Line 56 is out of range ... (lines: 51)` na importação OpenCover. Regenerar build+cobertura e usar diretório exclusivo da coleta atual; não importar XMLs antigos por um glob amplo nem editar o relatório para ocultar a inconsistência.

Sem implantação, MySQL condicional, handshakeTLS ou homologação em cliente real. Revisão independente não encontrou regressão acionável; não executou falha tardia da reciclagem TCP.
