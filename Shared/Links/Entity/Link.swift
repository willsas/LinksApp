// Created for LinksApp in 2022
// Using Swift 5.0 
        
import Foundation

public struct Link: Identifiable {
    public let id: UUID
    public let url: URL
    public let title: String
    public let desc: String
    public let categoryName: String
    public let categoryId: UUID
    public let hexColor: String
}
