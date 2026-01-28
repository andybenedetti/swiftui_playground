import SwiftUI

struct BlurPlayground: View {
    @State private var blurRadius: Double = 5
    @State private var isOpaque = false
    @State private var showComparison = true

    var body: some View {
        ComponentPage(
            title: "Blur",
            description: "Applies a Gaussian blur effect to a view.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/view/blur(radius:opaque:)")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        if showComparison {
            HStack(spacing: 20) {
                VStack {
                    sampleContent
                    Text("Original")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack {
                    sampleContent
                        .blur(radius: blurRadius, opaque: isOpaque)
                    Text("Blurred")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        } else {
            sampleContent
                .blur(radius: blurRadius, opaque: isOpaque)
        }
    }

    private var sampleContent: some View {
        VStack(spacing: 8) {
            Image(systemName: "star.fill")
                .font(.largeTitle)
                .foregroundStyle(.yellow)
            Text("SwiftUI")
                .font(.headline)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.2))
        )
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            SliderControl(
                label: "Blur Radius",
                value: $blurRadius,
                range: 0...20,
                format: "%.1f"
            )

            ToggleControl(label: "Opaque", isOn: $isOpaque)

            ToggleControl(label: "Show Comparison", isOn: $showComparison)

            Text("Opaque blur extends edges to avoid transparent borders.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var generatedCode: String {
        if isOpaque {
            return """
            // Blur effect (opaque)
            Image(systemName: "star.fill")
                .blur(radius: \(String(format: "%.1f", blurRadius)), opaque: true)
            """
        } else {
            return """
            // Blur effect
            Image(systemName: "star.fill")
                .blur(radius: \(String(format: "%.1f", blurRadius)))
            """
        }
    }
}

#Preview {
    NavigationStack {
        BlurPlayground()
    }
}
