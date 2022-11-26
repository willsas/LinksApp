// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

struct GetLinksLocal {

    let get: () -> AnyPublisher<[Link], Error>

    init(
        localStorage: Storable
    ) {
        get = { localStorage.retrive() }
    }
}

extension GetLinksLocal {
    static func make() -> Self {
        .init(localStorage: LinkCoreDataStorable.make())
    }
}
