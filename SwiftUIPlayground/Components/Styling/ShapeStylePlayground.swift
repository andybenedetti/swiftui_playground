import SwiftUI

struct ShapeStylePlayground: View {
    // MARK: - State
    @State private var gradientType = GradientType.linear
    @State private var startColor: Color = .blue
    @State private var endColor: Color = .purple
    @State private var angle: Double = 45
    @State private var applyTo = ApplyTarget.fill

    enum GradientType: String, CaseIterable {
        case linear = "Linear"
        case radial = "Radial"
        case angular = "Angular"
        case elliptical = "Elliptical"
    }

    enum ApplyTarget: String, CaseIterable {
        case fill = "Fill"
        case stroke = "Stroke"
        case background = "Background"
    }

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "ShapeStyle",
            description: "Configure gradient-based shape styles including Linear, Radial, Angular, and Elliptical gradients. Apply them as fills, strokes, or backgrounds.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/shapestyle")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    // MARK: - Preview
    @ViewBuilder
    private var previewContent: some View {
        let colors: [Color] = [startColor, endColor]

        switch (gradientType, applyTo) {
        case (.linear, .fill):
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 200, height: 200)
        case (.linear, .stroke):
            RoundedRectangle(cornerRadius: 20)
                .stroke(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 8)
                .frame(width: 200, height: 200)
        case (.linear, .background):
            Text("Hello, World!").font(.title.bold()).padding(30)
                .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 20))

        case (.radial, .fill):
            RoundedRectangle(cornerRadius: 20)
                .fill(RadialGradient(colors: colors, center: .center, startRadius: 0, endRadius: 120))
                .frame(width: 200, height: 200)
        case (.radial, .stroke):
            RoundedRectangle(cornerRadius: 20)
                .stroke(RadialGradient(colors: colors, center: .center, startRadius: 0, endRadius: 120), lineWidth: 8)
                .frame(width: 200, height: 200)
        case (.radial, .background):
            Text("Hello, World!").font(.title.bold()).padding(30)
                .background(RadialGradient(colors: colors, center: .center, startRadius: 0, endRadius: 120), in: RoundedRectangle(cornerRadius: 20))

        case (.angular, .fill):
            RoundedRectangle(cornerRadius: 20)
                .fill(AngularGradient(colors: colors + [colors[0]], center: .center, angle: .degrees(angle)))
                .frame(width: 200, height: 200)
        case (.angular, .stroke):
            RoundedRectangle(cornerRadius: 20)
                .stroke(AngularGradient(colors: colors + [colors[0]], center: .center, angle: .degrees(angle)), lineWidth: 8)
                .frame(width: 200, height: 200)
        case (.angular, .background):
            Text("Hello, World!").font(.title.bold()).padding(30)
                .background(AngularGradient(colors: colors + [colors[0]], center: .center, angle: .degrees(angle)), in: RoundedRectangle(cornerRadius: 20))

        case (.elliptical, .fill):
            RoundedRectangle(cornerRadius: 20)
                .fill(EllipticalGradient(colors: colors, center: .center))
                .frame(width: 200, height: 200)
        case (.elliptical, .stroke):
            RoundedRectangle(cornerRadius: 20)
                .stroke(EllipticalGradient(colors: colors, center: .center), lineWidth: 8)
                .frame(width: 200, height: 200)
        case (.elliptical, .background):
            Text("Hello, World!").font(.title.bold()).padding(30)
                .background(EllipticalGradient(colors: colors, center: .center), in: RoundedRectangle(cornerRadius: 20))
        }
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Gradient Type",
                selection: $gradientType,
                options: GradientType.allCases,
                optionLabel: { $0.rawValue }
            )

            ColorControl(label: "Start Color", color: $startColor)
            ColorControl(label: "End Color", color: $endColor)

            if gradientType == .angular {
                SliderControl(label: "Angle", value: $angle, range: 0...360, format: "%.0f°")
            }

            PickerControl(
                label: "Apply As",
                selection: $applyTo,
                options: ApplyTarget.allCases,
                optionLabel: { $0.rawValue }
            )
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        let gradientCode: String
        switch gradientType {
        case .linear:
            gradientCode = """
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            """
        case .radial:
            gradientCode = """
            RadialGradient(
                colors: [.blue, .purple],
                center: .center,
                startRadius: 0,
                endRadius: 120
            )
            """
        case .angular:
            gradientCode = """
            AngularGradient(
                colors: [.blue, .purple, .blue],
                center: .center,
                angle: .degrees(\(Int(angle)))
            )
            """
        case .elliptical:
            gradientCode = """
            EllipticalGradient(
                colors: [.blue, .purple],
                center: .center
            )
            """
        }

        switch applyTo {
        case .fill:
            return """
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    \(gradientCode)
                )
            """
        case .stroke:
            return """
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    \(gradientCode),
                    lineWidth: 8
                )
            """
        case .background:
            return """
            Text("Hello, World!")
                .padding(30)
                .background(
                    \(gradientCode),
                    in: RoundedRectangle(cornerRadius: 20)
                )
            """
        }
    }
}

#Preview {
    NavigationStack {
        ShapeStylePlayground()
    }
}
