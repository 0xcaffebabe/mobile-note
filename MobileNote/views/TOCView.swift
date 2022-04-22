//
//  TOCView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/20.
//

import SwiftUI

struct TOCView: View {
    @State var tocItem: TOCItem
    var onClick : (String) -> () = { _ in ()}
    var body: some View {
        VStack(alignment: .leading) {
            Text(tocItem.name)
                .font(.body)
                .foregroundColor(.blue)
                .onTapGesture {
                    onClick(tocItem.link)
                }
            Divider()
            Spacer()
            Group {
                VStack {
                    if let children = tocItem.children {
                        ForEach(children) { item in
                            TOCView(tocItem: item, onClick: self.onClick)
                        }
                    }
                }
                
            }.offset(x: CGFloat(tocItem.level * 10), y: 0)
        }
    }
}

struct TOCView_Previews: PreviewProvider {
    static var previews: some View {
        TOCView(tocItem: TOCItem(
            name: "安全生产",
            link: "1",
            level: 1,
            children: [
                TOCItem(name: "组织&团队", link: "2", level: 2, children: []),
                TOCItem(name: "执行", link: "3", level: 2, children: []),
                TOCItem(name: "研发体系", link: "4", level: 2, children: [
                    TOCItem(name: "变更流程管控", link: "2", level: 2, children: []),
                    TOCItem(name: "准入体系", link: "3", level: 2, children: [])
                ])
            ]
        ))
    }
}
