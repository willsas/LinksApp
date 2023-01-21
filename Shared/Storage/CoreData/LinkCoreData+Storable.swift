// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import CoreData
import Foundation

struct LinkCoreDataStorable: Storable {
    typealias T = Link
    typealias Array = [Link]
    
    private let coreData = CoreDataController.shared

    private init() {}

    func save(_ data: Link) -> AnyPublisher<Bool, Error> {
        let backgroundContext = coreData.persistentContainer.newBackgroundContext()
        return Future<Bool, Error> { promise in
            backgroundContext.performAndWait {
                let linkCoreData = LinkCoreData(context: backgroundContext)
                linkCoreData.id = data.id
                linkCoreData.title = data.title
                linkCoreData.url = data.url
                linkCoreData.desc = data.desc
                linkCoreData.categoryName = data.categoryName
                linkCoreData.categoryId = data.categoryId
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

    func retrive() -> AnyPublisher<[Link], Error> {
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

        return Future<[Link], Error> { promise in
            do {
                try fetchedResultController.performFetch()
                let value = fetchedResultController.fetchedObjects ?? []
                let mappedValue = value.compactMap(Link.convertFrom(linkCoreData:))
                
                promise(.success(mappedValue))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func delete(_ data: Link) -> AnyPublisher<Bool, Error> {
        return retrive(linkId: data.id)
            .tryMap { linkCoreData in
                coreData.persistentContainer.viewContext.delete(linkCoreData)
                try coreData.persistentContainer.viewContext.save()
                return true
            }
            .eraseToAnyPublisher()
    }
    
    private func retrive(linkId: UUID) -> AnyPublisher<LinkCoreData, Error> {
        let fetchRequest = NSFetchRequest<LinkCoreData>(
            entityName: String(describing: LinkCoreData.self)
        )
        fetchRequest.sortDescriptors = []
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = .init(format: "id == %@", linkId as CVarArg)

        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreData.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        return Future<LinkCoreData, Error> { promise in
            do {
                try fetchedResultController.performFetch()
                guard let value = fetchedResultController.fetchedObjects?.first else {
                    promise(.failure(LinkCoreDataStorableError.dataNotFound))
                    return
                }
                promise(.success(value))
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
              let categoryName = link.categoryName,
              let cateogryId = link.categoryId,
              let hexColor = link.hexColor
        else { return nil }
        return .init(
            id: id,
            url: url,
            title: title,
            desc: desc,
            categoryName: categoryName,
            categoryId: cateogryId,
            hexColor: hexColor
        )
    }
}

public enum LinkCoreDataStorableError: Error {
    case invalidDataType
    case dataNotFound
}

extension LinkCoreDataStorable {
    static func make() -> Self {
        .init()
    }
}
