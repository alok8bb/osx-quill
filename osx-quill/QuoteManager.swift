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

    var quotes: [Quote] = []
    @Published var currentQuote: Quote = Quote(
        text: "", author: ""
    )
    
    init() {
        populateQuotes()
        if let newQuote = quotes.randomElement(){
            currentQuote = newQuote
        }
        startTimer()
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            if let newQuote = self?.quotes.randomElement(){
                self?.currentQuote = newQuote
            }
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
