// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

final class MainViewModel: ObservableObject {

    @MainActor @Published var links = [Link]()
    @MainActor @Published var error = ""

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
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(err) = completion {
                        self?.error = err.localizedDescription
                    }
                }, receiveValue: { [weak self] links in
                    self?.links = links
                }
            )
            .store(in: &cancellables)
    }
}

extension MainViewModel {
    static func make() -> Self {
        let linkProvider = LinkProvider.make()
        return .init(getLinks: linkProvider.getLinks, saveLink: linkProvider.saveLink)
    }
}
