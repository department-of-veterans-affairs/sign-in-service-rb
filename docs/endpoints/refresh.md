# Refresh Token

The Refresh Token Endpoint is responsible for refreshing session tokens.

## Usage

### Parameters
- `refresh_token` (required): The refresh token associated with the user's session.
- `anti_csrf_token` (optional): An optional token for client-side CSRF protection.

### Example Usage
``` ruby
  client = SignInService.client

  refresh_token = "your_refresh_token"
  anti_csrf_token = "your_anti_csrf_token" # Optional

  response = client.refresh_token(refresh_token: refresh_token, anti_csrf_token: anti_csrf_token)
```

## Handling Responses
The `refresh_token` method returns a Faraday::Response object.

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
