//
//  SettingsView.swift
//  osx-quill
//
//  Created by Alok on 02/08/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var selected: QuoteList = QuoteList.Motivation
    @State private var frequency: Frequency = Frequency.every10Seconds
    @EnvironmentObject var appState:AppState

    var body: some View {
        VStack() {
            Picker(selection: $selected, label: Text("Quote List")) {
                Text(QuoteList.Motivation.rawValue).tag(QuoteList.Motivation)
                Text(QuoteList.Coding.rawValue).tag(QuoteList.Coding)
                Text(QuoteList.Japanese.rawValue).tag(QuoteList.Japanese)
                Text(QuoteList.Custom.rawValue).tag(QuoteList.Custom)
            }
            Picker(selection: $frequency, label: Text("Change Frequency")) {
                Text("Every 10 seconds").tag(Frequency.every10Seconds)
                Text("Every minute").tag(Frequency.everyMinute)
                Text("Every hour").tag(Frequency.everyHour)
                Text("On Reboot").tag(Frequency.onReboot)
            }
        }.padding().frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top).onChange(of: frequency) {
            appState.settingsManager.updateFrequency(frequency: frequency)
            print(frequency)
            appState.quoteManager.setupTimer()
        }
    }
}
