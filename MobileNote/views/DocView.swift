//
//  DocView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/14.
//

import SwiftUI
import ImageViewerRemote

struct DocView: View {
    var baseData = BaseData()
    @State var docId: String
    @State private var docFileInfo: DocFileInfo = DocFileInfo.empty()
    
    @State var showImageViewer: Bool = false
    @State var imgURL: String = "https://..."
    
    
    var body: some View {
                WebView(
                    html: """
                <html>
                    <header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>
                    <style>
                        \(baseData.markdownV1Css)
                    </style>
                    <body>
                        <div class="markdown-section">
                        \(docFileInfo.html)
                        </div>
                    </body>
                    <script>
                        \(baseData.docJs)
                    </script>
                </html>
                """, bridge: DocImgBridge{ imgSrc in
                    self.imgURL = imgSrc
                    self.showImageViewer = true
                }, bridgeName: "doc-img-click")
                .overlay {
                    ImageViewerRemote(imageURL: self.$imgURL, viewerShown: self.$showImageViewer, closeButtonTopRight: true)
                }
            
        .onAppear {
            Api.defaultApi.getDocFileInfo(id: docId) { docFileInfo in
                if let docFileInfo = docFileInfo {
                    self.docFileInfo = docFileInfo
                }
            }
        }        .navigationTitle(docFileInfo.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(self.$showImageViewer.wrappedValue == true)
        
        
    }
}

struct DocView_Previews: PreviewProvider {
    static var previews: some View {
        DocView(docId: "" )
    }
}
