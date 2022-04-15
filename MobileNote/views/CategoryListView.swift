//
//  CategoryListView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/15.
//

import SwiftUI

struct CategoryListView: View {
    @State var categoryList: [Category]
    var body: some View {
        List {
            ForEach(categoryList) { category in
                Text(category.name)
            }
        }.onAppear{
            Api.defaultApi.getCategoryList { categoryList in
                if let categoryList = categoryList {
                    self.categoryList = categoryList
                }
            }
        }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        
        CategoryListView(categoryList:
                            [Category(name: "测试目录", link: "./a.md", chidren: []),
                             Category(name: "测试目录1", link: "./b.md", chidren: [])
                            ])
    }
}
