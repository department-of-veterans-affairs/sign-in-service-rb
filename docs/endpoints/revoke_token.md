# Revoke Token

The Revoke Token Endpoint is responsible for revoking a session.

## Usage

### Parameters

- `refresh_token` (required): The refresh token associated with the user's session.
- `anti_csrf_token` (optional): A token for client-side CSRF protection.

### Example Usage

```ruby
  client = SignInService.client
  refresh_token refresh_token = "your_refresh_token"
  anti_csrf_token = "your_anti_csrf_token" (optional)

  response = client.revoke_token(refresh_token: refresh_token, anti_csrf_token: anti_csrf_token)
```

## Handling Responses
The `revoke_token` method returns a Faraday::Response object. If successful, the response contains an HTTP status code of 200 and an empty body.
