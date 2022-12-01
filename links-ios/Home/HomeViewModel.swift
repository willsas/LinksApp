// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

struct LinkCategory: Identifiable {
    var id = UUID()
    var title: String
    var links: [Link]
}

final class HomeViewModel: ObservableObject {

    @MainActor @Published var categoriesLinks = [LinkCategory]()
    @MainActor @Published var error = ""

    private let getLinks: () -> AnyPublisher<[Link], Error>
    private var cancellables = Set<AnyCancellable>()

    init(
        getLinks: @escaping () -> AnyPublisher<[Link], Error>
    ) {
        self.getLinks = getLinks
    }

    @MainActor
    func onAppear() {
        getLinks()
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
       
        categoriesLinks = [allCategories, groupedCategories].flatMap { $0 }
    }
    
    private func appendAllLinksCategoriesTo(links: [Link]) -> [LinkCategory] {
        let allLinks = Dictionary(grouping: links, by: { $0.type })
            .flatMap { $0.value }
        
        var categories = [LinkCategory]()
        categories.append(.init(title: "All Links", links: allLinks))
        
        return categories
    }
    
    private func groupedCategories(links: [Link]) -> [LinkCategory] {
        Dictionary(grouping: links, by: { $0.type }).map{ key, value in
            LinkCategory(title: key, links: value)
        }
    }
}

extension HomeViewModel {
    static func make() -> Self {
        let linkProvider = LinkProvider.make()
        return .init(getLinks: linkProvider.getLink)
    }
}
