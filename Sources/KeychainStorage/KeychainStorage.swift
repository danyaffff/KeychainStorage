//
//  KeychainStorage.swift
//  KeychainStorage
//
//  Created by Daniil on 04.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

import SwiftUI

/// A property wrapper type that reflects a value from Keychain and invalidates a view on a change in value in .
@propertyWrapper
public struct KeychainStorage<
	Value: Sendable & Equatable & Codable,
	Provider: KeychainProvider
>: DynamicProperty {
	
	// MARK: - Public properties
	
	@MainActor
	public var wrappedValue: Value {
		get { storage.value }
		nonmutating set {
			if let optionalNewValue = newValue as? OptionalProtocol, optionalNewValue.isNil {
				guard keychainProvider.deleteData(forKey: key) else { return }  // Data was not deleted, so no value update
			} else if let data = try? JSONEncoder().encode(newValue) {
				guard keychainProvider.setData(data, forKey: key) else { return }  // Data was not set, so no value update
			} else {
				return  // No interaction with Keychain, so ignore the value
			}
			
			storage.value = newValue
		}
	}
	
	// MARK: - Private properties
	
	@StateObject
	private var storage: Storage
	
	private let keychainProvider: Provider
	private let key: String
	private let defaultValue: Value
	
	// MARK: - Initialization
	
	public init(
		wrappedValue: Value,
		keychainProvider: Provider,
		key: String
	) {
		self.keychainProvider = keychainProvider
		self.key = key
		self.defaultValue = wrappedValue
		
		self._storage = .init(
			wrappedValue: .init(
				value: {
					guard
						let data = keychainProvider.getData(forKey: key),
						let value = try? JSONDecoder().decode(Value.self, from: data)
					else { return wrappedValue }
					
					return value
				}(),
				key: key
			)
		)
	}
}

// MARK: - Storage

private extension KeychainStorage {
	
	@MainActor
	final class Storage: ObservableObject {
		
		// MARK: - Fileprivate properties
		
		@Published
		var value: Value {
			didSet { sendNotification() }
		}
		
		// MARK: - Private properties
		
		private let key: String
		
		// MARK: - Initialization
		
		init(
			value: Value,
			key: String
		) {
			self._value = .init(initialValue: value)
			self.key = key
			
			setupTasks()
		}
		
		// MARK: - Private methods
		
		private func setupTasks() {
			Task { @MainActor [weak self] in
				let values = NotificationCenter.default
					.notifications(named: .keychainStorageUpdatedNotification)
					.compactMap { [weak self] notification -> Value? in
						guard
							let key = notification.userInfo?[String.constants.key] as? String,
							let value = notification.userInfo?[String.constants.value] as? Value,
							key == self?.key
						else { return nil }
						return value
					}
				
				for await value in values {
					guard self?.value != value else { continue }
					self?.value = value
				}
			}
		}
		
		private func sendNotification() {
			NotificationCenter.default.post(
				name: .keychainStorageUpdatedNotification,
				object: nil,
				userInfo: [
					String.constants.key: key,
					String.constants.value: value
				]
			)
		}
	}
}

// MARK: - Constants

private extension String.constants {
	static let value = "value"
	static let key = "key"
}
