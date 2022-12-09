// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

struct CategoryProvider {

    private let getCategoriesLocal: () -> AnyPublisher<[Category], Error>
    private let saveCategoryLocal: (Category) -> AnyPublisher<Bool, Error>

    init(
        getCategoriesLocal: @escaping () -> AnyPublisher<[Category], Error>,
        saveCategoryLocal: @escaping (Category) -> AnyPublisher<Bool, Error>
    ) {
        self.getCategoriesLocal = getCategoriesLocal
        self.saveCategoryLocal = saveCategoryLocal
    }

    func getAll() -> AnyPublisher<[Category], Error> {
        getCategoriesLocal()
    }

    func addNew(_ category: Category) -> AnyPublisher<Bool, Error> {
        saveCategoryLocal(category)
    }
}

extension CategoryProvider {
    static func make() -> Self {
        .init(
            getCategoriesLocal: GetCategoryLocal.make().get,
            saveCategoryLocal: SaveCategoryLocal.make().save
        )
    }
}
