//
//  Alert.swift
//  SafeVision
//
//  Created by KimDogyung on 8/23/25.
//

import Foundation

struct Alert: Identifiable, Codable {
    var id: String
    var title: String
    var date: String
    var dangerLevel: String
    var status: String
}
