import SwiftUI

struct OverlayPlayground: View {
    @State private var overlayType = OverlayType.badge
    @State private var alignment = AlignmentOption.topTrailing
    @State private var showBorder = false
    @State private var borderWidth: Double = 2

    enum OverlayType: String, CaseIterable {
        case badge = "Badge"
        case icon = "Icon"
        case border = "Border"
        case gradient = "Gradient"
    }

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
            title: "Overlay",
            description: "Layers content on top of a view.",
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
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue)
                .frame(width: 120, height: 120)
                .overlay(alignment: alignment.value) {
                    overlayContent
                }
        }
        .frame(height: 180)
    }

    @ViewBuilder
    private var overlayContent: some View {
        switch overlayType {
        case .badge:
            Text("3")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(.red, in: Circle())
                .offset(x: 8, y: -8)
        case .icon:
            Image(systemName: "checkmark.circle.fill")
                .font(.title)
                .foregroundStyle(.green)
                .background(.white, in: Circle())
                .offset(x: 8, y: -8)
        case .border:
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.orange, lineWidth: borderWidth)
        case .gradient:
            LinearGradient(
                colors: [.clear, .black.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Overlay",
                selection: $overlayType,
                options: OverlayType.allCases,
                optionLabel: { $0.rawValue }
            )

            if overlayType == .badge || overlayType == .icon {
                PickerControl(
                    label: "Alignment",
                    selection: $alignment,
                    options: AlignmentOption.allCases,
                    optionLabel: { $0.rawValue }
                )
            }

            if overlayType == .border {
                SliderControl(
                    label: "Border Width",
                    value: $borderWidth,
                    range: 1...8,
                    format: "%.0fpt"
                )
            }
        }
    }

    private var generatedCode: String {
        switch overlayType {
        case .badge:
            return """
            // Badge overlay
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue)
                .frame(width: 120, height: 120)
                .overlay(alignment: .\(alignment.rawValue.lowercased().replacingOccurrences(of: " ", with: ""))) {
                    Text("3")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(.red, in: Circle())
                        .offset(x: 8, y: -8)
                }
            """
        case .icon:
            return """
            // Icon overlay
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue)
                .frame(width: 120, height: 120)
                .overlay(alignment: .\(alignment.rawValue.lowercased().replacingOccurrences(of: " ", with: ""))) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.green)
                }
            """
        case .border:
            return """
            // Border overlay
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue)
                .frame(width: 120, height: 120)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.orange, lineWidth: \(Int(borderWidth)))
                }
            """
        case .gradient:
            return """
            // Gradient overlay (common for images)
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue)
                .frame(width: 120, height: 120)
                .overlay {
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            """
        }
    }
}

#Preview {
    NavigationStack {
        OverlayPlayground()
    }
}
