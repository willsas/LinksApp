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

    @MainActor
    func getLinks(type: ListLinkView.LinkType) {
        linkType = type
        switch type {
        case .all: getAll()
        case .category(let categoryId): getWith(categoryId: categoryId)
        }
    }

    @MainActor
    func deleteLink(_ indexSet: IndexSet) {
        var idsToDelete = [UUID]()
        switch listType {
        case let .link(links):
            idsToDelete = indexSet.map { links[$0].id }
        case let .grouped(grouped):
            let links = grouped.flatMap { $0.links}
            idsToDelete = indexSet.map { links[$0].id }
        }
        
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
    
    @MainActor
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
    
    @MainActor
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
            deleteLink: linkProvider.deleteLink(id:))
    }
}

private extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
