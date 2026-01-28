import SwiftUI

struct ShadowPlayground: View {
    @State private var shadowColor = Color.black
    @State private var shadowRadius: Double = 10
    @State private var shadowX: Double = 0
    @State private var shadowY: Double = 5
    @State private var opacity: Double = 0.3

    var body: some View {
        ComponentPage(
            title: "Shadow",
            description: "Adds a shadow effect to a view.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/view/shadow(color:radius:x:y:)")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.white)
            .frame(width: 150, height: 100)
            .shadow(
                color: shadowColor.opacity(opacity),
                radius: shadowRadius,
                x: shadowX,
                y: shadowY
            )
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ColorControl(label: "Shadow Color", color: $shadowColor)

            SliderControl(
                label: "Radius",
                value: $shadowRadius,
                range: 0...30,
                format: "%.0f"
            )

            SliderControl(
                label: "Opacity",
                value: $opacity,
                range: 0...1,
                format: "%.1f"
            )

            SliderControl(
                label: "X Offset",
                value: $shadowX,
                range: -20...20,
                format: "%.0f"
            )

            SliderControl(
                label: "Y Offset",
                value: $shadowY,
                range: -20...20,
                format: "%.0f"
            )
        }
    }

    private var generatedCode: String {
        """
        // Shadow modifier
        RoundedRectangle(cornerRadius: 16)
            .fill(.white)
            .frame(width: 150, height: 100)
            .shadow(
                color: \(colorToCode(shadowColor)).opacity(\(String(format: "%.1f", opacity))),
                radius: \(Int(shadowRadius)),
                x: \(Int(shadowX)),
                y: \(Int(shadowY))
            )
        """
    }

    private func colorToCode(_ color: Color) -> String {
        if color == .black { return ".black" }
        if color == .gray { return ".gray" }
        if color == .blue { return ".blue" }
        if color == .red { return ".red" }
        return "Color(...)"
    }
}

#Preview {
    NavigationStack {
        ShadowPlayground()
    }
}
