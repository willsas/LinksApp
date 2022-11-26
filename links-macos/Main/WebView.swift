// Created for LinksApp in 2022
// Using Swift 5.0 

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    typealias NSViewType = WKWebView
    var url: URL

    func makeNSView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        nsView.load(request)
    }
}
