import SwiftUI

struct FramePlayground: View {
    @State private var width: Double = 150
    @State private var height: Double = 100
    @State private var alignment = AlignmentOption.center
    @State private var useFlexible = false
    @State private var maxWidth: Double = 200
    @State private var maxHeight: Double = 150

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

        var value: Alignment {
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
            title: "Frame",
            description: "Sets the size and alignment of a view.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        ZStack {
            if useFlexible {
                Text("Content")
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .frame(
                        maxWidth: maxWidth,
                        maxHeight: maxHeight,
                        alignment: alignment.value
                    )
                    .border(Color.gray.opacity(0.5), width: 1)
            } else {
                Text("Content")
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .frame(
                        width: width,
                        height: height,
                        alignment: alignment.value
                    )
                    .border(Color.gray.opacity(0.5), width: 1)
            }
        }
        .frame(height: 200)
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Flexible Frame", isOn: $useFlexible)

            if useFlexible {
                SliderControl(
                    label: "Max Width",
                    value: $maxWidth,
                    range: 100...300,
                    format: "%.0f"
                )

                SliderControl(
                    label: "Max Height",
                    value: $maxHeight,
                    range: 50...200,
                    format: "%.0f"
                )
            } else {
                SliderControl(
                    label: "Width",
                    value: $width,
                    range: 80...300,
                    format: "%.0f"
                )

                SliderControl(
                    label: "Height",
                    value: $height,
                    range: 50...200,
                    format: "%.0f"
                )
            }

            PickerControl(
                label: "Alignment",
                selection: $alignment,
                options: AlignmentOption.allCases,
                optionLabel: { $0.rawValue }
            )
        }
    }

    private var generatedCode: String {
        let alignmentCode = alignment == .center ? "" : ", alignment: .\(alignment.rawValue.lowercased().replacingOccurrences(of: " ", with: ""))"

        if useFlexible {
            return """
            // Flexible frame with max constraints
            Text("Content")
                .frame(
                    maxWidth: \(Int(maxWidth)),
                    maxHeight: \(Int(maxHeight))\(alignmentCode)
                )
            """
        } else {
            return """
            // Fixed frame size
            Text("Content")
                .frame(
                    width: \(Int(width)),
                    height: \(Int(height))\(alignmentCode)
                )
            """
        }
    }
}

#Preview {
    NavigationStack {
        FramePlayground()
    }
}
