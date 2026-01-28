import SwiftUI

struct ZStackPlayground: View {
    @State private var alignment = AlignmentOption.center
    @State private var itemCount = 3
    @State private var offsetAmount: Double = 20

    enum AlignmentOption: String, CaseIterable {
        case topLeading = "Top Leading"
        case top = "Top"
        case topTrailing = "Top Trailing"
        case leading = "Leading"
        case center = "Center"
        case trailing = "Trailing"
        case bottomLeading = "Bottom Leading"
        case bottom = "Bottom"
        case bottomTrailing = "Bottom Trailing"

        var alignment: Alignment {
            switch self {
            case .topLeading: .topLeading
            case .top: .top
            case .topTrailing: .topTrailing
            case .leading: .leading
            case .center: .center
            case .trailing: .trailing
            case .bottomLeading: .bottomLeading
            case .bottom: .bottom
            case .bottomTrailing: .bottomTrailing
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "ZStack",
            description: "A view that overlays its subviews, aligning them in both axes.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        ZStack(alignment: alignment.alignment) {
            ForEach(0..<itemCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 12)
                    .fill(colors[index % colors.count].opacity(0.8))
                    .frame(
                        width: CGFloat(150 - index * 30),
                        height: CGFloat(150 - index * 30)
                    )
                    .offset(
                        x: CGFloat(index) * offsetAmount,
                        y: CGFloat(index) * offsetAmount
                    )
            }
        }
        .frame(width: 250, height: 250)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private let colors: [Color] = [.blue, .green, .orange, .purple, .pink]

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ParameterControl(label: "Alignment") {
                Picker("Alignment", selection: $alignment) {
                    ForEach(AlignmentOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.menu)
            }

            SliderControl(
                label: "Items",
                value: Binding(get: { Double(itemCount) }, set: { itemCount = Int($0) }),
                range: 1...5,
                step: 1,
                format: "%.0f"
            )

            SliderControl(
                label: "Offset",
                value: $offsetAmount,
                range: 0...40,
                format: "%.0f"
            )
        }
    }

    private var generatedCode: String {
        var code = "ZStack("

        if alignment != .center {
            code += "alignment: .\(alignment.rawValue.replacingOccurrences(of: " ", with: "").lowercased().prefix(1).lowercased() + alignment.rawValue.replacingOccurrences(of: " ", with: "").dropFirst())"
        }

        code += ") {\n"

        for i in 0..<itemCount {
            code += "    // Layer \(i + 1)\n"
            code += "    RoundedRectangle(cornerRadius: 12)\n"
            code += "        .fill(Color.\(["blue", "green", "orange", "purple", "pink"][i % 5]))\n"
            code += "        .frame(width: \(150 - i * 30), height: \(150 - i * 30))\n"
        }

        code += "}"

        return code
    }
}

#Preview {
    NavigationStack {
        ZStackPlayground()
    }
}
