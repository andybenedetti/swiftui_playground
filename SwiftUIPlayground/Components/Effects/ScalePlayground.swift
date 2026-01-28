import SwiftUI

struct ScalePlayground: View {
    @State private var uniformScale: Double = 1.0
    @State private var scaleX: Double = 1.0
    @State private var scaleY: Double = 1.0
    @State private var useUniformScale = true
    @State private var anchorPoint = AnchorPointOption.center
    @State private var animate = false

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
            title: "Scale",
            description: "Scales a view's rendered output by the given amounts.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/view/scaleeffect(_:anchor:)")!,
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
            if useUniformScale {
                sampleContent
                    .scaleEffect(uniformScale, anchor: anchorPoint.anchor)
                    .animation(animate ? .easeInOut(duration: 1).repeatForever(autoreverses: true) : .default, value: uniformScale)
            } else {
                sampleContent
                    .scaleEffect(x: scaleX, y: scaleY, anchor: anchorPoint.anchor)
                    .animation(animate ? .easeInOut(duration: 1).repeatForever(autoreverses: true) : .default, value: scaleX)
                    .animation(animate ? .easeInOut(duration: 1).repeatForever(autoreverses: true) : .default, value: scaleY)
            }
        }
        .frame(width: 200, height: 200)
    }

    private var sampleContent: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 80, height: 80)
            .overlay {
                Text("Scale")
                    .foregroundStyle(.white)
                    .font(.headline)
            }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Uniform Scale", isOn: $useUniformScale)

            if useUniformScale {
                SliderControl(
                    label: "Scale",
                    value: $uniformScale,
                    range: 0.1...2.0,
                    format: "%.2f"
                )
            } else {
                SliderControl(
                    label: "Scale X",
                    value: $scaleX,
                    range: 0.1...2.0,
                    format: "%.2f"
                )

                SliderControl(
                    label: "Scale Y",
                    value: $scaleY,
                    range: 0.1...2.0,
                    format: "%.2f"
                )
            }

            PickerControl(
                label: "Anchor",
                selection: $anchorPoint,
                options: AnchorPointOption.allCases,
                optionLabel: { $0.rawValue }
            )

            ToggleControl(label: "Animate", isOn: $animate)
        }
    }

    private var generatedCode: String {
        if useUniformScale {
            if anchorPoint == .center {
                return """
                // Uniform scale effect
                RoundedRectangle(cornerRadius: 12)
                    .scaleEffect(\(String(format: "%.2f", uniformScale)))
                """
            } else {
                return """
                // Uniform scale effect with anchor
                RoundedRectangle(cornerRadius: 12)
                    .scaleEffect(\(String(format: "%.2f", uniformScale)), anchor: .\(anchorPoint.rawValue.lowercased().replacingOccurrences(of: " ", with: "")))
                """
            }
        } else {
            if anchorPoint == .center {
                return """
                // Non-uniform scale effect
                RoundedRectangle(cornerRadius: 12)
                    .scaleEffect(x: \(String(format: "%.2f", scaleX)), y: \(String(format: "%.2f", scaleY)))
                """
            } else {
                return """
                // Non-uniform scale effect with anchor
                RoundedRectangle(cornerRadius: 12)
                    .scaleEffect(x: \(String(format: "%.2f", scaleX)), y: \(String(format: "%.2f", scaleY)), anchor: .\(anchorPoint.rawValue.lowercased().replacingOccurrences(of: " ", with: "")))
                """
            }
        }
    }
}

#Preview {
    NavigationStack {
        ScalePlayground()
    }
}
