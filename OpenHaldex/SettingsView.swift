//
//  SettingsView.swift
//  OpenHaldex
//
//  Created by Callum Roulston on 13/04/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Connection Settings")) {
                    Toggle("Auto connect on app launch", isOn: .constant(false))
                }

                Section(header: Text("About")) {
                    Text("App Version: \(AppConstants.version)")
                    Text("Developed by Forbes Automotive")
                    Text("Contact: sales@forbes-automotive.com")
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
