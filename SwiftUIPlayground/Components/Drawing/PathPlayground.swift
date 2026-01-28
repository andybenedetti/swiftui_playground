import SwiftUI

struct PathPlayground: View {
    @State private var pathType = PathType.lines
    @State private var strokeWidth: Double = 3
    @State private var fillPath = false
    @State private var strokeColor: Color = .blue

    enum PathType: String, CaseIterable {
        case lines = "Lines"
        case curves = "Curves"
        case arc = "Arc"
        case star = "Star"
    }

    var body: some View {
        ComponentPage(
            title: "Path",
            description: "Draw custom shapes with lines, curves, and arcs.",
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
            pathView
                .frame(width: 200, height: 200)
        }
        .frame(height: 220)
    }

    @ViewBuilder
    private var pathView: some View {
        if fillPath {
            currentPath
                .fill(strokeColor)
        } else {
            currentPath
                .stroke(strokeColor, lineWidth: strokeWidth)
        }
    }

    private var currentPath: Path {
        switch pathType {
        case .lines:
            return Path { path in
                path.move(to: CGPoint(x: 20, y: 180))
                path.addLine(to: CGPoint(x: 100, y: 20))
                path.addLine(to: CGPoint(x: 180, y: 180))
                path.closeSubpath()
            }
        case .curves:
            return Path { path in
                path.move(to: CGPoint(x: 20, y: 100))
                path.addQuadCurve(
                    to: CGPoint(x: 180, y: 100),
                    control: CGPoint(x: 100, y: 20)
                )
                path.addQuadCurve(
                    to: CGPoint(x: 20, y: 100),
                    control: CGPoint(x: 100, y: 180)
                )
            }
        case .arc:
            return Path { path in
                path.addArc(
                    center: CGPoint(x: 100, y: 100),
                    radius: 80,
                    startAngle: .degrees(0),
                    endAngle: .degrees(270),
                    clockwise: false
                )
            }
        case .star:
            return starPath(points: 5, innerRadius: 40, outerRadius: 90, center: CGPoint(x: 100, y: 100))
        }
    }

    private func starPath(points: Int, innerRadius: CGFloat, outerRadius: CGFloat, center: CGPoint) -> Path {
        Path { path in
            let angleIncrement = .pi * 2 / CGFloat(points * 2)
            for i in 0..<(points * 2) {
                let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
                let angle = angleIncrement * CGFloat(i) - .pi / 2
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

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Shape",
                selection: $pathType,
                options: PathType.allCases,
                optionLabel: { $0.rawValue }
            )

            ToggleControl(label: "Fill", isOn: $fillPath)

            if !fillPath {
                SliderControl(
                    label: "Stroke Width",
                    value: $strokeWidth,
                    range: 1...10,
                    format: "%.0fpt"
                )
            }

            ColorControl(label: "Color", color: $strokeColor)
        }
    }

    private var generatedCode: String {
        switch pathType {
        case .lines:
            if fillPath {
                return """
                // Triangle path with fill
                Path { path in
                    path.move(to: CGPoint(x: 20, y: 180))
                    path.addLine(to: CGPoint(x: 100, y: 20))
                    path.addLine(to: CGPoint(x: 180, y: 180))
                    path.closeSubpath()
                }
                .fill(.blue)
                """
            } else {
                return """
                // Triangle path with stroke
                Path { path in
                    path.move(to: CGPoint(x: 20, y: 180))
                    path.addLine(to: CGPoint(x: 100, y: 20))
                    path.addLine(to: CGPoint(x: 180, y: 180))
                    path.closeSubpath()
                }
                .stroke(.blue, lineWidth: \(Int(strokeWidth)))
                """
            }
        case .curves:
            return """
            // Bezier curves
            Path { path in
                path.move(to: CGPoint(x: 20, y: 100))
                path.addQuadCurve(
                    to: CGPoint(x: 180, y: 100),
                    control: CGPoint(x: 100, y: 20)
                )
                path.addQuadCurve(
                    to: CGPoint(x: 20, y: 100),
                    control: CGPoint(x: 100, y: 180)
                )
            }
            .\(fillPath ? "fill" : "stroke")(.blue\(fillPath ? "" : ", lineWidth: \(Int(strokeWidth))"))
            """
        case .arc:
            return """
            // Arc path
            Path { path in
                path.addArc(
                    center: CGPoint(x: 100, y: 100),
                    radius: 80,
                    startAngle: .degrees(0),
                    endAngle: .degrees(270),
                    clockwise: false
                )
            }
            .\(fillPath ? "fill" : "stroke")(.blue\(fillPath ? "" : ", lineWidth: \(Int(strokeWidth))"))
            """
        case .star:
            return """
            // Star shape using calculated points
            func starPath(points: Int, innerRadius: CGFloat,
                         outerRadius: CGFloat, center: CGPoint) -> Path {
                Path { path in
                    let angleIncrement = .pi * 2 / CGFloat(points * 2)
                    for i in 0..<(points * 2) {
                        let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
                        let angle = angleIncrement * CGFloat(i) - .pi / 2
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
            """
        }
    }
}

#Preview {
    NavigationStack {
        PathPlayground()
    }
}
