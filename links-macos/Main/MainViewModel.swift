// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

final class MainViewModel: ObservableObject {

    @MainActor @Published var links = [Link]()

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
        getLinks().sink(
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
    
    @MainActor
    func addNew() {
        saveLink(.init(id: UUID(), url: URL(string: "https://www.google.com")!, title: "Edit Title", desc: "Edit desc"))
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] isSuccess in
                self?.onAppear()
            })
            .store(in: &cancellables)
    }
}

extension MainViewModel {
    static func make() -> Self {
        let linkProvider = LinkProvider.make()
        return .init(getLinks: linkProvider.getLink, saveLink: linkProvider.saveLink)
    }
}
