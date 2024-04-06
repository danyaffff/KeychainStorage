// swift-tools-version: 5.10
//
//  Package.swift
//  KeychainStorage
//
//  Created by Daniil on 04.04.2024.
//  Copyright © 2024 danyaffff. All rights reserved.
//


import PackageDescription

let package = Package(
	name: "KeychainStorage",
	platforms: [
		.iOS(.v15),
		.macOS(.v12),
		.watchOS(.v8),
		.tvOS(.v15),
		.visionOS(.v1)
	],
	products: [
		.library(
			name: "KeychainStorage",
			targets: [
				"KeychainStorage"
			]
		)
	],
	targets: [
		.target(
			name: "KeychainStorage"
		)
	]
)
