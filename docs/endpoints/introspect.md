#  Introspect
Introspect is used to retrieve user data associated with an access token.

## Usage

### Parameters
- `access_token` (required): The access token for the associated user.

### Example Usage
```ruby
  client = SignInService.client

  access_token access_token = "your_access_token"

  response = client.introspect(access_token: access_token)
```

### Handling Responses
The `introspect` method returns a Faraday::Response object.
The response body contains user data in JSON format.

```ruby
  response.body
```
```json
  {
  "data": {
    "id": "",
    "type": "users",
    "attributes": {
      "uuid": "uuid",
      "first_name": "first",
      "middle_name": null,
      "last_name": "last",
      "birth_date": "1950-01-01",
      "email": "email@email.com",
      "gender": "M",
      "ssn": "ssn",
      "birls_id": "birls-id",
      "authn_context": "authn_context",
      "icn": "icn",
      "edipi": "edipi",
      "active_mhv_ids": [],
      "sec_id": "sec_id",
      "vet360_id": "vet360_id",
      "participant_id": "participant_id",
      "cerner_id": null,
      "cerner_facility_ids": [],
      "idme_uuid": "idme_uuid",
      "vha_facility_ids": [],
      "id_theft_flag": false,
      "verified": true,
      "logingov_uuid": "logingov_uuid"
    }
  }
}
```
