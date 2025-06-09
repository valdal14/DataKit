//
//  DataKitTests.swift
//  DataKitStackTests
//
//  Created by Valerio D'ALESSIO on 7/6/25.
//

import Testing
import DataKit

public actor DataKitActorStack<T: DataKitCompatible>: Sendable {
	private var data: DataKitActorLinkedList<T> = DataKitActorLinkedList<T>()
	
	public func push(_ element: T) async {
		await data.add(element)
	}
	
	public func isEmpty() async -> Bool {
		return await data.isEmpty()
	}
	
	public func getSize() async -> Int {
		return await data.getSize()
	}
	
	public func peek(_ value: T) async -> (T, Int)? {
		return await data.search(value)
	}
	
	public func printStack()  async -> String {
		await data.dump()
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
	
	@Test("peek returns nil when the element is not present in the stack")
	func peek_returns_nil() async throws {
		let sut = makeSUT()
		let newUser = User(id: UUID(), name: "John", surname: "Doe", age: 30)
		if let _ = await sut.peek(newUser) {
			assertionFailure("Expected nil but found an element")
		} else {
			#expect(await sut.isEmpty())
		}
	}
	
	@Test("peek returns element when the it is present in the stack")
	func peek() async throws {
		let sut = makeSUT()
		let newUser = User(id: UUID(), name: "John", surname: "Doe", age: 30)
		await sut.push(newUser)
		
		if let user = await sut.peek(newUser) {
			#expect(user.0.name == "John")
			#expect(user.0.surname == "Doe")
			#expect(user.0.age == 30)
		} else {
			assertionFailure("Expected element but was not found")
		}
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
