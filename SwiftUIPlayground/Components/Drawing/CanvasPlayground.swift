import SwiftUI

struct CanvasPlayground: View {
    @State private var drawingType = DrawingType.shapes
    @State private var particleCount: Double = 50
    @State private var animated = false

    enum DrawingType: String, CaseIterable {
        case shapes = "Shapes"
        case gradient = "Gradient"
        case pattern = "Pattern"
    }

    var body: some View {
        ComponentPage(
            title: "Canvas",
            description: "Immediate mode drawing with GraphicsContext.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/canvas")!,
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
            canvasView
                .frame(width: 220, height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .frame(height: 240)
    }

    @ViewBuilder
    private var canvasView: some View {
        switch drawingType {
        case .shapes:
            TimelineView(.animation(minimumInterval: 0.05, paused: !animated)) { timeline in
                Canvas { context, size in
                    let time = animated ? timeline.date.timeIntervalSinceReferenceDate : 0

                    for i in 0..<Int(particleCount) {
                        let angle = Double(i) * (2 * .pi / particleCount)
                        let wobble = animated ? sin(time * 2 + Double(i) * 0.3) * 10 : 0
                        let radius = min(size.width, size.height) / 3 + wobble

                        let x = size.width / 2 + cos(angle) * radius
                        let y = size.height / 2 + sin(angle) * radius

                        let hue = Double(i) / particleCount
                        let rect = CGRect(x: x - 5, y: y - 5, width: 10, height: 10)

                        context.fill(
                            Circle().path(in: rect),
                            with: .color(Color(hue: hue, saturation: 0.8, brightness: 0.9))
                        )
                    }
                }
            }
        case .gradient:
            Canvas { context, size in
                let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
                let barWidth = size.width / CGFloat(colors.count)

                for (index, color) in colors.enumerated() {
                    let rect = CGRect(
                        x: CGFloat(index) * barWidth,
                        y: 0,
                        width: barWidth,
                        height: size.height
                    )
                    context.fill(Rectangle().path(in: rect), with: .color(color))
                }

                context.fill(
                    Circle().path(in: CGRect(
                        x: size.width / 2 - 40,
                        y: size.height / 2 - 40,
                        width: 80,
                        height: 80
                    )),
                    with: .color(.white.opacity(0.9))
                )
            }
        case .pattern:
            Canvas { context, size in
                let gridSize: CGFloat = 20
                let rows = Int(size.height / gridSize)
                let cols = Int(size.width / gridSize)

                for row in 0..<rows {
                    for col in 0..<cols {
                        let isEven = (row + col).isMultiple(of: 2)
                        let rect = CGRect(
                            x: CGFloat(col) * gridSize,
                            y: CGFloat(row) * gridSize,
                            width: gridSize,
                            height: gridSize
                        )

                        if isEven {
                            context.fill(Rectangle().path(in: rect), with: .color(.blue))
                        } else {
                            context.fill(Circle().path(in: rect.insetBy(dx: 2, dy: 2)), with: .color(.orange))
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Drawing",
                selection: $drawingType,
                options: DrawingType.allCases,
                optionLabel: { $0.rawValue }
            )

            if drawingType == .shapes {
                SliderControl(
                    label: "Particles",
                    value: $particleCount,
                    range: 10...100,
                    format: "%.0f"
                )

                ToggleControl(label: "Animate", isOn: $animated)
            }
        }
    }

    private var generatedCode: String {
        switch drawingType {
        case .shapes:
            return """
            // Canvas with animated particles
            Canvas { context, size in
                for i in 0..<\(Int(particleCount)) {
                    let angle = Double(i) * (2 * .pi / \(Int(particleCount)))
                    let radius = min(size.width, size.height) / 3

                    let x = size.width / 2 + cos(angle) * radius
                    let y = size.height / 2 + sin(angle) * radius

                    let rect = CGRect(x: x - 5, y: y - 5, width: 10, height: 10)
                    let hue = Double(i) / \(Int(particleCount))

                    context.fill(
                        Circle().path(in: rect),
                        with: .color(Color(hue: hue, saturation: 0.8, brightness: 0.9))
                    )
                }
            }
            """
        case .gradient:
            return """
            // Canvas with color bars
            Canvas { context, size in
                let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
                let barWidth = size.width / CGFloat(colors.count)

                for (index, color) in colors.enumerated() {
                    let rect = CGRect(
                        x: CGFloat(index) * barWidth,
                        y: 0,
                        width: barWidth,
                        height: size.height
                    )
                    context.fill(Rectangle().path(in: rect), with: .color(color))
                }
            }
            """
        case .pattern:
            return """
            // Canvas with checkerboard pattern
            Canvas { context, size in
                let gridSize: CGFloat = 20

                for row in 0..<Int(size.height / gridSize) {
                    for col in 0..<Int(size.width / gridSize) {
                        let isEven = (row + col).isMultiple(of: 2)
                        let rect = CGRect(
                            x: CGFloat(col) * gridSize,
                            y: CGFloat(row) * gridSize,
                            width: gridSize,
                            height: gridSize
                        )

                        let shape = isEven ? Rectangle().path(in: rect)
                                           : Circle().path(in: rect)
                        context.fill(shape, with: .color(isEven ? .blue : .orange))
                    }
                }
            }
            """
        }
    }
}

#Preview {
    NavigationStack {
        CanvasPlayground()
    }
}
