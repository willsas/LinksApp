// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

struct SaveLinkLocal {

    let save: (Link) -> AnyPublisher<Bool, Error>

    init(
        localStorage: Storable
    ) {
        save = { localStorage.save($0) }
    }
}

extension SaveLinkLocal {
    static func make() -> Self {
        .init(localStorage: LinkCoreDataStorable.make())
    }
}
