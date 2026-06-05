# Clean Architecture

Relacionado: [[Second Brain - MOC]], [[Knowledge Operating Model]], [[Architecture]], [[Backend]].

## Uso neste Second Brain

Clean Architecture e uma direcao tecnica recorrente nos projetos, mas deve ser aplicada de forma pragmatica e proporcional ao tamanho de cada base.

## Regras praticas

- Controllers ou endpoints devem ser adaptadores finos.
- Casos de uso e regras de aplicacao devem ficar em services ou handlers de Application.
- Persistencia, rede, arquivos e integrações externas devem ficar em Infrastructure.
- DTOs devem proteger boundaries publicos; entidades de persistencia nao devem sair diretamente pela API.
- Dependencias devem apontar para dentro: dominio e aplicacao nao devem depender de detalhes externos.

## Aplicacao por projeto

- LotoJogo: ver [[Clean Architecture]], [[Architecture]], [[Backend]] e [[Repositories]].
- Aika OG: ver [[Aika OG - Arquitetura Atual]].
- Consent: ver [[03 - Arquitetura e stack]].

## Caveat

Separar projetos fisicos (`Domain`, `Application`, `Infrastructure`, `Api`) so vale quando reduzir acoplamento real. Em projetos menores, uma separacao por pastas bem mantida pode ser suficiente.
