//
//  BluetoothManager.swift
//  OpenHaldex
//
//  Created by Callum Roulston on 11/04/2025.

import SwiftUI
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var connectedPeripheral: CBPeripheral?
    @Published var isConnected: Bool = false
    @Published var connectedDeviceName: String? = nil

    private var centralManager: CBCentralManager!
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // Called when Bluetooth state changes
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth is ON — starting scan")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth is not available")
        }
    }

    // Called when a device is found
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredDevices.contains(where: { $0.identifier == peripheral.identifier }) {
            discoveredDevices.append(peripheral)
            print("Discovered: \(peripheral.name ?? "Unnamed")")
        }
    }

    // Connect to a selected peripheral
    func connect(to peripheral: CBPeripheral) {
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
        connectedPeripheral = peripheral
        connectedDeviceName = peripheral.name
        peripheral.delegate = self
    }

    // Called when connection is successful
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown")")
        connectedPeripheral = peripheral
        isConnected = true
        peripheral.discoverServices(nil)
    }

    func disconnect() {
        if let peripheral = connectedPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "Unknown")")
        connectedPeripheral = nil
        isConnected = false
    }
}

