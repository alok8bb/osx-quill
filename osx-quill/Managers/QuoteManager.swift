//
//  QuoteManager.swift
//  osx-quill
//
//  Created by Alok on 02/08/24.
//

import SwiftUI

struct Quote: Codable {
    let text: String
    let author: String
}

// TODO: fix this mess
enum QuoteTypes: CaseIterable {
    case motivation
    case coding
    case jap
}

class QuoteManager: ObservableObject {
    var settings: SettingsManager!
    var timer: Timer?
    
    private var motivationQuotes: [Quote] = []
    private var japaneseQuotes: [Quote] = []
    private var codingQuotes: [Quote] = []
    
    @Published var currentQuote: Quote = Quote(
        text: "", author: ""
    )
    
    init() {
        populateQuotes()
        if let newQuote = motivationQuotes.randomElement(){
            currentQuote = newQuote
        }
    }
    
    func setupTimer() {
        timer?.invalidate()
        if (settings.frequency == Frequency.onReboot) {
            return;
        }
            
        let timeinterval =  {
            switch settings.frequency {
            case Frequency.every10Seconds:
                return 10.0
            case Frequency.everyHour:
                return 60.0 * 60.0
            case Frequency.everyMinute:
                return 60.0
            default:
                return 10.0
            }
        }()
        
        let quotesArray: [Quote] = {
                switch settings.quoteList {
                case QuoteList.Japanese:
                    return self.japaneseQuotes
                case QuoteList.Coding:
                    return self.codingQuotes
                case QuoteList.Motivation:
                    return self.motivationQuotes
                default:
                    return []
                }
            }()
        
        // run once before, for instant change when settings change
        if let newquote = quotesArray.randomElement(){
            self.currentQuote = newquote
        }

        timer = Timer.scheduledTimer(withTimeInterval: timeinterval, repeats: true) { [weak self] _ in
            if let newquote = quotesArray.randomElement(){
                self?.currentQuote = newquote
            }
        }
    }
    
    func populateQuotes(){
        let quoteFileNames: [QuoteTypes: String] = [
                .coding: "coding-quotes",
                .jap: "japanese-quotes",
                .motivation: "quotes"
            ]

        let quoteProperties: [QuoteTypes: ([Quote]) -> Void] = [
            .coding: { self.codingQuotes = $0 },
            .jap: { self.japaneseQuotes = $0 },
            .motivation: { self.motivationQuotes = $0 }
        ]
        
        for quoteType in QuoteTypes.allCases {
            guard let fileName = quoteFileNames[quoteType] else { continue }
            
            if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let quotes = try decoder.decode([Quote].self, from: data)
                    quoteProperties[quoteType]?(quotes)
                } catch {
                    print(error)
                }
            } else {
                print("JSON file not found")
            }
        }
    }
}
