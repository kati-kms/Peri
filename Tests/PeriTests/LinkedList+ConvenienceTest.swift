//
//  LinkedList+ConvenienceTest.swift
//  
//
//  Created by 강민석 on 2024/01/13.
//

import XCTest
@testable import Peri

final class LinkedList_ConvenienceTest: XCTestCase {
    
    private var list: LinkedList<Int>!
    private let sequence = (1...10)
    
    override func setUpWithError() throws {
        list = .init()
        sequence.forEach { list.append($0) }
    }
    
    func test_arrayLiteral() {
        list = .init(arrayLiteral: 1, 2, 4)
        
        XCTAssertEqual(list.toArray(), [1, 2, 4])
    }
    
    func test_toArray() {
        let asArray = list.toArray()
        
        zip(list, asArray).forEach {
            XCTAssertEqual($0, $1)
        }
    }
    
    func test_toArray_Empty() {
        list = .init()
        
        XCTAssertEqual(list.toArray(), [])
    }
    
    // MARK: - Init from Collection
    
    func test_init_from_Range() {
        list = .init(sequence)
        
        XCTAssertEqual(list.toArray(), Array(sequence))
    }
    
    func test_init_from_array() {
        let asArray = Array(sequence)
        list = .init(asArray)
        
        XCTAssertEqual(list.toArray(), asArray)
    }
    
    func test_init_from_Set() {
        let asSet = Set(sequence)
        list = .init(asSet)
        
        XCTAssertEqual(Set(list.toArray()), asSet)
    }
}
