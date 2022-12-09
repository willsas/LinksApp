// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

struct GetCategoryLocal {

    let get: () -> AnyPublisher<[Category], Error>

    init(
        localStorage: Storable
    ) {
        get = { localStorage.retrive() }
    }
}

extension GetCategoryLocal {
    static func make() -> Self {
        .init(localStorage: LinkCoreDataStorable.make())
    }
}
