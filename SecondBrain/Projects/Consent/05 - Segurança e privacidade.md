# Segurança e privacidade

## Posicionamento

Handshake lida com interações potencialmente sensíveis. A postura correta é privacidade por padrão, coleta mínima e segurança primeiro.

## Fundamentos

- JWT para autenticação.
- Refresh token via cookie HttpOnly, Secure e SameSite.
- CORS restrito a origens configuradas.
- Rate limiting.
- Security headers.
- Sanitização e validação de entrada.
- DTOs para contratos públicos.

## Regras de produto

O sistema não deve:

- criar score moral
- criar ranking íntimo
- exibir quantidade de parceiros
- expor histórico privado
- classificar pessoas sexualmente
- transformar safety mode em vigilância invasiva

## LGPD e minimização

- Coletar apenas dados necessários ao acordo.
- Permitir exclusão e expiração.
- Preparar retenção configurável.
- Evitar metadados sensíveis desnecessários.
- Separar payload sensível de dados públicos.

## Hardening futuro

- refresh tokens rotativos persistidos
- CSRF real para mutations baseadas em cookie
- criptografia de payloads sensíveis
- criptografia de anexos
- jobs de retenção e expiração
- trilhas auditáveis com redaction de dados sensíveis

## Safety Mode

Safety Mode deve ser opcional, contextual e transparente.

MVP:

- contato de confiança
- timer/check-in manual
- SOS simulado
- eventos auditáveis

Futuro:

- localização temporária
- mensagens automáticas
- expiração de compartilhamento
- regras de consentimento específicas para cada recurso

