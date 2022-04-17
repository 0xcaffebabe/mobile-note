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
    var bridge: WKScriptMessageHandler?
    var bridgeName: String?
    
    func makeUIView(context: Context) -> WKWebView {
        debugPrint("create webview")
        let webview = WKWebView()
        // 注册JS桥
        if let bridge = bridge, let bridgeName = bridgeName {
            webview.configuration.userContentController.add(bridge, name: bridgeName)
        }
        return webview
    }
    
    func updateUIView(_ webview: WKWebView, context: Context) {
        if let url = url {
            let request = URLRequest(url: url)
            webview.load(request)
        }
        if let html = html {
            webview.loadHTMLString(html, baseURL: nil)
        }
    }
}
