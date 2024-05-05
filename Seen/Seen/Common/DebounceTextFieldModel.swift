//
//  DebounceTextFieldModel.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/29/24.
//

import Foundation
import Combine

class DebounceTextFieldModel: ObservableObject {
    @Published var debouncedText = ""
    @Published var inputText = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $inputText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] dt in
                self?.debouncedText = dt
            }
            .store(in: &subscriptions)
    }
}
