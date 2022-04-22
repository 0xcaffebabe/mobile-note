//
//  DocView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/14.
//

import SwiftUI
import ImageViewerRemote
import Snap


struct DocView: View {
    @Environment(\.colorScheme) var colorScheme
    var baseData = BaseData()
    @State var docId: String
    @State private var docFileInfo: DocFileInfo = DocFileInfo.empty()
    
    @State var showImageViewer: Bool = false
    @State var imgURL: String = "https://..."
    @State var imgDesc: String = "111"
    
    @State var ready = false
    @State private var drawerState: AppleMapsSnapState = .tiny
    
    @State private var invoker: WebView.Coordinator = WebView.Coordinator()
    
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
            }, bridgeName: "doc-img-click", invoker: invoker)
            
            
            .onAppear {
                Api.defaultApi.getDocFileInfo(id: docId) { docFileInfo in
                    if let docFileInfo = docFileInfo {
                        self.docFileInfo = docFileInfo
                        self.ready = true
                    }
                }
            }
            .navigationTitle(docFileInfo.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(self.$showImageViewer.wrappedValue == true)
            .ignoresSafeArea()
            
            if self.ready {
                SnapDrawer(state: $drawerState, large: .paddingToTop(24), medium: .fraction(0.6), tiny: .height(5), allowInvisible: false) { state in
                    VStack {
                        Text("目录")
                        TOCListView(tocList: self.docFileInfo.toc) {id in
                            invoker.invoke(script: """
                                var elm  = document.querySelectorAll('h1,h2,h3,h4,h5,h6')[\(id)]
                                window.scrollTo(0, elm.offsetTop)
                            """)
                            debugPrint("cate click", id)
                        }
                        
                    }.ignoresSafeArea()
                    
                }
                
            }
            
        }.overlay {
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
        
    }
}

struct DocView_Previews: PreviewProvider {
    static var previews: some View {
        DocView(docId: "" )
    }
}
