//
//  LinkedListNode.swift
//  
//
//  Created by 강민석 on 2024/01/13.
//

import Foundation

public final class LinkedListNode<Element> {
    
    public typealias Node = LinkedListNode<Element>
    
    public var element: Element
    public var next: Node?
    public weak var prev: Node?
    
    public init(element: Element) {
        self.element = element
        self.next = nil
        self.prev = nil
    }
    
    deinit {
        print("\(Self.self) deinit : \(element)")
    }
    
    /// - Complexity: O(*k*), *k* is index parameter
    public func offset(by index: Int) -> Node? {
        weak var now = self
        if index > 0 {
            for _ in 0..<index {
                now = now?.next
            }
        } else {
            for _ in 0..<(-index) {
                now = now?.prev
            }
        }
        return now
    }
}

extension LinkedListNode: Equatable where Element: Equatable {
    
    public static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.element == rhs.element
    }
}
