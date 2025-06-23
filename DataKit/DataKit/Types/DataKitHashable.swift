//
//  DataKitHashable.swift
//  DataKit
//
//  Created by Valerio D'ALESSIO on 23/6/25.
//

import Foundation

public protocol DataKitHashable: Equatable {
	associatedtype T: DataKitCompatible
	var key: Int { get set }
	var value: T { get set }
}
