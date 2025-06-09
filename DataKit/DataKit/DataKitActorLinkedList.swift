//
//  DataKitActorLinkedList.swift
//  DataKit
//
//  Created by Valerio D'ALESSIO on 9/6/25.
//

import Foundation

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
	
	public init(head: Node<T>? = nil) {
		self.head = head
	}
	
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
	
	public func searchAllBy(_ value: T) -> [(T, Int)] {
		var output: [(T, Int)] = []
		
		if head == nil {
			return output
		}
		
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
	
	public func update(_ element: T, value: T) throws  {
		if head == nil { throw DataKitError.emptyStructure("Cannot update an empty list") }
		if head?.value == element {
			head?.value = value
			return
		}
		
		var current = head
		while let node = current {
			if node.value == element {
				node.value = value
			}
			current = node.next
		}
	}
}
