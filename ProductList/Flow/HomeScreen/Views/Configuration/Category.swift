import Foundation

enum Category {
    case men
    case women
    case jewelery
    case electronics
    
    var urlString: String {
        switch self {
        case .men:
            return "https://fakestoreapi.com/products/category/men's%20clothing"
        case .women:
            return "https://fakestoreapi.com/products/category/women's%20clothing"
        case .jewelery:
            return "https://fakestoreapi.com/products/category/jewelery"
        case .electronics:
            return "https://fakestoreapi.com/products/category/electronics"
        }
    }
}
