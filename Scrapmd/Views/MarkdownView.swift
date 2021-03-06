//
//  MarkdownView.swift
//  Scrapmd
//
//  Created by Atsushi Nagase on 2020/06/07.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import SwiftUI
import Ink

struct MarkdownView: UIViewRepresentable {
    let markdown: String
    let path: FileKitPath
    @Binding var showSource: Bool

    func wrapHTML(_ html: String, width: CGFloat) -> String {
        // swiftlint:disable:next line_length
        "<html><head><meta charset=\"utf-8\"><style type=\"text/css\">body { font-family: Helvetica, sans-serif; line-height: 200%; color: \(UIColor.label.cssHex) } a { color: \(Color.accentColor.cssHex) } img { max-width: \(width > 500 ? "100%" : "\(width - 20)px"); max-height: \(width)px; text-align: center; display: block; margin: 0 auto; }</style></head><body>\(html)</body></html>".replacingOccurrences(of: "<img src=\"img/", with: "<img src=\"file://\(path.rawValue)/img/")
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.font = .systemFont(ofSize: UIFont.labelFontSize)
        textView.textColor = .label
        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        if showSource {
            textView.text = markdown
            return
        }
        let parser = MarkdownParser()
        let html = wrapHTML(parser.html(from: markdown), width: UIApplication.shared.windows.first?.bounds.width ?? 320)
        let data = html.data(using: .utf8)!
        DispatchQueue.main.async {
            do {
                let attributedText =  try NSAttributedString(
                    data: data,
                    options: [.documentType: NSAttributedString.DocumentType.html],
                    documentAttributes: nil)
                textView.attributedText = attributedText
            } catch {
                log(error: error)
            }
        }
    }
}

struct MarkdownView_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownView(
            markdown: "# hello\n\nit works.",
            path: FileKitPath.userHome,
            showSource: .constant(false)
        )
    }
}
