import SwiftUI

struct ViewThatFitsPlayground: View {
    @State private var containerWidth: Double = 350
    @State private var axis = AxisOption.horizontal
    @State private var showLabels = true

    enum AxisOption: String, CaseIterable {
        case horizontal = "Horizontal"
        case vertical = "Vertical"
        case both = "Both"
    }

    var body: some View {
        ComponentPage(
            title: "ViewThatFits",
            description: "Shows the first child view that fits in available space. iOS 16+",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/viewthatfits")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 20) {
            Text("Container width: \(Int(containerWidth))pt")
                .font(.caption)
                .foregroundStyle(.secondary)

            // Container with adjustable width
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))

                viewThatFitsContent
                    .padding()
            }
            .frame(width: containerWidth, height: 100)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundStyle(.secondary)
            )

            Text("Drag slider to see layout adapt")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var viewThatFitsContent: some View {
        switch axis {
        case .horizontal:
            ViewThatFits(in: .horizontal) {
                wideLayout
                mediumLayout
                narrowLayout
            }
        case .vertical:
            ViewThatFits(in: .vertical) {
                wideLayout
                mediumLayout
                narrowLayout
            }
        case .both:
            ViewThatFits {
                wideLayout
                mediumLayout
                narrowLayout
            }
        }
    }

    private var wideLayout: some View {
        HStack(spacing: 12) {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
            if showLabels {
                Text("Wide Layout")
                    .fontWeight(.medium)
            }
            Text("This is the full description text")
                .foregroundStyle(.secondary)
        }
    }

    private var mediumLayout: some View {
        HStack(spacing: 8) {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
            if showLabels {
                Text("Medium")
                    .fontWeight(.medium)
            }
        }
    }

    private var narrowLayout: some View {
        VStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
            if showLabels {
                Text("Narrow")
                    .font(.caption)
            }
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            SliderControl(
                label: "Container Width",
                value: $containerWidth,
                range: 80...350
            )

            PickerControl(
                label: "Constrained Axis",
                selection: $axis,
                options: AxisOption.allCases,
                optionLabel: { $0.rawValue }
            )

            ToggleControl(label: "Show Labels", isOn: $showLabels)
        }
    }

    private var generatedCode: String {
        let axisCode: String
        switch axis {
        case .horizontal:
            axisCode = "ViewThatFits(in: .horizontal)"
        case .vertical:
            axisCode = "ViewThatFits(in: .vertical)"
        case .both:
            axisCode = "ViewThatFits"
        }

        return """
        \(axisCode) {
            // Wide layout (tried first)
            HStack {
                Image(systemName: "star.fill")
                Text("Wide Layout")
                Text("Full description")
            }

            // Medium layout (fallback)
            HStack {
                Image(systemName: "star.fill")
                Text("Medium")
            }

            // Narrow layout (last resort)
            VStack {
                Image(systemName: "star.fill")
                Text("Narrow")
            }
        }
        """
    }
}

#Preview {
    NavigationStack {
        ViewThatFitsPlayground()
    }
}
