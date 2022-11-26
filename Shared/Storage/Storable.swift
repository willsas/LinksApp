// Created for LinksApp in 2022
// Using Swift 5.0

import Combine
import Foundation

protocol Storable {
    func save<T>(_ data: T) -> AnyPublisher<Bool, Error>
    func retrive<T>() -> AnyPublisher<T, Error>
}
