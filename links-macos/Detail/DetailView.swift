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
                    subtitle: link.url.absoluteString,
                    content: link.desc
                )
                
                Text("Preview Website")
                    .font(.headline)
                    .foregroundColor(Color(NSColor.labelColor))
                WebView(url: link.url)
                    .padding(4)
            }
        }
        .padding(.horizontal, 16)
    }
}

private struct DetailItemView: View {
    let title: String
    let subtitle: String
    @State var content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color(NSColor.labelColor))
            Text(subtitle)
                .font(.footnote)
                .foregroundColor(Color(NSColor.linkColor))
            EditableLabel($content) {
                print(content)
            }
            .lineLimit(nil)
        }
        .padding([.bottom, .top], 4)
    }
}

public struct EditableLabel: View {
    @Binding var text: String
    @State private var newValue: String = ""

    @State var editProcessGoing = false { didSet { newValue = text } }

    let onEditEnd: () -> Void

    public init(_ txt: Binding<String>, onEditEnd: @escaping () -> Void) {
        _text = txt
        self.onEditEnd = onEditEnd
    }

    @ViewBuilder public var body: some View {
        ZStack {
            Text(text)
                .opacity(editProcessGoing ? 0 : 1)
            MacEditorv2(text: $text).font(.body)
        }
        .onTapGesture(count: 1, perform: { editProcessGoing = true })
    }
}

struct MacEditorv2: NSViewRepresentable {
    
    @Binding var text: String
    let textView = NSTextView.scrollableTextView()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> NSScrollView {
        let textView = (textView.documentView as! NSTextView)
        textView.delegate = context.coordinator
        textView.string = text
        textView.backgroundColor = .clear
        textView.textContainer?.lineFragmentPadding = 0
        return self.textView

    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {}
}

extension MacEditorv2 {
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: MacEditorv2
        
        init(_ parent: MacEditorv2) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
        }
        
        func textView(
            _ textView: NSTextView,
            shouldChangeTextIn affectedCharRange: NSRange,
            replacementString: String?
        ) -> Bool {
            true
        }
    }
}
