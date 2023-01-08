// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

struct DeleteLinkLocal<LinkStorable: Storable> where
    LinkStorable.T == Link,
    LinkStorable.Array == [Link] {

    let delete: (Link) -> AnyPublisher<Bool, Error>

    init(
        localStorage: LinkStorable
    ) {
        delete = {
            localStorage.delete($0)
        }
    }
}

extension DeleteLinkLocal {
    static func make() -> Self {
        .init(localStorage: LinkCoreDataStorable.make() as! LinkStorable)
    }
}
