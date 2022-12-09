// Created for LinksApp in 2022
// Using Swift 5.0 
        
//

import Foundation
import CoreData


extension LinkCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LinkCoreData> {
        return NSFetchRequest<LinkCoreData>(entityName: "LinkCoreData")
    }

    @NSManaged public var desc: String?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var url: URL?
    @NSManaged public var category: CategoryCoreData?

}

extension LinkCoreData : Identifiable {

}
