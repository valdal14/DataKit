//
//  DataKitHashingTests.swift
//  DataKitTests
//
//  Created by Valerio D'ALESSIO on 10/6/25.
//

import DataKit
import Testing

public protocol DataKitHashable: Equatable {
	associatedtype T: DataKitCompatible
	var key: Int { get set }
	var value: T { get set }
}

public struct DataKitHashTableFactory: Sendable {
	private static let minTableSize: Int = 2
	private static let maxTableSize: Int = 126
	private static let maxLambdaValue: Double = 0.5
	private static let minLambdaValue: Double = 0.3
	private static let lambdaStep: Double = 0.5
	private static let rationStartingValue: Double = 1.0
	
	public static func make<T: DataKitHashable>(tableSize: Int) throws -> DataKitHashTable<T> {
		if tableSize < minTableSize || tableSize > maxTableSize { throw DataKitError.invalidHashTableCapacity }
		let hashTableSize: Int = self.computeLoadFactor(chosenSize: tableSize, ratio: rationStartingValue)
		var r: Int = minTableSize
		if tableSize > minTableSize { r = previousPrime(hashTableSize - 1) }
		let elements: [T?] = Array(repeating: nil, count: hashTableSize)
		return .init(maxElement: tableSize, hashTableSize: hashTableSize, r: r, elements: elements)
	}
}

// MARK: - DataKitHashing determine HashTable Size
private extension DataKitHashTableFactory {
	
	static func computeLoadFactor(chosenSize: Int, ratio: Double) -> Int {
		let lambda: Double = Double(chosenSize) / ratio
		
		if lambda >= minLambdaValue && lambda <= maxLambdaValue {
			let nPrime: Int = nextPrime(Int(ratio))
			let pPrime: Int = previousPrime(Int(ratio))
			
			if (nPrime < pPrime) {
				return nPrime
			} else {
				return pPrime
			}
		}
		
		return computeLoadFactor(chosenSize: chosenSize, ratio: ratio + lambdaStep)
	}
	
	static func isPrime(_ n: Int) -> Bool {
		if (n <= 1) { return false };
		if (n <= 3) { return true };
		if (n % 2 == 0 || n % 3 == 0) { return false };
		
		let limit: Int = Int(sqrt(Double(n)));
		var i = 5;
		let increment = 6;
		
		while(i <= limit) {
			if (n % i == 0 || n % (i + 2) == 0) {
				return false;
			}
			i += increment;
		}
		
		return true;
	}
	
	static func nextPrime(_ n: Int) -> Int {
		var num = n;
		if (num <= 2) { return 2 };
		if (num % 2 == 0) { num += 1 };
		
		while (!isPrime(num)) {
			num += 2;
		}
		
		return num;
	}
	
	static func previousPrime(_ n: Int) -> Int {
		var num = n;
		if (num <= 2) { return 2 };
		if (num % 2 == 0) { num -= 1 };
		
		while (!isPrime(num))
		{
			num -= 2;
		}
		
		return num;
	}
}

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

struct DataKitHashingTests {
	
