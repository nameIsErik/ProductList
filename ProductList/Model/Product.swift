import Foundation

struct Product: Decodable {
    var id: Int
    var title: String
    var price: Double
    var category: String
    var description: String
    var image: String
}

