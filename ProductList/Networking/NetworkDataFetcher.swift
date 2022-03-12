import Foundation

class NetworkDataFetcher {

    let networkService = NetworkService()
    
    func fetchProducts(urlString: String, response: @escaping ([Product]?) -> Void) {
        networkService.request(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let products = try JSONDecoder().decode([Product].self, from: data)
                    response(products)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    response(nil)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
    
}
