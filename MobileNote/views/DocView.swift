//
//  DocView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/14.
//

import SwiftUI

struct DocView: View {
    @State var docId: String
    @State private var docFileInfo: DocFileInfo = DocFileInfo.empty()
    var body: some View {
            WebView(
                html: """
            <html>
                <header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>
                <style>
                    \(BaseData().markdownV1Css)
                </style>
                <body>
                    <div class="markdown-section">
                    \(docFileInfo.html)
                    </div>
                </body>
            </html>
            """)
        .onAppear {
            Api.defaultApi.getDocFileInfo(id: docId) { docFileInfo in
                if let docFileInfo = docFileInfo {
                    self.docFileInfo = docFileInfo
                }
            }
        }        .navigationTitle(docFileInfo.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DocView_Previews: PreviewProvider {
    static var previews: some View {
        DocView(docId: "" )
    }
}
