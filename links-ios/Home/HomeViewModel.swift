// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {

    @MainActor @Published var categories = [Category]()
    @MainActor @Published var error = ""

    private let getCategory: () -> AnyPublisher<[Category], Error>
    private var cancellables = Set<AnyCancellable>()

    init(
        getCategory: @escaping () -> AnyPublisher<[Category], Error>
    ) {
        self.getCategory = getCategory
    }

    @MainActor
    func onAppear() {
        getCategory()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(err) = completion {
                        self?.error = err.localizedDescription
                    }
                }, receiveValue: { [weak self] in
                    self?.categories = $0
                }
            )
            .store(in: &cancellables)
    }

    @MainActor
    func refresh() {
        onAppear()
    }
}

extension HomeViewModel {
    static func make() -> Self {
        return .init(getCategory: { CategoryProvider.make().getCategories() })
    }
}
