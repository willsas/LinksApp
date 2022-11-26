// Created for LinksApp in 2022
// Using Swift 5.0

import CoreData
import Foundation

class CoreDataController: ObservableObject {

    static var shared = CoreDataController()

    private init() {
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Links")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
