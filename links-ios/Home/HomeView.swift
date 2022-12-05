// Created for LinksApp in 2022
// Using Swift 5.0

import SwiftUI

struct HomeView: View {

    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    let height: CGFloat = 120

    @ObservedObject var viewModel: HomeViewModel
    
    @State var presentAddCategory: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                LinksColor.background
                    .ignoresSafeArea(edges: .bottom)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.categoriesLinks) { category in
                            CardView(
                                title: category.title ,
                                totalLink: "\(category.links.count) links",
                                color: category.color
                            )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .frame(height: height)
                        }
                    }
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                }
            }
            .refreshable { viewModel.refresh() }
            .navigationTitle("Links")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {}
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Add Category") {
                        presentAddCategory.toggle()
                    }
                    Button {
                    } label: {
                        HStack(alignment: .center) {
                            Image(systemName: "plus.circle.fill")
                            Text("New link")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .sheet(isPresented: $presentAddCategory) {
            AddCategoryView.make()
        }
    }
}

private struct CardView: View {
    var title: String
    var totalLink: String
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                LinksImage.folderOpen
                    .resizable()
                    .frame(width: 52, height: 52)
                    .foregroundColor(color)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(LinksColor.black)
                Text(totalLink)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(LinksColor.secondary)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14))
        .background(LinksColor.white)
    }
}

extension HomeView {
    static func make() -> Self {
        .init(viewModel: .make())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView.make()
    }
}
