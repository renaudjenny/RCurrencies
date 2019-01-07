import Foundation

class RatesRepositoryRevolut: RatesRepository {
  static let url = URLComponents(string: "https://revolut.duckdns.org/latest")

  lazy var jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-DD"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
  }()

  func rates(baseCurrency currency: Currency, completion: @escaping (Rates?) -> Void) {
    guard var urlComponents = RatesRepositoryRevolut.url else { fatalError("Cannot parse Revolut URL") }
    urlComponents.queryItems = [URLQueryItem(name: "base", value: currency.code)]
    guard let url = urlComponents.url else { fatalError("Cannot add base query item") }

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
