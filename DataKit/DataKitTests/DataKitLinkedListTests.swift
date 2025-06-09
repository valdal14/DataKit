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
		await #expect(throws: DataKitError.emptyStructure("Cannot update an empty list"), performing: ({
			try await ll.update(newHead, value: .makeItem(newHead.keyName, 14))
		}))
	}
	
	@Test("updateBy updates the head node with a new value")
	func updateBy_head() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newHead: MyCustomType = MyCustomType.makeItem("Head", 7)
		let newNode0: MyCustomType = MyCustomType.makeItem("Key0", 13)
		await ll.add(newHead)
		await ll.add(newNode0)
		
		let expectedNewHeadValue: Int = 14
		let expectedNewHead: MyCustomType = MyCustomType.makeItem(newHead.keyName, expectedNewHeadValue)
		try await ll.update(newHead, value: .makeItem(newHead.keyName, expectedNewHeadValue))
		
		if let element = await ll.searchBy(expectedNewHead) {
			#expect(element.0.value == expectedNewHeadValue)
		} else {
			assertionFailure("Could not find the node")
		}
	}
	
	@Test("updateBy updates the node with a new value")
	func updateBy_node() async throws {
		let ll: DataKitActorLinkedList<MyCustomType> = makeSUT()
		let newHead: MyCustomType = MyCustomType.makeItem("Head", 7)
		let newNode0: MyCustomType = MyCustomType.makeItem("Key0", 13)
		let newNode1: MyCustomType = MyCustomType.makeItem("Key1", 11)
		let newNode2: MyCustomType = MyCustomType.makeItem("Key2", 1)
		await ll.add(newHead)
		await ll.add(newNode0)
		await ll.add(newNode1)
		await ll.add(newNode2)
		
		let expectedNewValue: Int = 99
		let expectedNewNode: MyCustomType = MyCustomType.makeItem(newNode1.keyName, expectedNewValue)
		
		try await ll.update(newNode1, value: .makeItem(newNode1.keyName, expectedNewValue))
		
		if let element = await ll.searchBy(expectedNewNode) {
			#expect(element.0.value == expectedNewValue)
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
