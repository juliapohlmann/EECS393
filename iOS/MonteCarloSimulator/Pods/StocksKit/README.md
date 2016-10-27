# StocksKit

[![Version](https://img.shields.io/cocoapods/v/StocksKit.svg?style=flat)](http://cocoapods.org/pods/StocksKit)
[![License](https://img.shields.io/cocoapods/l/StocksKit.svg?style=flat)](http://cocoapods.org/pods/StocksKit)
[![Platform](https://img.shields.io/cocoapods/p/StocksKit.svg?style=flat)](http://cocoapods.org/pods/StocksKit)

A framework for fetching stock information and exchange rates from the Yahoo API.

# Usage

Fetching one or more quotes is straightforward:

```
Quote.fetch(["MSFT","AAPL"]) { result in

  switch result {
    case .Success(let quotes):
        // do something with the quotes
        break
    case .Failure(let error):
        // handle the error
        break
  }

}.resume()

```

As is fetching one or more exchange rates:

```
ExchangeRate.fetch(["USDGBP","GBPEUR"]) { result in

  switch result {
    case .Success(let exchangeRates):
        // do something with the exchange rates
        break
    case .Failure(let error):
        // handle the error
        break
  }

}.resume()

```

# Requirements

iOS 8.0 / Mac OS 10.10

## Installation

StocksKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "StocksKit"
```

## Author

Alexander Edge, alex@alexedge.co.uk

## License

StocksKit is available under the MIT license. See the LICENSE file for more info.
