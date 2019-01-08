import Foundation

struct Currency: Codable {
  var code: String
  var rate: Double

  var numberFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = self.code
    formatter.usesGroupingSeparator = false
    formatter.currencySymbol = ""
    return formatter
  }

  func formatted(amount: Double) -> String {
    return self.numberFormatter.string(from: amount as NSNumber) ?? "-"
  }

  func double(from string: String) -> Double? {
    return self.numberFormatter.number(from: string) as? Double
  }
}

extension Array where Element == Currency {
  mutating func update(rates: Rates) {
    for currency in rates.currencies ?? [] {
      if let index = self.firstIndex(where: { $0.code == currency.code }) {
        self[index] = currency
      } else {
        self.append(currency)
      }
    }
  }
}
