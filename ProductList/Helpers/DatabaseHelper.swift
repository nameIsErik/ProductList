import Foundation
import CoreData
import UIKit

class DatabaseHelper {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllProducts(in session: Session) -> [ProductDB]? {
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
}
