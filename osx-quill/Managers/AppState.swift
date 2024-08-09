//
//  AppState.swift
//  osx-quill
//
//  Created by Alok on 02/08/24.
//

import SwiftUI
import Combine
import SwiftData

struct Quote: Codable {
    let text: String
    let author: String
}

enum QuoteTypes: CaseIterable {
    case motivation
    case coding
    case jap
}

class AppState: ObservableObject {
    var timer: Timer?

    private var motivationQuotes: [Quote] = []
    private var japaneseQuotes: [Quote] = []
    private var codingQuotes: [Quote] = []
    private var customQuotes: [Quote] = []
    
    @Published var currentQuote: Quote = Quote(
        text: "", author: ""
    )

    init() {
        populateQuotes()
        setupTimer()
    }
    
    func setupTimer(settings: Settings = Settings()) {
        timer?.invalidate()
        let timeinterval =  {
            switch settings.repeatFrequency {
            case Frequency.every10Seconds.rawValue:
                return 10.0
            case Frequency.everyHour.rawValue:
                return 60.0 * 60.0
            case Frequency.everyMinute.rawValue:
                return 60.0
            case Frequency.every3Hours.rawValue:
                return 60.0 * 60.0 * 3.0
            default:
                return 10.0
            }
        }()
        
        let quotesArray: [Quote] = {
            switch settings.quoteList {
                case QuoteList.Japanese.rawValue:
                    return self.japaneseQuotes
                case QuoteList.Coding.rawValue:
                    return self.codingQuotes
                case QuoteList.Motivational.rawValue:
                    return self.motivationQuotes
                case QuoteList.Custom.rawValue:
                return settings.customText.split(separator: "\n").map { Quote(text: String($0), author: "Unknown") }
            default:
                return self.motivationQuotes
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
    }}

