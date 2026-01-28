import SwiftUI

struct RotationPlayground: View {
    @State private var rotationAngle: Double = 45
    @State private var rotationType = RotationTypeOption.rotation
    @State private var anchorPoint = AnchorPointOption.center
    @State private var animate = false

    enum RotationTypeOption: String, CaseIterable {
        case rotation = "2D Rotation"
        case rotation3DX = "3D X-Axis"
        case rotation3DY = "3D Y-Axis"
        case rotation3DZ = "3D Z-Axis"
    }

    enum AnchorPointOption: String, CaseIterable {
        case center = "Center"
        case topLeading = "Top Leading"
        case top = "Top"
        case bottomTrailing = "Bottom Trailing"

        var anchor: UnitPoint {
            switch self {
            case .center: .center
            case .topLeading: .topLeading
            case .top: .top
            case .bottomTrailing: .bottomTrailing
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "Rotation",
            description: "Rotates a view in 2D or 3D space.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/view/rotationeffect(_:anchor:)")!,
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
            rotatedView
                .animation(animate ? .easeInOut(duration: 1).repeatForever(autoreverses: true) : .default, value: rotationAngle)
        }
        .frame(width: 200, height: 200)
    }

    @ViewBuilder
    private var rotatedView: some View {
        let content = RoundedRectangle(cornerRadius: 12)
            .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 100, height: 100)
            .overlay {
                Text("Rotate")
                    .foregroundStyle(.white)
                    .font(.headline)
            }

        switch rotationType {
        case .rotation:
            content
                .rotationEffect(.degrees(rotationAngle), anchor: anchorPoint.anchor)
        case .rotation3DX:
            content
                .rotation3DEffect(.degrees(rotationAngle), axis: (x: 1, y: 0, z: 0))
        case .rotation3DY:
            content
                .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0))
        case .rotation3DZ:
            content
                .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: 0, z: 1))
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Type",
                selection: $rotationType,
                options: RotationTypeOption.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(
                label: "Angle",
                value: $rotationAngle,
                range: 0...360,
                format: "%.0f°"
            )

            if rotationType == .rotation {
                PickerControl(
                    label: "Anchor",
                    selection: $anchorPoint,
                    options: AnchorPointOption.allCases,
                    optionLabel: { $0.rawValue }
                )
            }

            ToggleControl(label: "Animate", isOn: $animate)
        }
    }

    private var generatedCode: String {
        switch rotationType {
        case .rotation:
            if anchorPoint == .center {
                return """
                // 2D rotation
                RoundedRectangle(cornerRadius: 12)
                    .rotationEffect(.degrees(\(Int(rotationAngle))))
                """
            } else {
                return """
                // 2D rotation with anchor
                RoundedRectangle(cornerRadius: 12)
                    .rotationEffect(.degrees(\(Int(rotationAngle))), anchor: .\(anchorPoint.rawValue.lowercased().replacingOccurrences(of: " ", with: "")))
                """
            }
        case .rotation3DX:
            return """
            // 3D rotation around X-axis
            RoundedRectangle(cornerRadius: 12)
                .rotation3DEffect(.degrees(\(Int(rotationAngle))), axis: (x: 1, y: 0, z: 0))
            """
        case .rotation3DY:
            return """
            // 3D rotation around Y-axis
            RoundedRectangle(cornerRadius: 12)
                .rotation3DEffect(.degrees(\(Int(rotationAngle))), axis: (x: 0, y: 1, z: 0))
            """
        case .rotation3DZ:
            return """
            // 3D rotation around Z-axis
            RoundedRectangle(cornerRadius: 12)
                .rotation3DEffect(.degrees(\(Int(rotationAngle))), axis: (x: 0, y: 0, z: 1))
            """
        }
    }
}

#Preview {
    NavigationStack {
        RotationPlayground()
    }
}
