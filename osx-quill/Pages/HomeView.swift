//
//  HomeView.swift
//  osx-quill
//
//  Created by Alok on 02/08/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState:AppState

    var body: some View {
        VStack {
            Image(systemName: "quote.opening")
                .resizable()
                .frame(width: 45.0, height: 32.0)
                .foregroundStyle(.tint)
            Text(appState.quoteManager.currentQuote.text).font(.title)
            Text("- \(appState.quoteManager.currentQuote.author)")
        }
    }
}
