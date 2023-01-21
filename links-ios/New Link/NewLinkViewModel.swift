// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation
import SwiftUI

final class NewLinkViewModel: ObservableObject {

    @Published var categories = [Category]()
    @Published var error = ""
    @Published var errorPresented = false
    @Published var onDismiss = false

    @Published var url = ""
    @Published var title = ""
    @Published var description = ""
    @Published var selectedCategoryId = UUID()

    private let getLinks: () -> AnyPublisher<[Link], Error>
    private let saveLink: (Link) -> AnyPublisher<Bool, Error>
    private let getCategories: () -> AnyPublisher<[Category], Error>
    private var cancellables = Set<AnyCancellable>()

    init(
        getLinks: @escaping () -> AnyPublisher<[Link], Error>,
        saveLink: @escaping (Link) -> AnyPublisher<Bool, Error>,
        getCategories: @escaping () -> AnyPublisher<[Category], Error>
    ) {
        self.getLinks = getLinks
        self.saveLink = saveLink
        self.getCategories = getCategories
    }

    func onAppear() {
        getCategories()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(err) = completion {
                        self?.error = err.localizedDescription
                    }
                }, receiveValue: { [weak self] categories in
                    self?.categories = categories
                }
            )
            .store(in: &cancellables)
    }

    func refresh() {
        onAppear()
    }

    func getCategoryTitle() -> String {
        getCategory(withCategoryId: selectedCategoryId)?.title ?? "Select Category"
    }

    func add() {
        guard !url.isEmpty,
              let url = URL(string: url),
              UIApplication.shared.canOpenURL(url),
              let category = getCategory(withCategoryId: selectedCategoryId)
        else {
            error = "Form is not valid"
            errorPresented = true
            return
        }
        let link = Link(
            id: UUID(),
            url: url,
            title: title,
            desc: description,
            categoryName: category.title,
            categoryId: selectedCategoryId,
            hexColor: category.hexColor
        )
        saveLink(link)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] in
                if case let .failure(err) = $0 {
                    self?.error = err.localizedDescription
                }
            }, receiveValue: { [weak self] in
                self?.onDismiss = $0
            }).store(in: &cancellables)
    }

    private func getCategory(withCategoryId: UUID) -> Category? {
        categories.first(where: { $0.id == selectedCategoryId })
    }
}

extension NewLinkViewModel {
    static func make() -> Self {
        let linkProvider = LinkProvider.make()
        return .init(
            getLinks: linkProvider.getLinks,
            saveLink: linkProvider.saveLink,
            getCategories: CategoryProvider.make().getCategories)
    }
}
