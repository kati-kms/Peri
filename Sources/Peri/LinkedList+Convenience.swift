//
//  LinkedList+Convenience.swift
//  
//
//  Created by 강민석 on 2024/01/13.
//

extension LinkedList: ExpressibleByArrayLiteral {
    
    public convenience init(arrayLiteral elements: Element...) {
        self.init()
        
        elements.forEach { append($0) }
    }
}

extension LinkedList {
    
    public func toArray() -> [Element] {
        var elements = [Element]()
        var now = head
        while let node = now {
            elements.append(node.element)
            now = now?.next
        }
        return elements
    }
    
    public convenience init(_ collection: some Collection<Element>) {
        self.init()
        
        collection.forEach { append($0) }
    }
}
