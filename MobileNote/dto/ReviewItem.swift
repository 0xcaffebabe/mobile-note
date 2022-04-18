//
//  ReviewItem.swift
//  MobileNote
//
//  Created by mymac on 2022/4/18.
//

import Foundation

enum ReviewItem: Codable {
    case docId(String)
    case commitInfo(CommitInfo)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .docId(x)
            return
        }
        if let x = try? container.decode(CommitInfo.self) {
            self = .commitInfo(x)
            return
        }
        throw DecodingError.typeMismatch(ReviewItem.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for InnerItem"))
    }
    
    static func toData(_ e :[ReviewItem]) -> Review {
        guard e.count == 2 else {
            return Review(docId: "", commitInfo: nil)
        }
        var docId: String = ""
        var commitInfo: CommitInfo?
        switch e[0] {
        case .docId(let x):
            docId = x
        case .commitInfo(let x):
            commitInfo = x
        }
        switch e[1] {
        case .docId(let x):
            docId = x
        case .commitInfo(let x):
            commitInfo = x
        }
        
        return Review(docId: docId, commitInfo: commitInfo ?? nil)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .docId(let x):
            try container.encode(x)
        case .commitInfo(let x):
            try container.encode(x)
        }
    }
}

struct Review: Hashable, Codable, Identifiable {
    var docId: String
    var commitInfo: CommitInfo?
    var id: String {
        docId
    }
}
