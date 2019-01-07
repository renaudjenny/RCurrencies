import UIKit

class CurrencyTableViewCell: UITableViewCell {
  @IBOutlet weak var countryFlag: UILabel!
  @IBOutlet weak var countryCode: UILabel!
  @IBOutlet weak var currencyName: UILabel!
  @IBOutlet weak var amountTextField: UITextField!

  func populate(with currency: Currency, baseAmount: Double = 0.0) {
    self.countryFlag.text = currency.flag
    self.countryCode.text = currency.code
    self.currencyName.text = currency.name
    self.amountTextField.text = currency.formattedRatedAmount(baseAmount: baseAmount)
  }
}

private extension Currency {
  var name: String {
    switch self.code {
    case "CAD": return "Canadian Dollar"
    case "CZK": return "Czech Koruna"
    case "EUR": return "Euro"
    case "MXN": return "Mexican Peso"
    case "KRW": return "Won"
    case "ISK": return "Iceland Krona"
    case "HUF": return "Forint"
    case "TRY": return "Turkish Lira"
    case "BGN": return "Bulgarian Lev"
    case "USD": return "US Dollar"
    case "GBP": return "Pound Sterling"
    case "PLN": return "Zloty"
    case "NZD": return "New Zealand Dollar"
    case "HKD": return "Hong Kong Dollar"
    case "HRK": return "Croatian Kuna"
    case "CHF": return "Swiss Franc"
    default: return self.code
    }
  }

  var flag: String {
    switch self.code {
    case "CAD": return "🇨🇦"
    case "CZK": return "🇨🇿"
    case "EUR": return "🇪🇺"
    case "MXN": return "🇲🇽"
    case "KRW": return "🇰🇷"
    case "ISK": return "🇮🇸"
    case "HUF": return "🇭🇺"
    case "TRY": return "🇹🇷"
    case "BGN": return "🇧🇬"
    case "USD": return "🇺🇸"
    case "GBP": return "🇬🇧"
    case "PLN": return "🇵🇱"
    case "NZD": return "🇳🇿"
    case "HKD": return "🇭🇰"
    case "HRK": return "🇭🇷"
    case "CHF": return "🇨🇭"
    default: return "🏳"
    }
  }
}
