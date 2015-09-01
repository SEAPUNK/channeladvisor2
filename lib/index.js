(function() {
  var ChannelAdvisor, async, services, soap;

  soap = require('soap');

  async = require('async');

  exports.create = function(options, callback) {
    var client;
    client = new ChannelAdvisor(options);
    return client.init(function(err) {
      return callback(err, client);
    });
  };

  services = {
    "AdminService": "https://api.channeladvisor.com/ChannelAdvisorAPI/v7/AdminService.asmx?WSDL",
    "FulfillmentService": "https://api.channeladvisor.com/ChannelAdvisorAPI/v7/FulfillmentService.asmx?WSDL",
    "InventoryService": "https://api.channeladvisor.com/ChannelAdvisorAPI/v7/InventoryService.asmx?WSDL",
    "ListingService": "https://api.channeladvisor.com/ChannelAdvisorAPI/v7/ListingService.asmx?WSDL",
    "MarketplaceAdService": "https://api.channeladvisor.com/ChannelAdvisorAPI/v7/MarketplaceAdService.asmx?WSDL",
    "OrderService": "https://api.channeladvisor.com/ChannelAdvisorAPI/v7/OrderService.asmx?WSDL",
    "ShippingService": "https://api.channeladvisor.com/ChannelAdvisorAPI/v7/ShippingService.asmx?WSDL",
    "CartService": "https://api.channeladvisor.com/ChannelAdvisorAPI/v7/CartService.asmx?WSDL",
    "StoreService": "https://api.channeladvisor.com/ChannelAdvisorAPI/v6/StoreService.asmx?WSDL",
    "TaxService": "https://api.channeladvisor.com/ChannelAdvisorAPI/v6/TaxService.asmx?WSDL"
  };

  ChannelAdvisor = (function() {
    function ChannelAdvisor(options1) {
      this.options = options1;
      this.initialized = false;
    }

    ChannelAdvisor.prototype.init = function(callback) {
      var q, serviceName, serviceURL, svcarr;
      delete this.init;
      svcarr = [];
      for (serviceName in services) {
        serviceURL = services[serviceName];
        svcarr.push({
          name: serviceName,
          url: serviceURL
        });
      }
      q = async.queue((function(_this) {
        return function(service, done) {
          return soap.createClient(service.url, function(err, client) {
            var header;
            if (err) {
              q.kill();
              return callback(err);
            }
            header = {
              APICredentials: {
                DeveloperKey: _this.options.developerKey,
                Password: _this.options.password
              }
            };
            client.addSoapHeader(header, '', 'tns', 'http://api.channeladvisor.com/webservices/');
            _this[service.name] = client;
            return done();
          });
        };
      })(this));
      q.push(svcarr);
      return q.drain = (function(_this) {
        return function() {
          _this.initialized = true;
          return callback();
        };
      })(this);
    };

    return ChannelAdvisor;

  })();

}).call(this);
