//
//  Session+CoreDataProperties.swift
//  ProductList
//
//  Created by Erik on 18.03.22.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for products
extension Session {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: ProductDB)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: ProductDB)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}

extension Session : Identifiable {

}
