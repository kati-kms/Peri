import XCTest
@testable import Peri

final class LinkedListTests: XCTestCase {
    
    typealias Node = LinkedListNode<Int>
    typealias List = LinkedList<Int>
    
    private var list: List!
    private let sequence = Array(0...9)
    private var weakNodes: [WeakObject<Node>] = []
    
    override func setUpWithError() throws {
        list = .init()
        sequence.forEach { list.append($0) }
        
        weak var now = list.head
        for _ in sequence {
            weakNodes.append(.init(now))
            now = now?.next
        }
    }
    
    func test_setUp_Valid() {
        for i in sequence {
            XCTAssertEqual(weakNodes[i].value.element, i)
        }
        XCTAssertEqual(list.count, 10)
    }
    
    // MARK: - Access
    
    func test_first() {
        XCTAssertEqual(list.first, sequence.first)
    }
    
    func test_last() {
        XCTAssertEqual(list.last, sequence.last)
    }
    
    func test_size() {
        XCTAssertEqual(list.count, sequence.count)
    }
    
    func test_isEmpty() {
        list = .init()
        XCTAssertTrue(list.isEmpty)
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
    }
    
    func test_isNotEmpty() {
        XCTAssertFalse(list.isEmpty)
    }
    
    func test_when_two_elements() {
        list = [1, 2]
        
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.count, 2)
        XCTAssertIdentical(list.head?.next, list.tail)
        XCTAssertIdentical(list.tail?.prev, list.head)
    }
    
    // MARK: - Subscript
    
    func test_subscript_by_node() {
        let node = weakNodes[4].value!
        
        XCTAssertEqual(list[node], 4)
    }
    
    func test_subscript_by_safe_index() {
        XCTAssertEqual(list[safe: 4], 4)
    }
    
    func test_subscript_by_safe_outOfIndex() {
        XCTAssertNil(list[safe: list.count + 100])
        XCTAssertNil(list[safe: -100])
    }
    
    func test_node_by_index() {
        XCTAssertIdentical(list.node(index: 4), weakNodes[4].value)
    }
    
    func test_node_by_index_outOfBounds() {
        XCTAssertNil(list.node(index: list.count + 100))
        XCTAssertNil(list.node(index: -100))
    }
    
    // MARK: - Add
    
    func test_pushFront() {
        list.pushFront(-1)
        list.pushFront(-2)
        list.pushFront(-3)
        
        XCTAssertEqual(list.toArray(), [-3, -2, -1] + sequence)
        XCTAssertEqual(list.count, 13)
    }
    
    func test_pushFront_when_empty() {
        list = .init()
        
        list.pushFront(3)
        list.pushFront(2)
        list.pushFront(1)
        
        XCTAssertEqual(list, [1, 2, 3])
        XCTAssertEqual(list.count, 3)
    }
    
    func test_append() {
        list.append(11)
        list.append(12)
        
        XCTAssertEqual(list.toArray(), sequence + [11, 12])
        XCTAssertEqual(list.count, 12)
    }
    
    func test_append_when_empty() {
        list = .init()
        
        list.append(2)
        list.append(3)
        list.append(4)
        
        XCTAssertEqual(list, [2, 3, 4])
        XCTAssertEqual(list.count, 3)
    }
    
    func test_append_other() {
        let otherList: List = [11, 12, 13]
        
        list.append(other: otherList)
        
        XCTAssertEqual(list.toArray(), sequence + [11, 12, 13])
        XCTAssertEqual(list.count, 13)
    }
    
    func test_append_empty() {
        let otherList: List = []
        
        list.append(other: otherList)
        
        XCTAssertEqual(list.toArray(), sequence)
        XCTAssertEqual(list.count, 10)
    }
    
    func test_append_other_when_original_isEmpty() {
        list = .init()
        let otherList: List = [1, 2, 3]
        
        list.append(other: otherList)
        
        XCTAssertEqual(list, [1, 2, 3])
    }
    
    func test_insert() {
        list = .init()
        
        list.append(1)
        list.append(3)
        list.append(4)
        list.insert(2, at: 1)
        if let secondPos = list?.head?.next {
            list?.insert(5, at: secondPos)
        }
        
        XCTAssertEqual(list, [1, 5, 2, 3, 4])
        XCTAssertEqual(list.count, 5)
    }
    
    func test_insert_by_index() {
        list = [1, 3]
        
        list.insert(2, at: 1)
        
        XCTAssertEqual(list, [1, 2, 3])
    }
    
    func test_insert_fail_when_outOfIndex() {
        list = [1, 3]
        
        let insertedNode = list.insert(2, at: 2)
        
        XCTAssertNil(insertedNode)
    }
    
    func test_insert_at_head() {
        let insertedNode = list.insert(-1, at: list.head)
        
        XCTAssertIdentical(insertedNode, list.head)
        XCTAssertEqual(list.toArray(), [-1] + sequence)
    }
    
    func test_insert_at_back() {
        let insertedNode = list.insert(11, at: nil)
        
        XCTAssertIdentical(insertedNode, list.tail)
        XCTAssertEqual(list.toArray(), sequence + [11])
    }
    
    func test_insert_head_when_empty() {
        list = .init()
        
        let insertedNode = list.insert(1, at: list.head)
        
        XCTAssertIdentical(insertedNode, list.head)
        XCTAssertIdentical(insertedNode, list.tail)
        XCTAssertEqual(list, [1])
    }
    
    func test_insert_tail_when_empty() {
        list = .init()
        
        let insertedNode = list.insert(1, at: list.tail)
        
        XCTAssertIdentical(insertedNode, list.head)
        XCTAssertIdentical(insertedNode, list.tail)
        XCTAssertEqual(list, [1])
    }
    
    func test_add() {
        list = .init()
        
        list.append(3)
        list.pushFront(2)
        list.append(4)
        list.append(5)
        list.pushFront(1)
        
        XCTAssertEqual(list, [1, 2, 3, 4, 5])
        XCTAssertEqual(list.count, 5)
    }
    
    // MARK: - Remove
    
    func test_popFront() {
        list.popFront()
        
        XCTAssertEqual(list.toArray(), Array(sequence.dropFirst()))
        XCTAssertEqual(list.count, 9)
    }
    
    func test_popFront_when_one_element() {
        list = [1]
        
        list.popFront()
        
        XCTAssertEqual(list, [])
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
    }
    
    func test_popFront_when_empty() {
        list = .init()
        
        list.popFront()
        
        XCTAssertEqual(list, [])
        XCTAssertEqual(list.count, 0)
    }
    
    func test_popLast() {
        list.popLast()
        
        XCTAssertEqual(list.toArray(), sequence.dropLast())
        XCTAssertEqual(list.count, 9)
    }
    
    func test_popLast_when_one_element() {
        list = [1]
        
        list.popLast()
        
        XCTAssertEqual(list, [])
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
    }
    
    func test_popLast_when_empty() {
        list = .init()
        
        list.popLast()
        
        XCTAssertEqual(list, [])
        XCTAssertEqual(list.count, 0)
    }
    
    func test_remove() {
        list.remove(weakNodes[4].value)
        
        XCTAssertNil(weakNodes[4].value)
        XCTAssertEqual(list.toArray(), sequence.filter { $0 != 4 })
        XCTAssertEqual(list.count, 9)
    }
    
    func test_remove_head() {
        list.remove(list.head!)
        
        XCTAssertEqual(list.toArray(), Array(sequence.dropFirst()))
        XCTAssertEqual(list.count, 9)
    }
    
    func test_remove_tail() {
        list.remove(list.tail!)
        
        XCTAssertEqual(list.toArray(), sequence.dropLast())
        XCTAssertEqual(list.count, 9)
    }
    
    func test_remove_when_one_element() {
        // given
        list = [1]
        
        guard let node = list.node(index: 0) else {
            XCTFail("invalid index access")
            return
        }
        
        // when
        list.remove(node)
        
        // then
        XCTAssertTrue(list.isEmpty)
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
    }
    
    func test_remove_by_index() {
        guard let node = list.node(index: 4) else {
            XCTFail("invalid index access")
            return
        }
        
        list.remove(node)
        
        addTeardownBlock { [weak self] in
            XCTAssertNil(self?.weakNodes[4].value)
        }
        XCTAssertEqual(list.toArray(), sequence.filter { $0 != 4 })
        XCTAssertEqual(list.count, 9)
    }
    
    func test_removeAll() {
        // given
        list = .init()
        
        list.append(1)
        list.append(3)
        list.append(4)
        list.insert(2, at: 1)
        if let secondPos = list?.head?.next {
            list?.insert(5, at: secondPos)
        }
        
        // when
        list.removeAll()
        
        // then
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
        XCTAssertEqual(list.count, 0)
        XCTAssertEqual(list, [])
    }
    
    func test_removeAll_and_check_all_nodes_deinit() {
        list.removeAll()
        
        for weakNode in weakNodes {
            XCTAssertNil(weakNode.value)
        }
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
        XCTAssertEqual(list.count, 0)
        XCTAssertEqual(list, [])
    }
    
    func test_remove_while_iterating() {
        var now = list.head
        
        while let node = now {
            if node.element % 2 == 0 {
                list.remove(node)
            }
            now = now?.next
        }
        
        XCTAssertEqual(list, [1, 3, 5, 7, 9])
    }
    
    // MARK: - Element Equatable
    
    func test_firstNode() {
        let element = 5
        let node = list.firstNode(of: element)
        
        XCTAssertEqual(node, weakNodes[5].value)
    }
    
    func test_firstNode_not_exist() {
        let notExsitElement = 100
        let node = list.firstNode(of: notExsitElement)
        
        XCTAssertNil(node)
    }
    
    func test_firstNode_when_empty() {
        list = .init()
        let notExsitElement = 1
        let node = list.firstNode(of: notExsitElement)
        
        XCTAssertNil(node)
    }
    
    func test_firstIndex() {
        let element = 5
        let index = list.firstIndex(of: element)
        
        XCTAssertEqual(index, 5)
    }
    
    func test_firstIndex_not_exist() {
        let notExsitElement = 100
        let index = list.firstIndex(of: notExsitElement)
        
        XCTAssertNil(index)
    }
    
    func test_firstIndex_when_empty() {
        list = .init()
        let notExsitElement = 1
        let index = list.firstIndex(of: notExsitElement)
        
        XCTAssertNil(index)
    }
    
    // MARK: - Equatable
    
    func test_LinkedList_Equatable() {
        let list2 = List(sequence)
        
        XCTAssertEqual(list, list2)
    }
    
    func test_not_Equatable() {
        let list2 = List(sequence.dropLast())
        
        XCTAssertNotEqual(list, list2)
    }
    
    // MARK: - Description
    
    func test_description() {
        list = .init()
        
        list.append(3)
        list.pushFront(2)
        list.append(4)
        list.append(5)
        list.pushFront(1)
        
        XCTAssertEqual(list.description, "[1, 2, 3, 4, 5]")
    }
    
    func test_empty_description() {
        list = .init()
        
        XCTAssertEqual(list.description, "[]")
    }
    
    func test_one_element_description() {
        list = [1]
        
        XCTAssertEqual(list.description, "[1]")
    }
}

// MARK: - Combination Scenario

extension LinkedListTests {
    
    func test_remove_and_add() {
        list = [1]
        
        list.popFront()
        
        XCTAssertEqual(list, [])
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
        
        list.append(3)
        XCTAssertEqual(list, [3])
        XCTAssertEqual(list.count, 1)
        XCTAssertIdentical(list.head, list.tail)
    }
}
