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
	
	private var bucket: [Bucket] = []
	
	public init(capacity: Int = 7) {
		self.bucket = Array(repeating: [], count: capacity)
	}
	
	public func getSize() -> Int {
		bucket.count
	}
}

struct DataKitHashingTests {
	
	@Test("init with default (capacity: Int = 7)")
	func init_hash_table() async throws {
		let sut = makeSUT()
		let expectedSize = 7
		let currentSize = await sut.getSize()
		#expect(currentSize == expectedSize)
	}
	
	// MARK: - Helpers
	private func makeSUT(capacity: Int = 7) -> DataKitHashing<Int, Car> {
		.init(capacity: capacity)
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
