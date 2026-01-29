import SwiftUI

struct AccessibilityValuePlayground: View {
    // MARK: - State
    @State private var rating = 3
    @State private var volume: Double = 0.7
    @State private var useCustomValue = true

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "accessibilityValue",
            description: "Communicates the current value of a view to assistive technologies.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/view/accessibilityvalue(_:)-3x4e1")!,
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
        VStack(spacing: 30) {
            VStack(spacing: 12) {
                Text("Custom Rating Control")
                    .font(.headline)

                HStack(spacing: 8) {
                    ForEach(1...5, id: \.self) { star in
                        Button {
                            rating = star
                        } label: {
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .font(.title)
                                .foregroundStyle(star <= rating ? .yellow : .gray)
                        }
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Rating")
                .accessibilityValue(useCustomValue ? "\(rating) out of 5 stars" : "")
                .accessibilityAdjustableAction { direction in
                    switch direction {
                    case .increment:
                        rating = min(5, rating + 1)
                    case .decrement:
                        rating = max(1, rating - 1)
                    @unknown default:
                        break
                    }
                }
            }

            VStack(spacing: 12) {
                Text("Volume Control")
                    .font(.headline)

                HStack {
                    Image(systemName: "speaker.fill")
                    Slider(value: $volume, in: 0...1)
                    Image(systemName: "speaker.wave.3.fill")
                }
                .padding(.horizontal)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Volume")
                .accessibilityValue(useCustomValue ? "\(Int(volume * 100)) percent" : "")
            }

            VStack(spacing: 8) {
                Text("VoiceOver reads:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Rating: \"\(rating) out of 5 stars\"")
                    Text("Volume: \"\(Int(volume * 100)) percent\"")
                }
                .font(.caption.monospaced())
                .foregroundStyle(.blue)
            }
            .padding()
            .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            SliderControl(
                label: "Rating",
                value: Binding(get: { Double(rating) }, set: { rating = Int($0) }),
                range: 1...5,
                format: "%.0f"
            )

            SliderControl(
                label: "Volume",
                value: $volume,
                range: 0...1,
                format: "%.2f"
            )

            ToggleControl(label: "Use Custom Value", isOn: $useCustomValue)

            Text("accessibilityValue tells VoiceOver the current state of custom controls that don't use standard SwiftUI components.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        """
        // Star rating with accessibility value
        HStack {
            ForEach(1...5, id: \\.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Rating")
        .accessibilityValue("\(rating) out of 5 stars")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                rating = min(5, rating + 1)
            case .decrement:
                rating = max(1, rating - 1)
            @unknown default: break
            }
        }
        """
    }
}

#Preview {
    NavigationStack {
        AccessibilityValuePlayground()
    }
}
