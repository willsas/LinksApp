// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

struct SaveCategoryLocal {

    let save: (Category) -> AnyPublisher<Bool, Error>

    init(
        localStorage: Storable
    ) {
        save = { localStorage.save($0) }
    }
}

extension SaveCategoryLocal {
    static func make() -> Self {
        .init(localStorage: LinkCoreDataStorable.make())
    }
}
