import SwiftUI

struct VStackPlayground: View {
    @State private var alignment = HorizontalAlignmentOption.center
    @State private var spacing: Double = 10
    @State private var itemCount = 3

    enum HorizontalAlignmentOption: String, CaseIterable {
        case leading = "Leading"
        case center = "Center"
        case trailing = "Trailing"

        var alignment: HorizontalAlignment {
            switch self {
            case .leading: .leading
            case .center: .center
            case .trailing: .trailing
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "VStack",
            description: "A view that arranges its subviews in a vertical line.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/vstack")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(alignment: alignment.alignment, spacing: spacing) {
            ForEach(0..<itemCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 8)
                    .fill(colors[index % colors.count])
                    .frame(width: widths[index % widths.count], height: 40)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private let colors: [Color] = [.blue, .green, .orange, .purple, .pink]
    private let widths: [CGFloat] = [120, 80, 160, 100, 140]

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Alignment",
                selection: $alignment,
                options: HorizontalAlignmentOption.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(
                label: "Spacing",
                value: $spacing,
                range: 0...40,
                format: "%.0f"
            )

            SliderControl(
                label: "Items",
                value: Binding(get: { Double(itemCount) }, set: { itemCount = Int($0) }),
                range: 1...5,
                step: 1,
                format: "%.0f"
            )
        }
    }

    private var generatedCode: String {
        var code = "VStack("

        var params: [String] = []
        if alignment != .center {
            params.append("alignment: .\(alignment.rawValue.lowercased())")
        }
        if spacing != 10 {
            params.append("spacing: \(Int(spacing))")
        }

        code += params.joined(separator: ", ")
        code += ") {\n"

        for i in 0..<itemCount {
            code += "    // Item \(i + 1)\n"
            code += "    Text(\"Item \(i + 1)\")\n"
        }

        code += "}"

        return code
    }
}

#Preview {
    NavigationStack {
        VStackPlayground()
    }
}
