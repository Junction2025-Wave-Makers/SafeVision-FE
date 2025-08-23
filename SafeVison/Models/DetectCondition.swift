//
//  DetectCondition.swift
//  SafeVision
//
//  Created by Nike on 8/23/25.
//

import Foundation

enum DetectConditionType: String, CaseIterable, Identifiable, Codable {
    case fall = "fall"
    case collision = "collision"
    case density = "density"
    case restricted = "restrictedArea"
    case unknown = "unknown"
    
    var id: String { rawValue }
}

struct DetectCondition: Identifiable, Codable, Equatable {
    let id: UUID
    var type: DetectConditionType
    var description: String
    var rate: Int
    
    init(id: UUID = UUID(),
        type: DetectConditionType,
        description: String,
        rate: Int) {
            self.id = id
            self.type = type
            self.description = description
            self.rate = rate
        }
}
