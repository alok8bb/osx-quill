//
//  AppState.swift
//  osx-quill
//
//  Created by Alok on 02/08/24.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @ObservedObject var settingsManager: SettingsManager
    @ObservedObject var quoteManager: QuoteManager
    
    init() {
        self.settingsManager = SettingsManager()
        self.quoteManager = QuoteManager()
        self.quoteManager.settings = settingsManager
        self.quoteManager.setupTimer() // must start here only 😭
        self.settingsManager.quoteManager = quoteManager
    self.quoteManager.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
        
        self.settingsManager.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
    }
    private var cancellables = Set<AnyCancellable>()
}

