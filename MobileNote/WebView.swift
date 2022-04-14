//
//  WebView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/14.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var url: URL?
    var html: String?
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        if let html = html {
            webView.loadHTMLString(html, baseURL: nil)
        }
    }
}
