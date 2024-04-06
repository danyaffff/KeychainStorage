//
//  Constants.swift
//  KeychainStorage
//
//  Created by Daniil on 06.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//

private protocol Constants {
	associatedtype ParentType
}

extension String {
	enum constants: Constants {
		typealias ParentType = String
	}
}
