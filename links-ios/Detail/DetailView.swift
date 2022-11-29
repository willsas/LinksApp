// Created for LinksApp in 2022
// Using Swift 5.0
import Foundation
import SwiftUI

struct DetailView: View {

    let link: Link

    @State var title = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                }.frame(height: 1)
                DetailItemView(
                    title: link.title,
                    content: link.desc
                )
            }
        }
        .padding(.horizontal, 16)
    }
}

private struct DetailItemView: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color.primary)
            Text(content)
                .font(.body)
                .foregroundColor(Color.secondary)
                .lineLimit(nil)
        }
        .padding([.bottom, .top], 4)
    }
}
