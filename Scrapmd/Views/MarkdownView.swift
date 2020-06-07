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
    
    func wrapHTML(_ html: String) -> String {
        "<html><head><meta charset=\"utf-8\"><style type=\"text/css\">body { font-family: Helvetica, sans-serif; line-height: 200%; color: \(UIColor.label.cssHex) } a { color: \(Color.accentColor.cssHex) } img { max-width: 100%; max-height: 320px; }</style></head><body>\(html)</body></html>".replacingOccurrences(of: "<img src=\"img/", with: "<img src=\"file://\(path.rawValue)/img/")
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
        let parser = MarkdownParser()
        let html = wrapHTML(parser.html(from: markdown))
        let data = html.data(using: .utf8)!
        DispatchQueue.main.async {
            do {
                let attributedText =  try NSAttributedString(
                    data: data,
                    options: [.documentType: NSAttributedString.DocumentType.html],
                    documentAttributes: nil)
                textView.attributedText = attributedText
            } catch {
                print(error)
            }
        }
    }
}

struct MarkdownView_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownView(
            markdown: "# hello\n\nit works.",
            path: FileKitPath.userHome
        )
    }
}
