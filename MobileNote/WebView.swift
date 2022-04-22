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
    var invoker: Coordinator?
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        // 注册JS桥
        if let bridge = bridge, let bridgeName = bridgeName {
            webview.configuration.userContentController.add(bridge, name: bridgeName)
        }
        // 注册invoker
        if let invoker = invoker {
            invoker.webview = webview
        }
        context.coordinator.webview = webview
        return webview
    }
    
    func updateUIView(_ webview: WKWebView, context: Context) {
        // 记录上一次加载的内容 如果再次更新时还是之前的内容 不进行更新
        if let url = url, url != context.coordinator.lastUrl {
            let request = URLRequest(url: url)
            webview.load(request)
            context.coordinator.lastUrl = url
        }
        if let html = html, html != context.coordinator.lastHtml {
            webview.loadHTMLString(html, baseURL: nil)
            context.coordinator.lastHtml = html
        }
    }
    
    class Coordinator: NSObject {
        var lastHtml: String?
        var lastUrl: URL?
        weak var webview: WKWebView?
        
        func invoke(script: String) {
            if let webview = webview {
                webview.evaluateJavaScript(script) { result,error in
                    debugPrint(result, error)
                }
            }
        }
    }
}
