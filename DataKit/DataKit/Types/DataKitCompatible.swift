//
//  DataKitCompatible.swift
//  DataKit
//
//  Created by Valerio D'ALESSIO on 7/6/25.
//

import Foundation

public protocol DataKitCompatible: Sendable, Hashable {}

// MARK: - Numeric types
extension Int: DataKitCompatible {}
extension Int8: DataKitCompatible {}
extension Int16: DataKitCompatible {}
extension Int32: DataKitCompatible {}
extension Int64: DataKitCompatible {}
extension UInt: DataKitCompatible {}
extension UInt8: DataKitCompatible {}
extension UInt16: DataKitCompatible {}
extension UInt32: DataKitCompatible {}
extension UInt64: DataKitCompatible {}
extension Float: DataKitCompatible {}
extension Double: DataKitCompatible {}
extension Decimal: DataKitCompatible {}

// MARK: - Boolean
extension Bool: DataKitCompatible {}

// MARK: - String
extension String: DataKitCompatible {}
extension Character: DataKitCompatible {}

// MARK: - Date and Time
extension Date: DataKitCompatible {}
extension UUID: DataKitCompatible {}
extension URL: DataKitCompatible {}
extension Data: DataKitCompatible {}

// MARK: - Optional types — for generic use cases
extension Optional: DataKitCompatible where Wrapped: DataKitCompatible {}
