//
//  Alert.swift
//  SafeVision
//
//  Created by KimDogyung on 8/23/25.
//

import Foundation

struct MockAlert: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var date: String
    var dangerLevel: String
    var status: String
    var videoUrl: String
}


extension MockAlert {
    
    static var mock: MockAlert {
        MockAlert(
            id: UUID().uuidString,
            title: "Person-Machine Distance < 1.5m",
            date: "2025-08-23 14:32",
            dangerLevel: "high",
            status: "Unconfirmed",
            videoUrl: "cctv1.mp4"
        )
    }
    
    static var mocks: [MockAlert] {
        [
            MockAlert(
                id: UUID().uuidString,
                title: "Person-Machine Distance < 1.5m",
                date: "2025-08-23 14:32",
                dangerLevel: "high",
                status: "Unconfirmed",
                videoUrl: "cctv1.mp4"
            ),
            MockAlert(
                id: UUID().uuidString,
                title: "Worker entered restricted zone",
                date: "2025-08-23 13:57",
                dangerLevel: "critical",
                status: "In Progress",
                videoUrl: "cctv2.mp4"
            ),
            MockAlert(
                id: UUID().uuidString,
                title: "Person-Machine Distance < 10m",
                date: "2025-08-23 12:45",
                dangerLevel: "low",
                status: "Resolved",
                videoUrl: "cctv3.mp4"
            ),
            MockAlert(
                id: UUID().uuidString,
                title: "Unauthorized entry detected",
                date: "2025-08-23 11:28",
                dangerLevel: "medium",
                status: "Resolved",
                videoUrl: "cctv4.mp4"
            ),
            MockAlert(
                id: UUID().uuidString,
                title: "Worker standing near moving equipment",
                date: "2025-08-23 10:16",
                dangerLevel: "high",
                status: "Resolved",
                videoUrl: "cctv1.mp4"
            )
        ]
    }
}
