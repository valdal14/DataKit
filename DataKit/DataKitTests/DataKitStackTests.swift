//
//  DataKitTests.swift
//  DataKitStackTests
//
//  Created by Valerio D'ALESSIO on 7/6/25.
//

import Testing
import DataKit

actor DataKitActorStack<T: DataKitCompatible>: Sendable {
	private var data: [T] = []
}

struct DataKitStackTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
		#expect(true)
    }
	
	// MARK: - Helper methods
	private func makeSUT() -> DataKitActorStack<Int> {
		return .init()
	}
}
