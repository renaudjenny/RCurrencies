import UIKit

class CurrencyTableViewCell: UITableViewCell {
  @IBOutlet weak var countryFlag: UILabel!
  @IBOutlet weak var countryCode: UILabel!
  @IBOutlet weak var currencyName: UILabel!
  @IBOutlet weak var amountTextField: UITextField!

  func populate(with currency: Currency, baseAmount: Double, isBaseCurrency: Bool) {
    self.countryFlag.text = currency.flag
    self.countryCode.text = currency.code
    self.currencyName.text = currency.name
    let amount = isBaseCurrency ? baseAmount : baseAmount * currency.rate
    self.amountTextField.text = currency.formatted(amount: amount)
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
    case "PHP": return "Philippine Peso"
    case "BRL": return "Brazilian Real"
    case "INR": return "Indian Rupee"
    case "AUD": return "Australian Dollar"
    case "RUB": return "Russian Ruble"
    case "ILS": return "New Israeli Sheqel"
    case "IDR": return "Rupiah"
    case "NOK": return "Norwegian Krone"
    case "CNY": return "Yuan Renminbi"
    case "DKK": return "Danish Krone"
    case "ZAR": return "Rand"
    case "SEK": return "Swedish Krona"
    case "MYR": return "Malaysian Ringgit"
    case "RON": return "Romanian Leu"
    case "THB": return "Baht"
    case "JPY": return "Yen"
    case "SGD": return "Singapore Dollar"
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
    case "PHP": return "🇵🇭"
    case "BRL": return "🇧🇷"
    case "INR": return "🇮🇳"
    case "AUD": return "🇦🇺"
    case "RUB": return "🇷🇺"
    case "ILS": return "🇮🇱"
    case "IDR": return "🇮🇩"
    case "NOK": return "🇳🇴"
    case "CNY": return "🇨🇳"
    case "DKK": return "🇩🇰"
    case "ZAR": return "🇱🇸"
    case "SEK": return "🇸🇪"
    case "MYR": return "🇲🇾"
    case "RON": return "🇷🇴"
    case "THB": return "🇹🇭"
    case "JPY": return "🇯🇵"
    case "SGD": return "🇸🇬"
    default: return "🏳"
    }
  }
}
