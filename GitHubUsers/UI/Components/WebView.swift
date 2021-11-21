//
//  WebView.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/20.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var loadUrl: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: loadUrl) {
            uiView.load(URLRequest(url: url))
        }
    }
}
