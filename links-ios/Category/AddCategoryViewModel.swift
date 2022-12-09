// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation
import SwiftUI

final class AddCategoryViewModel: ObservableObject {
    
    @MainActor @Published var isSuccess = false
    @MainActor @Published var error = ""

    @Published var name = ""
    @Published var color: Color

    let allColors: [Color]
    
    private let saveLink: (Link) -> AnyPublisher<Bool, Error>
    private var cancellables = Set<AnyCancellable>()

    init(saveLink: @escaping (Link) -> AnyPublisher<Bool, Error>) {
        self.saveLink = saveLink
        self.allColors =  (1...12).map { _ in LinksColor.random }
        self.color = allColors.first!
    }

    @MainActor
    func save() {
        let link = Link(
            id: UUID(),
            url: URL(string: "https://")!,
            title: "",
            desc: ""
        )
        saveLink(link)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(err) = completion {
                        self?.error = err.localizedDescription
                    }
                }, receiveValue: { [weak self] links in
                    self?.isSuccess = true
                }
            )
            .store(in: &cancellables)
    }
}

extension AddCategoryViewModel {
    static func make() -> Self {
        let linkProvider = LinkProvider.make()
        return .init(saveLink: linkProvider.saveLink)
    }
}
