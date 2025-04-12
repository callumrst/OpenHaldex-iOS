//
//  OpenHaldexApp.swift
//  OpenHaldex
//
//  Created by Callum Roulston on 09/04/2025.
//

import SwiftUI

@main
struct OpenHaldexApp: App {
    @StateObject private var bluetoothManager = BluetoothManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bluetoothManager)
        }
    }
}
