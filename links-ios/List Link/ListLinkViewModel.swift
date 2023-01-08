// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation
import SwiftUI

struct GroupedLink: Identifiable {
    let id: String
    let title: String
    var links: [Link]
}

enum ListType {
    case grouped([GroupedLink])
    case link([Link])
}

final class ListLinkViewModel: ObservableObject {

    @MainActor @Published var listType = ListType.link([])
    @MainActor @Published var navigationTitle = ""
    @MainActor @Published var error = ""

    private let getLinksWithCategory: (String) -> AnyPublisher<[Link], Error>
    private let deleteLink: (String) -> AnyPublisher<Bool, Error>
    private var cancellables = Set<AnyCancellable>()

    private var categoryId: String?

    init(
        getLinksWithCategory: @escaping (String) -> AnyPublisher<[Link], Error>,
        deleteLink: @escaping (String) -> AnyPublisher<Bool, Error>
    ) {
        self.getLinksWithCategory = getLinksWithCategory
        self.deleteLink = deleteLink
    }

    @MainActor
    func getLinks(categoryId: String) {
        self.categoryId = categoryId
        getLinksWithCategory(categoryId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(err) = completion {
                        self?.error = err.localizedDescription
                    }
                }, receiveValue: { [weak self] in
                    self?.processNewLinks($0)
                }
            )
            .store(in: &cancellables)
    }

    @MainActor
    func deleteLink(_ row: Int) {
        switch listType {
        case let .link(links):
            var unmutableLinks = links
            unmutableLinks.remove(at: row)
            listType = .link(unmutableLinks)
//            deleteLink(link.id.uuidString)
//                .sink(
//                    receiveCompletion: { [weak self] completion in
//                        if case let .failure(err) = completion {
//                            self?.error = err.localizedDescription
//                        }
//                    }, receiveValue: { [weak self] _ in
//                        guard let categoryId = self?.categoryId else { return }
//                        self?.getLinks(categoryId: categoryId)
//                    }
//                )
//                .store(in: &cancellables)

        case let .grouped(grouped):
//            let link = grouped.links[row]
            print("not handeled yet")
        }
    }

    @MainActor
    private func processNewLinks(_ links: [Link]) {
        let categoryId = links
            .map { $0.categoryId }
            .uniqued()
        if categoryId.count == 1 {
            listType = .link(links)
            navigationTitle = links.first?.categoryName ?? ""
        } else {
            let groupedLink = getGroupedLink(links)
            listType = .grouped(groupedLink)
            navigationTitle = "All links"
        }
    }

    private func getGroupedLink(_ links: [Link]) -> [GroupedLink] {
        Dictionary(grouping: links, by: { $0.categoryId.uuidString })
            .map { key, value in
                GroupedLink(
                    id: key,
                    title: value.first?.categoryName ?? "",
                    links: value
                )
            }
    }
}

extension ListLinkViewModel {
    static func make() -> Self {
        return .init(
            getLinksWithCategory: {
                LinkProvider.make().getLinksWith(categoryId: $0)
            },
            deleteLink: LinkProvider.make().deleteLink(id:))
    }
}

private extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
