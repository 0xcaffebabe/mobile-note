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
