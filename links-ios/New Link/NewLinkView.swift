// Created for LinksApp in 2022
// Using Swift 5.0

import SwiftUI

struct NewLinkView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: NewLinkViewModel
    @State var presentSelectCategory: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                LinksColor.background
                    .ignoresSafeArea(edges: .bottom)
                ScrollView {
                    VStack(alignment: .center, spacing: 15) {

                        ZStack {
                            LinksColor.white
                            VStack(alignment: .center, spacing: 20) {
                                TextField("Link", text: $viewModel.url)
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                    .frame(height: 44)
                                    .background(LinksColor.white)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                        }
                        .cornerRadius(12)
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))

                        ZStack {
                            LinksColor.white
                            VStack(alignment: .center, spacing: 0) {
                                TextField("Title", text: $viewModel.title)
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                    .frame(height: 52)
                                    .background(LinksColor.white)
                                    .multilineTextAlignment(.leading)

                                Divider()

                                TextField(
                                    "Description",
                                    text: $viewModel.description,
                                    axis: .vertical
                                )
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                .frame(height: 80, alignment: .top)
                                .background(LinksColor.white)
                                .multilineTextAlignment(.leading)
                                .padding(EdgeInsets(
                                    top: 10,
                                    leading: 0,
                                    bottom: 10,
                                    trailing: 0
                                ))
                            }
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                        }
                        .cornerRadius(12)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                        ZStack {
                            LinksColor.white
                            HStack(alignment: .center) {
                                Text("Category")
                                    .font(.system(size: 17, weight: .regular, design: .rounded))

                                Spacer()

                                HStack(spacing: 12) {
                                    Text(viewModel.getCategoryTitle())
                                        .font(.system(size: 17, weight: .regular, design: .rounded))
                                        .foregroundColor(LinksColor.secondary)
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(LinksColor.secondary)
                                }.onTapGesture {
                                    presentSelectCategory = true
                                }
                            }
                            .padding(EdgeInsets(top: 17, leading: 12, bottom: 17, trailing: 12))
                        }
                        .cornerRadius(12)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                    }
                }
            }
            .onAppear {
                viewModel.onAppear()
            }
            .navigationTitle("New Link")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        viewModel.add()
                    }
                }
            }
            .onReceive(viewModel.$onDismiss) { onDismiss in
                if onDismiss {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .sheet(isPresented: $presentSelectCategory) {
                CategorySelectionView.make(
                    selectedID: $viewModel.categoryId,
                    categories: viewModel.categoriesLinks
                        .map {
                            CategorySelectionParam(
                                id: $0.id,
                                name: $0.title,
                                hexString: $0.color.asHex()
                            )
                        }
                )
            }
        }
    }
}

extension NewLinkView {
    static func make() -> Self {
        .init(viewModel: .make())
    }
}

struct NewLinkView_Previews: PreviewProvider {
    static var previews: some View {
        NewLinkView(viewModel: .make())
    }
}
