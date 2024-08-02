//
//  SettingsManager.swift
//  osx-quill
//
//  Created by Alok on 02/08/24.
//

import SwiftUI

enum QuoteList: String {
    case Motivation
    case Coding
    case Japanese
    case Custom
}

// in seconds
enum Frequency{
    case every10Seconds // Testing only
    case everyMinute
    case everyHour
    case onReboot
}

class SettingsManager: ObservableObject {
    @Published var frequency : Frequency
    @Published var quoteList : QuoteList
    
    var quoteManager: QuoteManager!
    
    init() {
        self.frequency = Frequency.every10Seconds
        self.quoteList = QuoteList.Motivation
    }
    
    func updateFrequency(frequency: Frequency) {
        self.frequency = frequency
    }
    
    func updateQuoteList(quoteList: QuoteList) {
        self.quoteList = quoteList
    }
}
