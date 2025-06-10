//
//  DataKitLinkedListTests.swift
//  DataKitTests
//
//  Created by Valerio D'ALESSIO on 8/6/25.
//

import DataKit
import Testing

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
	
	@Test("delete throws an exception when trying to delete from an empty list")
	func delete_throws() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newNode: MyCustomType = MyCustomType.makeItem("Key1", 14)
		await #expect(throws: DataKitError.emptyStructure, performing: ({
			try await ll.delete(newNode)
		}))
	}
	
	@Test("delete successfully remove the first node from the list with a given value")
	func delete() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newNode1: MyCustomType = MyCustomType.makeItem("Key1", 14)
		let newNode2: MyCustomType = MyCustomType.makeItem("Key1", 14)
		await ll.add(newNode1)
		await ll.add(newNode2)
		try await ll.delete(newNode1)
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
		try await ll.delete(newNode1)
		size = await ll.getSize()
		#expect(size == 1)
		try await ll.delete(newNode2)
		size = await ll.getSize()
		#expect(size == 0)
		let newHead: MyCustomType = MyCustomType.makeItem("Key1", 28)
		await ll.add(newHead)
		size = await ll.getSize()
		#expect(size == 1)
		try await ll.delete(newHead)
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
	
	@Test("search returns nil when a node cannot be found")
	func search_nil() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newHead: MyCustomType = MyCustomType.makeItem("Head", 28)
		let newNode0: MyCustomType = MyCustomType.makeItem("Key0", 12)
		let newNode1: MyCustomType = MyCustomType.makeItem("Key1", 2)
		await ll.add(newHead)
		await ll.add(newNode0)
		await ll.add(newNode1)
		
		#expect(await ll.search(MyCustomType.makeItem("Key2", 285)) == nil)
	}
	
	@Test("search successfully finds the first node and return a its value and index in the list")
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
		
		if let element = await ll.search(newNode1) {
			#expect(element.0.value == 2)
			#expect(element.1 == 2)
		} else {
			assertionFailure("Could not find the node")
		}
	}
	
	@Test("searchAllBy returns a list of values and index associated with the found nodes")
	func searchAllBy() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newHead: MyCustomType = MyCustomType.makeItem("Head", 28)
		let newNode0: MyCustomType = MyCustomType.makeItem("Key0", 12)
		let newNode1: MyCustomType = MyCustomType.makeItem("Key1", 2)
		let newNode2: MyCustomType = MyCustomType.makeItem("Key2", 14)
		await ll.add(newHead)
		await ll.add(newNode0)
		await ll.add(newNode1)
		await ll.add(newNode2)
		await ll.add(newNode1)
		
		let foundElements = await ll.searchAllBy(newNode1)
		#expect(foundElements.count == 2)
	}
	
	
	@Test("updateBy throws when the list is empty")
	func updateBy_Throws_On_Empty_List() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newHead: MyCustomType = MyCustomType.makeItem("Head", 7)
		await #expect(throws: DataKitError.emptyStructure, performing: ({
			try await ll.update(newHead, with: .makeItem(newHead.keyName, 14))
		}))
	}
	
	@Test("update updates the head node with a new value")
	func update_head() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newHead: MyCustomType = MyCustomType.makeItem("Head", 7)
		let newNode0: MyCustomType = MyCustomType.makeItem("Key0", 13)
		let newNode1: MyCustomType = MyCustomType.makeItem("Key0", 13)
		await ll.add(newHead)
		await ll.add(newNode0)
		await ll.add(newNode1)
		
		let expectedNewHeadValue: Int = 14
		let expectedNewHead: MyCustomType = MyCustomType.makeItem(newHead.keyName, expectedNewHeadValue)
		try await ll.update(newHead, with: .makeItem(newHead.keyName, expectedNewHeadValue))
		
		let elements = await ll.searchAllBy(expectedNewHead)
		#expect(elements.count == 1)
	}
	
	@Test("update updates all node occurrences a new value")
	func update_nodes() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newHead: MyCustomType = MyCustomType.makeItem("Head", 7)
		let newNode0: MyCustomType = MyCustomType.makeItem("Key0", 13)
		let newNode1: MyCustomType = MyCustomType.makeItem("Key1", 11)
		let newNode2: MyCustomType = MyCustomType.makeItem("Key1", 11)
		await ll.add(newHead)
		await ll.add(newNode0)
		await ll.add(newNode1)
		await ll.add(newNode2)
		
		let expectedNewValue: Int = 99
		let expectedNewNode: MyCustomType = MyCustomType.makeItem(newNode1.keyName, expectedNewValue)
		
		try await ll.update(newNode1, with: .makeItem(newNode1.keyName, expectedNewValue), configuration: .all)
		
		let elements = await ll.searchAllBy(expectedNewNode)
		#expect(elements.count == 2)
	}
	
	@Test("update updates only the first occurrence of the node with a new value")
	func update_node() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newHead: MyCustomType = MyCustomType.makeItem("Head", 7)
		let newNode0: MyCustomType = MyCustomType.makeItem("Key0", 13)
		let newNode1: MyCustomType = MyCustomType.makeItem("Key1", 11)
		let newNode2: MyCustomType = MyCustomType.makeItem("Key1", 11)
		await ll.add(newHead)
		await ll.add(newNode0)
		await ll.add(newNode1)
		await ll.add(newNode2)
		
		let expectedNewValue: Int = 99
		let expectedNewNode: MyCustomType = MyCustomType.makeItem(newNode1.keyName, expectedNewValue)
		
		try await ll.update(newNode1, with: .makeItem(newNode1.keyName, expectedNewValue))
		
		let elements = await ll.searchAllBy(expectedNewNode)
		#expect(elements.count == 1)
	}
	
	@Test("getTail throws when the tail node is nil")
	func getTail_throws() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		await #expect(throws: DataKitError.emptyStructure, performing: ({
			try await ll.getTail()
		}))
	}
	
	// MARK: - Helpers
	private func makeSUT() -> DataKitActorLinkedList<MyCustomType> {
		return .init()
	}
}

