//
//  ContentView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/14.
//

import SwiftUI

struct ContentView: View {
    @State private var showWebView = false
    @State private var showAlert = false
    @State private var showDocView = false
    @State private var docFileInfo: DocFileInfo = DocFileInfo.empty()
    @Binding var docId: String
    
    var body: some View {
        TextField(text: $docId) {
            Text("输入Doc Id")
        }
        .padding(.horizontal)
        
        Button {
            Api.defaultApi.getDocFileInfo(id: docId) { docFileInfo in
                showDocView = true
                if let docFileInfo = docFileInfo {
                    self.docFileInfo = docFileInfo
                }
            }
        } label: {
            Text("转换")
        }
        .sheet(isPresented: $showDocView) {
            DocView(docFileInfo: docFileInfo)
        }
        
        Button {
            showWebView.toggle()
        } label: {
            Text("开始")
        }
        .sheet(isPresented: $showWebView) {
//            WebView(url: URL(string: "https://b.ismy.wang/#/doc/%E8%BD%AF%E4%BB%B6%E5%B7%A5%E7%A8%8B-%E5%AE%89%E5%85%A8%E7%94%9F%E4%BA%A7")!)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(docId: .constant(""))
    }
}
