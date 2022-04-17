//
//  DocImgBridge.swift
//  MobileNote
//
//  Created by mymac on 2022/4/17.
//

import Foundation
import WebKit

class DocImgBridge: NSObject, WKScriptMessageHandler {
    
    let onImgClick: (String) -> ()
    
    init(callback: @escaping (String) -> () = {v in ()}) {
        self.onImgClick = callback
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any] else { return }
        onImgClick(body["src"] as? String ?? "")
    }
}
