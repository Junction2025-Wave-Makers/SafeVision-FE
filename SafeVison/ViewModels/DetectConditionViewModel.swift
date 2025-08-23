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
    @Published var conditions: [DetectCondition] = [
            DetectCondition(type: .fall,
                            description: "카메라 프레임 내 사람이 급격히 수직 낙하",
                            rate: 4),
            DetectCondition(type: .collision,
                            description: "두 객체의 이동 벡터가 수렴(상호 충돌 위험)",
                            rate: 2),
            DetectCondition(type: .density,
                            description: "ROI 내 인원 밀집도 임계치 초과(> 6명/㎡)",
                            rate: 1),
            DetectCondition(type: .restricted,
                            description: "출입금지 구역 경계선 침범",
                            rate: 2),
            DetectCondition(type: .undefined,
                            description: "모델이 분류하지 못한 이상 패턴",
                            rate: 3),

            DetectCondition(type: .fall,
                            description: "낙상 후 3초 이상 움직임 없음",
                            rate: 4),
            DetectCondition(type: .collision,
                            description: "차량-보행자 근접 거리 < 0.5m",
                            rate: 3),
            DetectCondition(type: .density,
                            description: "대피구 통로 정체 감지",
                            rate: 1),
            DetectCondition(type: .restricted,
                            description: "야간 시간대 공사장 무단 출입",
                            rate: 2)
    ]
    
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
