// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation
import SwiftUI

final class AddCategoryViewModel: ObservableObject {
    
    typealias Name = String
    typealias HexColor = String
    
    @MainActor @Published var isSuccess = false
    @MainActor @Published var error = ""

    @Published var name = ""
    @Published var color: Color

    let allColors: [Color]
    
    private let addCategory: (Name, HexColor) -> AnyPublisher<Bool, Error>
    private var cancellables = Set<AnyCancellable>()

    init(addCategory: @escaping (Name, HexColor) -> AnyPublisher<Bool, Error>) {
        self.addCategory = addCategory
        self.allColors =  (1...12).map { _ in LinksColor.random }
        self.color = allColors.first!
    }

    @MainActor
    func save() {
        addCategory(name, color.asHex())
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
        .init(addCategory: CategoryProvider.make().addCategory)
    }
}
