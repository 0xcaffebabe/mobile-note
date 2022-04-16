//
//  Category.swift
//  MobileNote
//
//  Created by mymac on 2022/4/15.
//

import Foundation

struct Category: Hashable, Codable, Identifiable {
    let name: String
    let link: String?
    var id: String {
        if let link = link {
            return  name + "-" + link
        }
        return name
    }
    let chidren: [Category]
}
