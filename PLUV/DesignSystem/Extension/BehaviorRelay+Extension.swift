//
//  BehaviorRelay+Extension.swift
//  PLUV
//
//  Created by jaegu park on 12/9/24.
//

import RxSwift
import RxCocoa

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func append(_ element: Element.Element) {
        var currentValue = self.value
        currentValue.append(element)
        self.accept(currentValue)
    }
    
    func append(contentsOf elements: [Element.Element]) {
        var currentValue = self.value
        currentValue.append(contentsOf: elements)
        self.accept(currentValue)
    }
}
