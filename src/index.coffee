soap = require 'soap'
async = require 'async'

exports.create = (options, callback) ->
    client = new ChannelAdvisor options
    client.init (err) ->
        return callback err, client

services =
    "AdminService":         "https://api.channeladvisor.com/ChannelAdvisorAPI/v7/AdminService.asmx?WSDL"
    "FulfillmentService":   "https://api.channeladvisor.com/ChannelAdvisorAPI/v7/FulfillmentService.asmx?WSDL"
    "InventoryService":     "https://api.channeladvisor.com/ChannelAdvisorAPI/v7/InventoryService.asmx?WSDL"
    "ListingService":       "https://api.channeladvisor.com/ChannelAdvisorAPI/v7/ListingService.asmx?WSDL"
    "MarketplaceAdService": "https://api.channeladvisor.com/ChannelAdvisorAPI/v7/MarketplaceAdService.asmx?WSDL"
    "OrderService":         "https://api.channeladvisor.com/ChannelAdvisorAPI/v7/OrderService.asmx?WSDL"
    "ShippingService":      "https://api.channeladvisor.com/ChannelAdvisorAPI/v7/ShippingService.asmx?WSDL"
    "CartService":          "https://api.channeladvisor.com/ChannelAdvisorAPI/v7/CartService.asmx?WSDL"
    "StoreService":         "https://api.channeladvisor.com/ChannelAdvisorAPI/v6/StoreService.asmx?WSDL"
    "TaxService":           "https://api.channeladvisor.com/ChannelAdvisorAPI/v6/TaxService.asmx?WSDL"


class ChannelAdvisor
    constructor: (@options) ->
        @initialized = false

    init: (callback) ->
        delete @init

        svcarr = []
        for serviceName, serviceURL of services
            svcarr.push
                name: serviceName
                url: serviceURL

        q = async.queue (service, done) =>
            soap.createClient service.url, (err, client) =>
                if err
                    q.kill()
                    return callback err
                header =
                    APICredentials:
                        DeveloperKey: @options.developerKey
                        Password: @options.password
                client.addSoapHeader header, '', 'tns', 'http://api.channeladvisor.com/webservices/'
                @[service.name] = client
                done()
        q.push svcarr
        q.drain = () =>
            @initialized = true
            return callback()