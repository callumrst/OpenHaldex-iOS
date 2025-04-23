//
//  HaldexSettingsView.swift
//  OpenHaldex
//
//  Created by Callum Roulston on 23/04/2025.
//

import SwiftUI

struct HaldexSettingsView: View {
    var body: some View {
        ZStack {
            Color(.lightGray)
                .ignoresSafeArea()

            VStack {
                Text("Haldex Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Text("detailed settings go here eventually")
                    .font(.body)
                    .padding()

                Spacer()
            }
        }
    }
}

#Preview {
    HaldexSettingsView()
}
