//
//  Color+.swift
//  cokcok
//
//  Created by 최지웅 on 11/23/23.
//

import SwiftUI

extension Color {
    static let bronze = Color.brown
    static let silver = Color.gray
    static let gold = Color.yellow
    static let emerald = Color(UIColor(red: 0.31, green: 0.78, blue: 0.47, alpha: 1.00))
    static let diamond = Color(UIColor(red: 0.60, green: 0.75, blue: 1.00, alpha: 1.00))
    
    init(_ hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        self.init(
            .sRGB,
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0)
    }
}

