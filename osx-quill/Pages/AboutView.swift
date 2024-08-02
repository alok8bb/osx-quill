//
//  About.swift
//  osx-quill
//
//  Created by Alok on 02/08/24.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("OSX-Quill").font(.title).bold().foregroundColor(.accentColor)
            Text("v0.1").font(.subheadline)
            Spacer().frame(height: 10)
            Text("osx-quill is a simple app that keeps you motivated by displaying inspiring quotes in your Mac's quick menu. It comes with a variety of preloaded quotes and will soon let you add your own custom lists and text. Stay focused and uplifted while you work!")    .multilineTextAlignment(.center)

        }.padding().frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
