//
//  ContentView.swift
//  osx-quill
//
//  Created by Alok on 02/08/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var quoteManager: QuoteManager

    var body: some View {
        VStack {
            Image(systemName: "quote.opening")
                .resizable()
                .frame(width: 45.0, height: 32.0)
                .foregroundStyle(.tint)
            Text(quoteManager.currentQuote.text).font(.title)
            Text("- \(quoteManager.currentQuote.author)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
