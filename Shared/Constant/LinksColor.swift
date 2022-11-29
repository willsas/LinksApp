// Created for LinksApp in 2022
// Using Swift 5.0

import SwiftUI

struct LinksColor {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
    static var background: Color {
        Color(uiColor: UIColor(red: 0.949, green: 0.949, blue: 0.965, alpha: 1))
    }
    static var white: Color { .white }
    static var black: Color { .black }
    static var secondary: Color {
        Color(uiColor: UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6))
    }
}
