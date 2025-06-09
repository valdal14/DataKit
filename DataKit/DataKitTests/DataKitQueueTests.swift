//
//  DataKitQueueTests.swift
//  DataKitTests
//
//  Created by Valerio D'ALESSIO on 9/6/25.
//

import DataKit
import Testing

struct DataKitQueueTests {
	
	@Test("enqueue new element into the queue")
	func enqueue() async throws {
		let sut = makeSUT()
		var isEmpty = await sut.isEmpty()
		#expect(isEmpty)
		
		await sut.enqueue(1)
		isEmpty = await sut.isEmpty()
		#expect(!isEmpty)
	}
	
	@Test("dequeue an element from the queue")
	func dequeue() async throws {
		let sut = makeSUT()
		await sut.enqueue(1)
		await sut.enqueue(2)
		await sut.enqueue(3)
		
		var size = await sut.getSize()
		#expect(size == 3)
		
		let dequeuedValue = try await sut.dequeue()
		#expect(dequeuedValue == 1)
		
		size = await sut.getSize()
		#expect(size == 2)
	}
	
	@Test("getFront returns the front element of the queue")
	func getFront() async throws {
		let sut = makeSUT()
		await sut.enqueue(14)
		await sut.enqueue(7)
		await sut.enqueue(33)
		
		let value = try await sut.getFront()
		#expect(value == 14)
	}
	
	@Test("search returns the first element found by a given value")
	func search() async throws {
		let sut = makeSUT()
		await sut.enqueue(1)
		await sut.enqueue(2)
		await sut.enqueue(1)
		
		if let value = await sut.search(1) {
			#expect(value.0 == 1)
			#expect(value.1 == 0)
		} else {
			assertionFailure("Expected an element but got nil")
		}
	}
	
	@Test("search return nil if the element is not present in the queue")
	func search_Returns_Nil() async throws {
		let sut = makeSUT()
		await sut.enqueue(1)
		await sut.enqueue(2)
		
		if let value = await sut.search(3) {
			assertionFailure("Expected an element but got \(value)")
		}
	}
	
	@Test("searchAll returns all occurrences of the given element")
	func searchAll() async throws {
		let sut = makeSUT()
		await sut.enqueue(1)
		await sut.enqueue(2)
		await sut.enqueue(1)
		await sut.enqueue(1)
		
		let values = await sut.searchAll(1)
		#expect(values.count == 3)
	}
	
	@Test("searchAll returns an empty list")
	func searchAll_Returns_Empty_List() async throws {
		let sut = makeSUT()
		await sut.enqueue(1)
		await sut.enqueue(2)
		await sut.enqueue(1)
		await sut.enqueue(1)
		
		let values = await sut.searchAll(14)
		#expect(values.count == 0)
	}
	
	@Test("update the first found element in the queue")
	func update() async throws {
		let sut = makeSUT()
		await sut.enqueue(1)
		
		try await sut.update(1, with: 14, configuration: .one)
		let updatedElement = try await sut.getFront()
		#expect(updatedElement == 14)
	}
	
	@Test("update all elements in the queue")
	func update_all() async throws {
		let sut = makeSUT()
		await sut.enqueue(1)
		await sut.enqueue(2)
		await sut.enqueue(3)
		await sut.enqueue(2)
		await sut.enqueue(6)
		await sut.enqueue(2)
		
		try await sut.update(2, with: 14, configuration: .all)
		let updatedElements = await sut.searchAll(14)
		#expect(updatedElements.count == 3)
	}
	
	// MARK: - Helpers
	private func makeSUT() -> DataKitQueue<Int> {
		return .init()
	}
}
