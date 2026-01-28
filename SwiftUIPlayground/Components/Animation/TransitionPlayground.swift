import SwiftUI

struct TransitionPlayground: View {
    @State private var isVisible = true
    @State private var selectedTransition = TransitionType.slide
    @State private var duration: Double = 0.5

    enum TransitionType: String, CaseIterable {
        case slide = "Slide"
        case opacity = "Opacity"
        case scale = "Scale"
        case moveTop = "Move (Top)"
        case moveBottom = "Move (Bottom)"
        case push = "Push"
        case combined = "Combined"
        case asymmetric = "Asymmetric"
    }

    var body: some View {
        ComponentPage(
            title: "Transition",
            description: "Animates views as they appear and disappear.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 24) {
            ZStack {
                if isVisible {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [.green, .mint],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 120, height: 120)
                        .overlay {
                            Image(systemName: "star.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                        }
                        .transition(transition)
                }
            }
            .frame(height: 150)
            .animation(.easeInOut(duration: duration), value: isVisible)

            Button(isVisible ? "Hide" : "Show") {
                isVisible.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var transition: AnyTransition {
        switch selectedTransition {
        case .slide:
            return .slide
        case .opacity:
            return .opacity
        case .scale:
            return .scale
        case .moveTop:
            return .move(edge: .top)
        case .moveBottom:
            return .move(edge: .bottom)
        case .push:
            return .push(from: .leading)
        case .combined:
            return .scale.combined(with: .opacity)
        case .asymmetric:
            return .asymmetric(insertion: .scale, removal: .opacity)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Transition",
                selection: $selectedTransition,
                options: TransitionType.allCases,
                optionLabel: { $0.rawValue }
            )

            SliderControl(
                label: "Duration",
                value: $duration,
                range: 0.2...2.0,
                format: "%.1fs"
            )
        }
    }

    private var generatedCode: String {
        let transitionCode: String
        switch selectedTransition {
        case .slide:
            transitionCode = ".slide"
        case .opacity:
            transitionCode = ".opacity"
        case .scale:
            transitionCode = ".scale"
        case .moveTop:
            transitionCode = ".move(edge: .top)"
        case .moveBottom:
            transitionCode = ".move(edge: .bottom)"
        case .push:
            transitionCode = ".push(from: .leading)"
        case .combined:
            transitionCode = ".scale.combined(with: .opacity)"
        case .asymmetric:
            transitionCode = ".asymmetric(insertion: .scale, removal: .opacity)"
        }

        return """
        // Transition animates view appearance/disappearance
        @State private var isVisible = true

        if isVisible {
            RoundedRectangle(cornerRadius: 16)
                .transition(\(transitionCode))
        }
        .animation(.easeInOut(duration: \(String(format: "%.1f", duration))), value: isVisible)

        Button("Toggle") {
            isVisible.toggle()
        }
        """
    }
}

#Preview {
    NavigationStack {
        TransitionPlayground()
    }
}
