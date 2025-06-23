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
	
	public func searchBy(_ key: Int) -> (Int, T)? {
		let index = singleHashFunction(key)
		if let element = elements[index] {
			if element.key == key {
				return (index, element)
			} else {
				for i in 1..<hashTableSize {
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
		} else {
			return nil
		}
	}
	
	public func update(key: Int, with element: T) throws {
		if let foundElement = searchBy(key) {
			elements[foundElement.0] = element
		} else {
			throw DataKitError.elementNotFound
		}
	}
	
	public func delete(key: Int) throws {
		if let foundElement = searchBy(key) {
			elements[foundElement.0] = nil
		} else {
			throw DataKitError.elementNotFound
		}
	}
	
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
