# TokenProtectorService

Relacionado: [[Auth]], [[AuthService]], [[GoogleAuthService]], [[Backend]].

Arquivo: `lotojogo-back-end/Services/TokenProtectorService.cs`.

## Responsabilidade

Criptografa e descriptografa tokens sensiveis do Google OAuth antes/depois da persistencia.

## Implementacao

Usa ASP.NET Core Data Protection:

```text
IDataProtectionProvider.CreateProtector("google-oauth-tokens")
```

## Metodos

- `Protect(string plaintext)`: protege o token antes de salvar.
- `Unprotect(string ciphertext)`: recupera o token original quando necessario.

## Configuracao relacionada

`Program.cs` configura Data Protection com:

- persistencia de chaves em `DataProtection:KeyPath` ou `./keys`;
- `ApplicationName = lotojogo-api`;
- lifetime de 90 dias;
- DPAPI em Windows.
