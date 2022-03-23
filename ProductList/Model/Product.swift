import Foundation

struct Product: Decodable {
    var id: Int
    var title: String
    var price: Double
    var category: String
    var description: String
    var image: URL
}

extension Product {
    init?(productDB: ProductDB) {
        if let productTitle = productDB.title,
           let productCategory = productDB.category,
           let productDescription = productDB.descriptionDB,
           let productImageURL = productDB.image {
            self.init(id: Int(productDB.id), title: productTitle,
                      price: productDB.price, category: productCategory,
                      description: productDescription, image: productImageURL)
        } else {
            return nil
        }
    }
}
