import UIKit

class CurrenciesViewController: UITableViewController {
  static let baseCurrency = Currency(code: "EUR", rate: 1.0)

  var currencies: [Currency] = [CurrenciesViewController.baseCurrency]
  var ratesRepository: RatesRepository = RatesRepositoryRevolut()
  var baseAmount = 100.0
  var selectedCurrency: Currency {
    return self.currencies.first ?? CurrenciesViewController.baseCurrency
  }

  var timer: DispatchSourceTimer? = nil

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setupTimer()
  }

  func setupTimer() {
    self.timer?.cancel()
    self.timer = DispatchSource.makeTimerSource()
    let delay: DispatchTime = .now() + .seconds(1)
    self.timer?.schedule(deadline: delay, repeating: .seconds(1))
    self.timer?.setEventHandler { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.ratesRepository.rates(baseCurrency: strongSelf.selectedCurrency) { rates in
        guard let rates = rates else { return }
        strongSelf.currencies.update(rates: rates)
        strongSelf.tableView.reloadData()
      }
    }
    self.timer?.resume()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.timer?.cancel()
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
    let currency = self.currencies[indexPath.row]
    cell.populate(
      with: currency,
      baseAmount: self.baseAmount,
      isBaseCurrency: currency.code == self.selectedCurrency.code
    )
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let firstIndexPath = IndexPath(row: 0, section: 0)
    guard indexPath != firstIndexPath else { return }

    self.timer?.cancel()

    let currency = self.currencies[indexPath.row]
    self.baseAmount = self.baseAmount * currency.rate
    self.currencies.remove(at: indexPath.row)
    self.currencies.insert(currency, at: 0)

    self.tableView.moveRow(at: indexPath, to: firstIndexPath)
    self.tableView.scrollToRow(at: firstIndexPath, at: .top, animated: true)
    self.setupTimer()
  }
}

// MARK: Scroll View
extension CurrenciesViewController {
  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.timer?.cancel()
  }

  override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    guard let timer = self.timer, timer.isCancelled else { return }
    self.setupTimer()
  }

  override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    guard !decelerate, let timer = self.timer, timer.isCancelled else { return }
    self.setupTimer()
  }
}
