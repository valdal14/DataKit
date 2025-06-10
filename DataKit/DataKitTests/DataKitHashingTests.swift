//
//  DataKitHashingTests.swift
//  DataKitTests
//
//  Created by Valerio D'ALESSIO on 10/6/25.
//

import DataKit
import Testing

public actor DataKitHashing<K: Hashable, T: DataKitCompatible>: Sendable {
	private typealias Element = (key: K, value: T)
	private typealias Bucket = [Element]
	
	private var buckets: [Bucket] = []
	
	/// Creates a new instance of `DataKitHashing` with a specified capacity.
	///
	/// The `capacity` parameter determines the number of buckets in the hash table.
	/// By default, the capacity is set to `7`. If a different value is provided,
	/// it must be a prime number otherwise, an error is thrown.
	///
	/// - Parameter capacity: The number of buckets in the hash table.
	/// - Throws: `DataKitError.invalidHashTableCapacity` if the capacity is not a valid prime number.
	///
	public init(capacity: Int = 7) throws {
		try Self.validHashTableSize(capacity)
		self.buckets = Array(repeating: [], count: capacity)
	}
	
	/// Returns the size of the current HastTable instance
	/// - Returns: an Int representing the size of the bucket
	public func getSize() -> Int {
		buckets.count
	}
}

private extension DataKitHashing {
	static nonisolated func validHashTableSize(_ number: Int, maxSize: Int = 97) throws {
		if number <= maxSize {
			guard number > 1 else { throw DataKitError.invalidHashTableCapacity }
			guard number > 3 else { return }
			guard number % 2 != 0 && number % 3 != 0 else { throw DataKitError.invalidHashTableCapacity }
			
			var i = 5
			while i * i <= number {
				if number % i == 0 || number % (i + 2) == 0 {
					throw DataKitError.invalidHashTableCapacity
				}
				i += 6
			}
		} else {
			throw DataKitError.exceededHashTableCapacity
		}
	}
}

struct DataKitHashingTests {
	
	@Test("init with default (capacity: Int = 7)")
	func init_default() async throws {
		let sut = try makeSUT()
		let expectedSize = 7
		let currentSize = await sut.getSize()
		#expect(currentSize == expectedSize)
	}
	
	@Test("init with custom capacity: Int = 11")
	func init_custom_size() async throws {
		let expectedSize = 3
		let sut = try makeSUT(capacity: expectedSize)
		let currentSize = await sut.getSize()
		#expect(currentSize == expectedSize)
	}
	
	@Test("init throws when the custom capacity: Int value is not a prime number")
	func init_throws() async throws {
		await #expect(throws: DataKitError.invalidHashTableCapacity, performing: ({
			let _ = try await makeSUT(capacity: 4)
		}))
	}
	
	@Test("init throws when the custom capacity: Int value is greater than the default max size Int value")
	func init_throws_max_size() async throws {
		await #expect(throws: DataKitError.exceededHashTableCapacity, performing: ({
			let _ = try await makeSUT(capacity: 101)
		}))
	}
	
	// MARK: - Helpers
	private func makeSUT(capacity: Int = 7) throws -> DataKitHashing<Int, Car> {
		try .init(capacity: capacity)
	}
}

// MARK: - Custom type with conformance to the DataKitCompatible
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
