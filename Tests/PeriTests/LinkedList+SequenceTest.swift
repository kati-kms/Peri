//
//  LinkedList+SequenceTest.swift
//  
//
//  Created by 강민석 on 2024/01/13.
//

import XCTest
@testable import Peri

final class LinkedList_SequenceTest: XCTestCase {

    private var list: LinkedList<Int>!
    private let sequence = (1...10)
    
    override func setUpWithError() throws {
        list = .init()
        sequence.forEach { list.append($0) }
    }
    
    func test_asSequence() {
        zip(sequence, list).forEach {
            XCTAssertEqual($0, $1)
        }
    }
    
    func test_iterator_next() {
        var elements = [Int]()
        var iterator = list.makeIterator()
        while let element = iterator.next() {
            elements.append(element)
        }
        
        XCTAssertEqual(Array(sequence), elements)
    }
    
    func test_iterator_next_with_count() {
        let expected = [1, 3, 5, 7, 9]
        
        var elements = [Int]()
        var iterator = list.makeIterator()
        while let element = iterator.next(2) {
            elements.append(element)
        }
        
        XCTAssertEqual(expected, elements)
    }
    
    func test_iterator_next_with_count3() {
        let expected = [1, 4, 7, 10]
        
        var elements = [Int]()
        var iterator = list.makeIterator()
        while let element = iterator.next(3) {
            elements.append(element)
        }
        
        XCTAssertEqual(expected, elements)
    }
}
