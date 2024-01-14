//
//  LinkedListNodeTest.swift
//  
//
//  Created by 강민석 on 2024/01/13.
//

import XCTest
@testable import Peri

final class LinkedListNodeTest: XCTestCase {
    
    public typealias Node = LinkedListNode<Int>
    
    private var head: Node!
    
    private weak var observer1: Node!
    private weak var observer2: Node!
    private weak var observer3: Node!
    private weak var observer4: Node!
    private weak var observer3_2: Node!
    
    override func setUpWithError() throws {
        head = .init(element: 0)
        let node1 = Node(element: 1)
        let node2 = Node(element: 2)
        let node3 = Node(element: 3)
        let node4 = Node(element: 4)
        let node3_2 = Node(element: 3)
        
        observer1 = node1
        observer2 = node2
        observer3 = node3
        observer4 = node4
        observer3_2 = node3_2
        
        head.prev = nil
        head.next = node1
        
        node1.prev = head
        node1.next = node2
        
        node2.prev = node1
        node2.next = node3
        
        node3.prev = node2
        node3.next = node4
        
        node4.prev = node3
        node4.next = node3_2
        
        node3_2.prev = node4
        node3_2.next = nil
    }
    
    func test_all_nodes_Alive() {
        XCTAssertNotNil(observer1)
        XCTAssertNotNil(observer2)
        XCTAssertNotNil(observer3)
        XCTAssertNotNil(observer4)
        XCTAssertNotNil(observer3_2)
    }
    
    func test_all_nodes_deinit_when_head_is_nil() {
        // when
        head = nil
        
        // then
        XCTAssertNil(observer1)
        XCTAssertNil(observer2)
        XCTAssertNil(observer3)
        XCTAssertNil(observer4)
        XCTAssertNil(observer3_2)
    }
    
    func test_offset_by_positive() {
        let node1 = head.next
        let node3 = node1?.offset(by: 2)
        
        XCTAssertIdentical(node1, observer1)
        XCTAssertIdentical(node3, observer3)
    }
    
    func test_offset_by_zero() {
        let node1 = head.next
        let sameNode = node1?.offset(by: 0)
        
        XCTAssertIdentical(node1, sameNode)
    }
    
    func test_offset_by_negative() {
        let node1 = head.next
        let before = node1?.offset(by: -1)
        
        XCTAssertIdentical(node1, observer1)
        XCTAssertIdentical(before, head)
    }

}
