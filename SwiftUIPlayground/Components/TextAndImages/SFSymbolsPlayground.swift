import SwiftUI

struct SFSymbolsPlayground: View {
    // MARK: - State
    @State private var selectedSymbol = "star.fill"
    @State private var fontSize: Double = 48
    @State private var selectedRendering: RenderingOption = .monochrome
    @State private var primaryColor: Color = .blue
    @State private var secondaryColor: Color = .cyan
    @State private var useVariableValue = false
    @State private var variableValue: Double = 0.5
    @State private var useBounce = false

    enum RenderingOption: String, CaseIterable {
        case monochrome = "Monochrome"
        case hierarchical = "Hierarchical"
        case multicolor = "Multicolor"
        case palette = "Palette"

        var codeName: String {
            switch self {
            case .monochrome: ".monochrome"
            case .hierarchical: ".hierarchical"
            case .multicolor: ".multicolor"
            case .palette: ".palette"
            }
        }
    }

    private let symbolOptions = [
        "star.fill", "heart.fill", "cloud.sun.rain.fill",
        "wifi", "battery.75percent", "speaker.wave.3.fill",
        "chart.bar.fill", "person.3.fill", "globe.americas.fill",
        "bell.badge.fill", "folder.fill.badge.plus", "iphone.gen3"
    ]

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "SF Symbols",
            description: "Apple's icon library with rendering modes, variable values, and symbol effects.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/image/init(systemname:)")!,
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
        VStack(spacing: 24) {
            symbolPreview
                .symbolEffect(.bounce, value: useBounce)

            // Show all rendering modes side by side
            VStack(spacing: 8) {
                Text("Rendering Modes")
                    .font(.headline)

                HStack(spacing: 20) {
                    renderingPreview("Mono", mode: .monochrome)
                    renderingPreview("Hier", mode: .hierarchical)
                    renderingPreview("Multi", mode: .multicolor)
                    renderingPreview("Palette", mode: .palette)
                }
            }
        }
        .padding()
    }

    @ViewBuilder
    private var symbolPreview: some View {
        Group {
            if useVariableValue {
                Image(systemName: selectedSymbol, variableValue: variableValue)
                    .font(.system(size: fontSize))
            } else {
                Image(systemName: selectedSymbol)
                    .font(.system(size: fontSize))
            }
        }
        .symbolRenderingMode(renderingMode)
        .foregroundStyle(primaryColor, secondaryColor)
    }

    private var renderingMode: SymbolRenderingMode {
        switch selectedRendering {
        case .monochrome: .monochrome
        case .hierarchical: .hierarchical
        case .multicolor: .multicolor
        case .palette: .palette
        }
    }

    private func renderingPreview(_ label: String, mode: SymbolRenderingMode) -> some View {
        VStack(spacing: 4) {
            Image(systemName: selectedSymbol)
                .font(.system(size: 28))
                .symbolRenderingMode(mode)
                .foregroundStyle(primaryColor, secondaryColor)

            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Symbol",
                selection: $selectedSymbol,
                options: symbolOptions,
                optionLabel: { $0 }
            )

            SliderControl(label: "Size", value: $fontSize, range: 20...80, format: "%.0f pt")

            PickerControl(
                label: "Rendering",
                selection: $selectedRendering,
                options: RenderingOption.allCases,
                optionLabel: { $0.rawValue }
            )

            ColorControl(label: "Primary Color", color: $primaryColor)

            if selectedRendering == .palette {
                ColorControl(label: "Secondary Color", color: $secondaryColor)
            }

            ToggleControl(label: "Variable Value", isOn: $useVariableValue)

            if useVariableValue {
                SliderControl(label: "Value", value: $variableValue, range: 0...1, format: "%.2f")
            }

            ToggleControl(label: "Bounce Effect", isOn: $useBounce)
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        var code: String
        if useVariableValue {
            code = "Image(systemName: \"\(selectedSymbol)\", variableValue: \(String(format: "%.2f", variableValue)))"
        } else {
            code = "Image(systemName: \"\(selectedSymbol)\")"
        }

        code += "\n    .font(.system(size: \(Int(fontSize))))"
        code += "\n    .symbolRenderingMode(\(selectedRendering.codeName))"

        if selectedRendering == .palette {
            code += "\n    .foregroundStyle(.blue, .cyan)"
        } else {
            code += "\n    .foregroundStyle(.blue)"
        }

        if useBounce {
            code += "\n    .symbolEffect(.bounce, value: trigger)"
        }

        return code
    }
}

#Preview {
    NavigationStack {
        SFSymbolsPlayground()
    }
}
