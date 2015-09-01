channeladvisor2
===

[ivan's](https://github.com/seapunk) complete rewrite of the [node-channeladvisor](https://github.com/wankdanker/node-channeladvisor) library

---

This is a wrapper around the ChannelAdvisor SOAP API.

While it is pretty simple to use the `soap` module to make SOAP calls to
ChannelAdvisor, there is some boilerplate for setting up the clients which
this project aims to eliminate.


```coffeescript

channeladvisor = require('channeladvisor2')

opts =
    developerKey: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    password: "Password!123"

channeladvisor.create opts, (err, ca) ->
    ca.AdminService.GetAuthorizationList (err, result) ->
        console.log result

```

install
---

```bash
npm install channeladvisor2
```

api
---

The complete documentaion of ChannelAdvisor's SOAP API is available at the
[ChannelAdvisor Developer Network (CADN)](http://developer.channeladvisor.com/display/cadn/ChannelAdvisor+Developer+Network).

This module exposes each service as a child object of a `ChannelAdvisor`
instance. These are the implemented services:

* AdminService
* FulfillmentService
* InventoryService
* ListingService
* MarketplaceAdService
* OrderService
* ShippingService
* CartService
* StoreService (**DEPRECATED**, according to CADN)
* TaxService (**DEPRECATED**, according to CADN)

Each service object contains methods for each operation that is described in
the CADN documentation. The methods are named exactly as they appear in the documentation.
For example:

* AdminService
  * GetAuthorizationList
  * RequestAccess
  * Ping

Each method takes an optional `args` object and a required callback function.

Example:

```coffeescript
opts =
    localID: 9999999

ca.AdminService.RequestAccess opts, (err, result) ->
    console.log result
```

If the operation does not require any arguments then you may just specify the
callback function.

Example:

```coffeescript
ca.InventoryService.Ping (err, result) ->
    console.log result
```