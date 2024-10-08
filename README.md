Note: This repo is managed by the VA.gov Identity team. Please reference our main product page here for contact information and questions.

# SignInService Ruby Client

The SignInService Ruby client provides a simple and convenient way to interact with the SignInService API for handling OAuth flows.

## Installation

Add gem to your Gemfile
```ruby
gem 'sign_in_service', :git => 'git://github.com/department-of-veterans-affairs/sign-in-service-rb.git'
```

```bash
bundle install
```
## Client Configuration

Configure the SignInService client with your base URL, client ID, and authentication type in an initializer:

```ruby
require 'sign_in_service'

SignInService::Client.configure do |config|
  config.base_url = 'https://your_sign_in_service_url'
  config.client_id = 'your_client_id'
  config.auth_type = :cookie # or :api
end
```

### Auth Types: Cookie vs API
The SignInService client supports two authentication types: Cookie and API.

#### Cookie Authentication
With Cookie authentication, tokens are returned in the `Set-Cookie` headers of the response. This approach is typically used in web applications where cookies can be stored and managed directly by the browser.

#### API Authentication
With API authentication, tokens are returned in the response body. This approach is typically used in non-web applications or scenarios where the application handles the tokens directly, such as mobile apps, desktop apps, or server-side scripts.

### Endpoints

#### Authorization
- [Authorize](docs/endpoints/authorize.md) - Initiate the OAuth flow
- [Token](docs/endpoints/token.md) - Exchange authorization code for session tokens

#### Session Management
- [Refresh](docs/endpoints/refresh.md) - Refresh session tokens.
- [Logout](docs/endpoints/logout.md) - Log out the user and revoke tokens.
- [Revoke Token](docs/endpoints/revoke_token.md) - Revoke a sessions tokens.
- [Revoke All Sessions](docs/endpoints/revoke_all_sessions.md) - Revoke all sessions associated with a user


## STS Configuration

```ruby

SignInService::Sts.configure do |config|
  config.base_url = 'https://api.va.gov' # Sign-in service URL
  config.service_account_id = 'your_client_id'
  config.issuer = 'your_client_secret',
  config.scopes = ["https://api.va.gov/v0/some-path"]
  config.user_attributes = ['icn'] # optional
  config.private_key_path = 'path/to/private_key.pem'
end
```

Or create a new instance of the STS client with the configuration (overrides the global configuration):

```ruby
sts_client = SignInService::Sts.new(
  base_url: 'https://api.va.gov',
  service_account_id: 'your_client_id',
  issuer: 'your_client_secret',
  scopes: ["https://api.va.gov/v0/some-path"],
  user_attributes: ['icn'], # optional
  private_key_path: 'path/to/private_key.pem'
)
```

#### Token - `/v0/sign_in/token`

When requesting a token you need to pass in a user_identifier to be used as the subject of the token. This can be an ICN, email, or any other unique identifier.

```ruby
sts = SignInService::Sts.new(user_identifier: '1234567890') # And other configuration options not in the global configuration

token = sts.request_token
```
