# Modelo de dados

## Agregado central

`Agreement` é o agregado central. Ele representa uma interação estruturada entre participantes e registra uma fotografia temporal do entendimento entre as partes.

## Entidades principais

### Agreement

- Id
- Type
- Status
- CreatedAt
- UpdatedAt
- ExpiresAt
- OwnerId

### AgreementParticipant

- Id
- AgreementId
- UserId
- Status

### AgreementTerm

- Id
- AgreementId
- Label
- Value

### AgreementTermDecision

- Id
- AgreementTermId
- ParticipantId
- Decision
- CreatedAt

### AgreementAttachment

- Id
- AgreementId
- FileUrl
- FileType

### AgreementEvent

- Id
- AgreementId
- EventType
- Timestamp
- Metadata

### AgreementTemplate

- Id
- OwnerId
- Type
- Name
- Payload
- CreatedAt
- UpdatedAt

### SafetyEvent

- Id
- AgreementId
- EventType
- Timestamp
- Metadata

### ApplicationUser

Usuário da aplicação baseado em ASP.NET Identity, com perfil mínimo.

## Status de Agreement

- Draft
- PendingReview
- Active
- Changed
- Withdrawn
- Expired
- Deleted

## Decisões de participante

- Pending
- Agreed
- Disagreed
- Negotiating
- Withdrawn

## Regras

- Todo Agreement deve ter dono.
- Mudanças relevantes geram evento.
- Decisões dos participantes influenciam o status do Agreement.
- Soft delete deve preservar auditoria.
- Exclusão permanente deve tornar o item indisponível sem apagar trilhas auditáveis essenciais.

