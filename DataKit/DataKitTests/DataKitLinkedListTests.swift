//
//  DataKitLinkedListTests.swift
//  DataKitTests
//
//  Created by Valerio D'ALESSIO on 8/6/25.
//

import DataKit
import Testing


public final class Node<T: DataKitCompatible> {
	public var value: T
	public var next: Node?
	
	public init(value: T) {
		self.value = value
		self.next = nil
	}
}

public enum DataKitError: Error, Equatable {
	case emptyStructure(String)
}

public actor DataKitActorLinkedList<T: DataKitCompatible>: Sendable {
	private var head: Node<T>?
	
	public func add(_ value: T) async {
		if head == nil {
			head = Node<T>(value: value)
		} else {
			var current = head
			while current?.next != nil {
				current = current?.next
			}
			current?.next = Node<T>(value: value)
		}
	}
	
	public func delete(_ value: T) async throws {
		if head == nil { throw DataKitError.emptyStructure("Cannot delete from an empty list") }
		
	}
	
	public func getSize() async -> Int {
		var current = head
		var count = 0
		while let _ = current {
			count += 1
			current = current?.next
		}
		return count
	}
	
}

struct DataKitLinkedListTests {
	
	@Test("Add new element to the DataKitActorLinkedList")
	func add() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newNode: MyCustomType = MyCustomType.makeItem("Key1", 14)
		await ll.add(newNode)
		let size = await ll.getSize()
		#expect(size == 1)
	}
	
	@Test("Delete throws an exception when trying to delete from an empty list")
	func delete_throws() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newNode: MyCustomType = MyCustomType.makeItem("Key1", 14)
		let expectedErrorMessage: String = "Cannot delete from an empty list"
		await #expect(throws: DataKitError.emptyStructure(expectedErrorMessage), performing: {
			try await ll.delete(newNode)
		})
	}
	
	// MARK: - Helpers
	private func makeSUT() -> DataKitActorLinkedList<MyCustomType> {
		return .init()
	}
}

// MARK: - Custom type with conformance to the DataKitCompatible
struct MyCustomType: DataKitCompatible {
	let keyName: String
	let value: Int
}

extension MyCustomType {
	static func makeItem(_ name: String, _ value: Int) -> MyCustomType {
		return MyCustomType(keyName: name, value: value)
	}
}
