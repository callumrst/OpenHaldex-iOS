//
//  ContentView.swift
//  OpenHaldex
//
//  Created by Callum Roulston on 09/04/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bluetoothManager: BluetoothManager
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var showSettings = false

    var body: some View {
        
        ZStack(alignment: .topTrailing) {
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
                
                Text("Current version: \(AppConstants.version)")
                    .foregroundColor(Color.white)
                
                Text(bluetoothManager.isConnected ? "Status: Connected to \(bluetoothManager.connectedDeviceName ?? "device")" : "Status: Not connected")
                    .foregroundColor(bluetoothManager.isConnected ? Color(red: 0.0, green: 0.5, blue: 0.0) : .red)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                Image("falogotrans")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal)
                
                VStack(spacing: 16) {
                    Menu {
                        ForEach(bluetoothManager.discoveredDevices, id: \.identifier) { device in
                            Button(device.name ?? "Unknown Device") {
                                bluetoothManager.connect(to: device)
                                toastMessage = "Attempting to connect to \(device.name ?? "device")..."
                                showToast = true

                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    if bluetoothManager.isConnected {
                                        toastMessage = "Successfully connected to \(device.name ?? "device")!"
                                    } else {
                                        toastMessage = "Failed to connect to \(device.name ?? "device")."
                                    }
                                }
                            }
                        }
                    } label: {
                        ZStack {
                            Text(bluetoothManager.isConnected ? "Connected to OpenHaldex" : "Connect to OpenHaldex")
                                .foregroundStyle(.white)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(bluetoothManager.isConnected ? Color.green : Color.blue)
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        bluetoothManager.disconnect()
                        toastMessage = "Disconnected from OpenHaldex."
                        showToast = true
                    }) {
                        Text("Disconnect from OpenHaldex")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                            .cornerRadius(12)
                        }
                    .disabled(!bluetoothManager.isConnected)
                    .opacity(bluetoothManager.isConnected ? 1.0 : 0.5)
                }
                .padding(.horizontal)
                
                if showToast {
                    Text(toastMessage)
                        .font(.subheadline)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                withAnimation {
                                    showToast = false
                                }
                            }
                        }
                }
                
                Spacer()
            
            }
            
            Button(action: {
                showSettings = true
            }) {
                Image(systemName: "gear")
                    .imageScale(.large)
                    .padding()
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(BluetoothManager())
}
