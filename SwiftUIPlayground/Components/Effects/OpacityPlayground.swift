import SwiftUI

struct OpacityPlayground: View {
    @State private var opacity: Double = 0.5
    @State private var showComparison = true
    @State private var animate = false

    var body: some View {
        ComponentPage(
            title: "Opacity",
            description: "Sets the transparency of a view.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/view/opacity(_:)")!,
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
                            .opacity(opacity)
                            .animation(animate ? .easeInOut(duration: 1).repeatForever(autoreverses: true) : .default, value: opacity)
                        Text("Modified")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                sampleContent
                    .opacity(opacity)
                    .animation(animate ? .easeInOut(duration: 1).repeatForever(autoreverses: true) : .default, value: opacity)
            }
        }
    }

    private var sampleContent: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 100, height: 100)
            .overlay {
                Image(systemName: "star.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
            }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            SliderControl(
                label: "Opacity",
                value: $opacity,
                range: 0...1,
                format: "%.2f"
            )

            ToggleControl(label: "Show Comparison", isOn: $showComparison)

            ToggleControl(label: "Animate", isOn: $animate)

            Text("0 = fully transparent, 1 = fully opaque")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var generatedCode: String {
        """
        // Opacity modifier
        RoundedRectangle(cornerRadius: 12)
            .fill(.blue)
            .opacity(\(String(format: "%.2f", opacity)))
        """
    }
}

#Preview {
    NavigationStack {
        OpacityPlayground()
    }
}