// MARK: - DataKitLinkedListTests extension for testing the stack implementation methods
extension DataKitLinkedListTests {
	
	@Test("stack operations work correctly")
	func stackOperations() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newHead: MyCustomType = MyCustomType.makeItem("Head", 7)
		let newNode0: MyCustomType = MyCustomType.makeItem("Key0", 13)
		let newNode1: MyCustomType = MyCustomType.makeItem("Key1", 32)
		await ll.push(newHead)
		await ll.push(newNode0)
		await ll.push(newNode1)
		let size = await ll.getSize()
		#expect(size == 3)
	}
	
	@Test("pop from an empty list throws an error")
	func pop_Empty_List_Throws() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		await #expect(throws: DataKitError.emptyStructure, performing: ({
			let _ = try await ll.pop()
		}))
	}
	
	@Test("pop always returns the head of the list")
	func pop() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newHead: MyCustomType = MyCustomType.makeItem("Head", 7)
		let newNode0: MyCustomType = MyCustomType.makeItem("Key0", 13)
		let newNode1: MyCustomType = MyCustomType.makeItem("Key1", 32)
		await ll.push(newHead)
		await ll.push(newNode0)
		await ll.push(newNode1)
		
		let popHead = try await ll.pop()
		#expect(popHead.value == 32)
		let popAgainHead = try await ll.pop()
		#expect(popAgainHead.value == 13)
		let size = await ll.getSize()
		let isEmpty = await ll.isEmpty()
		#expect(size == 1)
		#expect(!isEmpty)
	}
	
	@Test("peek throws if the list is empty")
	func peek_Empty_List_Throws() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		await #expect(throws: DataKitError.emptyStructure, performing: ({
			_ = try await ll.peek()
		}))
	}
	
	@Test("peek returns the head element from the list")
	func peek() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newHead: MyCustomType = MyCustomType.makeItem("Head", 7)
		let newNode0: MyCustomType = MyCustomType.makeItem("Key0", 13)
		let newNode1: MyCustomType = MyCustomType.makeItem("Key1", 32)
		let newNode2: MyCustomType = MyCustomType.makeItem("Key2", 14)
		await ll.push(newHead)
		await ll.push(newNode0)
		await ll.push(newNode1)
		await ll.push(newNode2)
		
		let popHead = try await ll.peek()
		let size = await ll.getSize()
		#expect(popHead.value == 14)
		#expect(size == 4)
	}
}

// MARK: - DataKitLinkedListTests extension for testing the stack implementation methods
extension DataKitLinkedListTests {
	
	@Test("enqueue the element into the queue")
	func enqueue() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newHead: MyCustomType = MyCustomType.makeItem("Head", 7)
		let newNode0: MyCustomType = MyCustomType.makeItem("Key0", 13)
		await ll.enqueue(newHead)
		await ll.enqueue(newNode0)
		
		let size = await ll.getSize()
		#expect(size == 2)
	}
	
	@Test("dequeue the element from the queue")
	func dequeue() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newHead: MyCustomType = MyCustomType.makeItem("Head", 7)
		let newNode0: MyCustomType = MyCustomType.makeItem("Key0", 13)
		await ll.enqueue(newHead)
		await ll.enqueue(newNode0)
		
		let dequeueElement = try await ll.dequeue()
		#expect(dequeueElement.keyName == "Head")
		#expect(dequeueElement.value == 7)
		
		let size = await ll.getSize()
		#expect(size == 1)
	}
	
	@Test("dequeue throws an error when the queue is empty")
	func dequeue_Throws() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		await #expect(throws: DataKitError.emptyStructure, performing: ({
			try await ll.dequeue()
		}))
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
