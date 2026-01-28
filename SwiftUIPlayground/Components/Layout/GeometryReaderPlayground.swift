import SwiftUI

struct GeometryReaderPlayground: View {
    @State private var showSize = true
    @State private var showSafeArea = true
    @State private var showFrame = false
    @State private var coordinateSpace = CoordinateSpaceOption.local
    @State private var childAlignment = AlignmentOption.center

    enum CoordinateSpaceOption: String, CaseIterable {
        case local = "Local"
        case global = "Global"
        case named = "Named"
    }

    enum AlignmentOption: String, CaseIterable {
        case topLeading = "Top Leading"
        case top = "Top"
        case center = "Center"
        case bottom = "Bottom"
        case bottomTrailing = "Bottom Trailing"

        var alignment: Alignment {
            switch self {
            case .topLeading: .topLeading
            case .top: .top
            case .center: .center
            case .bottom: .bottom
            case .bottomTrailing: .bottomTrailing
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "GeometryReader",
            description: "A container that provides size and position info. iOS 13+",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        GeometryReader { geometry in
            ZStack(alignment: childAlignment.alignment) {
                // Background showing the container
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.blue.opacity(0.3), lineWidth: 2)
                    )

                // Info overlay
                VStack(alignment: .leading, spacing: 8) {
                    if showSize {
                        InfoRow(label: "Size", value: "\(Int(geometry.size.width)) x \(Int(geometry.size.height))")
                    }

                    if showSafeArea {
                        InfoRow(label: "Safe Area Top", value: "\(Int(geometry.safeAreaInsets.top))")
                        InfoRow(label: "Safe Area Bottom", value: "\(Int(geometry.safeAreaInsets.bottom))")
                    }

                    if showFrame {
                        InfoRow(label: "Frame Origin", value: "(\(Int(frameFor(geometry).minX)), \(Int(frameFor(geometry).minY)))")
                        InfoRow(label: "Frame Size", value: "\(Int(frameFor(geometry).width)) x \(Int(frameFor(geometry).height))")
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .frame(height: 200)
        .coordinateSpace(name: "preview")
    }

    private func frameFor(_ geometry: GeometryProxy) -> CGRect {
        switch coordinateSpace {
        case .local:
            geometry.frame(in: .local)
        case .global:
            geometry.frame(in: .global)
        case .named:
            geometry.frame(in: .named("preview"))
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Show Size", isOn: $showSize)

            ToggleControl(label: "Show Safe Area", isOn: $showSafeArea)

            ToggleControl(label: "Show Frame", isOn: $showFrame)

            if showFrame {
                PickerControl(
                    label: "Coordinate Space",
                    selection: $coordinateSpace,
                    options: CoordinateSpaceOption.allCases,
                    optionLabel: { $0.rawValue }
                )
            }

            PickerControl(
                label: "Content Alignment",
                selection: $childAlignment,
                options: AlignmentOption.allCases,
                optionLabel: { $0.rawValue }
            )
        }
    }

    private var generatedCode: String {
        var code = """
        // GeometryReader provides layout information
        GeometryReader { geometry in
        """

        if showSize {
            code += """

            // Access container size
            let width = geometry.size.width
            let height = geometry.size.height
        """
        }

        if showSafeArea {
            code += """

            // Access safe area insets
            let topInset = geometry.safeAreaInsets.top
            let bottomInset = geometry.safeAreaInsets.bottom
        """
        }

        if showFrame {
            let frameCode: String
            switch coordinateSpace {
            case .local:
                frameCode = "geometry.frame(in: .local)"
            case .global:
                frameCode = "geometry.frame(in: .global)"
            case .named:
                frameCode = "geometry.frame(in: .named(\"container\"))"
            }
            code += """

            // Get frame in coordinate space
            let frame = \(frameCode)
        """
        }

        code += """

            // Use geometry values to layout content
            Text("\\(Int(geometry.size.width)) x \\(Int(geometry.size.height))")
        }
        """

        if coordinateSpace == .named && showFrame {
            code += "\n.coordinateSpace(name: \"container\")"
        }

        return code
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.caption.monospaced())
                .fontWeight(.medium)
        }
    }
}

#Preview {
    NavigationStack {
        GeometryReaderPlayground()
    }
}
