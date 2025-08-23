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

    @State var draft: DetectCondition = DetectCondition(type: .fall, description: "", rate: 2)
    var onSave: (DetectCondition) -> Void = { _ in }

    @StateObject private var dropdownVM = DropdownOverlayViewModel()
    @State private var typeFieldWidth: CGFloat = 0

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 16) {
                // Type
                VStack {
                    HStack { Text("Type"); Spacer() }
                    DropdownField(
                        title: "Type",
                        displayText: draft.type.rawValue
                    ) { anchor in
                        typeFieldWidth = anchor.width
                        dropdownVM.open(anchor: anchor, options: DetectConditionType.allCases)
                    }
                    .frame(maxWidth: 360)
                }

                // Description
                VStack {
                    HStack { Text("Description"); Spacer() }
                    TextField("ex. 3 people in room 3", text: $draft.description, axis: .vertical)
                        .lineLimit(2...4)
                        .textFieldStyle(.roundedBorder)
                }

                VStack {
                    HStack { Text("Risk Level"); Spacer() }
                        // 가로 4개 배치 (이미지와 동일)
                        HStack(spacing: 16) {
                            ForEach(DangerLevel.allCases) { level in
                                DangerLevelOptionCard(
                                    level: level,
                                    isSelected: draft.rate == level.rawValue,
                                    onTap: { draft.rate = level.rawValue }
                                )
                            }
                        }
                    
                }

                HStack {
                    Spacer()
                    Button("Save") {
                        onSave(draft)
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .background(Color.gray)
                }
            }

            if dropdownVM.isOpen {
                // 바깥 탭 → 닫기
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture { dropdownVM.close() }
                    .zIndex(998)

                // 드롭다운 바 (다른 뷰는 그대로)
                OverlayDropBar(isOpen: dropdownVM.isOpen, maxHeight: 280) {
                    OverlayDropdownList(
                        options: dropdownVM.options,
                        onSelect: { sel in
                            draft.type = sel
                            dropdownVM.close()
                        }
                    )
                }
                .frame(width: typeFieldWidth)
                .offset(x: dropdownVM.anchor.minX, y: dropdownVM.anchor.maxY + 6)
                .zIndex(999)
            }
        }
        .coordinateSpace(name: "container")
    }
}


#Preview(traits: .landscapeLeft) {
    let vm = DetectConditionViewModel()
    return DetectConditionSheet(vm: vm)
}
