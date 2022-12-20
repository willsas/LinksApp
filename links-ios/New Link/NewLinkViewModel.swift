// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation
import SwiftUI

final class NewLinkViewModel: ObservableObject {

    @MainActor @Published var categoriesLinks = [LinkCategory]()
    @MainActor @Published var error = ""
    @MainActor @Published var onDismiss = false

    @Published var url = ""
    @Published var title = ""
    @Published var description = ""
    @Published var categoryId = UUID()

    private let getLinks: () -> AnyPublisher<[Link], Error>
    private let saveLink: (Link) -> AnyPublisher<Bool, Error>
    private var cancellables = Set<AnyCancellable>()

    init(
        getLinks: @escaping () -> AnyPublisher<[Link], Error>,
        saveLink: @escaping (Link) -> AnyPublisher<Bool, Error>
    ) {
        self.getLinks = getLinks
        self.saveLink = saveLink
    }

    @MainActor
    func onAppear() {
        getLinks()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(err) = completion {
                        self?.error = err.localizedDescription
                    }
                }, receiveValue: { [weak self] links in
                    self?.processLinks(links)
                }
            )
            .store(in: &cancellables)
    }

    @MainActor
    func refresh() {
        onAppear()
    }

    @MainActor
    func getCategoryTitle() -> String {
        getCategory(withCategoryId: categoryId)?.title ?? "Select Category"
    }

    @MainActor
    func add() {
        guard let url = URL(string: url),
              let category = getCategory(withCategoryId: categoryId)
        else { return }
        let link = Link(
            id: categoryId,
            url: url,
            title: title,
            desc: description,
            type: category.title,
            hexColor: category.color.asHex()
        )
        saveLink(link)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] in
                if case let .failure(err) = $0 {
                    self?.error = err.localizedDescription
                }
            }, receiveValue: { [weak self] in
                self?.onDismiss = $0
            }).store(in: &cancellables)
    }

    @MainActor
    private func getCategory(withCategoryId: UUID) -> LinkCategory? {
        categoriesLinks.first(where: { $0.id == categoryId })
    }

    @MainActor
    private func processLinks(_ links: [Link]) {
        let allCategories = appendAllLinksCategoriesTo(links: links)
        let groupedCategories = groupedCategories(links: links)

        categoriesLinks = [allCategories, groupedCategories]
            .flatMap { $0 }
            .sorted(by: { $0.title < $1.title })
    }

    private func appendAllLinksCategoriesTo(links: [Link]) -> [LinkCategory] {
        let allLinks = Dictionary(grouping: links, by: { $0.type })
            .flatMap { $0.value }

        var categories = [LinkCategory]()
        categories.append(.init(title: "All Links", links: allLinks, color: LinksColor.black))

        return categories
    }

    private func groupedCategories(links: [Link]) -> [LinkCategory] {
        Dictionary(grouping: links, by: { $0.type }).map { key, value in
            var color = LinksColor.black
            if let firstColor = getFirstHexInColor(links: value) {
                color = firstColor
            }
            return LinkCategory(
                title: key,
                links: value,
                color: color
            )
        }
    }

    private func getFirstHexInColor(links: [Link]) -> Color? {
        guard let firstHex = links.first?.hexColor,
              let uiColor = UIColor(hex: firstHex)
        else { return nil }

        return Color(uiColor: uiColor)
    }
}

extension NewLinkViewModel {
    static func make() -> Self {
        let linkProvider = LinkProvider.make()
        return .init(getLinks: linkProvider.getLink, saveLink: linkProvider.saveLink(_:))
    }
}
