// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

struct LinkProvider {

    private let getLinksLocal: () -> AnyPublisher<[Link], Error>
    private let saveLinkLocal: (Link) -> AnyPublisher<Bool, Error>

    init(
        getLinksLocal: @escaping () -> AnyPublisher<[Link], Error>,
        saveLinkLocal: @escaping (Link) -> AnyPublisher<Bool, Error>
    ) {
        self.getLinksLocal = getLinksLocal
        self.saveLinkLocal = saveLinkLocal
    }

    func getLink() -> AnyPublisher<[Link], Error> {
//        getLinksLocal()
        Just([
            Link(
                id: UUID(),
                url: URL(string: "https://nohello.net/en/")!,
                title: "Website no hello",
                desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
            )
        ])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }

    func saveLink(_ link: Link) -> AnyPublisher<Bool, Error> {
        saveLinkLocal(link)
    }
}

extension LinkProvider {
    static func make() -> Self {
        .init(
            getLinksLocal: GetLinksLocal.make().get,
            saveLinkLocal: SaveLinkLocal.make().save
        )
    }
}