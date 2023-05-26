# Authorize

The Authorize Endpoint is responsible for initiating the OAuth 2.0 authorization flow. You can generate an authorization URL, or use the authorization endpoint.

## Generating Authorize URL
The `authorize_url` method is used to generate a URL.

### Parameters

- `type` (required): The CSP type.
- `acr` (required): Level of authentication requested.
- `code_challenge` (required): Used by SignInService to verify requests.
- `state` (optional): Optional string that can be returned in the callback.

### Example

```ruby
   client = SignInService.client

   type = "your_csp_type"
   acr = "your_acr"
   code_challenge = "your_code_challenge"
   state = "your_state" # Optional

   auth_url = client.authorize_uri(type: type, acr: acr, code_challenge: code_challenge, state: state)
```

## Handling Responses
The `authorize_uri` method returns an authorization URL as a string. You can use this URL to redirect users to the SignInService authorization page.

```ruby
  redirect_to uri
```

## Authorize Endpoint
The `authorize` method is used to interact with the Authorize Endpoint

### Parameters
- `type` (required): The CSP type.
- `acr` (required): Level of authentication requested.
- `code_challenge` (required): Used by SignInService to verify requests.
- `state` (optional): Optional string that can be returned in the callback.

### Example Usage
```ruby
  client = SignInService.client

  # Required parameters
  type = "your_csp_type"
  acr = "your_acr"
  code_challenge = "your_code_challenge"
  state = "your_state" # Optional

  response = client.authorize(type: type, acr: acr, code_challenge: code_challenge, state: state)
```

## Handling Responses
The `authorize` method returns a Faraday::Response object, which contains an HTML body used to redirect to the CSP

```ruby
  render response.body
```
