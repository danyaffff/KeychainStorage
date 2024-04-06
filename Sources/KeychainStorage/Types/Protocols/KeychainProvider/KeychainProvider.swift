//
//  KeychainProvider.swift
//  KeychainStorage
//
//  Created by Daniil on 04.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

import Foundation

/// A protocol that describes an object that interacts with Keychain.
public protocol KeychainProvider {
	
	// MARK: - Public methods
	
	/// Updates or replaces existing data with given data or writes new data for the provided key.
	/// - Parameters:
	///   - data: A data that should written using the provided `key`.
	///   - key: A key by which `data` will be written.
	func setData(_ data: Data, forKey key: String) -> Bool
	
	/// Returns existing data for the provided key.
	/// - Parameter key: A `key` by which existing data will returned.
	/// - Returns: Existing data returned by the provided key, or `nil` if there is no data.
	func getData(forKey key: String) -> Data?
	
	/// Deletes existing data for the provided key.
	/// - Parameter key: A `key` by which data will deleted.
	/// - Returns: A `Bool` value that indicates whether existing data was deleted successfully.
	func deleteData(forKey key: String) -> Bool
}
