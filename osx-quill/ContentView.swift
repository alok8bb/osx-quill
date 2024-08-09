//
//  ContentView.swift
//  osx-quill
//
//  Created by Alok on 02/08/24.
//

import SwiftUI
import SwiftData

enum Tab {
    case Home
    case Settings
    case About
}

struct ContentView: View {
    @Binding var selectedTab: Tab

    var body: some View {
        TabView (selection: $selectedTab) {
            HomeView().tabItem {
                Label("Home", systemImage: "house")
            }.tag(Tab.Home)
            SettingsView().tabItem {
                Label("Settings", systemImage: "gear")
            }.tag(Tab.Settings)
            AboutView().tabItem{
                Label("About", systemImage: "info.circle")
            }.tag(Tab.About)
        }
        .padding()
    }
}
