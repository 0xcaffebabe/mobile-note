//
//  CommitInfo.swift
//  MobileNote
//
//  Created by mymac on 2022/4/14.
//

import Foundation

struct CommitInfo : Hashable, Codable {
    let date: String
    let author: String
    let message: String
    let hash: String
    let insertions: Int?
    let deletions: Int?
}
