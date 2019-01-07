import Foundation

class RatesRepositoryRevolut: RatesRepository {
  static let url = URL(string: "https://revolut.duckdns.org/latest?base=EUR")

  lazy var jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-DD"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
  }()

  func rates(completion: @escaping (Rates?) -> Void) {
    guard let url = RatesRepositoryRevolut.url else { fatalError("Cannot parse Revolut URL") }
    URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
      guard error == nil else {
        print(error?.localizedDescription ?? "UNKNOWN ERROR")
        completion(nil)
        return
      }

      guard
        let json = data,
        let rates = try? self.jsonDecoder.decode(Rates.self, from: json) else {
          completion(nil)
          return
      }

      DispatchQueue.main.async {
        completion(rates)
      }
    }.resume()
  }
}
