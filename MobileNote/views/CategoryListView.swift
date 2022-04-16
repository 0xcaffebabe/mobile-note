//
//  CategoryListView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/15.
//

import SwiftUI
import Combine

func pyFirstLetter(str: String) -> String{
    return str.transformToPinYin()
        .components(separatedBy: " ")
        .map { String($0[$0.startIndex]) }
        .joined(separator: "")
}

func categoryIsMatch(category: Category, queryString: String) -> Bool {
    return category.name.lowercased().contains(queryString.lowercased()) || // 包含完全匹配
    category.name.transformToPinYin().components(separatedBy: " ").joined(separator: "").lowercased().contains(queryString.lowercased()) || // 包含拼音完全匹配
    pyFirstLetter(str: category.name).lowercased().contains(queryString.lowercased()) // 包含拼音首字母匹配
}

final class CategoryListVM : ObservableObject {
    @Published var originCateList: [Category] = [] {
        didSet {
            onKWChanged(kw: "")
        }
    }
    @Published var filteredCateList: [Category] = []
    @Published var kw: String = ""
    @Published var debouncedKw: String = "" {
        didSet {
            debugPrint(debouncedKw)
            onKWChanged(kw: debouncedKw)
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        // 防抖
        $kw
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.global())
            .sink(receiveValue: { [weak self] t in
                DispatchQueue.main.async {
                    self?.debouncedKw = t
                }
            } )
            .store(in: &subscriptions)
    }
    
    /// <#Description#>  当搜索关键词发生变化时被调用
    /// - Parameter kw: <#kw description#>
    func onKWChanged(kw: String) {
        // 异步过滤目录列表
        DispatchQueue.global().async {
            let list = self.originCateList.flatMap{v in [v] + v.chidren}
                .filter {category in kw.isEmpty || categoryIsMatch(category: category, queryString: kw)}
            debugPrint(list.count)
            DispatchQueue.main.async {
                self.filteredCateList = list
            }
        }
    }
}

struct CategoryListView: View {
    @ObservedObject var categoryListVM: CategoryListVM = CategoryListVM()
    
    //    var flatCategoryList: [Category] {
    //        categoryList.flatMap{v in [v] + v.chidren}
    //            .filter {category in self.kw.isEmpty || categoryIsMatch(category: category, queryString: kw)}
    //    }
    var body: some View {
        NavigationView {
            List {
                TextField(text: $categoryListVM.kw) {
                    Text("输入搜索关键字")
                }
                ForEach(categoryListVM.filteredCateList) { category in
                    NavigationLink {
                        DocView(docId: docUrl2Id(url: category.link ?? ""))
                    } label: {
                        Text(category.name)
                    }.disabled(category.link == nil)
                }
            }
        }
        .onAppear{
            Api.defaultApi.getCategoryList { categoryList in
                if let categoryList = categoryList {
                    categoryListVM.originCateList = categoryList
                }
            }
        }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        
        CategoryListView()
    }
}

extension String {
    
    func transformToPinYin() -> String {
        
        let mutableString = NSMutableString(string: self)
        //把汉字转为拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        //去掉拼音的音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        
        return String(mutableString)
    }
}