	@Test("add throws when the chosen capacity is too small")
	func add_throws_min_value() async throws {
		#expect(throws: DataKitError.invalidHashTableCapacity, performing: ({
			let _ = try makeSUT(capacity: 0)
		}))
	}
	
	@Test("add throws when the chosen capacity is too big")
	func add_throws_max_value() async throws {
		#expect(throws: DataKitError.invalidHashTableCapacity, performing: ({
			let _ = try makeSUT(capacity: 127)
		}))
	}
	
	@Test("add successfully adds a new element to the hash table")
	func add() async throws {
		let sut = try makeSUT(capacity: 2)
		try await sut.add(.init(key: 23, value: .init(brand: .ferrari, year: 2025)))
		try await sut.add(.init(key: 44, value: .init(brand: .lamborghini, year: 2022)))
		try await sut.add(.init(key: 55, value: .init(brand: .porsche, year: 2021)))
		let expectedKeys: [Int] = [55, 44, 23]
		let currentKeys: [Int] = await sut.getStoredKeys()
		#expect(currentKeys == expectedKeys)
	}
	
	@Test("search returns the element by given key when a collision occurs")
	func search_with_collision() async throws {
		let sut = try makeSUT(capacity: 2)
		try await sut.add(.init(key: 23, value: .init(brand: .ferrari, year: 2025)))
		try await sut.add(.init(key: 44, value: .init(brand: .lamborghini, year: 2022)))
		try await sut.add(.init(key: 55, value: .init(brand: .porsche, year: 2021)))
		
		let expectedElement: HashedCar? = .init(key: 44, value: .init(brand: .lamborghini, year: 2022))
		let currentElement: HashedCar? = await sut.searchBy(44)?.1
		#expect(currentElement == expectedElement)
	}
	
	@Test("search returns the element by given key when no collision occurs")
	func search_no_collision() async throws {
		let sut = try makeSUT(capacity: 2)
		try await sut.add(.init(key: 13, value: .init(brand: .ferrari, year: 2025)))
		try await sut.add(.init(key: 24, value: .init(brand: .lamborghini, year: 2022)))
		try await sut.add(.init(key: 35, value: .init(brand: .porsche, year: 2021)))
		
		let expectedElement: HashedCar? = .init(key: 24, value: .init(brand: .lamborghini, year: 2022))
		let currentElement: HashedCar? = await sut.searchBy(24)?.1
		#expect(currentElement == expectedElement)
	}
	
	@Test("search return nil as soon as it finds a nil element at hashed index")
	func search_nil() async throws {
		let sut = try makeSUT(capacity: 2)
		try await sut.add(.init(key: 88, value: .init(brand: .ferrari, year: 2025)))
		let expectedElement: HashedCar? = nil
		let currentElement: HashedCar? = await sut.searchBy(188)?.1
		#expect(currentElement == expectedElement)
	}
	
	@Test("update successfully update the element by the given key")
	func update() async throws {
		let sut = try makeSUT(capacity: 2)
		try await sut.add(.init(key: 88, value: .init(brand: .ferrari, year: 2025)))
		try await sut.add(.init(key: 35, value: .init(brand: .porsche, year: 2021)))
		
		try await sut.update(key: 35, with: .init(key: 35, value: .init(brand: .lamborghini, year: 2014)))
		
		let expectedElement: HashedCar? = .init(key: 35, value: .init(brand: .lamborghini, year: 2014))
		let currentElement: HashedCar? = await sut.searchBy(35)?.1
		#expect(currentElement == expectedElement)
	}
	
	@Test("update throws when the element is not present in the table")
	func update_throws() async throws {
		let sut = try makeSUT(capacity: 2)
		try await sut.add(.init(key: 88, value: .init(brand: .ferrari, year: 2025)))
		
		await #expect(throws: DataKitError.elementNotFound, performing: ({
			try await sut.update(key: 35, with: .init(key: 35, value: .init(brand: .lamborghini, year: 2014)))
		}))
	}
	
	@Test("delete successfully delete an element by a given key")
	func delete() async throws {
		let sut = try makeSUT(capacity: 2)
		try await sut.add(.init(key: 88, value: .init(brand: .ferrari, year: 2025)))
		try await sut.add(.init(key: 35, value: .init(brand: .porsche, year: 2021)))
		
		try await sut.delete(key: 35)
		
		// assert that the element is no longer present
		await #expect(throws: DataKitError.elementNotFound, performing: ({
			try await sut.update(key: 35, with: .init(key: 35, value: .init(brand: .lamborghini, year: 2014)))
		}))
	}
	
	@Test("delete throws when the key is not found")
	func delete_throws() async throws {
		let sut = try makeSUT(capacity: 2)
		await #expect(throws: DataKitError.elementNotFound, performing: ({
			try await sut.delete(key: 35)
		}))
	}
	
	// MARK: - Helpers
	private func makeSUT(capacity: Int = 7) throws -> DataKitHashTable<HashedCar> {
		try DataKitHashTableFactory.make(tableSize: capacity)
	}
}

// MARK: - Custom type with conformance to the DataKitCompatible & DataKitHashable
enum Brand {
	case ferrari
	case lamborghini
	case porsche
	case tesla
}

struct Car: DataKitCompatible {
	let brand: Brand
	let year: UInt32
	
	init(brand: Brand, year: UInt32) {
		self.brand = brand
		self.year = year
	}
}

struct HashedCar: DataKitHashable {
	var key: Int
	var value: Car
	
	init(key: Int, value: Car) {
		self.key = key
		self.value = value
	}
}
