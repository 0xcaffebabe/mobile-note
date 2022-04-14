//
//  DocFileInfo.swift
//  MobileNote
//
//  Created by mymac on 2022/4/14.
//

import Foundation
import Ink

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
        let parser = MarkdownParser()
        let result = parser.parse(content)
        return result.html
    }()
    
    
    static func empty() -> DocFileInfo {
        return DocFileInfo(name: "test", id: "test", content: "# Test", hasMoreCommit: false, totalCommits: 1, metadata: "", createTime: "2022-04-14 23:00:00")
    }
}
