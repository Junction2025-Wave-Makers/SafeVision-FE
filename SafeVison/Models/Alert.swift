//
//  Alert.swift
//  SafeVision
//
//  Created by KimDogyung on 8/24/25.
//


import Foundation

// Alert 모델 (200 응답용)
struct Alert: Codable, Identifiable {
    let id: String // response의 alertId에 해당
    let ruleId: String
    let ruleType: String
    let tsMs: Int
    let summary: String
    let detail: [String: String] 
    let createdAt: String
    let videoId: String
    let frameNumber: Int
    let severity: String
    let status: String
    let processedAt: String
    let videoClipPath: String

    // JSON 키와 Swift 속성 이름이 다른 경우 매핑
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
    static var mocks: [Alert] {
        [
            Alert(
                id: UUID().uuidString,
                ruleId: "RULE-001",
                ruleType: "distance_below",
                tsMs: 1724479920000,
                summary: "Person-Machine Distance < 1.5m",
                detail: ["additionalProp1": ""],
                createdAt: "2025-08-23T14:32:00Z",
                videoId: "cctv1-id",
                frameNumber: 520,
                severity: "high",
                status: "unprocessed",
                processedAt: "",
                videoClipPath: "cctv1.mp4"
            ),
            Alert(
                id: UUID().uuidString,
                ruleId: "RULE-002",
                ruleType: "zone_breach",
                tsMs: 1724477820000,
                summary: "Worker entered restricted zone",
                detail: ["additionalProp1": ""],
                createdAt: "2025-08-23T13:57:00Z",
                videoId: "cctv2-id",
                frameNumber: 875,
                severity: "critical",
                status: "in_progress",
                processedAt: "",
                videoClipPath: "cctv2.mp4"
            ),
            Alert(
                id: UUID().uuidString,
                ruleId: "RULE-003",
                ruleType: "distance_below",
                tsMs: 1724473500000,
                summary: "Person-Machine Distance < 10m",
                detail: ["additionalProp1": ""],
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
                detail: ["additionalProp1": ""],
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
                detail: ["additionalProp1": ""],
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
