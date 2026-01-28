import SwiftUI

struct ClipShapePlayground: View {
    @State private var shapeType = ShapeType.roundedRectangle
    @State private var cornerRadius: Double = 20
    @State private var trimFrom: Double = 0
    @State private var trimTo: Double = 1

    enum ShapeType: String, CaseIterable {
        case rectangle = "Rectangle"
        case roundedRectangle = "Rounded Rectangle"
        case circle = "Circle"
        case ellipse = "Ellipse"
        case capsule = "Capsule"
    }

    var body: some View {
        ComponentPage(
            title: "ClipShape",
            description: "Masks a view to a shape.",
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
            LinearGradient(
                colors: [.blue, .purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(width: 150, height: 150)
            .clipShape(clipShape)
            .overlay {
                Text("Clipped")
                    .font(.headline)
                    .foregroundStyle(.white)
            }
        }
        .frame(height: 200)
    }

    private var clipShape: some Shape {
        switch shapeType {
        case .rectangle:
            AnyShape(Rectangle())
        case .roundedRectangle:
            AnyShape(RoundedRectangle(cornerRadius: cornerRadius))
        case .circle:
            AnyShape(Circle())
        case .ellipse:
            AnyShape(Ellipse())
        case .capsule:
            AnyShape(Capsule())
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Shape",
                selection: $shapeType,
                options: ShapeType.allCases,
                optionLabel: { $0.rawValue }
            )

            if shapeType == .roundedRectangle {
                SliderControl(
                    label: "Corner Radius",
                    value: $cornerRadius,
                    range: 0...75,
                    format: "%.0f"
                )
            }
        }
    }

    private var generatedCode: String {
        switch shapeType {
        case .rectangle:
            return """
            // Clip to rectangle (no effect on square content)
            Image("photo")
                .clipShape(Rectangle())
            """
        case .roundedRectangle:
            return """
            // Clip to rounded rectangle
            Image("photo")
                .clipShape(RoundedRectangle(cornerRadius: \(Int(cornerRadius))))
            """
        case .circle:
            return """
            // Clip to circle (great for avatars)
            Image("photo")
                .clipShape(Circle())
            """
        case .ellipse:
            return """
            // Clip to ellipse
            Image("photo")
                .clipShape(Ellipse())
            """
        case .capsule:
            return """
            // Clip to capsule
            Image("photo")
                .clipShape(Capsule())
            """
        }
    }
}

// Type-erased shape for switch compatibility
struct AnyShape: Shape, @unchecked Sendable {
    private let pathBuilder: @Sendable (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        pathBuilder = { rect in
            shape.path(in: rect)
        }
    }

    func path(in rect: CGRect) -> Path {
        pathBuilder(rect)
    }
}

#Preview {
    NavigationStack {
        ClipShapePlayground()
    }
}
