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
    
    var id: String { rawValue }
}

extension DetectConditionType: CustomStringConvertible {
    var description: String { rawValue }
}

struct DetectCondition: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var type: DetectConditionType
    var description: String
    var rate: Int
    var durationSec: Int
    
}


enum ServerRuleType: String, CaseIterable, Codable {
    case distance_below
    case zone_entry
    case speed_over
    case crowd_in_zone
    case line_cross
    case approaching
    case collision_risk
    case fall_detection
}

// MARK: [NEW] 클라이언트 DetectConditionType → 서버 ServerRuleType 매핑
extension DetectConditionType {
    /// 서버에 보낼 type으로 매핑
    var serverRuleType: ServerRuleType? {
        switch self {
        case .fall:       return .fall_detection
        case .collision:  return .collision_risk
        case .density:    return .crowd_in_zone
        case .restricted: return .zone_entry
        }
    }
}
