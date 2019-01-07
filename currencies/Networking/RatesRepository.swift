import Foundation

protocol RatesRepository {
  func rates(baseCurrency: Currency, completion: @escaping (Rates?) -> Void)
}
