// Created for LinksApp in 2022
// Using Swift 5.0 
        
//

import Foundation
import CoreData


extension CategoryCoreData {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryCoreData> {
        return NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
    }
    
    @NSManaged public var hexColor: String?
    @NSManaged public var title: String?
    @NSManaged public var id: UUID?
    @NSManaged public var links: NSSet?
    
    public var linksArray: [LinkCoreData] {
        let array = links as? Set<LinkCoreData> ?? []
        
        return array.sorted { $0.title! < $1.title! }
    }

}

// MARK: Generated accessors for links
extension CategoryCoreData {

    @objc(addLinksObject:)
    @NSManaged public func addToLinks(_ value: LinkCoreData)

    @objc(removeLinksObject:)
    @NSManaged public func removeFromLinks(_ value: LinkCoreData)

    @objc(addLinks:)
    @NSManaged public func addToLinks(_ values: NSSet)

    @objc(removeLinks:)
    @NSManaged public func removeFromLinks(_ values: NSSet)

}

extension CategoryCoreData : Identifiable {

}
