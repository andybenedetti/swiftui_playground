import SwiftUI

struct CustomShapePlayground: View {
    @State private var shapeType = ShapeOption.polygon
    @State private var sides: Double = 6
    @State private var cornerRadius: Double = 0
    @State private var rotation: Double = 0
    @State private var fillColor: Color = .blue

    enum ShapeOption: String, CaseIterable {
        case polygon = "Polygon"
        case heart = "Heart"
        case wave = "Wave"
        case badge = "Badge"
    }

    var body: some View {
        ComponentPage(
            title: "Custom Shape",
            description: "Create reusable shapes with the Shape protocol.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/shape")!,
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
            Group {
                switch shapeType {
                case .polygon:
                    Polygon(sides: Int(sides))
                        .fill(fillColor)
                case .heart:
                    HeartShape()
                        .fill(fillColor)
                case .wave:
                    WaveShape()
                        .fill(fillColor)
                case .badge:
                    BadgeShape(points: Int(sides))
                        .fill(fillColor)
                }
            }
            .frame(width: 180, height: 180)
            .rotationEffect(.degrees(rotation))
        }
        .frame(height: 220)
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Shape",
                selection: $shapeType,
                options: ShapeOption.allCases,
                optionLabel: { $0.rawValue }
            )

            if shapeType == .polygon || shapeType == .badge {
                SliderControl(
                    label: shapeType == .polygon ? "Sides" : "Points",
                    value: $sides,
                    range: 3...12,
                    format: "%.0f"
                )
            }

            SliderControl(
                label: "Rotation",
                value: $rotation,
                range: 0...360,
                format: "%.0f°"
            )

            ColorControl(label: "Color", color: $fillColor)
        }
    }

    private var generatedCode: String {
        switch shapeType {
        case .polygon:
            return """
            // Custom polygon shape
            struct Polygon: Shape {
                var sides: Int

                func path(in rect: CGRect) -> Path {
                    let center = CGPoint(x: rect.midX, y: rect.midY)
                    let radius = min(rect.width, rect.height) / 2

                    return Path { path in
                        for i in 0..<sides {
                            let angle = (CGFloat(i) * (2 * .pi / CGFloat(sides))) - .pi / 2
                            let point = CGPoint(
                                x: center.x + cos(angle) * radius,
                                y: center.y + sin(angle) * radius
                            )
                            if i == 0 { path.move(to: point) }
                            else { path.addLine(to: point) }
                        }
                        path.closeSubpath()
                    }
                }
            }

            Polygon(sides: \(Int(sides)))
                .fill(.blue)
            """
        case .heart:
            return """
            // Custom heart shape
            struct HeartShape: Shape {
                func path(in rect: CGRect) -> Path {
                    let width = rect.width
                    let height = rect.height

                    return Path { path in
                        path.move(to: CGPoint(x: width / 2, y: height))

                        path.addCurve(
                            to: CGPoint(x: 0, y: height / 4),
                            control1: CGPoint(x: width / 2, y: height * 0.75),
                            control2: CGPoint(x: 0, y: height / 2)
                        )

                        path.addArc(
                            center: CGPoint(x: width / 4, y: height / 4),
                            radius: width / 4,
                            startAngle: .degrees(180),
                            endAngle: .degrees(0),
                            clockwise: false
                        )

                        path.addArc(
                            center: CGPoint(x: width * 3/4, y: height / 4),
                            radius: width / 4,
                            startAngle: .degrees(180),
                            endAngle: .degrees(0),
                            clockwise: false
                        )

                        path.addCurve(
                            to: CGPoint(x: width / 2, y: height),
                            control1: CGPoint(x: width, y: height / 2),
                            control2: CGPoint(x: width / 2, y: height * 0.75)
                        )
                    }
                }
            }

            HeartShape()
                .fill(.red)
            """
        case .wave:
            return """
            // Custom wave shape
            struct WaveShape: Shape {
                func path(in rect: CGRect) -> Path {
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: rect.midY))

                        let waveHeight = rect.height * 0.2
                        let wavelength = rect.width / 3

                        for x in stride(from: 0, through: rect.width, by: 1) {
                            let relativeX = x / wavelength
                            let y = rect.midY + sin(relativeX * 2 * .pi) * waveHeight
                            path.addLine(to: CGPoint(x: x, y: y))
                        }

                        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
                        path.addLine(to: CGPoint(x: 0, y: rect.height))
                        path.closeSubpath()
                    }
                }
            }

            WaveShape()
                .fill(.blue)
            """
        case .badge:
            return """
            // Custom badge shape with points
            struct BadgeShape: Shape {
                var points: Int

                func path(in rect: CGRect) -> Path {
                    let center = CGPoint(x: rect.midX, y: rect.midY)
                    let outerRadius = min(rect.width, rect.height) / 2
                    let innerRadius = outerRadius * 0.6

                    return Path { path in
                        for i in 0..<(points * 2) {
                            let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
                            let angle = (CGFloat(i) * .pi / CGFloat(points)) - .pi / 2
                            let point = CGPoint(
                                x: center.x + cos(angle) * radius,
                                y: center.y + sin(angle) * radius
                            )
                            if i == 0 { path.move(to: point) }
                            else { path.addLine(to: point) }
                        }
                        path.closeSubpath()
                    }
                }
            }

            BadgeShape(points: \(Int(sides)))
                .fill(.orange)
            """
        }
    }
}

// MARK: - Custom Shapes

struct Polygon: Shape {
    var sides: Int

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        return Path { path in
            for i in 0..<sides {
                let angle = (CGFloat(i) * (2 * .pi / CGFloat(sides))) - .pi / 2
                let point = CGPoint(
                    x: center.x + cos(angle) * radius,
                    y: center.y + sin(angle) * radius
                )
                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            path.closeSubpath()
        }
    }
}

struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height

        return Path { path in
            path.move(to: CGPoint(x: width / 2, y: height))

            path.addCurve(
                to: CGPoint(x: 0, y: height / 4),
                control1: CGPoint(x: width / 2, y: height * 0.75),
                control2: CGPoint(x: 0, y: height / 2)
            )

            path.addArc(
                center: CGPoint(x: width / 4, y: height / 4),
                radius: width / 4,
                startAngle: .degrees(180),
                endAngle: .degrees(0),
                clockwise: false
            )

            path.addArc(
                center: CGPoint(x: width * 3 / 4, y: height / 4),
                radius: width / 4,
                startAngle: .degrees(180),
                endAngle: .degrees(0),
                clockwise: false
            )

            path.addCurve(
                to: CGPoint(x: width / 2, y: height),
                control1: CGPoint(x: width, y: height / 2),
                control2: CGPoint(x: width / 2, y: height * 0.75)
            )
        }
    }
}

struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: rect.midY))

            let waveHeight = rect.height * 0.2
            let wavelength = rect.width / 3

            for x in stride(from: 0, through: rect.width, by: 1) {
                let relativeX = x / wavelength
                let y = rect.midY + sin(relativeX * 2 * .pi) * waveHeight
                path.addLine(to: CGPoint(x: x, y: y))
            }

            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.closeSubpath()
        }
    }
}

struct BadgeShape: Shape {
    var points: Int

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.6

        return Path { path in
            for i in 0..<(points * 2) {
                let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
                let angle = (CGFloat(i) * .pi / CGFloat(points)) - .pi / 2
                let point = CGPoint(
                    x: center.x + cos(angle) * radius,
                    y: center.y + sin(angle) * radius
                )
                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            path.closeSubpath()
        }
    }
}

#Preview {
    NavigationStack {
        CustomShapePlayground()
    }
}
