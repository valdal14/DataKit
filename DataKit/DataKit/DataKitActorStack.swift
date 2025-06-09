//
//  DataKitActorStack.swift
//  DataKit
//
//  Created by Valerio D'ALESSIO on 9/6/25.
//

import Foundation

/// An actor-based stack implementation using a linked list as the underlying data structure.
public actor DataKitActorStack<T: DataKitCompatible>: Sendable {
	private var data: DataKitActorLinkedList<T> = DataKitActorLinkedList<T>()

	/// Initialises an empty stack.
	public init() {}
	
	/// Pushes an element onto the top of the stack.
	///
	/// - Parameter element: The element to be pushed.
	public func push(_ element: T) async {
		await data.push(element)
	}

	/// Checks whether the stack is empty.
	///
	/// - Returns: `true` if the stack is empty, otherwise `false`.
	public func isEmpty() async -> Bool {
		return await data.isEmpty()
	}

	/// Returns the current number of elements in the stack.
	///
	/// - Returns: The number of elements in the stack.
	public func getSize() async -> Int {
		return await data.getSize()
	}

	/// Returns the top element of the stack without removing it.
	///
	/// - Returns: The element at the top of the stack.
	/// - Throws: `DataKitError.emptyStructure` if the stack is empty.
	public func peek() async throws -> T {
		return try await data.peek()
	}

	/// Returns a string representation of the stack contents.
	///
	/// - Returns: A string describing the elements in the stack.
	public func dumpStack() async -> String {
		await data.dump()
	}

	/// Searches for the first occurrence of an element in the stack.
	///
	/// - Parameter element: The element to search for.
	/// - Returns: A tuple containing the matched element and its index, or `nil` if not found.
	public func search(_ element: T) async -> (T, Int)? {
		return await data.search(element)
	}

	/// Searches for all occurrences of an element in the stack.
	///
	/// - Parameter element: The element to search for.
	/// - Returns: An array of tuples containing each matched element and its index.
	public func searchAll(_ element: T) async -> [(T, Int)?] {
		return await data.searchAllBy(element)
	}

	/// Updates one or more occurrences of an element in the stack.
	///
	/// - Parameters:
	///   - currentElement: The existing element to update.
	///   - with: The new element to replace it with.
	///   - configuration: Specifies whether to update one or all occurrences.
	/// - Throws: `DataKitError.emptyStructure` if the stack is empty.
	public func update(_ currentElement: T, with newElement: T, configuration: UpdateType) async throws {
		try await data.update(currentElement, with: newElement, configuration: configuration)
	}
}
