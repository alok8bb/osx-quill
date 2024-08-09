//
//  SettingsView.swift
//  osx-quill
//
//  Created by Alok on 02/08/24.
//

import SwiftUI
import SwiftData

enum QuoteList: String, Codable {
    case Motivational
    case Japanese
    case Coding
    case Custom
}

enum Frequency: String, Codable {
    case every10Seconds
    case everyMinute
    case everyHour
    case every3Hours
}

class Settings: ObservableObject {
    @Published var quoteList: String {
            didSet {
                UserDefaults.standard.set(self.quoteList, forKey: "quoteList")
            }
        }
        
        @Published var repeatFrequency: String {
            didSet {
                UserDefaults.standard.set(self.repeatFrequency, forKey: "repeatFrequency")
            }
        }
        
        @Published var customText: String {
            didSet{
                UserDefaults.standard.set(self.customText, forKey: "customText")
            }
        }
        
        init() {
            self.quoteList = UserDefaults.standard.string(forKey: "quoteList") ?? QuoteList.Motivational.rawValue
            self.repeatFrequency = UserDefaults.standard.string(forKey: "repeatFrequency") ?? Frequency.everyMinute.rawValue
            self.customText = UserDefaults.standard.string(forKey: "customText") ?? ""
        }
}

struct SettingsView: View {
    @FocusState private var customQuoteFocus: Bool
    
    @EnvironmentObject var appState: AppState
    @ObservedObject var settings = Settings()

    var body: some View {
        VStack() {
            Picker(selection: $settings.repeatFrequency, label: Text("Change Frequency")) {
                Text("Every 10 seconds").tag(Frequency.every10Seconds.rawValue)
                Text("Every minute").tag(Frequency.everyMinute.rawValue)
                Text("Every hour").tag(Frequency.everyHour.rawValue)
                Text("Every 3 hours").tag(Frequency.every3Hours.rawValue)
            }

            Picker(selection: $settings.quoteList, label: Text("Quote List")) {
                Text("Motivational").tag(QuoteList.Motivational.rawValue)
                Text("Japanese").tag(QuoteList.Japanese.rawValue)
                Text("Coding").tag(QuoteList.Coding.rawValue)
                Text("Custom").tag(QuoteList.Custom.rawValue)
            }
            
            if (settings.quoteList == QuoteList.Custom.rawValue) {
                Text("Use custom text/quote (for multiple quotes, separate quotes with newlines)")
                TextField("Quotes", text: $settings.customText, axis: .vertical).focused($customQuoteFocus).lineLimit(1...30).onSubmit {
                    settings.customText += "\n"
                }
                Button(action: {
                    customQuoteFocus = false
                    appState.setupTimer(settings: settings)
                }) {
                    Text("Save")
                }
            }
        }.padding().frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top).onChange(of: settings.repeatFrequency) {
            appState.setupTimer(settings: settings)
        }.onChange(of: settings.quoteList){
            if (settings.quoteList != QuoteList.Custom.rawValue) {
                appState.setupTimer(settings: settings)
            }
        }
    }
}
