//
//  osx_quillApp.swift
//  osx-quill
//
//  Created by Alok on 02/08/24.
//

import SwiftUI

@main
struct osx_quillApp: App {
    @State private var selectedTab: Tab = .Home
    @StateObject var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView(selectedTab: $selectedTab).environmentObject(appState)
        }
        
        MenuBarExtra(appState.currentQuote.text.lowercased()) {
            Button("Settings"){
                selectedTab = .Settings
            }.keyboardShortcut(",")
            Button("Quit"){
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        }
    }
}
