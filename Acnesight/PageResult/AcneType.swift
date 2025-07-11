//
//  ResultInfo.swift
//  Acnesight
//
//  Created by Vira Fitriyani on 16/06/25.
//

import SwiftUI

struct BoundingBox: Identifiable {
    let id = UUID()
    let label: String
    let confidence: Float
    let rect: CGRect
    
    var type: AcneType? {
        AcneType(rawValue: label.capitalized)
    }
}

enum AcneType: String, CaseIterable, Identifiable {
    case blackhead = "Blackhead"
    case whitehead = "Whitehead"
    case papule = "Papule"
    case pustule = "Pustule"
    case nodule = "Nodule"
    
    var id: String { rawValue }
    
    var shortDescription: String {
        switch self {
        case .blackhead:
            return "Bk"
        case .whitehead:
            return "Wh"
        case .papule:
            return "Pa"
        case .pustule:
            return "Pu"
        case .nodule:
            return "Nd"
        }
    }
    
    var color: Color {
        switch self {
        case .blackhead:
            return .orange
        case .whitehead:
            return .blue
        case .papule:
            return .green
        case .pustule:
            return .purple
        case .nodule:
            return .red
        }
    }
}
