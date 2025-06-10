//
//  DataKitQueue.swift
//  DataKit
//
//  Created by Valerio D'ALESSIO on 9/6/25.
//

import Foundation

/// An actor-based queue implementation using a linked list as the underlying data structure.
public actor DataKitQueue<T: DataKitCompatible>: Sendable {
	private let data: DataKitActorLinkedList<T> = DataKitActorLinkedList<T>()
	
	/// Initialises an empty linked queue.
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
	
	/// Retrieves the value at the rear (tail) of the queue.
	///
	/// - Throws: `DataKitError.emptyStructure` if the queue is empty.
	/// - Returns: The value of the rear node.
	public func getRear() async throws -> T {
		return try await data.getTail()
	}
	
	/// Searches for the first occurrence of the specified element in the queue.
	///
	/// - Parameter element: The element to search for.
	/// - Returns: A tuple containing the element and its index if found, or `nil` if the element is not present.
	public func search(_ element: T) async -> (T, Int)? {
		return await data.search(element)
	}
	
	/// Searches for the all occurrences of the specified element in the queue.
	///
	/// - Parameter element: The element to search for.
	/// - Returns: An array of tuple containing the element and its index if found, or an empty array if the element is not present.
	public func searchAll(_ element: T) async -> [(T, Int)?] {
		return await data.searchAllBy(element)
	}
	
	/// Updates one or more occurrences of an element in the queue.
	///
	/// - Parameters:
	///   - currentElement: The existing element to update.
	///   - with: The new element to replace it with.
	///   - configuration: Specifies whether to update one or all occurrences.
	/// - Throws: `DataKitError.emptyStructure` if the queue is empty.
	public func update(_ currentElement: T, with newElement: T, configuration: UpdateType) async throws {
		try await data.update(currentElement, with: newElement, configuration: configuration)
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
