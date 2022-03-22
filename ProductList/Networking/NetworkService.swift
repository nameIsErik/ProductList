import Foundation

enum NetworkServiceError: Error {
    case badResponse(URLResponse?)
    case badData
    case badLocalUrl
}

class NetworkService {
    
    static var shared = NetworkService()
    
    private var images = NSCache<NSString, NSData>()
    
    let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func request(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                
                completion(.success(data))
            }
        }.resume()
    }
    
    private func download(imageURL: URL, completion: @escaping (Data?, Error?) -> Void) {
        if let cachedData = images.object(forKey: imageURL.absoluteString as NSString) {
            print("Using caching data")
            completion(cachedData as Data, nil)
            return
        }
        
        if FilesManager.fileExists(at: FilesManager.fileUrl(named: imageURL.lastPathComponent)) {
            completion(FilesManager.retrieveImage(forKey: imageURL.lastPathComponent), nil)
            return
        }
        
        let task = session.downloadTask(with: imageURL) { localURL, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NetworkServiceError.badResponse(response))
                return
            }
            
            guard let localURL = localURL else {
                completion(nil, NetworkServiceError.badLocalUrl)
                return
            }
            
            do {
                let data = try Data(contentsOf: localURL)
                self.images.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
                completion(data, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func image(product: Product, completion: @escaping(Data?, Error?) -> Void) {
        let imageUrl = product.image
        download(imageURL: imageUrl, completion: completion)
    }
}
