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
                debugPrint(imgLink, imgTitle)
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
    
    
    static func empty() -> DocFileInfo {
        return DocFileInfo(name: "test", id: "test", content: "# Test", hasMoreCommit: false, totalCommits: 1, metadata: "", createTime: "2022-04-14 23:00:00")
    }
}
