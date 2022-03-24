import Foundation

enum Category: Int, CaseIterable {
    case men
    case women
    case jewelery
    case electronics
    
    func getText() -> String {
        switch self {
        case .men:
            return "Men"
        case .women:
            return "Women"
        case .jewelery:
            return "Jewlery"
        case .electronics:
            return "Electronics"
        }
    }
    
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
