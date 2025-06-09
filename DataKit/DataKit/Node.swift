//
//  Node.swift
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
