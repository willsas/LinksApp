// Created for LinksApp in 2023
// Using Swift 5.0

import Foundation

public extension UUID {
    static func idForAllCategory() -> UUID {
        //TODO: harusnya generate uuid lalu save ke core data biar gaada kemungkinan duplicate
        .init(uuidString: "68753A44-4D6F-1226-9C60-0050E4C00067")!
    }
}
