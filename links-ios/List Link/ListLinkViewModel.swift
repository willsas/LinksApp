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

    @Published var listType = ListType.link([])
    @Published var navigationTitle = ""
    @Published var error = ""

    private let getLinksWithCategory: (String) -> AnyPublisher<[Link], Error>
    private let getAllLinks: () -> AnyPublisher<[Link], Error>
    private let deleteLink: (String) -> AnyPublisher<Bool, Error>
    private var cancellables = Set<AnyCancellable>()

    private var linkType: ListLinkView.LinkType?

    init(
        getLinksWithCategory: @escaping (String) -> AnyPublisher<[Link], Error>,
        getAllLinks: @escaping () -> AnyPublisher<[Link], Error>,
        deleteLink: @escaping (String) -> AnyPublisher<Bool, Error>
    ) {
        self.getLinksWithCategory = getLinksWithCategory
        self.getAllLinks = getAllLinks
        self.deleteLink = deleteLink
    }

    func getLinks(type: ListLinkView.LinkType) {
        linkType = type
        switch type {
        case .all: getAll()
        case let .category(categoryId): getWith(categoryId: categoryId)
        }
    }

    func deleteLinkWith(indexSet: IndexSet) {
        if case let .link(links) = listType {
            let idsToDelete = indexSet.map { links[$0].id }
            idsToDelete.forEach { id in
                deleteLink(id.uuidString)
                    .sink(
                        receiveCompletion: { [weak self] completion in
                            if case let .failure(err) = completion {
                                self?.error = err.localizedDescription
                            }
                        }, receiveValue: { [weak self] _ in
                            guard let linkType = self?.linkType else { return }
                            self?.getLinks(type: linkType)
                        }
                    )
                    .store(in: &cancellables)
            }
        }
    }

    func deleteLinkWith(groupedLinkId: String, indexSet: IndexSet) {
        if case let .grouped(grouped) = listType {
            guard let selectedGrouped = grouped.first(where: { $0.id == groupedLinkId })
            else { return }

            let idsToDelete = indexSet.map { selectedGrouped.links[$0].id }
            idsToDelete.forEach { id in
                deleteLink(id.uuidString)
                    .sink(
                        receiveCompletion: { [weak self] completion in
                            if case let .failure(err) = completion {
                                self?.error = err.localizedDescription
                            }
                        }, receiveValue: { [weak self] _ in
                            guard let linkType = self?.linkType else { return }
                            self?.getLinks(type: linkType)
                        }
                    )
                    .store(in: &cancellables)
            }
        }
    }

    private func getAll() {
        getAllLinks()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(err) = completion {
                        self?.error = err.localizedDescription
                    }
                }, receiveValue: { [weak self] in
                    guard let self else { return }
                    let groupedLink = self.getGroupedLink($0)
                    self.listType = .grouped(groupedLink)
                    self.navigationTitle = "All links"
                }
            )
            .store(in: &cancellables)
    }

    private func getWith(categoryId: String) {
        getLinksWithCategory(categoryId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(err) = completion {
                        self?.error = err.localizedDescription
                    }
                }, receiveValue: { [weak self] in
                    guard let self else { return }
                    self.listType = .link($0)
                    self.navigationTitle = $0.first?.categoryName ?? ""
                }
            )
            .store(in: &cancellables)
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
        let linkProvider = LinkProvider.make()
        return .init(
            getLinksWithCategory: linkProvider.getLinksWith(categoryId:),
            getAllLinks: linkProvider.getLinks,
            deleteLink: linkProvider.deleteLink(id:)
        )
    }
}

private extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
