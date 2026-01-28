import SwiftUI

struct PaddingPlayground: View {
    @State private var paddingAmount: Double = 20
    @State private var paddingType = PaddingType.all
    @State private var showBorder = true

    enum PaddingType: String, CaseIterable {
        case all = "All Edges"
        case horizontal = "Horizontal"
        case vertical = "Vertical"
        case top = "Top"
        case bottom = "Bottom"
        case leading = "Leading"
        case trailing = "Trailing"
    }

    var body: some View {
        ComponentPage(
            title: "Padding",
            description: "Adds space around a view's content.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/view/padding(_:_:)")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack {
            paddedContent
                .background(Color.blue)
                .border(showBorder ? Color.orange : Color.clear, width: 2)
        }
        .frame(height: 200)
    }

    @ViewBuilder
    private var paddedContent: some View {
        let content = Text("Content")
            .foregroundStyle(.white)

        switch paddingType {
        case .all:
            content.padding(paddingAmount)
        case .horizontal:
            content.padding(.horizontal, paddingAmount)
        case .vertical:
            content.padding(.vertical, paddingAmount)
        case .top:
            content.padding(.top, paddingAmount)
        case .bottom:
            content.padding(.bottom, paddingAmount)
        case .leading:
            content.padding(.leading, paddingAmount)
        case .trailing:
            content.padding(.trailing, paddingAmount)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Edges",
                selection: $paddingType,
                options: PaddingType.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(
                label: "Amount",
                value: $paddingAmount,
                range: 0...60,
                format: "%.0fpt"
            )

            ToggleControl(label: "Show Border", isOn: $showBorder)
        }
    }

    private var generatedCode: String {
        let amount = Int(paddingAmount)

        switch paddingType {
        case .all:
            if amount == 16 {
                return """
                // Default padding (system spacing)
                Text("Content")
                    .padding()
                """
            }
            return """
            // Padding on all edges
            Text("Content")
                .padding(\(amount))
            """
        case .horizontal:
            return """
            // Horizontal padding
            Text("Content")
                .padding(.horizontal, \(amount))
            """
        case .vertical:
            return """
            // Vertical padding
            Text("Content")
                .padding(.vertical, \(amount))
            """
        case .top:
            return """
            // Top padding only
            Text("Content")
                .padding(.top, \(amount))
            """
        case .bottom:
            return """
            // Bottom padding only
            Text("Content")
                .padding(.bottom, \(amount))
            """
        case .leading:
            return """
            // Leading padding only
            Text("Content")
                .padding(.leading, \(amount))
            """
        case .trailing:
            return """
            // Trailing padding only
            Text("Content")
                .padding(.trailing, \(amount))
            """
        }
    }
}

#Preview {
    NavigationStack {
        PaddingPlayground()
    }
}
