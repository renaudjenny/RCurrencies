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

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.timer?.cancel()
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
        strongSelf.updateTable(with: rates)
      }
    }
    self.timer?.resume()
  }

  func updateTable(with rates: Rates) {
    let currenciesCountBeforeUpdate = self.currencies.count
    self.currencies.update(rates: rates)
    let isCurrenciesSizeChanged = currenciesCountBeforeUpdate != self.currencies.count
    if isCurrenciesSizeChanged {
      self.tableView.reloadData()
    } else {
      guard let visibleIndexPaths = self.tableView.indexPathsForVisibleRows else { return }
      self.tableView.reloadRows(at: Array(visibleIndexPaths.dropFirst()), with: .none)
    }
  }

  var firstCell: CurrencyTableViewCell? {
    let firstIndexPath = IndexPath(row: 0, section: 0)
    return self.tableView.cellForRow(at: firstIndexPath) as? CurrencyTableViewCell
  }

  func editFirstCellAmount() {
    self.firstCell?.amountTextField.isUserInteractionEnabled = true
    self.firstCell?.amountTextField.becomeFirstResponder()
  }

  func resignFirstCellResponder() {
    self.firstCell?.amountTextField.resignFirstResponder()
  }
}

// MARK: Table View
extension CurrenciesViewController {
  static let cellIdentifier = "CurrenciesViewControllerCellIdentifier"
  static let rowAnimationDuration: TimeInterval = 0.4

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
    guard indexPath != firstIndexPath else {
      self.editFirstCellAmount()
      return
    }

    self.timer?.cancel()

    self.firstCell?.amountTextField.isUserInteractionEnabled = false

    let currency = self.currencies[indexPath.row]
    self.baseAmount = self.baseAmount * currency.rate
    self.currencies.remove(at: indexPath.row)
    self.currencies.insert(currency, at: 0)

    UIView.animate(withDuration: CurrenciesViewController.rowAnimationDuration, animations: {
      self.tableView.moveRow(at: indexPath, to: firstIndexPath)
      self.tableView.scrollToRow(at: firstIndexPath, at: .top, animated: true)
    }) { _ in
      self.editFirstCellAmount()
      self.setupTimer()
    }
  }
}

// MARK: Scroll View
extension CurrenciesViewController {
  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.timer?.cancel()
    self.resignFirstCellResponder()
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
