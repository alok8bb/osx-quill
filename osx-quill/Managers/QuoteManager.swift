//
//  QuoteManager.swift
//  osx-quill
//
//  Created by Alok on 02/08/24.
//

import SwiftUI

class QuoteManager: ObservableObject {
    struct Quote: Codable {
        let text: String
        let author: String
    }

    var settings: SettingsManager!
    var timer: Timer?
    
    private var quotes: [Quote] = []
    @Published var currentQuote: Quote = Quote(
        text: "", author: ""
    )
    
    init() {
        populateQuotes()
        if let newQuote = quotes.randomElement(){
            currentQuote = newQuote
        }
    }
    
    func setupTimer() {
        print("I was called")
        timer?.invalidate()
        if (settings.frequency == Frequency.onReboot) {
            return;
        } else {
            print(self.settings.frequency)
            let timeInterval =  {
                switch self.settings.frequency{
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
            
            timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
                print("fired")
                if let newQuote = self?.quotes.randomElement(){
                    print(newQuote)
                    self?.currentQuote = newQuote
                }
            }
            print("scheduled")
            print(timeInterval)
        }
    }
    
    func populateQuotes(){
        if let url = Bundle.main.url(forResource: "quotes", withExtension: "json") {
                   do {
                       let data = try Data(contentsOf: url)
                       let decoder = JSONDecoder()
                       self.quotes = try decoder.decode([Quote].self, from: data)
                   } catch {
                       print(error)
                   }
               } else {
                   print("JSON file not found")
               }
    }
}
