//
//  LoginWebView.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/23.
//

import SwiftUI
import WebKit
import Foundation

struct LoginWebView: UIViewRepresentable {
    @ObservedObject private(set) var viewModel: LoginWebViewModel
    
    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        var parent: LoginWebView
        var viewModel: LoginWebViewModel
        
        init(_ parent: LoginWebView, _ viewModel: LoginWebViewModel) {
            self.parent = parent
            self.viewModel = viewModel
        }
        
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
            if let requestUrl = navigationAction.request.url {
                viewModel.checkRedirectUrl(requestUrl)
            }
            
            decisionHandler(WKNavigationActionPolicy.allow);
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        
        if let url = URL(string: viewModel.fetchAuthUrl()) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
