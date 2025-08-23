//
//  DetectConditionSheet.swift
//  SafeVision
//
//  Created by Nike on 8/23/25.
//

import SwiftUI

struct DetectConditionSheet: View {
    @ObservedObject var vm: DetectConditionViewModel
    var onClose: () -> Void

    @State private var mode: Mode = .list
    @State private var editingDraft: DetectCondition? = nil

    private enum Mode { case list, form }

    var body: some View {
        NavigationStack {
            HStack{
                Text("Alerts Settings")
                    .font(.system(size: 22, weight: .medium))
                Spacer()
                Button(action: { onClose() }) {
                    Image(systemName: "xmark")
                }
                .foregroundColor(.black)
            }

            // Content container: fixed frame, no layout jump
            ZStack(alignment: .topLeading) {
                // LIST MODE
                VStack(spacing: 0) {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(vm.conditions) { cond in
                                ZStack(alignment: .topTrailing) {
                                    Button {
                                        editingDraft = cond
                                        mode = .form
                                    } label: {
                                        ConditionCardView(cond: cond)
                                    }
                                    .buttonStyle(.plain)

                                    VStack{
                                        Spacer()
                                        Button(action: {
                                            vm.delete(id: cond.id)
                                        }) {
                                            Image(systemName: "minus.circle")
                                                .foregroundColor(.gray)
                                                .padding()
                                        }
                                        .buttonStyle(.plain)
                                        Spacer()
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    
                    // Add Setting button should only appear with list
                    HStack{
                        Spacer()
                        Button {
                            editingDraft = DetectCondition(type: .fall, description: "", rate: 3)
                            mode = .form
                        } label: {
                            Label("Add Setting", systemImage: "plus")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 28.5)
                                .padding(.vertical, 16)
                                .background(Color(hex: "#0E0E0E"))
                                .cornerRadius(8)
                        }
                        .padding(.top, 8)
                    }
                }
                .opacity(mode == .list ? 1 : 0)

                // FORM MODE
                Group {
                    if let draft = editingDraft {
                        DetectConditionFormInline(
                            draft: draft,
                            onCancel: {
                                mode = .list
                                editingDraft = nil
                            },
                            onSave: { saved in
                                vm.insert(saved)
                                mode = .list
                                editingDraft = nil
                            }
                        )
                    }
                }
                .opacity(mode == .form ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .transaction { $0.animation = nil } // prevent implicit layout animations
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: { onClose() }) {
                    Label("닫기", systemImage: "xmark")
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
    }
}

private struct ConditionCardView: View {
    let cond: DetectCondition

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text(cond.type.rawValue)
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .regular))
                Text("\(cond.rate >= 4 ? "Critical" : cond.rate == 3 ? "High" : cond.rate == 2 ? "Medium" : "Low")")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(
                        cond.rate >= 4 ? Color(hex: "#F94C4C") :
                        cond.rate == 3 ? Color(hex: "#FF9945") :
                        cond.rate == 2 ? Color(hex: "#FFD651") :
                        cond.rate == 1 ? Color(hex: "#5AEE7F") : .gray
                    )
                Spacer()
            }
            Text(cond.description)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "#EAECF4"))
        )
    }
}

private struct DetectConditionFormInline: View {
    @Environment(\.dismiss) private var dismiss

    @State var draft: DetectCondition
    var onCancel: () -> Void
    var onSave: (DetectCondition) -> Void

    @StateObject private var dropdownVM = DropdownOverlayViewModel()
    @State private var typeFieldWidth: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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

            // Risk Level cards
            VStack {
                HStack { Text("Risk Level"); Spacer() }
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
            
            // Save Button
            HStack{
                Spacer()
                Button("Save") { onSave(draft) }
                    .buttonStyle(.bordered)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .background(Color.gray)
            }
        }
        .padding(.top, 8)
        // Overlay dropdown bar
        .overlay(alignment: .topLeading) {
            if dropdownVM.isOpen {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture { dropdownVM.close() }
                    .zIndex(998)

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
    return DetectConditionSheet(vm: vm, onClose: {})
}
