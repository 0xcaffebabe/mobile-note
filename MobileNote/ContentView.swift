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
        NavigationView {
            VStack {
                TextField(text: $docId) {
                    Text("输入Doc Id")
                }
                .padding(.horizontal)
                NavigationLink {
                    
                    DocView(docId: docId)
                } label: {
                    Text("进入")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(docId: .constant(""))
    }
}
