//
//  TOCListView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/21.
//

import SwiftUI

struct TOCListView: View {
    @State var tocList: [TOCItem] = []
    var onClick : (String) -> () = { _ in ()}
    var body: some View {
        ScrollView {
            ForEach(tocList) { toc in
                TOCView(tocItem: toc, onClick: self.onClick)
                    .offset(x: 10, y: 0)
            }
        }.padding(.leading, 20)
    }
}

struct TOCListView_Previews: PreviewProvider {
    static var previews: some View {
        TOCListView()
    }
}
