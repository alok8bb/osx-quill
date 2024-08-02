//
//  osx_quillApp.swift
//  osx-quill
//
//  Created by Alok on 02/08/24.
//

import SwiftUI

@main
struct osx_quillApp: App {
    @StateObject private var quoteManager = QuoteManager()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(quoteManager)
        }
        
        MenuBarExtra(quoteManager.currentQuote.text.lowercased()) {
            Button("Quit"){
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        }
    }
}
