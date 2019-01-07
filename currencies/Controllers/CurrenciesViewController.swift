import UIKit

class CurrenciesViewController: UITableViewController {
  static let baseCurrency = Currency(code: "EUR", rate: 1.0)

  var currencies: [Currency] = []
  var ratesRepository: RatesRepository = RatesRepositoryRevolut()
  var baseAmount = 100.0

  override func viewDidLoad() {
    super.viewDidLoad()

    self.ratesRepository.rates { [weak self] rates in
      guard
        let strongSelf = self,
        let currencies = rates?.currencies else { return }
      strongSelf.currencies = [CurrenciesViewController.baseCurrency]
      strongSelf.currencies.append(contentsOf: currencies)
      strongSelf.tableView.reloadData()
    }
  }
}

// MARK: Table View
extension CurrenciesViewController {
  static let cellIdentifier = "CurrenciesViewControllerCellIdentifier"

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.currencies.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dequeuedCell = self.tableView.dequeueReusableCell(withIdentifier: CurrenciesViewController.cellIdentifier, for: indexPath)
    guard let cell = dequeuedCell as? CurrencyTableViewCell else { return dequeuedCell }
    cell.populate(with: self.currencies[indexPath.row], baseAmount: self.baseAmount)
    return cell
  }
}
