//
//  DataKitLinkedListTests.swift
//  DataKitTests
//
//  Created by Valerio D'ALESSIO on 8/6/25.
//

import DataKit
import Testing


public final class Node<T: DataKitCompatible>: Equatable {
	public var value: T
	public var next: Node?
	
	public init(value: T) {
		self.value = value
		self.next = nil
	}
	
	public static func == (lhs: Node<T>, rhs: Node<T>) -> Bool {
		return lhs.value == rhs.value && lhs.next == rhs.next
	}
}

public enum DataKitError: Error, Equatable {
	case emptyStructure(String)
	case nodeNotFound(String)
}

public actor DataKitActorLinkedList<T: DataKitCompatible>: Sendable {
	private var head: Node<T>?
	
	public func add(_ value: T) {
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
	
	public func deleteFirstBy(_ value: T) throws {
		if head == nil { throw DataKitError.emptyStructure("Cannot delete from an empty list") }
		
		if head?.value == value {
			head = head?.next
			return
		}
		
		var current = head?.next
		var previous = head
		
		while let c = current {
			if c.value == value {
				previous?.next = current?.next
			}
			previous = current
			current = current?.next
		}
	}
	
	public func getSize() -> Int {
		var current = head
		var count = 0
		while let _ = current {
			count += 1
			current = current?.next
		}
		return count
	}
	
	public func dump() -> String {
		if head == nil {
			return "Empty List"
		}
		
		var output: [T] = []
		var current = head
		
		while let node = current {
			output.append(node.value)
			current = node.next
		}
		
		return output.map(\.self).description
	}
}

struct DataKitLinkedListTests {
	
	@Test("add new element to the DataKitActorLinkedList")
	func add() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newNode: MyCustomType = MyCustomType.makeItem("Key1", 14)
		await ll.add(newNode)
		let size = await ll.getSize()
		#expect(size == 1)
	}
	
	@Test("deleteFirstBy throws an exception when trying to delete from an empty list")
	func deleteFirstBy_throws() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newNode: MyCustomType = MyCustomType.makeItem("Key1", 14)
		let expectedErrorMessage: String = "Cannot delete from an empty list"
		await #expect(throws: DataKitError.emptyStructure(expectedErrorMessage), performing: {
			try await ll.deleteFirstBy(newNode)
		})
	}
	
	@Test("deleteFirstBy successfully remove the first node from the list with a given value")
	func delete() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newNode1: MyCustomType = MyCustomType.makeItem("Key1", 14)
		let newNode2: MyCustomType = MyCustomType.makeItem("Key1", 14)
		await ll.add(newNode1)
		await ll.add(newNode2)
		try await ll.deleteFirstBy(newNode1)
		let size = await ll.getSize()
		#expect(size == 1)
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
