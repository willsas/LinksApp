// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation
import SwiftUI

struct LinkCategory: Identifiable {
    var id = UUID()
    var title: String
    var links: [Link]
    var color: Color
}

final class HomeViewModel: ObservableObject {

    @MainActor @Published var categoriesLinks = [LinkCategory]()
    @MainActor @Published var error = ""

    private let getLinks: () -> AnyPublisher<[Link], Error>
    private var cancellables = Set<AnyCancellable>()

    init(getLinks: @escaping () -> AnyPublisher<[Link], Error>) {
        self.getLinks = getLinks
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
    private func processLinks(_ links: [Link]) {
        let allCategories = appendAllLinksCategoriesTo(links: links)
        let groupedCategories = groupedCategories(links: links)

        categoriesLinks = [allCategories, groupedCategories]
            .flatMap { $0 }
            .sorted(by: { $0.title < $1.title })
    }

    private func appendAllLinksCategoriesTo(links: [Link]) -> [LinkCategory] {
        []
//        let allLinks = Dictionary(grouping: links, by: { $0.type })
//            .flatMap { $0.value }
//
//        var categories = [LinkCategory]()
//        categories.append(.init(title: "All Links", links: allLinks, color: LinksColor.black))
//
//        return categories
    }

    private func groupedCategories(links: [Link]) -> [LinkCategory] {
        []
//        Dictionary(grouping: links, by: { $0.type }).map { key, value in
//            var color = LinksColor.black
//            if let firstColor = getFirstHexInColor(links: value) {
//                color = firstColor
//            }
//            return LinkCategory(
//                title: key,
//                links: value,
//                color: color
//            )
//        }
    }

    private func getFirstHexInColor(links: [Link]) -> Color? {
        nil
//        guard let firstHex = links.first?.hexColor,
//              let uiColor = UIColor(hex: firstHex)
//        else { return nil }
//
//        return Color(uiColor: uiColor)
    }
}

extension HomeViewModel {
    static func make() -> Self {
        let linkProvider = LinkProvider.make()
        return .init(getLinks: linkProvider.getLink)
    }
}
