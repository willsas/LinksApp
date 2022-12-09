// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

class LinkProvider {

    private let getLinksLocal: () -> AnyPublisher<[Link], Error>
    private let saveLinkLocal: (Link) -> AnyPublisher<Bool, Error>
    private let getCategoriesLocal: () -> AnyPublisher<[Category], Error>
    private let saveCategoryLocal: (Category) -> AnyPublisher<Bool, Error>
    
    private var cancellable = Set<AnyCancellable>()

    init(
        getLinksLocal: @escaping () -> AnyPublisher<[Link], Error>,
        saveLinkLocal: @escaping (Link) -> AnyPublisher<Bool, Error>,
        getCategoriesLocal: @escaping () -> AnyPublisher<[Category], Error>,
        saveCategoryLocal: @escaping (Category) -> AnyPublisher<Bool, Error>
    ) {
        self.getLinksLocal = getLinksLocal
        self.saveLinkLocal = saveLinkLocal
        self.getCategoriesLocal = getCategoriesLocal
        self.saveCategoryLocal = saveCategoryLocal
    }

    func addLinkToCategoryId(_ categoryId: String, link: Link) -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { [weak self] promise in
            guard let self = self else { return }
            
            self.getCategoriesLocal().sink(receiveCompletion: {
                if case let .failure(err) = $0 {
                    promise(.failure(err))
                }
            }, receiveValue: { categories in
                guard let cateogry = categories.first(where:  {$0.id.uuidString == categoryId })
                else { return }
                
                
                
            }).store(in: &self.cancellable)
            
        }.eraseToAnyPublisher()
    }
}

extension LinkProvider {
    static func make() -> Self {
        .init(
            getLinksLocal: GetLinksLocal.make().get,
            saveLinkLocal: SaveLinkLocal.make().save
        )
    }
}
