//
//  ContentView.swift
//  OpenHaldex
//
//  Created by Callum Roulston on 09/04/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        
        ZStack {
            Color(.lightGray)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 8) {
                
                Text("Forbes Automotive")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Text("OpenHaldex Controller")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Current version: v0.1.0 (dev)")
                    .foregroundColor(Color.white)
                
                Image("falogotrans")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal)
                
                VStack(spacing: 16) {
                    Button(action: {
                        if let device = bluetoothManager.discoveredDevices.first {
                            bluetoothManager.connect(to: device)
                        }
                    }) {
                        Text("Connect to OpenHaldex")
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        // Action here
                    }) {
                        Text("Disconnect from OpenHaldex")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(BluetoothManager())
}
