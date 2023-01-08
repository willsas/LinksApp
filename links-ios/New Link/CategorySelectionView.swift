// Created for LinksApp in 2022
// Using Swift 5.0

import SwiftUI

struct CategorySelectionView: View {

    @Environment(\.presentationMode) var presentationMode

    @Binding var selectedId: UUID
    var categories: [Category]

    var body: some View {
        NavigationView {
            List {
                ForEach(categories) { category in
                    HStack(spacing: 12) {
                        LinksImage.folderOpen
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.init(uiColor: .init(hex: category.hexColor)!))
                        Text(category.title)
                        Spacer()
                        if selectedId == category.id {
                            Image(systemName: "checkmark")
                        }
                    }.onTapGesture {
                        selectedId = category.id
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
                }
            }
        }
    }
}

extension CategorySelectionView {
    static func make(selectedID: Binding<UUID>, categories: [Category]) -> Self {
        .init(selectedId: selectedID, categories: categories)
    }
}
