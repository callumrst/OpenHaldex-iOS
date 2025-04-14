//
//  BluetoothManager.swift
//  OpenHaldex
//
//  Created by Callum Roulston on 11/04/2025.

import SwiftUI
import Foundation
import CoreBluetooth


class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var connectedPeripheral: CBPeripheral?
    @Published var isConnected: Bool = false
    @Published var connectedDeviceName: String? = nil

    @Published var selectedDriveMode: String = "Stock"
    @Published var availableDriveModes: [String] = ["Stock", "FWD", "50/50", "75/25"]

    private var centralManager: CBCentralManager!
    private var targetServiceUUID: CBUUID? = nil // can set to filter only specific BLE peripherals
    private var characteristicUUIDs: [CBUUID] = []

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("✅ Bluetooth is ON — scanning for BLE peripherals")
            startScanning()
        default:
            print("⚠️ Bluetooth not available: \(central.state.rawValue)")
        }
    }

    func startScanning() {
        discoveredDevices.removeAll()
        centralManager.scanForPeripherals(withServices: targetServiceUUID != nil ? [targetServiceUUID!] : nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }

    func stopScanning() {
        centralManager.stopScan()
    }

    func connect(to peripheral: CBPeripheral) {
        stopScanning()
        peripheral.delegate = self
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredDevices.contains(where: { $0.identifier == peripheral.identifier }) {
            discoveredDevices.append(peripheral)
            print("🔍 Discovered: \(peripheral.name ?? "Unnamed") — UUID: \(peripheral.identifier)")
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("✅ Connected to \(peripheral.name ?? "Unknown")")
        connectedPeripheral = peripheral
        connectedDeviceName = peripheral.name
        isConnected = true
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("❌ Failed to connect: \(error?.localizedDescription ?? "Unknown error")")
        isConnected = false
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("🔌 Disconnected from \(peripheral.name ?? "Unknown")")
        connectedPeripheral = nil
        isConnected = false
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("❗️Error discovering services: \(error.localizedDescription)")
            return
        }

        guard let services = peripheral.services else { return }
        print("📡 Discovered \(services.count) services")
        for service in services {
            print("🧭 Service UUID: \(service.uuid)")
            peripheral.discoverCharacteristics(characteristicUUIDs.isEmpty ? nil : characteristicUUIDs, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("❗️Error discovering characteristics: \(error.localizedDescription)")
            return
        }

        guard let characteristics = service.characteristics else { return }
        print("📶 Discovered \(characteristics.count) characteristics for service \(service.uuid)")
        for characteristic in characteristics {
            print("➡️ Characteristic UUID: \(characteristic.uuid)")
        }
    }

    func disconnect() {
        if let peripheral = connectedPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }

    // method for writing data later
    func write(data: Data, to characteristic: CBCharacteristic) {
        connectedPeripheral?.writeValue(data, for: characteristic, type: .withResponse)
    }
}
