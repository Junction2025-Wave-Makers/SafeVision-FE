//
//  DetectConditionSheet.swift
//  SafeVision
//
//  Created by Nike on 8/23/25.
//

import SwiftUI

struct DetectConditionSheet: View {
    @ObservedObject var vm: DetectConditionViewModel
    @Environment(\.dismiss) private var dismiss

    enum Route: Hashable {
        case add
        case edit(UUID) // DetectCondition.id
    }

    var body: some View {
        NavigationStack {
            HStack{
                Text("Alerts Settings")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                }
                .foregroundColor(.black)
            }
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(vm.conditions) { cond in
                        ZStack(alignment: .topTrailing) {
                            NavigationLink(value: Route.edit(cond.id)) {
                                ConditionCardView(cond: cond)
                            }

                            Button(action: {
                                vm.delete(id: cond.id)
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .add:
                    DetectConditionFormView(
                        draft: DetectCondition(type: .fall, description: "", rate: 3),
                        onSave: { saved in
                            vm.insert(saved)
                        }
                    )
                case .edit(let id):
                    if let cond = vm.conditions.first(where: { $0.id == id }) {
                        DetectConditionFormView(
                            draft: cond,
                            onSave: { saved in
                                vm.insert(saved)
                            }
                        )
                    } else {
                        Text("선택한 조건을 찾을 수 없습니다.")
                    }
                }
            }
            
            NavigationLink(value: Route.add) {
                Label("Add Setting", systemImage: "plus")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                    )
            }
                
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: { dismiss() }) {
                    Label("닫기", systemImage: "xmark")
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 10)
    }
}

private struct ConditionCardView: View {
    let cond: DetectCondition

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text(cond.type.rawValue)
                    .foregroundColor(.black)
                Text("\(cond.rate >= 4 ? "Critical" : cond.rate == 3 ? "High" : cond.rate == 2 ? "Medium" : "Low")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
            Text(cond.description)
                .font(.callout)
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3))
        )
    }
}

struct DetectConditionFormView: View {
    @Environment(\.dismiss) private var dismiss

    @State var draft: DetectCondition
    let onSave: (DetectCondition) -> Void

    var body: some View {
        Form {
            Section("Type") {
                Picker("",selection: $draft.type) {
                    ForEach(DetectConditionType.allCases) { t in
                        Text(t.rawValue).tag(t)
                    }
                }
                .pickerStyle(.menu)
                .foregroundColor(.gray)
            }
            
            Section("Description") {
                TextField("ex. 3 people in room 3",
                          text: $draft.description,
                          axis: .vertical)
                    .lineLimit(2...4)
            }
            
            Section("Risk Level") {
                Stepper(value: $draft.rate, in: 1...4) {
                    HStack {
                        Text("\(draft.rate)")
                            .monospaced()
                    }
                }
            }
        }
        .navigationTitle("Detect Condition")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("취소") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("저장") {
                    onSave(draft)
                    dismiss()
                }
                .disabled(draft.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
}

#Preview(traits: .landscapeLeft) {
    let vm = DetectConditionViewModel()
    return DetectConditionSheet(vm: vm)
}
