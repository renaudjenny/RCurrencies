import Foundation

struct Currency: Codable {
  var code: String
  var rate: Double

  func formattedRatedAmount(baseAmount: Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.currencyCode = self.code
    numberFormatter.usesGroupingSeparator = false
    numberFormatter.currencySymbol = ""

    let value = baseAmount * self.rate
    return numberFormatter.string(from: value as NSNumber) ?? "-"
  }
}
