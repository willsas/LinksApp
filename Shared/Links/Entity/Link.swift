// Created for LinksApp in 2022
// Using Swift 5.0 
        
import Foundation

public struct Link: Identifiable {
    public let id: UUID
    public let url: URL
    public let title: String
    public let desc: String
}
public extension Link {
    static func dummy(count: Int) -> [Self] {
        (1...count).map { count in
            .init(
                id: UUID(),
                url: URL(string: "https://www.google/\(count)")!,
                title: "title \(count)",
                desc: "lorem ipsum dor sit amet blablablaa asnuan able"
            )
        }
    }
}
