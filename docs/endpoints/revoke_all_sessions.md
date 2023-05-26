# Revoke All Sessions
The Revoke All Sessions Endpoint is responsible for revoking all sessions associated with a user.

## Usage

##### Parameters

- `access_token` (required): The access token associated with the user's session.

##### Example Usage

```ruby
  client = SignInService.client

  access_token access_token = "your_access_token"

  response = client.revoke_all_sessions(access_token: access_token)
```

#### Handling Responses

The `revoke_all_sessions` method returns a Faraday::Response object. If successful, the response contains an HTTP status code of 200.
