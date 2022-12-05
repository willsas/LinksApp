// Created for LinksApp in 2022
// Using Swift 5.0 
        
import Foundation
import SwiftUI

extension Color {
    func asHex() -> String {
        UIColor(cgColor: cgColor!).asHex()
    }
}
