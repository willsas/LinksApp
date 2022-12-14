// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

struct SaveLinkLocal<LinkStorable: Storable> where
    LinkStorable.T == Link,
    LinkStorable.Array == [Link] {

    let save: (Link) -> AnyPublisher<Bool, Error>

    init(
        localStorage: LinkStorable
    ) {
        save = { localStorage.save($0) }
    }
}

extension SaveLinkLocal {
    static func make() -> Self {
        .init(localStorage: LinkCoreDataStorable.make() as! LinkStorable)
    }
}
