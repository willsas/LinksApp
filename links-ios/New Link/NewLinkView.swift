// Created for LinksApp in 2022
// Using Swift 5.0

import SwiftUI

struct NewLinkView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddCategoryViewModel
    
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
                                TextField("Link", text: $viewModel.name)
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
                                TextField("Title", text: $viewModel.name)
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                    .frame(height: 52)
                                    .background(LinksColor.white)
                                    .multilineTextAlignment(.leading)
                                
                                Divider()
                                
                                TextField("Description", text: $viewModel.name, axis: .vertical)
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                                    .frame(height: 80, alignment: .top)
                                    .background(LinksColor.white)
                                    .multilineTextAlignment(.leading)
                                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
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
                                    Text("Select Category")
                                        .font(.system(size: 17, weight: .regular, design: .rounded))
                                        .foregroundColor(LinksColor.secondary)
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(LinksColor.secondary)
                                }.onTapGesture {
                                    print("ayey")
                                }
                            }
                            .padding(EdgeInsets(top: 17, leading: 12, bottom: 17, trailing: 12))
                        }
                        .cornerRadius(12)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                    }
                }
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
//                        viewModel.save()
                    }
                }
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
