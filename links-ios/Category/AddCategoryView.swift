// Created for LinksApp in 2022
// Using Swift 5.0 
        

import SwiftUI

let allColors = (1...12).map { _ in LinksColor.random }

struct AddCategoryView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var name = ""
    @State var color = allColors.first!
    
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
                                LinksImage.folderOpen
                                    .resizable()
                                    .frame(width: 52, height: 52)
                                    .foregroundColor(color)
                                
                                TextField("Name", text: $name)
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .frame(height: 56)
                                    .background(LinksColor.background)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(16)
                        }
                        .cornerRadius(12)
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                        
                        ZStack {
                            LinksColor.white
                            ColorSwatchView(selection: $color)
                            .padding(16)
                        }
                        .cornerRadius(12)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    }
                }
            }
            .navigationTitle("Add Categories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {}
                }
            }
        }
      
    }
}

private struct ColorSwatchView: View {

    @Binding var selection: Color
    
    let colors = allColors
    let columns = [GridItem(.adaptive(minimum: 50))]
    
    var body: some View {

        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(colors, id: \.self) { color in
                ZStack {
                    Circle()
                        .fill(color)
                        .frame(width: 40, height: 40)
                        .onTapGesture(perform: {
                            selection = color
                        })
                        .padding(10)

                    if selection == color {
                        Circle()
                        .stroke(LinksColor.background, lineWidth: 5)
                            .frame(width: 54, height: 54)
                    }
                }
            }
        }
        .padding(10)
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView()
    }
}
