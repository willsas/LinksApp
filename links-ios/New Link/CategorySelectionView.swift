// Created for LinksApp in 2022
// Using Swift 5.0

import SwiftUI

struct CategorySelectionParam: Identifiable {
    let id: UUID
    let name: String
    let hexString: String
}

struct CategorySelectionView: View {

    @Environment(\.presentationMode) var presentationMode

    @Binding var selectedId: UUID
    var categories: [CategorySelectionParam]

    var body: some View {
        NavigationView {
            List {
                ForEach(categories) { category in
                    HStack(spacing: 12) {
                        LinksImage.folderOpen
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.init(uiColor: .init(hex: category.hexString)!))
                        /*@START_MENU_TOKEN@*/Text(category.name)/*@END_MENU_TOKEN@*/
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
    static func make(selectedID: Binding<UUID>, categories: [CategorySelectionParam]) -> Self {
        .init(selectedId: selectedID, categories: categories)
    }
}

//struct CategorySelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategorySelectionView(selectedId: UUID(), categories: [
//            .init(id: UUID(), name: "name 1", hexString: "#f49325"),
//            .init(id: UUID(), name: "name 2", hexString: "#f49325"),
//            .init(id: UUID(), name: "name 3", hexString: "#f49325"),
//            .init(id: UUID(), name: "name 4", hexString: "#f49325")
//        ])
//    }
//}
