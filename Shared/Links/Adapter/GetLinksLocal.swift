// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

struct GetLinksLocal<LinkStorable: Storable> where
    LinkStorable.T == Link,
    LinkStorable.Array == [Link] {

    let get: () -> AnyPublisher<[Link], Error>

    init(
        localStorage: LinkStorable
    ) {
        get = { localStorage.retrive() }
    }
}

extension GetLinksLocal {
    static func make() -> Self {
        .init(localStorage: LinkCoreDataStorable.make() as! LinkStorable)
    }
}
