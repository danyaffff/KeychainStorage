//
//  OptionalProtocol.swift
//  KeychainStorage
//
//  Created by Daniil on 05.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

/// A protocol that indicates whether the current Type is optional.
protocol OptionalProtocol {
	
	// MARK: - Internal properties
	
	/// A value that returns `true` in case of absence of value.
	var isNil: Bool { get }
}

// MARK: - Optional+OptionalProtocol

extension Optional: OptionalProtocol {
	
	// MARK: - Internal properties
	
	var isNil: Bool { self == nil }
}
