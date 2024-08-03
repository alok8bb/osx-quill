//
//  SettingsView.swift
//  osx-quill
//
//  Created by Alok on 02/08/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var quoteList: QuoteList = QuoteList.Motivation
    @State private var frequency: Frequency = Frequency.every10Seconds
    @State private var customQuoteTxt: String = ""
    
    @FocusState private var customQuoteFocus: Bool
    @EnvironmentObject var appState:AppState
    
    var body: some View {
        VStack() {
            Picker(selection: $frequency, label: Text("Change Frequency")) {
                Text("Every 10 seconds").tag(Frequency.every10Seconds)
                Text("Every minute").tag(Frequency.everyMinute)
                Text("Every hour").tag(Frequency.everyHour)
                Text("On Reboot").tag(Frequency.onReboot)
            }

            Picker(selection: $quoteList, label: Text("Quote List")) {
                Text(QuoteList.Motivation.rawValue).tag(QuoteList.Motivation)
                Text(QuoteList.Coding.rawValue).tag(QuoteList.Coding)
                Text(QuoteList.Japanese.rawValue).tag(QuoteList.Japanese)
                Text(QuoteList.Custom.rawValue).tag(QuoteList.Custom)
            }
            
            if (quoteList == QuoteList.Custom) {
                Text("Use custom text/quote (for multiple quotes, separate quotes with newlines)")
                TextField("Quotes", text: $customQuoteTxt, axis: .vertical).focused($customQuoteFocus).lineLimit(1...30).onSubmit {
                    customQuoteTxt += "\n"
                }
                Button(action: {
                    customQuoteFocus = false
                    appState.quoteManager.setCustomQuotes(quotesTxt: customQuoteTxt)
                    appState.settingsManager.updateQuoteList(quoteList: quoteList)
                    appState.quoteManager.setupTimer()
                }) {
                    Text("Save")
                }
            }
        }.padding().frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top).onChange(of: frequency) {
            appState.settingsManager.updateFrequency(frequency: frequency)
            appState.quoteManager.setupTimer()
        }.onChange(of: quoteList){
            if (quoteList != QuoteList.Custom) {
                appState.settingsManager.updateQuoteList(quoteList: quoteList)
                appState.quoteManager.setupTimer()
            }
        }
    }
}
