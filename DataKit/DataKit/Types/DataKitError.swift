//
//  DataKitError.swift
//  DataKit
//
//  Created by Valerio D'ALESSIO on 9/6/25.
//

import Foundation

public enum DataKitError: Error, Equatable {
	case emptyStructure
	case invalidHashTableCapacity
	case exceededHashTableCapacity
	case elementNotFound
}
