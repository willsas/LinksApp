// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation
import SwiftUI

struct CategoryProvider {

    private let getLinksLocal: () -> AnyPublisher<[Link], Error>
    private let saveLinksLocal: (Link) -> AnyPublisher<Bool, Error>

    init(
        getLinksLocal: @escaping () -> AnyPublisher<[Link], Error>,
        saveLinksLocal: @escaping (Link) -> AnyPublisher<Bool, Error>
    ) {
        self.getLinksLocal = getLinksLocal
        self.saveLinksLocal = saveLinksLocal
    }

    func getCategories(includeAllCategories: Bool = true) -> AnyPublisher<[Category], Error> {
        getLinksLocal()
            .map {
                var allCategories = [Category]()
                if includeAllCategories {
                    allCategories = appendAllLinksCategoriesTo(links: $0)
                }
                let groupedCategories = groupedCategories(links: $0)

                return [
                    allCategories,
                    groupedCategories.sorted(by: { $0.title < $1.title })
                ]
                .flatMap { $0 }

            }
            .eraseToAnyPublisher()
    }

    func addCategory(name: String, hexColor: String) -> AnyPublisher<Bool, Error> {
        let link = Link(
            id: .idForEmptyLink(),
            url: URL(string: "https://")!,
            title: "",
            desc: "",
            categoryName: name,
            categoryId: UUID(),
            hexColor: hexColor
        )
        return saveLinksLocal(link).eraseToAnyPublisher()
    }

    private func appendAllLinksCategoriesTo(links: [Link]) -> [Category] {
        let links = links.filter { !$0.title.isEmpty }

        var categories = [Category]()
        categories.append(
            .init(
                id: .idForAllCategory(),
                title: "All Links",
                linkCount: links.count,
                hexColor: LinksColor.black.asHex()
            )
        )

        return categories
    }

    private func groupedCategories(links: [Link]) -> [Category] {
        Dictionary(grouping: links, by: { $0.categoryId }).map { key, value in
            guard let firstHex = value.first?.hexColor,
                  let firstCategoryName = value.first?.categoryName
            else { return nil }

            let linksCount = value
                .filter { !$0.title.isEmpty }
                .count

            return Category(
                id: key,
                title: firstCategoryName,
                linkCount: linksCount,
                hexColor: firstHex
            )
        }
        .compactMap { $0 }
    }
}

extension CategoryProvider {
    static func make() -> Self {
        .init(
            getLinksLocal: GetLinksLocal<LinkCoreDataStorable>.make().get,
            saveLinksLocal: SaveLinkLocal<LinkCoreDataStorable>.make().save
        )
    }
}
