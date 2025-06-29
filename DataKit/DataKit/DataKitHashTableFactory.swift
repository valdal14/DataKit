//
//  DataKitHashTableFactory.swift
//  DataKit
//
//  Created by Valerio D'ALESSIO on 23/6/25.
//

import Foundation

public struct DataKitHashTableFactory: Sendable {
	private static let minTableSize: Int = 2
	private static let maxTableSize: Int = 126
	private static let maxLambdaValue: Double = 0.5
	private static let minLambdaValue: Double = 0.3
	private static let lambdaStep: Double = 0.5
	private static let rationStartingValue: Double = 1.0
	
	public static func make<T: DataKitHashable>(tableSize: Int) throws -> DataKitHashTable<T> {
		if tableSize < minTableSize || tableSize > maxTableSize { throw DataKitError.invalidHashTableCapacity }
		let hashTableSize: Int = self.computeLoadFactor(chosenSize: tableSize, ratio: rationStartingValue)
		var r: Int = minTableSize
		if tableSize > minTableSize { r = previousPrime(hashTableSize - 1) }
		let elements: [T?] = Array(repeating: nil, count: hashTableSize)
		return .init(maxElement: tableSize, hashTableSize: hashTableSize, r: r, elements: elements)
	}
}

// MARK: - DataKitHashing determine HashTable Size
private extension DataKitHashTableFactory {
	
	static func computeLoadFactor(chosenSize: Int, ratio: Double) -> Int {
		let lambda: Double = Double(chosenSize) / ratio
		
		if lambda >= minLambdaValue && lambda <= maxLambdaValue {
			let nPrime: Int = nextPrime(Int(ratio))
			let pPrime: Int = previousPrime(Int(ratio))
			
			if (nPrime < pPrime) {
				return nPrime
			} else {
				return pPrime
			}
		}
		
		return computeLoadFactor(chosenSize: chosenSize, ratio: ratio + lambdaStep)
	}
	
	static func isPrime(_ n: Int) -> Bool {
		if (n <= 1) { return false };
		if (n <= 3) { return true };
		if (n % 2 == 0 || n % 3 == 0) { return false };
		
		let limit: Int = Int(sqrt(Double(n)));
		var i = 5;
		let increment = 6;
		
		while(i <= limit) {
			if (n % i == 0 || n % (i + 2) == 0) {
				return false;
			}
			i += increment;
		}
		
		return true;
	}
	
	static func nextPrime(_ n: Int) -> Int {
		var num = n;
		if (num <= 2) { return 2 };
		if (num % 2 == 0) { num += 1 };
		
		while (!isPrime(num)) {
			num += 2;
		}
		
		return num;
	}
	
	static func previousPrime(_ n: Int) -> Int {
		var num = n;
		if (num <= 2) { return 2 };
		if (num % 2 == 0) { num -= 1 };
		
		while (!isPrime(num))
		{
			num -= 2;
		}
		
		return num;
	}
}
