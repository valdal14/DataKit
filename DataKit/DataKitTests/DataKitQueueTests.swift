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
	
	// MARK: - Helpers
	private func makeSUT() -> DataKitQueue<Int> {
		return .init()
	}
}
