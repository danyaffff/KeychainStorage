//
//  ExampleView.swift
//  KeychainStorage
//
//  Created by Daniil on 05.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

import SwiftUI

// MARK: - SimpleKeychain

// Keychain is not working with Swift Package.
struct SimpleKeychain: KeychainProvider {
	func setData(_ data: Data, forKey key: String) -> Bool { true }
	func getData(forKey key: String) -> Data? { nil }
	func deleteData(forKey key: String) -> Bool { true }
}

// MARK: - ReaderView

struct ReaderView: View {
	
	// MARK: - Private properties
	
	@KeychainStorage(keychainProvider: SimpleKeychain(), key: "someKey")
	private var someValue: Bool? = nil
	
	// MARK: - Body
	
	var body: some View {
		Text(someValue?.description ?? "No data")
	}
}

// MARK: - WriterView

struct WriterView: View {
	
	// MARK: - Private properties
	
	@KeychainStorage(keychainProvider: SimpleKeychain(), key: "someKey")
	private var someValue: Bool? = nil
	
	// MARK: - Body
	
	var body: some View {
		HStack {
			Button("Toggle") {
				if someValue == nil {
					someValue = true
				} else {
					someValue?.toggle()
				}
			}
			
			Button("Delete") {
				someValue = nil
			}
		}
	}
}

// MARK: - ContentView

struct ContentView: View {
	var body: some View {
		ReaderView()
		WriterView()
	}
}

// MARK: - Preview

#Preview {
	ContentView()
}
