//
//  InterFontExtension.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/29/24.
//

import Foundation
import SwiftUI

extension Font {
    enum InterWeight {
        case regular
        case medium
        case semibold
        case bold
        
        var associatedFont: String {
            switch self {
            case .regular:
                return "Inter-Regular"
            case .medium:
                return "Inter-Medium"
            case .semibold:
                return "Inter-SemiBold"
            case .bold:
                return "Inter-Bold"
            }
        }
    }
    
    static func inter(_ weight: InterWeight = .regular, size: CGFloat = 16) -> Font {
        return .custom(weight.associatedFont, size: size)
    }
}

