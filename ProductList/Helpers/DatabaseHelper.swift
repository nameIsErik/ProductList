import Foundation
import CoreData
import UIKit

class DatabaseHelper {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var lastSession: Session?
    
    private func getAllProducts(in session: Session) -> [ProductDB]? {
        var products: [ProductDB]?
        
        do {
            let request = ProductDB.fetchRequest() as NSFetchRequest<ProductDB>
            let sessionPredicate = NSPredicate(format: "session == %@", session)
            request.predicate = sessionPredicate
            
            products = try context.fetch(request)
        } catch {
            
        }
        
        return products
    }
    
    func convertToProducts(from productsDB: [ProductDB]) -> [Product] {
        var products: [Product] = []
        for productDB in productsDB {
            if let product = Product.init(productDB: productDB) {
                products.append(product)
            }
        }
        
        return products
    }
    
    func getDataFromLastSession() -> [ProductDB]? {
        do {
            lastSession = try context.fetch(Session.fetchRequest()).last
        } catch let error{
            print("Error fetching products from database: \(error)")
            return nil
        }
        
        guard let lastSession = lastSession else {
            return nil
        }

        return self.getAllProducts(in: lastSession)
    }
    
    func saveProductsToDB(products: [Product]) {
        let newSession = Session(context: context)
        
        for product in products {
            let productDB = ProductDB(context: context)
            productDB.id = Int64(product.id)
            productDB.title = product.title
            productDB.price = product.price
            productDB.category = product.category
            productDB.descriptionDB = product.description
            productDB.image = product.image
            productDB.session = newSession
            
            newSession.addToProducts(productDB)
        }
        do {
            try context.save()
        } catch let error {
            print("Eerror saving prouducts to DB: \(error)")
        }
    }
}
