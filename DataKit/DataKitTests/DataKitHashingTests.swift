//
//  DataKitHashingTests.swift
//  DataKitTests
//
//  Created by Valerio D'ALESSIO on 10/6/25.
//

import DataKit
import Testing

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
