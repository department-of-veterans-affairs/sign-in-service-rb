# Logout
The Logout Endpoint is responsible for logging out the user and revoking tokens.
## Usage

##### Parameters

- `access_token` (required): The access token for the associated user.
- `anti_csrf_token` (optional): An optional token for client-side CSRF protection.

##### Example Usage

```ruby
  client = SignInService.client

  access_token = "your_id_token_hint"
  anti_csrf_token = "your_anti_csrf_token" # Optional

  response = client.logout(access_token: access_token, anti_csrf_token: anti_csrf_token)
```

#### Handling Responses
The `logout` method returns a Faraday::Response object.

In the case of successful logout from login.gov you can expect an HTTP status code of 302. You will need to
redirect to the location header and expect a callback

```ruby
  redirect_to response.headers['location'] if response.status == 302
```

In the case of id.me you will receive a 200 with an empty body
