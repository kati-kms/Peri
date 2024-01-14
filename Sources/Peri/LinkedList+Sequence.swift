//
//  LinkedList+Sequence.swift
//  
//
//  Created by 강민석 on 2024/01/13.
//

import Foundation

extension LinkedList: Sequence {
    
    public func makeIterator() -> LinkedListIterator<Element> {
        return LinkedListIterator(start: self.head)
    }
}

public struct LinkedListIterator<Element>: IteratorProtocol {
    
    public typealias List = LinkedList<Element>
    public typealias Node = LinkedListNode<Element>
    
    private var now: Node?
    
    public init(start: Node?) {
        self.now = start
    }
    
    public mutating func next() -> Element? {
        return next(1)
    }
    
    public mutating func next(_ count: Int = 1) -> Element? {
        let element = now?.element
        
        for _ in (0..<count) {
            now = now?.next
        }
        return element
    }
}
