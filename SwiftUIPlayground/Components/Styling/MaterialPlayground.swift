import SwiftUI

struct MaterialPlayground: View {
    // MARK: - State
    @State private var thickness = MaterialThickness.regular
    @State private var backgroundType = BackgroundType.gradient
    @State private var cornerRadius: Double = 16
    @State private var forceDarkMode = false

    enum MaterialThickness: String, CaseIterable {
        case ultraThin = "Ultra Thin"
        case thin = "Thin"
        case regular = "Regular"
        case thick = "Thick"
        case ultraThick = "Ultra Thick"

        var material: Material {
            switch self {
            case .ultraThin: .ultraThinMaterial
            case .thin: .thinMaterial
            case .regular: .regularMaterial
            case .thick: .thickMaterial
            case .ultraThick: .ultraThickMaterial
            }
        }

        var code: String {
            switch self {
            case .ultraThin: ".ultraThinMaterial"
            case .thin: ".thinMaterial"
            case .regular: ".regularMaterial"
            case .thick: ".thickMaterial"
            case .ultraThick: ".ultraThickMaterial"
            }
        }
    }

    enum BackgroundType: String, CaseIterable {
        case gradient = "Gradient"
        case image = "Image"
        case solid = "Solid Color"
    }

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "Material",
            description: "SwiftUI's material effects create translucent layers that blend with content behind them. Five thickness levels from ultra thin to ultra thick, with automatic adaptation to light/dark mode.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/material")!,
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
        ZStack {
            backgroundView
                .frame(maxWidth: .infinity)
                .frame(height: 280)

            VStack(spacing: 12) {
                Text(thickness.rawValue)
                    .font(.headline)
                Text("Material overlay")
                    .font(.subheadline)

                HStack(spacing: 16) {
                    Image(systemName: "star.fill")
                    Image(systemName: "heart.fill")
                    Image(systemName: "bolt.fill")
                }
                .font(.title2)
            }
            .padding(24)
            .background(thickness.material, in: RoundedRectangle(cornerRadius: cornerRadius))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .preferredColorScheme(forceDarkMode ? .dark : nil)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch backgroundType {
        case .gradient:
            LinearGradient(
                colors: [.red, .orange, .yellow, .green, .blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .image:
            ZStack {
                LinearGradient(
                    colors: [.blue, .cyan, .mint],
                    startPoint: .top,
                    endPoint: .bottom
                )
                VStack(spacing: 8) {
                    ForEach(0..<5) { row in
                        HStack(spacing: 8) {
                            ForEach(0..<6) { col in
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                        }
                    }
                }
                .font(.title2)
            }
        case .solid:
            Color.orange
        }
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Thickness",
                selection: $thickness,
                options: MaterialThickness.allCases,
                optionLabel: { $0.rawValue }
            )

            PickerControl(
                label: "Background",
                selection: $backgroundType,
                options: BackgroundType.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(label: "Corner Radius", value: $cornerRadius, range: 0...40, format: "%.0f")

            ToggleControl(label: "Force Dark Mode", isOn: $forceDarkMode)
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        """
        ZStack {
            // Rich background content
            LinearGradient(
                colors: [.red, .orange, .yellow, .green],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Material overlay
            VStack {
                Text("Content")
                    .font(.headline)
            }
            .padding(24)
            .background(
                \(thickness.code),
                in: RoundedRectangle(cornerRadius: \(Int(cornerRadius)))
            )
        }
        """
    }
}

#Preview {
    NavigationStack {
        MaterialPlayground()
    }
}
