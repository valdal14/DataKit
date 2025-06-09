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
