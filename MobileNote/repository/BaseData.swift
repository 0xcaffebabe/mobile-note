//
//  FileReader.swift
//  MobileNote
//
//  Created by mymac on 2022/4/15.
//

import Foundation

struct BaseData {
    let markdownV1Css = load(filename: "markdown-v1.css")
}


func load(filename: String) -> String {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    return String(decoding: data, as: UTF8.self)
}
