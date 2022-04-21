//
//  TOCListView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/21.
//

import SwiftUI

struct TOCListView: View {
    @State var tocList: [TOCItem] = []
    var body: some View {
        ScrollView {
            ForEach(tocList) { toc in
                TOCView(tocItem: toc)
                    .offset(x: 10, y: 0)
            }
        }.background(.white.opacity(0.8))
    }
}

struct TOCListView_Previews: PreviewProvider {
    static var previews: some View {
        TOCListView()
    }
}
