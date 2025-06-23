//
//  DataKitHashTable.swift
//  DataKit
//
//  Created by Valerio D'ALESSIO on 23/6/25.
//

import Foundation

// MARK: - DataKitHashTable Implementation
public actor DataKitHashTable<T: DataKitHashable>: Sendable {
	private let maxElement: Int
	private let hashTableSize: Int
	private let r: Int
	private var elements: [T?]
	private var itemCount: Int = 0
	
	public init(maxElement: Int, hashTableSize: Int, r: Int, elements: [T?]) {
		self.maxElement = maxElement
		self.hashTableSize = hashTableSize
		self.r = r
		self.elements = elements
	}
	
	/// Adds an element to the hash table using double hashing for collision resolution.
	///
	/// The function first checks if the hash table has space to accommodate the new element.
	/// It computes the initial index. If that position is already occupied, it double hash to probe for the next available slot.
	///
	/// - Parameter element: The element to be added. It must provide a `key` used in the hash functions.
	///
	/// - Throws:
	///   - `DataKitError.exceededHashTableCapacity` if the hash table is full and cannot store more elements.
	///
	/// The hash table uses double hashing to resolve collisions, attempting up to `hashTableSize - 1` probes.
	///
	public func add(_ element: T) throws {
		if itemCount <= maxElement {
			let index = singleHashFunction(element.key)
			if let _ = elements[index] {
				for i in 1..<hashTableSize {
					let newIndex: Int = doubleHashFunction(element.key, at: i)
					if let _ = elements[newIndex] {
						continue
					} else {
						itemCount += 1
						elements[newIndex] = element
						break
					}
				}
			} else {
				itemCount += 1
				elements[index] = element
			}
		} else {
			throw DataKitError.exceededHashTableCapacity
		}
	}
	
	/// Searches for an element in the hash table by its key using double hashing for collision resolution.
	///
	/// The function computes the initial index. If the element at that index does not match the requested key,
	/// it double hash to probe for the correct slot.
	///
	/// - Parameter key: The key of the element to search for.
	///
	/// - Returns:
	///   A tuple containing the index in the hash table and the found element,
	///   or `nil` if no matching element is found.
	///
	/// The search uses double hashing to resolve possible collisions and will attempt
	/// up to `hashTableSize - 1` probes to locate the element.
	///
	public func searchBy(_ key: Int) -> (Int, T)? {
		let index = singleHashFunction(key)
		if let element = elements[index] {
			if element.key == key {
				return (index, element)
			} else {
				return doubleHashSearchHelper(key, tableSize: hashTableSize)
			}
		} else {
			return nil
		}
	}
	
	/// Updates an existing element in the hash table with a new value.
	///
	/// The function searches for an element matching the provided `key`.
	/// If found, the element is updated with the new value provided.
	/// If no element with the given key exists, an error is thrown.
	///
	/// - Parameters:
	///   - key: The key of the element to update.
	///   - element: The new element value to replace the existing one.
	///
	/// - Throws:
	///   - `DataKitError.elementNotFound` if no element with the given key exists in the hash table.
	///
	public func update(key: Int, with element: T) throws {
		if let foundElement = searchBy(key) {
			elements[foundElement.0] = element
		} else {
			throw DataKitError.elementNotFound
		}
	}
	
	/// Deletes an element from the hash table by its key.
	///
	/// The function searches for an element matching the provided `key`.
	/// If found, the element is removed from the hash table by setting its slot to `nil`.
	/// If no element with the given key exists, an error is thrown.
	///
	/// - Parameter key: The key of the element to delete.
	///
	/// - Throws:
	///   - `DataKitError.elementNotFound` if no element with the given key exists in the hash table.
	///
	public func delete(key: Int) throws {
		if let foundElement = searchBy(key) {
			elements[foundElement.0] = nil
		} else {
			throw DataKitError.elementNotFound
		}
	}
	
	/// Returns all keys currently stored in the hash table.
	///
	/// Iterates through the hash table and collects the keys of all non-nil elements.
	///
	/// - Returns:
	///   An array of keys for all elements currently stored in the hash table.
	///
	public func getStoredKeys() -> [Int] {
		var keys: [Int] = []
		for element in elements {
			if let e = element {
				keys.append(e.key)
			}
		}
		return keys
	}
}

// MARK: - DataKitHashTable - Double Hashing Helpers
private extension DataKitHashTable {
	private func singleHashFunction(_ key: Int) -> Int {
		return key % hashTableSize
	}
	
	private func doubleHashFunction(_ key: Int, at index: Int) -> Int {
		return (singleHashFunction(key) + (index * (r - (key % r)))) % hashTableSize
	}
}

// MARK: - DataKitHashTable Search Helpers
private extension DataKitHashTable {
	private func doubleHashSearchHelper(_ key: Int, tableSize: Int) -> (Int, T)? {
		for i in 1..<tableSize {
			let newIndex: Int = doubleHashFunction(key, at: i)
			if let element = elements[newIndex] {
				if element.key == key {
					return (newIndex, element)
				} else {
					return nil
				}
			} else {
				return nil
			}
		}
		return nil
	}
}
