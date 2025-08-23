//
//  OverlayDropdownList.swift
//  SafeVision
//
//  Created by Nike on 8/23/25.
//

import SwiftUI

struct OverlayDropdownList: View {
    let options: [DetectConditionType]
    let onSelect: (DetectConditionType) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(options, id: \.id) { option in
                    Button {
                        onSelect(option)
                    } label: {
                        HStack {
                            Text(option.rawValue)
                                .foregroundColor(.white)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 16)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if option.id != options.last?.id {
                        Rectangle().fill(Color.white.opacity(0.08)).frame(height: 1)
                    }
                }
            }
        }
    }
}
