# Property service
Ruby on Rails app with one endpoint, that return properties list within 5 km from given coordinates. Using:
 - Ruby version - 3.0.2
 - Rails version - 6.1.4

### Launch
1. git clone git@github.com:denis-mironov/property_service.git
2. rake db:create
3. psql property_service_development < db/dumps/properties.sql
4. rake db:migrate

### Run specs
 - rspec spec

# Endpoints
### GET `/properties`
Get properties within 5 km

**Incoming params:**

Name	         | Required | Type     | Description
---------------|----------|----------|--------------------
lat            | Yes      | float    | Latitude
lng            | Yes      | float    | Longitude
property_type  | Yes      | string   | Type of property (apartment / single_family_house)
marketing_type | Yes      | string   | Type of offer (sell / rent)

```json
{
  "lng": 13.4236807,
  "lat": 52.5342963,
  "property_type": "apartment",
  "marketing_type": "sell"
}
```

**Response:**

When response is not empty, it will return array with properties:
```json
[
    {
        "zip_code": "10115",
        "city": "Berlin",
        "street": null,
        "house_number": null,
        "lng": "13.38815072",
        "lat": "52.53177508",
        "price": "269700.0"
    },
    {
        "zip_code": "10115",
        "city": "Berlin",
        "street": null,
        "house_number": null,
        "lng": "13.3791152",
        "lat": "52.5304903",
        "price": "622500.0"
    }
]
```

When response is empty, it will return empty array:
```json
[]
```

**Errors:**

Code | Message
-----| --------
422  | Latitude is required, Longitude is required, Property type is required, Marketing type is required, Latitude is invalid, Longitude is invalid, Property type is invalid, Marketing type is invalid
