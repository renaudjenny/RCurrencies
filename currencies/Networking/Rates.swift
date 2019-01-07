import Foundation

struct Rates: Codable {
  var base: String?
  var date: Date?
  var rates: [String: Double]?

  var currencies: [Currency]? {
    return self.rates?.map { (key, value) -> Currency in
      return Currency(code: key, rate: value)
    }
  }
}
