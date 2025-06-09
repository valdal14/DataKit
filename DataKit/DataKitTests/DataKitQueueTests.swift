//
//  DataKitQueueTests.swift
//  DataKitTests
//
//  Created by Valerio D'ALESSIO on 9/6/25.
//

import DataKit
import Testing

public actor DataKitQueue<T: DataKitCompatible>: Sendable {
	private let data: DataKitActorLinkedList<T> = DataKitActorLinkedList<T>()
	
	public init() {}
	
	/// Adds an element to the queue.
	///
	/// - Parameter value: The value to be enqueued.
	public func enqueue(_ element: T) async {
		await data.enqueue(element)
	}
	
	/// Removes and returns the element at the front of the queue.
	///
	/// - Returns: The dequeued element.
	/// - Throws: `DataKitError.emptyStructure` if the list is empty.
	public func dequeue() async throws -> T {
		return try await data.dequeue()
	}
	
	/// Returns the element at the front of the queue without removing it.
	///
	/// - Returns: The front element of the queue.
	/// - Throws: `DataKitError.emptyStructure` if the queue is empty.
	public func getFront() async throws -> T {
		return try await data.peek()
	}
	
	/// Searches for the first occurrence of the specified element in the queue.
	///
	/// - Parameter element: The element to search for.
	/// - Returns: A tuple containing the element and its index if found, or `nil` if the element is not present.
	public func search(_ element: T) async -> (T, Int)? {
		return await data.search(element)
	}
	
	/// Checks whether the stack is queue.
	///
	/// - Returns: `true` if the stack is empty, otherwise `false`.
	public func isEmpty() async -> Bool {
		return await data.isEmpty()
	}

	/// Returns the current number of elements in the queue.
	///
	/// - Returns: The number of elements in the stack.
	public func getSize() async -> Int {
		return await data.getSize()
	}
	
	/// Returns a string representation of the queue contents.
	///
	/// - Returns: A string describing the elements in the queue.
	public func dumpQueue() async -> String {
		await data.dump()
	}
}

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
	
	// MARK: - Helpers
	private func makeSUT() -> DataKitQueue<Int> {
		return .init()
	}
}
