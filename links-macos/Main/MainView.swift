// Created for LinksApp in 2022
// Using Swift 5.0 
        
import SwiftUI

struct MainView: View {

    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        NavigationView {
            List(viewModel.links) { link in
                NavigationLink(
                    destination: WebView(url: link.url),
                    label: {
                        VStack(alignment: .leading) {
                            Text(link.title)
                                .font(.headline)
                            Text(link.url.absoluteString)
                                .font(.caption)
                                .foregroundColor(.blue)
                            Text(link.desc)
                                .font(.footnote)
                                .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
                        }.padding(6)
                    }
                )
            }.toolbar {
                ToolbarItem {
                    Menu {} label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Links")
        }

        .onAppear {
            viewModel.getLinks()
        }
    }
}

extension MainView {
    static func make() -> Self {
        .init(viewModel: .make())
    }
}

// struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
// }
