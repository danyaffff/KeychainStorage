# KeychainStorage

A simple SwiftUI property wrapper for synchronized interaction with Keychain.

## Features

[x] Supports all types that confirm `Sendable`, `Equatable`, and `Codable` protocols.
[x] Synchorizes data across all `@KeychainStorage`s with the same key and data type.
[x] Supports any custom Keychain objects that confirm a `KeychainProvider` protocol.
[x] Optional values support.

## Motivation

SwiftUI provides two awesome property wrapper types `@AppStorage` and `@SceneStorage` to deal with UserDefaults. One of the most interesting features of these property wrappers is synchronization across all the similar property wrappers. So, changes made in one property wrapper automatically synchronizes in corresponding property wrappers.

```swift
struct WriterView: View {
	@AppStorage("someKey") private var someValue = false
	
	var body: some View {
		Button("Toggle") {
			someValue.toggle()  // Updates UserDefault's object with key "some Key"
		}
	}
}

struct ReaderView: View {
	@AppStorage("someKey") private var someValue = false
	
	var body: some View {
		Text("\(someValue)")  // Automatically displays new data
	}
}
```

Despite the easy-to-use UserDefaults property wrappers, there are no objects to work with Keychain that way. This library aims to provide a similar experience interacting with Keychain.

## How does is work?

I don’t know how `@AppStorage` and `@SceneStorage` work internally. I suppose they may use KVO (or a similar approach) to observe `UserDefaults` changes to receive actual data. We can’t use Keychain that way, because there is no API to provide a callback that will be called when an object for a certain key changes (or any other callbacks except [this only one deprecated function](https://developer.apple.com/documentation/security/1394998-seckeychainaddcallback) that can be used only on macOS).

So I decided to use the `NotificationCenter` to post and observe internal-library notification that contains a key (to determine what was changed) and a new value (to update all the other storages). This approach doesn’t respect any changes that are made in Keychain directly, it only synchronizes property wrappers with each other.

Property wrapper itself does not guarantee that any data was written to Keychain, but Keychain provider may control property wrapper's local value updating by returning a `Bool` value.

## Usage

You can use the `@KeychainStorage` similarly to other storages.

```swift
struct WriterView: View {
	@KeychainStorage(provider: myKeychainProvider.shared, key: "someKey")
	private var someValue = false
	
	var body: some View {
		Button("Toggle") {
			someValue.toggle()
		}
	}
}

struct ReaderView: View {
	@KeychainStorage(provider: myKeychainProvider.shared, key: "someKey")
	private var someValue = false
	
	var body: some View {
		Text("\(someValue)")
	}
}
```

First, confirm your Keychain accessor class to the `KeychainProvider` protocol. This can be either an object from a third-party library or your self-written solution.

Next, create a property wrapper with `.init(wrappedValue:provider:key:)` initializer inside a `View`.

A `wrappedValue` that can be any object that confirms `Sendable`, `Equatable`, and `Codable` protocols. If this was the first time when the value was specified by a certain key, this value will be written to Keychain. It is also possible to initialize (or assign) a wrapped value with an `Optional` type, the `nil` value will be automatically detected and will cause the object at the specified key to be deleted.

A `keychainProvider` object that confirms a `KeychainProvider` protocol and interacts with Keychain. To be honest, there are no limitations that object, confirmed to the protocol, __must__ interact with Keychain. It can be any other database that supports storing, reading, and deleting `Data` objects (or it can be an empty object just like in `ExampleView.swift`, then it can be used as a shared `@State` property wrapper), but it primary designed to be used with Keychain.

A `key` is a string value that specifies which object in the database will be interacted with. Property wrappers with the same key in different views will interact with the same object. If you set different data types for the same key, the first one (which was written to Keychain first) will be chosen, and changes proposed by the second one will be discarded.

Finally, you can modify the stored value just like any other wrapped values, and all changes will reflect on the view. If, for some reason, the new value cannot be encoded as a `Data` (and thus cannot be written to Keychain), the property wrapper will continue to store the old one. If you set a non-`Optional` type, then you will not be able to delete a value from Keychain through the property wrapper.

## Requirements

- iOS 15
- macOS 12
- tvOS 15
- watchOS 8
- visionOS 1

## Installation

### Swift Package Manager

Add the following line into the package `dependencies` value of your `Package.swift` file or the Package Dependencies list in Xcode:

```swift
.package(url: "https://github.com/danyaffff/KeychainStorage.git", .upToNextMajor(from: "1.0.0"))
```

## Lisence

KeychainStorage is available under the [MIT License](https://github.com/danyaffff/KeychainStorage/blob/main/LICENSE)
