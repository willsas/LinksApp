// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

struct LinkCategories: Identifiable {
    var id = UUID()
    var title: String
    var links: [Link]
}

final class HomeViewModel: ObservableObject {

    @MainActor @Published var categoriesLinks = [LinkCategories]()
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
    private func processLinks(_ links: [Link]) {
        let dict = Dictionary(grouping: links, by: { $0.type })
        let allLinks = Dictionary(grouping: links, by: { $0.type })
            .flatMap { $0.value }
        
        var categories = [LinkCategories]()
        categories.append(.init(title: "All Links", links: allLinks))
        
        let categoriesLinks = Dictionary(grouping: links, by: { $0.type }).map{ key, value in
            LinkCategories(title: key, links: value)
        }
        categories.append(contentsOf: categoriesLinks)
        
        self.categoriesLinks = categories
    }
}

extension HomeViewModel {
    static func make() -> Self {
        let linkProvider = LinkProvider.make()
        return .init(getLinks: linkProvider.getLink)
    }
}
