// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import CoreData
import Foundation

struct LinkCoreDataStorable: Storable {

    private let coreData = CoreDataController.shared

    private init() {}

    func save<T>(_ data: T) -> AnyPublisher<Bool, Error> {
        guard let data = data as? Link else {
            return Fail(error: LinkCoreDataStorableError.invalidDataType).eraseToAnyPublisher()
        }

        let backgroundContext = coreData.persistentContainer.newBackgroundContext()
        return Future<Bool, Error> { promise in
            backgroundContext.performAndWait {
                let linkCoreData = LinkCoreData(context: backgroundContext)
                linkCoreData.id = data.id
                linkCoreData.title = data.title
                linkCoreData.url = data.url
                linkCoreData.desc = data.desc
                linkCoreData.type = data.type
                linkCoreData.hexColor = data.hexColor

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
        let fetchRequest = NSFetchRequest<LinkCoreData>(
            entityName: String(describing: LinkCoreData.self)
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
                let mappedValue = value.compactMap(Link.convertFrom(linkCoreData:))

                guard mappedValue is T else {
                    promise(.failure(LinkCoreDataStorableError.invalidDataType))
                    return
                }

                promise(.success(mappedValue as! T))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()

    }
}

private extension Link {
    static func convertFrom(linkCoreData link: LinkCoreData) -> Self? {
        guard let id = link.id, let title = link.title,
              let url = link.url, let desc = link.desc,
              let type = link.type,
              let hexColor = link.hexColor
        else { return nil }
        return .init(id: id, url: url, title: title, desc: desc, type: type, hexColor: hexColor)
    }
}

public enum LinkCoreDataStorableError: Error {
    case invalidDataType
}

extension LinkCoreDataStorable {
    static func make() -> Self {
        .init()
    }
}
