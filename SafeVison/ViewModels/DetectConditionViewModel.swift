//
//  DetectConditionViewModel.swift
//  SafeVision
//
//  Created by Nike on 8/23/25.
//

import Foundation
import SwiftUI

@MainActor
final class DetectConditionViewModel: ObservableObject {
    @Published var conditions: [DetectCondition] = []
    
    func insert(_ condition: DetectCondition) {
        if let idx = conditions.firstIndex(where: { $0.id == condition.id }) {
            conditions[idx] = condition
        } else {
            conditions.append(condition)
        }
    }
    
    func delete(at offsets: IndexSet) {
        conditions.remove(atOffsets: offsets)
    }
    
    func delete(id: UUID) {
        conditions.removeAll { $0.id == id }
    }
}
