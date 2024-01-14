//
//  LinkedList.swift
//
//
//  Created by 강민석 on 2020/07/29.
//  Copyright © 2020 강민석. All rights reserved.
//

import Foundation

public final class LinkedList<Element> {
    
    public typealias Node = LinkedListNode<Element>
    
    private(set) var size: Int
    public private(set) var head: Node?
    public private(set) var tail: Node?
    
    // MARK: - Init
    
    public init () {
        self.size = 0
        self.head = nil
        self.tail = nil
    }
    
    deinit {
        print("\(Self.self) deinited")
    }
    
    // MARK: - Access
    
    public var first: Element? {
        return head?.element
    }
    
    public var last: Element? {
        return tail?.element
    }
    
    public var isEmpty: Bool {
        return size == 0
    }
    
    public var count: Int {
        return size
    }
    
    // MARK: - Subscript
    
    /// - Complexity: O(1)
    public subscript(node: Node) -> Element {
        return node.element
    }
    
    /// - Complexity: O(*k*), *k* is index parameter
    public subscript(safe index: Int) -> Element? {
        return node(index: index)?.element
    }
    
    /// - Complexity: O(*k*), *k* is index parameter
    func node(index: Int) -> Node? {
        guard index >= 0 else { return nil }
        var now = head
        for _ in 0..<index {
            now = now?.next
        }
        return now
    }
    
    // MARK: - Add
    
    public func pushFront(_ element: Element) {
        let node = Node(element: element)
        pushFront(node)
    }
    
    public func pushFront(_ node: Node) {
        node.prev = nil
        node.next = self.head
        node.next?.prev = node
        self.head = node
        if size == 0 {
            self.tail = node
        }
        self.size += 1
    }
    
    public func append(_ element: Element) {
        let node = Node(element: element)
        append(node)
    }
    
    public func append(_ node: Node) {
        node.next = nil
        node.prev = self.tail
        node.prev?.next = node
        self.tail = node
        if size == 0 {
            head = node
        }
        self.size += 1
    }
    
    public func append(other: LinkedList<Element>) {
        self.tail?.next = other.head
        other.head?.prev = self.tail
        self.tail = other.tail
        self.size += other.size
    }
    
    /// - Returns: insert된 위치 (nil 이면 insert 실패)
    @discardableResult
    public func insert(_ element: Element, at index: Int) -> Node? {
        guard let node = node(index: index) else { return nil }
        return insert(element, at: node)
    }
    
    /// - Returns: insert된 위치
    @discardableResult
    public func insert(_ element: Element, at node: Node?) -> Node {
        let newNode = Node(element: element)
        insert(newNode, at: node)
        return newNode
    }
    
    /// - Parameters:
    ///     - node : head면 pushFront, nil이면 append로 동작
    public func insert(_ newNode: Node, at node: Node?) {
        if node === head {
            pushFront(newNode)
        } else if node == nil {
            append(newNode)
        } else {
            let before = node?.prev
            let after = node
            
            newNode.prev = before
            newNode.next = after
            after?.prev = newNode
            before?.next = newNode
            self.size += 1
        }
    }
    
    // MARK: - Remove
    
    public func removeAll() {
        head = nil
        tail = nil
        size = 0
    }
    
    /// - Returns: 삭제된 Node의 다음 Node (만약 tail을 지웠다면 nil을 리턴)
    @discardableResult
    public func remove(_ node: Node) -> Node? {
        if isEmpty { return nil }
        if node === head {
            popFront()
            return head
        } else if node === tail {
            popLast()
            return nil
        }
        
        let before = node.prev
        let after = node.next
        
        before?.next = after
        after?.prev = before
        self.size -= 1
        return after
    }
    
    public func popFront() {
        if isEmpty { return }
        self.size -= 1
        self.head = self.head?.next
        
        if size == 0 {
            self.tail = nil
        } else {
            self.head?.prev = nil
        }
    }
    
    public func popLast() {
        if isEmpty { return }
        self.size -= 1
        self.tail = self.tail?.prev
        
        if size == 0 {
            self.head = nil
        } else {
            self.tail?.next = nil
        }
    }

}

// MARK: - Equatable

extension LinkedList where Element: Equatable {
    
    /// - Complexity: O(n)
    public func firstNode(of element: Element) -> Node? {
        return first(of: element)?.node
    }
    
    /// - Complexity: O(n)
    public func firstIndex(of element: Element) -> Int? {
        return first(of: element)?.index
    }
    
    /// - Complexity: O(n)
    private func first(of element: Element) -> (index: Int, node: Node)? {
        var index = 0
        var now = head
        while let node = now {
            if node.element == element {
                return (index, node)
            }
            now = node.next
            index += 1
        }
        return nil
    }
}

extension LinkedList: Equatable where Element: Equatable {
    
    public static func == (lhs: LinkedList<Element>, rhs: LinkedList<Element>) -> Bool {
        guard lhs.count == rhs.count else {
            return false
        }
        return zip(lhs, rhs).allSatisfy { $0 == $1 }
    }
}

// MARK: - Description

extension LinkedList: CustomStringConvertible {
    
    public var description: String {
        var str = "["
        var now = head
        while let node = now {
            str += "\(node.element)"
            now = node.next
            
            if now != nil { str += ", "}
        }
        return str + "]"
    }
}
