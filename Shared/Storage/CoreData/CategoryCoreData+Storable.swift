// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import CoreData
import Foundation

struct CategoryCoreDataStorable: Storable {

    private let coreData = CoreDataController.shared

    private init() {}

    func save<T>(_ data: T) -> AnyPublisher<Bool, Error> {
        guard let data = data as? Category else {
            return Fail(error: CategoryCoreDataStorableError.invalidDataType).eraseToAnyPublisher()
        }

        let backgroundContext = coreData.persistentContainer.newBackgroundContext()
        return Future<Bool, Error> { promise in
            backgroundContext.performAndWait {
                let categoryCoreData = CategoryCoreData(context: backgroundContext)
                categoryCoreData.id = data.id
                categoryCoreData.title = data.title
                categoryCoreData.hexColor = data.hexColor
                
                data.links.forEach { link in
                    let linkCoreData = LinkCoreData(context: backgroundContext)
                    linkCoreData.id = link.id
                    linkCoreData.title = link.title
                    linkCoreData.url = link.url
                    linkCoreData.desc = link.desc
                    categoryCoreData.addToLinks(linkCoreData)
                }

                if backgroundContext.hasChanges {
                    do {
                        try backgroundContext.save()
                        DispatchQueue.main.async {
                            promise(.success(true))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            promise(.failure(error))
                        }
                    }
                }
            }
        }.eraseToAnyPublisher()
    }

    func retrive<T>() -> AnyPublisher<T, Error> {
        let fetchRequest = NSFetchRequest<CategoryCoreData>(
            entityName: String(describing: CategoryCoreData.self)
        )
        fetchRequest.sortDescriptors = []

        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreData.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        return Future<T, Error> { promise in
            do {
                try fetchedResultController.performFetch()
                let value = fetchedResultController.fetchedObjects ?? []
                let mappedValue = value.compactMap(Category.convertFrom(categoryCoreData:))

                guard mappedValue is T else {
                    promise(.failure(CategoryCoreDataStorableError.invalidDataType))
                    return
                }

                promise(.success(mappedValue as! T))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()

    }
}

private extension Category {
    static func convertFrom(categoryCoreData category: CategoryCoreData) -> Self? {
        guard let id = category.id,
              let title = category.title,
              let hexColor = category.hexColor
        else { return nil }
        
        let links = category.linksArray.compactMap { Link.convertFrom(linkCoreData:$0) }
        
        return .init(id: id, title: title, hexColor: hexColor, links: links)
    }
}

public enum CategoryCoreDataStorableError: Error {
    case invalidDataType
}

extension CategoryCoreDataStorable {
    static func make() -> Self {
        .init()
    }
}

