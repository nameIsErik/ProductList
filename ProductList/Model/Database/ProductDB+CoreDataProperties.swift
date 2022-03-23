import Foundation
import CoreData


extension ProductDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductDB> {
        return NSFetchRequest<ProductDB>(entityName: "ProductDB")
    }

    @NSManaged public var category: String?
    @NSManaged public var descriptionDB: String?
    @NSManaged public var id: Int64
    @NSManaged public var image: URL?
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var session: Session?

}

extension ProductDB : Identifiable {

}
