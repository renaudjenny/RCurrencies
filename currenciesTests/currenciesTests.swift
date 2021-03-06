import XCTest
@testable import currencies

class currenciesTests: XCTestCase {
  func testDecodeRevolutRates() {
    let stream =
    """
      {"base":"EUR","date":"2018-09-06","rates":{"AUD":1.6147,"BGN":1.9537,"BRL":4.7867,"CAD":1.5322,"CHF":1.1263,"CNY":7.9366,"CZK":25.687,"DKK":7.4487,"GBP":0.89728,"HKD":9.1226,"HRK":7.4261,"HUF":326.14,"IDR":17305.0,"ILS":4.1661,"INR":83.628,"ISK":127.66,"JPY":129.41,"KRW":1303.4,"MXN":22.341,"MYR":4.8069,"NOK":9.7655,"NZD":1.7614,"PHP":62.525,"PLN":4.3137,"RON":4.6335,"RUB":79.49,"SEK":10.579,"SGD":1.5983,"THB":38.089,"TRY":7.62,"USD":1.1622,"ZAR":17.804}}
    """
    XCTAssertNoThrow(
      try RatesRepositoryRevolut().jsonDecoder.decode(Rates.self, from: stream.data(using: .utf8)!)
    )
  }

  func testCurrencyFormatRatedAmount() {
    let baseAmount = 100.0
    let jpyCurrency = Currency(code: "JPY", rate: 129.23)
    var ratedAmount = baseAmount * jpyCurrency.rate
    XCTAssertEqual(jpyCurrency.formatted(amount: ratedAmount), "12923")

    let czkCurrency = Currency(code: "CZK", rate: 25.687)
    ratedAmount = baseAmount * czkCurrency.rate
    XCTAssertEqual(czkCurrency.formatted(amount: ratedAmount), "2568.70")
  }

  func testCurrencyConvertAmountStringToDouble() {
    let czkCurrency = Currency(code: "CZK", rate: 25.687)
    let stringAmount = "180.42"
    XCTAssertEqual(czkCurrency.double(from: stringAmount), 180.42)
  }

  func testUpdateListOfCurrencyWithNewRates() {
    let newRates = Rates(base: "EUR", date: Date(), rates: ["JPY": 129.23, "CZK": 25.687])
    var currencies = [
      Currency(code: "EUR", rate: 1.0),
      Currency(code: "JPY", rate: 123.19)
    ]
    currencies.update(rates: newRates)
    XCTAssertEqual(currencies[1].rate, 129.23)
    XCTAssertEqual(currencies.count, 3)
    XCTAssertEqual(currencies[2].code, "CZK")
    XCTAssertEqual(currencies[2].rate, 25.687)
  }
}
