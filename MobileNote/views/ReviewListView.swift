//
//  ReviewListView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/17.
//

import SwiftUI

struct ReviewListView: View {
    var body: some View {
        List {
            ForEach(1 ..< 10) { index in
                NavigationLink {
                    DocView(docId: "编程语言-C-nav")
                } label: {
                    VStack(alignment: .leading) {
                        Text("编程语言-C-nav")
                        HStack {
                            Text("1999/2/17 12:00:00")
                                .font(.caption)
                            Text("unknow commit")
                                .font(.body)
                        }
                    }
                }
                
            }
        }
        
    }
}

struct ReviewListView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewListView()
    }
}
