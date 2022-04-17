//
//  ContentView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/14.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection: Tab = .categoryList
    
    enum Tab {
        case categoryList
        case reviewList
    }
    
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                CategoryListView()
                    .tabItem{
                        Label("目录", systemImage: "book")
                    }
                    .tag(Tab.categoryList)
                ReviewListView()
                    .tabItem{
                        Label("回顾", systemImage: "pencil")
                    }
                    .tag(Tab.reviewList)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
