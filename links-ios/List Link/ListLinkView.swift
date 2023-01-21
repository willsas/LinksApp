// Created for LinksApp in 2022
// Using Swift 5.0

import SwiftUI

struct ListLinkView: View {
    
    enum LinkType {
        case all
        case category(categoryId: String)
    }

    @ObservedObject var viewModel: ListLinkViewModel
    let linkType: LinkType

    var body: some View {
        ZStack {
            switch viewModel.listType {
            case .link(let links):
                List {
                    ForEach(links) {
                        LinkCell(link: $0)
                    }
                    .onDelete { viewModel.deleteLink($0) }
                }
            case .grouped(let grouped):
                List(grouped) { groupedLink in
                    Section {
                        ForEach(groupedLink.links) { link in
                            LinkCell(link: link)
                        }
                        .onDelete { viewModel.deleteLink($0) }
                    } header: {
                        Text(groupedLink.title)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .padding(.bottom, 16)
                    }
                }
               
            }
        }
        .navigationTitle(viewModel.navigationTitle)
        .onAppear {
            viewModel.getLinks(type: linkType)
        }
        
    }
}

private struct LinkCell: View {

    let link: Link

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: getIconUrl())
                .frame(width: 24, height: 24)
                .aspectRatio(contentMode: .fit)

            VStack(alignment: .leading) {
                Text(link.title)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(LinksColor.black)

                Text(link.desc)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(LinksColor.secondary)

            }

        }.padding([.top, .bottom], 16)
    }
    
    private func getIconUrl() -> URL {
        let stringUrl = "https://t0.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=\(link.url)&size=24"
        return URL(string: stringUrl)!
    }
}

// struct ListLinkView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListLinkView()
//    }
// }

extension ListLinkView {
    static func make(linkType type: LinkType) -> Self {
        .init(viewModel: .make(), linkType: type)
    }
}
