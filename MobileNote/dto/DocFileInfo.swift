//
//  DocFileInfo.swift
//  MobileNote
//
//  Created by mymac on 2022/4/14.
//

import Foundation
import Ink
import SwiftSoup

struct DocFileInfo: Hashable, Codable {
    // 文档名称
    let name: String
    // 文档ID
    let id: String
    let content: String
    //let commitList: [CommitInfo]
    // commitList默认最多只展示10个 用此字段标志是否有更多
    let hasMoreCommit: Bool
    let totalCommits: Int
    let metadata: String
    let createTime: String
    
    lazy var html: String = {
        var parser = MarkdownParser()
        
        
        let modifier = Modifier(target: .images) { html, markdown in
            do {
                let doc = try SwiftSoup.parse(html)
                var imgLink = try doc.select("img").attr("src")
                let imgTitle = try doc.select("img").attr("alt")
                if imgLink.starts(with: "/") {
                    if let range = imgLink.range(of: "/") {
                        imgLink = Api.baseUrl + imgLink.replacingCharacters(in: range, with: "")
                    }
                }
                try doc.select("img").attr("src", imgLink)
                return "<p class='img-wrapper'>\(try doc.html())<p class='img-title'>\(imgTitle)</p></p>"
            }catch Exception.Error(let type, let message) {
                print(message)
            } catch {
                print("error")
            }
            return html
        }

        parser.addModifier(modifier)
        
        let result = parser.parse(content)
        return result.html
    }()
    
    lazy var toc: [TOCItem] = {
        do {
            let doc = try SwiftSoup.parse(self.html)
            let allHead = try doc.select("h1, h2, h3, h4, h5, h6")
            // 用来存储最近的Hx节点
                /*
                  算法概要：
                  获取所有h1 - h6 节点
                  计算顶级目录层级：查找出来的第一个Hx节点的level
                  每次迭代将dom元素转为Content类 并将转换后的对象存储到contentMap（key: level, value: content）里
                  除了顶级目录 其他目录每次都会通过ContentMap找寻其最近的一个父节点 并将自己添加到父节点的孩子列表
                */
            var contentMap: [TOCItem?] = [nil, nil, nil, nil, nil, nil, nil, nil]
            var result: [TOCItem] = []
            var topLevel = -1
            var cnt = 0
            for head in allHead {
                let level = Int(head.tagName().replacingOccurrences(of: "h", with: ""))!
                if topLevel == -1 {
                    topLevel = level
                }
                
                var tocItem = TOCItem(
                    name: try head.text(),
                    link: String(cnt),
                    level: level,
                    children: []
                )
                cnt += 1
                contentMap[level] = tocItem
                if level == topLevel {
                    result.append(tocItem)
                }else {
                    var i = level - 1
                    while i >= 1 {
                        if var toc = contentMap[i] {
                            toc.children.append(tocItem)
                        }
                        i -= 1;
                    }
                }
                
            }
            return result
        }catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
        return []
    }()
    
    
    static func empty() -> DocFileInfo {
        return DocFileInfo(name: "test", id: "test", content: "# Test", hasMoreCommit: false, totalCommits: 1, metadata: "", createTime: "2022-04-14 23:00:00")
    }
}
