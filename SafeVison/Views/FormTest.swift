import SwiftUI

struct FormTest: View {
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

                // Risk Level (원하는 UI로 추가)
                VStack {
                    HStack { Text("Risk Level"); Spacer() }
                    Stepper(value: $draft.rate, in: 1...4) {
                        Text("\(draft.rate)").monospaced()
                    }
                }

                HStack {
                    Spacer()
                    Button("Save") {
                        onSave(draft)
                        dismiss()
                    }
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
        .navigationTitle("Detect Condition")
    }
}

#Preview(traits: .landscapeLeft) {
    FormTest()
}
