import UIKit

class CurrencyTableViewCell: UITableViewCell {
  @IBOutlet weak var countryFlag: UILabel!
  @IBOutlet weak var countryCode: UILabel!
  @IBOutlet weak var currencyName: UILabel!
  @IBOutlet weak var amountTextField: UITextField!

  func populate(with currency: Currency) {
    self.countryFlag.text = currency.flag
    self.countryCode.text = currency.code
    self.currencyName.text = currency.name
    self.amountTextField.text = "-"
  }
}

private extension Currency {
  var name: String {
    return self.code
  }

  var flag: String {
    return "🏳"
  }

  var currencyName: String {
    return self.code
  }
}
