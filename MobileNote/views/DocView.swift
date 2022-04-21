//
//  DocView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/14.
//

import SwiftUI
import ImageViewerRemote

struct DocView: View {
    @Environment(\.colorScheme) var colorScheme
    var baseData = BaseData()
    @State var docId: String
    @State private var docFileInfo: DocFileInfo = DocFileInfo.empty()
    
    @State var showImageViewer: Bool = false
    @State var imgURL: String = "https://..."
    @State var imgDesc: String = "111"
    
    @State var showToc = false
    
    
    var body: some View {
        ZStack {
            
            WebView(
                html: """
            <html>
                <header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>
                <style>
                    \(baseData.markdownV1Css)
                </style>
                <body theme='\(colorScheme == .dark ? "dark": "light")'>
                    <div class="markdown-section">
                    \(docFileInfo.html)
                    </div>
                </body>
                <script>
                    \(baseData.docJs)
                </script>
            </html>
            """, bridge: DocImgBridge{ imgSrc, imgDesc in
                self.imgURL = imgSrc
                self.imgDesc = imgDesc
                debugPrint("img desc \(self.imgDesc)")
                self.showImageViewer = true
            }, bridgeName: "doc-img-click")
            .overlay {
                ImageViewerRemote(imageURL: self.$imgURL, viewerShown: self.$showImageViewer, closeButtonTopRight: true)
                if showImageViewer {
                    VStack {
                        Spacer()
                        Spacer()
                        Text(imgDesc)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }.frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            
            .onAppear {
                Api.defaultApi.getDocFileInfo(id: docId) { docFileInfo in
                    if let docFileInfo = docFileInfo {
                        self.docFileInfo = docFileInfo
                    }
                }
            }
            .navigationTitle(docFileInfo.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(self.$showImageViewer.wrappedValue == true)
            
            
            Button {
                withAnimation(Animation.easeInOut.delay(0.4)) {
                    self.showToc.toggle()
                }
            }label: {
                Text("目录")
            }
        }.overlay {
            if self.showToc {
                TOCListView(tocList: self.docFileInfo.toc)
                    .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height, alignment: .bottomLeading)
                    .offset(x: (UIScreen.main.bounds.width / 4), y: 0)
            }
        }
    }
}

struct DocView_Previews: PreviewProvider {
    static var previews: some View {
        DocView(docId: "" )
    }
}
