// Created for LinksApp in 2022
// Using Swift 5.0

import Foundation

public struct Category: Identifiable {
    public let id: UUID
    public let title: String
    public let hexColor: String
    public let links: [Link]
}
