//
//  DataKitActorLinkedList.swift
//  DataKit
//
//  Created by Valerio D'ALESSIO on 9/6/25.
//

import Foundation

/// An actor-based LinkedList implementation.
public actor DataKitActorLinkedList<T: DataKitCompatible>: Sendable {
	private var head: Node<T>?
	private var tail: Node<T>?
	private var listSize: Int = 0
	
	/// Initialises an empty linked list.
	public init() {}
	
	/// Adds a new value to the end of the linked list.
	/// - Parameter value: The value to be added to the list.
	public func add(_ value: T) {
		let newNode = Node<T>(value: value)
		
		if head == nil {
			head = newNode
			tail = newNode
		} else {
			tail?.next = newNode
			tail = newNode
		}
		
		listSize += 1
	}
	
	/// Deletes the first occurrence of a value from the linked list.
	/// - Parameter value: The value to be deleted.
	/// - Throws: `DataKitError.emptyStructure` if the list is empty.
	public func delete(_ value: T) throws {
		if head == nil { throw DataKitError.emptyStructure }
		
		if head?.value == value {
			if head === tail {
				tail = nil
			}
			head = head?.next
			listSize -= 1
			return
		}
		
		var current = head?.next
		var previous = head
		
		while let c = current {
			if c.value == value {
				previous?.next = c.next
				// Update tail if last node is removed
				if c === tail {
					tail = previous
				}
				listSize -= 1
				break
			}
			previous = current
			current = current?.next
		}
	}
	
	/// Returns the number of elements in the linked list.
	/// - Returns: The total number of elements.
	public func getSize() -> Int {
		return listSize
	}
	
	/// Checks whether the linked list is empty.
	/// - Returns: `true` if the list has no elements, `false` otherwise.
	public func isEmpty() -> Bool {
		return getSize() == 0
	}
	
	/// Searches for the first occurrence of a value in the list.
	/// - Parameter value: The value to search for.
	/// - Returns: A tuple containing the value and its index if found, or `nil` otherwise.
	public func search(_ value: T) -> (T, Int)? {
		if head == nil { return nil }
		
		var index = 0
		var current = head
		
		while let node = current {
			if node.value == value {
				return (node.value, index)
			}
			current = node.next
			index += 1
		}
		
		return nil
	}
	
	// Searches for all occurrences of a value in the list.
	/// - Parameter value: The value to search for.
	/// - Returns: An array of tuples containing the value and its index for each match found.
	public func searchAllBy(_ value: T) -> [(T, Int)] {
		var output: [(T, Int)] = []
		
		if head == nil { return output }
		
		var current = head
		var index = 0
		
		while let node = current {
			if node.value == value {
				output.append((node.value, index))
			}
			current = node.next
			index += 1
		}
		
		return output
	}
	
	/// Updates one or more occurrences of a value in the list.
	/// - Parameters:
	///   - currentElement: The element to find and update.
	///   - with: The new value to assign.
	///   - configuration: Whether to update only the first match (`.one`) or all matches (`.all`). Default is `.one`.
	/// - Throws: `DataKitError.emptyStructure` if the list is empty.
	public func update(_ currentElement: T, with newElement: T, configuration: UpdateType = .one) throws  {
		if head == nil { throw DataKitError.emptyStructure }
		
		if head?.value == currentElement {
			head?.value = newElement
			if configuration == .one { return }
		}
		
		var current = head
		
		while let node = current {
			if node.value == currentElement {
				node.value = newElement
				if configuration == .one { break }
			}
			current = node.next
		}
	}
	
	/// Returns the value of the last (tail) node in the linked list.
	///
	/// - Throws: `DataKitError.emptyStructure` if the list is empty.
	/// - Returns: The value of the tail node.
	public func getTail() throws -> T {
		guard let tailNode = tail?.value else { throw DataKitError.emptyStructure }
		return tailNode
	}
	
	/// Returns a string representation of all values in the list.
	/// - Returns: A string listing all values in order, or `"Empty List"` if the list is empty.
	public func dump() -> String {
		if head == nil { return "Empty List" }
		
		var output: [T] = []
		var current = head
		
		while let node = current {
			output.append(node.value)
			current = node.next
		}
		
		return output.description
	}
}

// MARK: - Add support for Stack implementation
public extension DataKitActorLinkedList {
	/// Pushes a value onto the top of the stack.
	///
	/// This method inserts a new element at the head of the linked list,
	/// effectively behaving like a stack's `push` operation.
	///
	/// - Parameter value: The value to be pushed onto the stack.
	func push(_ value: T) {
		let newNode = Node<T>(value: value)
		newNode.next = head
		head = newNode
		listSize += 1
	}
	
	/// Removes and returns the value at the top of the stack.
	///
	/// This method removes the element at the head of the linked list,
	/// effectively behaving like a stack's `pop` operation.
	///
	/// - Returns: The value at the top of the stack.
	/// - Throws: `DataKitError.emptyStructure` if the list is empty.
	func pop() throws -> T {
		if let currentHead = head {
			head = currentHead.next
			listSize -= 1
			return currentHead.value
		} else {
			throw DataKitError.emptyStructure
		}
	}
	
	/// Returns the value at the top of the stack without removing it.
	///
	/// - Returns: The value at the top of the stack.
	/// - Throws: `DataKitError.emptyStructure` if the list is empty.
	func peek() throws -> T {
		guard let currentHead = head else {
			throw DataKitError.emptyStructure
		}
		return currentHead.value
	}
}

// MARK: - Add support for Queue implementation
public extension DataKitActorLinkedList {
	
	/// Adds an element to the end of the list, mimicking queue enqueue behavior.
	///
	/// - Parameter value: The value to be enqueued.
	func enqueue(_ value: T) {
		add(value)
	}
	
	/// Removes and returns the element at the front of the list, mimicking queue dequeue behavior.
	///
	/// - Returns: The dequeued element.
	/// - Throws: `DataKitError.emptyStructure` if the list is empty.
	func dequeue() throws -> T {
		return try pop()
	}
}
