// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

struct LinkProvider {

    private let getLinksLocal: () -> AnyPublisher<[Link], Error>
    private let saveLinkLocal: (Link) -> AnyPublisher<Bool, Error>
    private let deleteLinkLocal: (Link) -> AnyPublisher<Bool, Error>

    init(
        getLinksLocal: @escaping () -> AnyPublisher<[Link], Error>,
        saveLinkLocal: @escaping (Link) -> AnyPublisher<Bool, Error>,
        deleteLinkLocal: @escaping (Link) -> AnyPublisher<Bool, Error>
    ) {
        self.getLinksLocal = getLinksLocal
        self.saveLinkLocal = saveLinkLocal
        self.deleteLinkLocal = deleteLinkLocal
    }

    func getLinks() -> AnyPublisher<[Link], Error> {
        getLinksLocal()
            .map {
                $0.filter { !$0.title.isEmpty && !$0.desc.isEmpty }
            }
            .eraseToAnyPublisher()
    }

    func saveLink(_ link: Link) -> AnyPublisher<Bool, Error> {
        saveLinkLocal(link)
    }

    func deleteLink(id: String) -> AnyPublisher<Bool, Error> {
        getLinksLocal()
            .compactMap { $0.first { $0.id.uuidString == id } }
            .map { deleteLinkLocal($0) }
            .switchToLatest()
            .eraseToAnyPublisher()
    }

    func getLinksWith(categoryId: String) -> AnyPublisher<[Link], Error> {
        getLinks()
            .map { $0.filter { $0.categoryId.uuidString == categoryId } }
            .eraseToAnyPublisher()
    }
}

extension LinkProvider {
    static func make() -> Self {
        .init(
            getLinksLocal: GetLinksLocal<LinkCoreDataStorable>.make().get,
            saveLinkLocal: SaveLinkLocal<LinkCoreDataStorable>.make().save,
            deleteLinkLocal: DeleteLinkLocal<LinkCoreDataStorable>.make().delete
        )
    }
}
