//
//  DataKitTests.swift
//  DataKitStackTests
//
//  Created by Valerio D'ALESSIO on 7/6/25.
//

import Testing
import DataKit

/// An actor-based stack implementation using a linked list as the underlying data structure.
public actor DataKitActorStack<T: DataKitCompatible>: Sendable {
	private var data: DataKitActorLinkedList<T> = DataKitActorLinkedList<T>()

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
	public func printStack() async -> String {
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
	///   - newElement: The new element to replace it with.
	///   - configuration: Specifies whether to update one or all occurrences.
	/// - Throws: `DataKitError.emptyStructure` if the stack is empty.
	public func update(_ currentElement: T, newElement: T, configuration: UpdateType) async throws {
		try await data.update(currentElement, newElement: newElement, configuration: configuration)
	}
}

struct DataKitStackTests {

    @Test("push a new user into the stack")
	func push() async throws {
		let sut = makeSUT()
		let newUser = User(id: UUID(), name: "John", surname: "Doe", age: 30)
		await sut.push(newUser)
		let isStackEmpty = await sut.isEmpty()
		#expect(isStackEmpty == false)
    }
	
	@Test("isEmpty successfully returns true if the stack is empty")
	func push_returns_true() async throws {
		let sut = makeSUT()
		let isStackEmpty = await sut.isEmpty()
		#expect(isStackEmpty)
	}
	
	@Test("getSize returns 0 when the stack is empty")
	func getSize_returns_zero() async throws {
		let sut = makeSUT()
		let size = await sut.getSize()
		#expect(size == 0)
	}
	
	@Test("getSize returns the size of the stack when the stack is not empty")
	func getSize() async throws {
		let sut = makeSUT()
		let newUser = User(id: UUID(), name: "John", surname: "Doe", age: 30)
		await sut.push(newUser)
		let size = await sut.getSize()
		#expect(size == 1)
	}
	
	@Test("peek throws when the element is not present in the stack")
	func peek_returns_nil() async throws {
		let sut = makeSUT()
		await #expect(throws: DataKitError.emptyStructure, performing: ({
			let _ = try await sut.peek()
		}))
	}
	
	@Test("peek returns element when the it is present in the stack")
	func peek() async throws {
		let sut = makeSUT()
		let newUser1 = User(id: UUID(), name: "John", surname: "Doe", age: 30)
		let newUser2 = User(id: UUID(), name: "Valerio", surname: "Dal", age: 40)
		await sut.push(newUser1)
		await sut.push(newUser2)
		
		let user = try await sut.peek()
		#expect(user.id == newUser2.id)
		#expect(user.name == newUser2.name)
		#expect(user.surname == newUser2.surname)
		#expect(user.age == newUser2.age)
	}
	
	@Test("search returns the found element")
	func search() async throws {
		let sut = makeSUT()
		let newUser1 = User(id: UUID(), name: "John", surname: "Doe", age: 30)
		let newUser2 = User(id: UUID(), name: "Valerio", surname: "Dal", age: 40)
		await sut.push(newUser1)
		await sut.push(newUser2)
		
		if let user = await sut.search(newUser1) {
			#expect(newUser1.name == "John")
			#expect(newUser1.surname == "Doe")
			#expect(newUser1.age == 30)
			#expect(newUser1.id == user.0.id)
		} else {
			assertionFailure("Expected user but got nil")
		}
	}
	
	@Test("searchAll returns all elements found with the same value")
	func searchAll() async throws {
		let sut = makeSUT()
		let newUser1 = User(id: UUID(), name: "John", surname: "Doe", age: 30)
		let newUser2 = User(id: UUID(), name: "Valerio", surname: "Dal", age: 40)
		let newUser3 = User(id: newUser1.id, name: "John", surname: "Doe", age: 30)
		await sut.push(newUser1)
		await sut.push(newUser2)
		await sut.push(newUser3)
		
		let elements = await sut.searchAll(newUser1)
		#expect(elements.count == 2)
	}
	
	@Test("update successfully update the first element found")
	func update_first() async throws {
		let sut = makeSUT()
		let newUser1 = User(id: UUID(), name: "John", surname: "Doe", age: 30)
		let newUser2 = User(id: UUID(), name: "Valerio", surname: "Dal", age: 40)
		let newUser3 = User(id: newUser2.id, name: "Valerio", surname: "Dal", age: 40)
		await sut.push(newUser1)
		await sut.push(newUser2)
		await sut.push(newUser3)
		
		try await sut.update(newUser2, newElement: .init(id: .init(), name: "Grazia", surname: "Dal", age: 6), configuration: .one)
		
		let foundUser = await sut.searchAll(newUser2)
		#expect(foundUser.count == 1)
	}
	
	@Test("update successfully update the first element found")
	func update_all() async throws {
		let sut = makeSUT()
		let newUser1 = User(id: UUID(), name: "John", surname: "Doe", age: 30)
		let newUser2 = User(id: UUID(), name: "Valerio", surname: "Dal", age: 40)
		let newUser3 = User(id: newUser2.id, name: "Valerio", surname: "Dal", age: 40)
		await sut.push(newUser1)
		await sut.push(newUser2)
		await sut.push(newUser3)
		
		let newUser = User(id: newUser2.id, name: "Grazia", surname: "Dal", age: 6)
		
		try await sut.update(newUser2, newElement: newUser, configuration: .all)
		
		let foundUser = await sut.searchAll(newUser)
		#expect(foundUser.count == 2)
	}
	
	// MARK: - Helper methods
	private func makeSUT() -> DataKitActorStack<User> {
		return .init()
	}
}

// MARK: - Custom type with conformance to the DataKitCompatible
struct User: DataKitCompatible, Identifiable {
	let id: UUID
	let name: String
	let surname: String
	let age: Int
	
	init(id: UUID, name: String, surname: String, age: Int) {
		self.id = id
		self.name = name
		self.surname = surname
		self.age = age
	}
}
