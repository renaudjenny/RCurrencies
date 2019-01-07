import UIKit

class CurrenciesViewController: UITableViewController {
  static let baseCurrency = Currency(code: "EUR", rate: 1.0)

  var currencies: [Currency] = []
  var ratesRepository: RatesRepository = RatesRepositoryRevolut()
  var baseAmount = 100.0

  var timer: DispatchSourceTimer? = nil

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setupTimer()
  }

  func setupTimer() {
    self.timer?.cancel()
    self.timer = DispatchSource.makeTimerSource()
    self.timer?.schedule(deadline: .now(), repeating: .seconds(1))
    self.timer?.setEventHandler { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.ratesRepository.rates { rates in
        guard let currencies = rates?.currencies else { return }
        strongSelf.currencies = [CurrenciesViewController.baseCurrency]
        strongSelf.currencies.append(contentsOf: currencies)
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
    cell.populate(with: self.currencies[indexPath.row], baseAmount: self.baseAmount)
    return cell
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
