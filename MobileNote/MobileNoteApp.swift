//
//  MobileNoteApp.swift
//  MobileNote
//
//  Created by mymac on 2022/4/14.
//

import SwiftUI

@main
struct MobileNoteApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(docId: .constant("软件工程-安全生产"))
        }
    }
}
