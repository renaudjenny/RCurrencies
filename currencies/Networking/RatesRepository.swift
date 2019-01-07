import Foundation

protocol RatesRepository {
  func rates(completion: @escaping (Rates?) -> Void)
}
