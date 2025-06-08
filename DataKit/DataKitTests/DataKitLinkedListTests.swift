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

public actor DataKitActorLinkedList<T: DataKitCompatible> {
	private var head: Node<T>?
	private var listSize: Int = 0
	
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
		
		listSize += 1
	}
	
	public func deleteFirstBy(_ value: T) throws {
		if head == nil { throw DataKitError.emptyStructure("Cannot delete from an empty list") }
		
		if head?.value == value {
			head = head?.next
			listSize -= 1
			return
		}
		
		var current = head?.next
		var previous = head
		
		while let c = current {
			if c.value == value {
				previous?.next = current?.next
				listSize -= 1
			}
			previous = current
			current = current?.next
		}
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
	
	public func getSize() -> Int {
		return listSize
	}
	
	public func isEmpty() -> Bool {
		return getSize() == 0
	}
	
	public func searchBy(_ value: T) -> (T, Int)? {
		var index = -1
		
		if head == nil {
			return nil
		}
		
		var current = head
		
		while let node = current {
			index += 1
			if node.value == value {
				return (node: node.value, index: index)
			} else {
				current = current?.next
			}
		}
		
		return nil
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
	
	@Test("dump return 'Empty List' when the list is empty")
	func bump_empty() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let expectedString: String = "Empty List"
		#expect(await ll.dump() == expectedString)
	}
	
	@Test("dump return a string representation of the current list")
	func dump() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newNode1: MyCustomType = MyCustomType.makeItem("Key1", 14)
		let newNode2: MyCustomType = MyCustomType.makeItem("Key2", 28)
		let newNode3: MyCustomType = MyCustomType.makeItem("Key3", 1)
		await ll.add(newNode1)
		await ll.add(newNode2)
		await ll.add(newNode3)
		let strList = await ll.dump()
		#expect(strList != "Empty List")
		let size = await ll.getSize()
		#expect(size == 3)
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
	
	@Test("getSize successfully returns the correct size of the list")
	func getSize() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newNode1: MyCustomType = MyCustomType.makeItem("Key1", 1)
		let newNode2: MyCustomType = MyCustomType.makeItem("Key1", 14)
		await ll.add(newNode1)
		await ll.add(newNode2)
		var size = await ll.getSize()
		#expect(size == 2)
		try await ll.deleteFirstBy(newNode1)
		size = await ll.getSize()
		#expect(size == 1)
		try await ll.deleteFirstBy(newNode2)
		size = await ll.getSize()
		#expect(size == 0)
		let newHead: MyCustomType = MyCustomType.makeItem("Key1", 28)
		await ll.add(newHead)
		size = await ll.getSize()
		#expect(size == 1)
		try await ll.deleteFirstBy(newHead)
		size = await ll.getSize()
		#expect(size == 0)
	}
	
	@Test("isEmpty returns true if the list is empty")
	func isEmpty() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		#expect(await ll.isEmpty())
	}
	
	@Test("isEmpty returns false if the list is not empty")
	func isEmpty_false() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newHead: MyCustomType = MyCustomType.makeItem("Key1", 28)
		await ll.add(newHead)
		#expect(await ll.isEmpty() == false)
	}
	
	@Test("searchBy returns nil when a node cannot be found")
	func search_nil() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newHead: MyCustomType = MyCustomType.makeItem("Head", 28)
		let newNode0: MyCustomType = MyCustomType.makeItem("Key0", 12)
		let newNode1: MyCustomType = MyCustomType.makeItem("Key1", 2)
		await ll.add(newHead)
		await ll.add(newNode0)
		await ll.add(newNode1)
		
		#expect(await ll.searchBy(MyCustomType.makeItem("Key2", 285)) == nil)
	}
	
	@Test("searchBy successfully finds the first node and return a its value and index in the list")
	func searchBy() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newHead: MyCustomType = MyCustomType.makeItem("Head", 28)
		let newNode0: MyCustomType = MyCustomType.makeItem("Key0", 12)
		let newNode1: MyCustomType = MyCustomType.makeItem("Key1", 2)
		let newNode2: MyCustomType = MyCustomType.makeItem("Key2", 14)
		let newNode3: MyCustomType = MyCustomType.makeItem("Key3", 2)
		await ll.add(newHead)
		await ll.add(newNode0)
		await ll.add(newNode1)
		await ll.add(newNode2)
		await ll.add(newNode3)
		
		if let element = await ll.searchBy(newNode1) {
			#expect(element.0.value == 2)
			#expect(element.1 == 2)
		} else {
			assertionFailure("Could not find the node")
		}
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
