// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

protocol Storable {
    associatedtype T
    associatedtype Array
    func save(_ data: T) -> AnyPublisher<Bool, Error>
    func retrive() -> AnyPublisher<Array, Error>
    func delete(_ data: T) -> AnyPublisher<Bool, Error>
}
