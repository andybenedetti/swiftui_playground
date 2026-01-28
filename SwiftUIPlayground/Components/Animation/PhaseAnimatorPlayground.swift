import SwiftUI

struct PhaseAnimatorPlayground: View {
    @State private var isAnimating = false
    @State private var animationType = AnimationType.continuous
    @State private var selectedEffect = EffectType.scale

    enum AnimationType: String, CaseIterable {
        case continuous = "Continuous"
        case triggered = "Triggered"
    }

    enum EffectType: String, CaseIterable {
        case scale = "Scale"
        case rotation = "Rotation"
        case offset = "Offset"
        case combined = "Combined"
    }

    enum Phase: CaseIterable {
        case start, middle, end

        var scale: Double {
            switch self {
            case .start: 1.0
            case .middle: 1.3
            case .end: 1.0
            }
        }

        var rotation: Double {
            switch self {
            case .start: 0
            case .middle: 180
            case .end: 360
            }
        }

        var offset: Double {
            switch self {
            case .start: -50
            case .middle: 0
            case .end: 50
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "PhaseAnimator",
            description: "Cycles through animation phases automatically (iOS 17+).",
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
                switch animationType {
                case .continuous:
                    continuousAnimator
                case .triggered:
                    triggeredAnimator
                }
            }
            .frame(height: 150)

            if animationType == .triggered {
                Button("Trigger Animation") {
                    isAnimating.toggle()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    @ViewBuilder
    private var continuousAnimator: some View {
        PhaseAnimator(Phase.allCases) { phase in
            animatedContent(for: phase)
        } animation: { phase in
            switch phase {
            case .start: .easeIn(duration: 0.4)
            case .middle: .easeOut(duration: 0.4)
            case .end: .easeInOut(duration: 0.4)
            }
        }
    }

    @ViewBuilder
    private var triggeredAnimator: some View {
        PhaseAnimator(Phase.allCases, trigger: isAnimating) { phase in
            animatedContent(for: phase)
        } animation: { phase in
            switch phase {
            case .start: .easeIn(duration: 0.3)
            case .middle: .easeOut(duration: 0.3)
            case .end: .easeInOut(duration: 0.3)
            }
        }
    }

    @ViewBuilder
    private func animatedContent(for phase: Phase) -> some View {
        let content = RoundedRectangle(cornerRadius: 16)
            .fill(LinearGradient(
                colors: [.indigo, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .frame(width: 100, height: 100)
            .overlay {
                Image(systemName: "sparkles")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
            }

        switch selectedEffect {
        case .scale:
            content.scaleEffect(phase.scale)
        case .rotation:
            content.rotationEffect(.degrees(phase.rotation))
        case .offset:
            content.offset(x: phase.offset)
        case .combined:
            content
                .scaleEffect(phase.scale)
                .rotationEffect(.degrees(phase.rotation * 0.5))
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Type",
                selection: $animationType,
                options: AnimationType.allCases,
                optionLabel: { $0.rawValue }
            )

            PickerControl(
                label: "Effect",
                selection: $selectedEffect,
                options: EffectType.allCases,
                optionLabel: { $0.rawValue }
            )
        }
    }

    private var generatedCode: String {
        let effectCode: String
        switch selectedEffect {
        case .scale:
            effectCode = ".scaleEffect(phase.scale)"
        case .rotation:
            effectCode = ".rotationEffect(.degrees(phase.rotation))"
        case .offset:
            effectCode = ".offset(x: phase.offset)"
        case .combined:
            effectCode = """
            .scaleEffect(phase.scale)
                        .rotationEffect(.degrees(phase.rotation))
            """
        }

        if animationType == .continuous {
            return """
            // Continuous phase animation (iOS 17+)
            enum Phase: CaseIterable {
                case start, middle, end

                var scale: Double {
                    switch self {
                    case .start: 1.0
                    case .middle: 1.3
                    case .end: 1.0
                    }
                }
            }

            PhaseAnimator(Phase.allCases) { phase in
                RoundedRectangle(cornerRadius: 16)
                    \(effectCode)
            } animation: { phase in
                .easeInOut(duration: 0.4)
            }
            """
        } else {
            return """
            // Triggered phase animation (iOS 17+)
            @State private var trigger = false

            PhaseAnimator(Phase.allCases, trigger: trigger) { phase in
                RoundedRectangle(cornerRadius: 16)
                    \(effectCode)
            } animation: { _ in
                .easeInOut(duration: 0.3)
            }

            Button("Animate") {
                trigger.toggle()
            }
            """
        }
    }
}

#Preview {
    NavigationStack {
        PhaseAnimatorPlayground()
    }
}
