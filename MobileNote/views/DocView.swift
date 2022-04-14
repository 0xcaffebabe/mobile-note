//
//  DocView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/14.
//

import SwiftUI

struct DocView: View {
    @State var docFileInfo: DocFileInfo
    var body: some View {
        WebView(html: docFileInfo.html)
    }
}

struct DocView_Previews: PreviewProvider {
    static var previews: some View {
        DocView(docFileInfo: DocFileInfo.empty())
    }
}
