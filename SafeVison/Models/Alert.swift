//
//  Alert.swift
//  SafeVision
//
//  Created by KimDogyung on 8/24/25.
//


import Foundation

struct Violation: Codable, Hashable {
    let position: [Double]
    let entityId: String
    let timestamp: String
    let videoId: String
    let objects: [String]
    let distance: Double
    let minDistance: Int
    let collisionRisk: Bool
    
    enum CodingKeys: String, CodingKey {
        case position
        case entityId = "entity_id"
        case timestamp
        case videoId = "video_id"
        case objects
        case distance
        case minDistance = "min_distance"
        case collisionRisk = "collision_risk"
    }
}

// ✅ 서버 응답 'detail' 속성의 실제 구조에 맞게 수정
struct AlertDetail: Codable, Hashable {
    let ruleId: String
    let ruleType: String
    let violations: [Violation]
    let summary: String
    
    enum CodingKeys: String, CodingKey {
        case ruleId = "rule_id"
        case ruleType = "rule_type"
        case violations
        case summary
    }
}

// Alert 모델 (200 응답용)
struct Alert: Codable, Identifiable, Hashable {
    let id: String
    let ruleId: String
    let ruleType: String
    let tsMs: Int
    let summary: String
    // ✅ detail 속성 타입을 새로운 AlertDetail 모델로 변경
    let detail: AlertDetail
    let createdAt: String
    let videoId: String
    let frameNumber: Int
    let severity: String
    let status: String
    // ✅ processedAt 속성을 옵셔널(Optional) String으로 변경 (null 값 처리)
    let processedAt: String?
    let videoClipPath: String
    
    enum CodingKeys: String, CodingKey {
        case id = "alertId"
        case ruleId = "rule_id"
        case ruleType = "rule_type"
        case tsMs = "ts_ms"
        case summary
        case detail
        case createdAt = "created_at"
        case videoId = "video_id"
        case frameNumber = "frame_number"
        case severity
        case status
        case processedAt = "processed_at"
        case videoClipPath = "video_clip_path"
    }
}



extension Alert {
    
    var formattedCreatedAt: String {
        return DateFormatterUtility.formatToDisplayTime(from: createdAt)
    }
    
    
    var capitalizedSeverity: String {
        return severity.capitalized
    }
    
    /// status의 첫 글자를 대문자로 변환하고 언더스코어를 공백으로 변환
    /// ("in_progress" → "In Progress", "unprocessed" → "Unprocessed")
    var formattedStatus: String {
        return status.replacingOccurrences(of: "_", with: " ").capitalized
    }
    
    static var mocks: [Alert] {
        [
            Alert(
                id: UUID().uuidString,
                ruleId: "RULE-001",
                ruleType: "distance_below",
                tsMs: 1724479920000,
                summary: "Person-Machine Distance < 1.5m",
                // ✅ detail과 violations의 실제 구조에 맞게 수정
                detail: AlertDetail(
                    ruleId: "RULE-001",
                    ruleType: "distance_below",
                    violations: [
                        Violation(
                            position: [123.4, 567.8],
                            entityId: "person_0",
                            timestamp: "2025-08-23T14:32:00Z",
                            videoId: "cctv1-id",
                            objects: ["person", "machine"],
                            distance: 1.2,
                            minDistance: 150,
                            collisionRisk: true
                        )
                    ],
                    summary: "Person-Machine Distance < 1.5m"
                ),
                createdAt: "2025-08-23T14:32:00Z",
                videoId: "cctv1-id",
                frameNumber: 520,
                severity: "high",
                status: "unprocessed",
                // ✅ processedAt이 null일 수 있으므로 nil로 설정
                processedAt: nil,
                videoClipPath: "cctv1.mp4"
            ),
            Alert(
                id: UUID().uuidString,
                ruleId: "RULE-002",
                ruleType: "zone_breach",
                tsMs: 1724477820000,
                summary: "Worker entered restricted zone",
                detail: AlertDetail(
                    ruleId: "RULE-002",
                    ruleType: "zone_breach",
                    violations: [
                        Violation(
                            position: [345.1, 789.2],
                            entityId: "worker_1",
                            timestamp: "2025-08-23T13:57:00Z",
                            videoId: "cctv2-id",
                            objects: ["worker", "zone"],
                            distance: 0.0,
                            minDistance: 0,
                            collisionRisk: true
                        )
                    ],
                    summary: "Worker entered restricted zone"
                ),
                createdAt: "2025-08-23T13:57:00Z",
                videoId: "cctv2-id",
                frameNumber: 875,
                severity: "critical",
                status: "in_progress",
                processedAt: nil,
                videoClipPath: "cctv2.mp4"
            ),
            Alert(
                id: UUID().uuidString,
                ruleId: "RULE-003",
                ruleType: "distance_below",
                tsMs: 1724473500000,
                summary: "Person-Machine Distance < 10m",
                detail: AlertDetail(
                    ruleId: "RULE-003",
                    ruleType: "distance_below",
                    violations: [
                        Violation(
                            position: [987.6, 543.2],
                            entityId: "person_2",
                            timestamp: "2025-08-23T12:45:00Z",
                            videoId: "cctv3-id",
                            objects: ["person", "equipment"],
                            distance: 8.5,
                            minDistance: 10,
                            collisionRisk: false
                        )
                    ],
                    summary: "Person-Machine Distance < 10m"
                ),
                createdAt: "2025-08-23T12:45:00Z",
                videoId: "cctv3-id",
                frameNumber: 240,
                severity: "low",
                status: "resolved",
                processedAt: "2025-08-23T12:48:00Z",
                videoClipPath: "cctv3.mp4"
            ),
            Alert(
                id: UUID().uuidString,
                ruleId: "RULE-004",
                ruleType: "unauthorized_entry",
                tsMs: 1724469080000,
                summary: "Unauthorized entry detected",
                detail: AlertDetail(
                    ruleId: "RULE-004",
                    ruleType: "unauthorized_entry",
                    violations: [
                        Violation(
                            position: [111.1, 222.2],
                            entityId: "intruder_3",
                            timestamp: "2025-08-23T11:28:00Z",
                            videoId: "cctv4-id",
                            objects: ["intruder", "zone"],
                            distance: 0.0,
                            minDistance: 0,
                            collisionRisk: true
                        )
                    ],
                    summary: "Unauthorized entry detected"
                ),
                createdAt: "2025-08-23T11:28:00Z",
                videoId: "cctv4-id",
                frameNumber: 155,
                severity: "medium",
                status: "resolved",
                processedAt: "2025-08-23T11:32:00Z",
                videoClipPath: "cctv4.mp4"
            ),
            Alert(
                id: UUID().uuidString,
                ruleId: "RULE-001",
                ruleType: "distance_below",
                tsMs: 1724464560000,
                summary: "Worker standing near moving equipment",
                detail: AlertDetail(
                    ruleId: "RULE-001",
                    ruleType: "distance_below",
                    violations: [
                        Violation(
                            position: [333.3, 444.4],
                            entityId: "worker_4",
                            timestamp: "2025-08-23T10:16:00Z",
                            videoId: "cctv1-id",
                            objects: ["worker", "equipment"],
                            distance: 2.1,
                            minDistance: 5,
                            collisionRisk: false
                        )
                    ],
                    summary: "Worker standing near moving equipment"
                ),
                createdAt: "2025-08-23T10:16:00Z",
                videoId: "cctv1-id",
                frameNumber: 990,
                severity: "high",
                status: "resolved",
                processedAt: "2025-08-23T10:18:00Z",
                videoClipPath: "cctv1.mp4"
            )
        ]
    }
}
