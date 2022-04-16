//
//  DocUtils.swift
//  MobileNote
//
//  Created by mymac on 2022/4/14.
//

import Foundation

public func docId2Url(id: String) -> String {
    if (id.isEmpty) {
        return ""
    }
    let arr = id.components(separatedBy: "?")
    let id: String = arr[0]
    return id.components(separatedBy: "-").joined(separator: "/").replacingOccurrences(of: "@@", with: "-") + ".md"
}

public func docUrl2Id(url: String) -> String {
    var url = url
    if url.isEmpty {
        return ""
    }
    if url.starts(with: "./doc") {
        url = url.replacingOccurrences(of: "./doc", with: "")
    }
    if url.starts(with: "/doc") {
        url = url.replacingOccurrences(of: "/doc", with: "")
    }
    url = url.removingPercentEncoding!
    if url.starts(with: "./") || url.starts(with: "/") || url.starts(with: "doc") {
        return url.components(separatedBy: "/")
            .dropFirst()
            .joined(separator: "-")
            .replacingOccurrences(of: ".md", with: "")
            .components(separatedBy: "#")
            .first ?? ""
    } else {
        return url.components(separatedBy: "/")
            .joined(separator: "-")
            .replacingOccurrences(of: ".md", with: "")
            .components(separatedBy: "#")
            .first ?? ""
    }
}
