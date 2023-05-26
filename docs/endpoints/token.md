# Token
The Token Endpoint is responsible for exchanging an authorization code for session tokens.

## Usage

### Parameters

- `code` (required): The code received from the authorize callback.
- `code_verifier` (required): The string stored client-side from the code_challenge.

### Example

```ruby
  client = SignInService.client

  # Assuming you have a valid authorization code and code_verifier
  code = "your_authorization_code"
  code_verifier = "your_code_verifier"

  response = client.get_token(code: code, code_verifier: code_verifier)
```

## Handling Responses
The `get_token` method returns a Faraday::Response object.

### `:cookie` auth type
Tokens are returned in the `Set-Cookie` headers

```ruby
  response.headers['set-cookie']

  # vagov_access_token=..., vagov_refresh_token=..., vagov_anti_csrf_token=..., vagov_info_token=...
```

### `:api` auth type
Tokens are returned in the response body

```ruby
  JSON.parse(response.body)

  # {
  #   "data": {
  #     "access_token": "<accessTokenHash>", // JWT eyJhbGci0... etc
  #     "refresh_token": "<refreshTokenHash>", // v1:secure+data+AZX9...
  #     "anti_csrf_token": "<antiCsrfTokenHash>" // be5aac9...
  #   }
  # }
```
