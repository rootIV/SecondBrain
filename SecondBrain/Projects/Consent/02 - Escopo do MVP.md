# Escopo do MVP

## Objetivo do MVP

Entregar uma versão utilizável do Handshake que permita criar, revisar, confirmar, acompanhar e auditar acordos mútuos, com uma primeira versão do Safety Mode.

## Fora do escopo inicial

- validade jurídica avançada
- assinatura digital oficial
- cartório
- rastreamento real contínuo de localização
- NFC e Bluetooth reais
- criptografia ponta a ponta completa
- score de reputação
- rankings públicos
- rede social

## Funcionalidades essenciais

### Autenticação

- registro
- login
- JWT
- refresh token preparado em cookie seguro
- sessão autenticada no frontend

### Dashboard

Primeira tela útil após login:

- acordos recentes
- ações rápidas
- templates
- status de segurança
- atividade recente

### Agreements

- criação
- listagem
- detalhes
- atualização de status
- decisões de participantes
- histórico de eventos
- soft delete
- restauração
- exclusão permanente lógica

### Tipos de acordo

- Encontro
- Compra e Venda
- Prestação de Serviço
- Empréstimo
- Outro

### Wizard de criação

Fluxo mínimo:

1. Escolher tipo.
2. Preencher termos.
3. Adicionar participante.
4. Revisar resumo.
5. Confirmar.
6. Persistir e auditar.

### Decisões

Participante pode marcar:

- Concordo
- Discordo
- Negociar
- Retirar consentimento

### Safety Mode

Versão inicial:

- ativar/desativar por acordo
- contato de confiança
- check-in manual
- timer simples
- SOS simulado
- timeline de SafetyEvent

### Templates

- criar template a partir de configuração
- listar
- reutilizar
- excluir

## Critérios de aceite

- Todo resultado relevante é persistido.
- Toda ação relevante gera evento.
- O frontend consome API real, com fallback mock apenas se explicitamente justificado.
- DTOs são usados em todos os contratos.
- Estados de loading, vazio e erro existem nas telas principais.
- Testes cobrem os fluxos críticos.

