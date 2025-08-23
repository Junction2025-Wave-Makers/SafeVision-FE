//
//  DetectCondition.swift
//  SafeVision
//
//  Created by Nike on 8/23/25.
//

import Foundation

enum DetectConditionType: String, CaseIterable, Identifiable, Codable {
    case fall = "Fall"
    case collision = "Collision"
    case density = "Density"
    case restricted = "RestrictedArea"
    case undefined = "Undefined"
    
    var id: String { rawValue }
}

extension DetectConditionType: CustomStringConvertible {
    var description: String { rawValue }
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
