//
//  TOCItem.swift
//  MobileNote
//
//  Created by mymac on 2022/4/20.
//

import Foundation

class TOCItem: Codable, Identifiable, CustomStringConvertible {
    
    var name: String
    var link: String
    var level: Int
    var children: [TOCItem]
    var id: String {link + name}
    
    init(name: String, link: String, level: Int, children: [TOCItem]) {
        self.name = name
        self.link = link
        self.level = level
        self.children = children
    }
}
