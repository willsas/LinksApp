// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

final class MainViewModel: ObservableObject {

    @MainActor @Published var links = [Link]()

    private let getLink: () -> AnyPublisher<[Link], Error>

    private var cancellables = Set<AnyCancellable>()

    init(
        getLink: @escaping () -> AnyPublisher<[Link], Error>
    ) {
        self.getLink = getLink
    }

    @MainActor
    func getLinks() {
        getLink().sink(
            receiveCompletion: { completion in
                switch completion {
                case let .failure(err):
                    print(err)
                case .finished:
                    break
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
        return .init(getLink: linkProvider.getLink)
    }
}
