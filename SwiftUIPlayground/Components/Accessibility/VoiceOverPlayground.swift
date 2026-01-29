import SwiftUI

struct VoiceOverPlayground: View {
    // MARK: - State
    @State private var selectedTrait: TraitOption = .isButton
    @State private var combineChildren = true
    @State private var sortPriority: Double = 1.0
    @State private var isHidden = false

    enum TraitOption: String, CaseIterable {
        case isButton = "Button"
        case isHeader = "Header"
        case isImage = "Image"
        case isLink = "Link"
        case isSearchField = "Search Field"
        case isStaticText = "Static Text"
        case playsSound = "Plays Sound"
        case startsMediaSession = "Starts Media"
        case isToggle = "Toggle"

        var trait: AccessibilityTraits {
            switch self {
            case .isButton: .isButton
            case .isHeader: .isHeader
            case .isImage: .isImage
            case .isLink: .isLink
            case .isSearchField: .isSearchField
            case .isStaticText: .isStaticText
            case .playsSound: .playsSound
            case .startsMediaSession: .startsMediaSession
            case .isToggle: .isToggle
            }
        }

        var codeName: String {
            switch self {
            case .isButton: ".isButton"
            case .isHeader: ".isHeader"
            case .isImage: ".isImage"
            case .isLink: ".isLink"
            case .isSearchField: ".isSearchField"
            case .isStaticText: ".isStaticText"
            case .playsSound: ".playsSound"
            case .startsMediaSession: ".startsMediaSession"
            case .isToggle: ".isToggle"
            }
        }
    }

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "VoiceOver",
            description: "Control how VoiceOver presents views using traits, element grouping, sort priority, and hidden elements.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/view-accessibility")!,
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
        VStack(spacing: 24) {
            // Traits example
            VStack(spacing: 8) {
                Text("Accessibility Traits")
                    .font(.headline)

                Text("Custom Element")
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blue.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
                    .accessibilityAddTraits(selectedTrait.trait)
                    .accessibilityLabel("Custom Element")

                Text("Trait: \(selectedTrait.rawValue)")
                    .font(.caption.monospaced())
                    .foregroundStyle(.blue)
            }

            // Combine children example
            VStack(spacing: 8) {
                Text("Element Grouping")
                    .font(.headline)

                HStack(spacing: 12) {
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                        .foregroundStyle(.blue)
                    VStack(alignment: .leading) {
                        Text("John Doe")
                            .font(.body.bold())
                        Text("Software Engineer")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .background(.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                .accessibilityElement(children: combineChildren ? .combine : .contain)

                Text(combineChildren ? "Children combined into one element" : "Children are separate elements")
                    .font(.caption.monospaced())
                    .foregroundStyle(.blue)
            }

            // Hidden example
            VStack(spacing: 8) {
                Text("Hidden from VoiceOver")
                    .font(.headline)

                HStack(spacing: 16) {
                    Image(systemName: "star.fill")
                        .font(.title)
                        .foregroundStyle(.yellow)
                        .accessibilityHidden(isHidden)

                    Text(isHidden ? "Decorative (hidden)" : "Visible to VoiceOver")
                        .font(.body)
                }
                .padding()
                .background(.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Trait",
                selection: $selectedTrait,
                options: TraitOption.allCases,
                optionLabel: { $0.rawValue }
            )

            ToggleControl(label: "Combine Children", isOn: $combineChildren)

            ToggleControl(label: "Hide Decorative Image", isOn: $isHidden)

            Text("Traits tell VoiceOver what kind of element it is. Grouping controls whether children are read as one element or separately.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        """
        // Add accessibility traits
        Text("Custom Element")
            .accessibilityAddTraits(\(selectedTrait.codeName))

        // Group child elements
        HStack {
            Image(systemName: "person.circle.fill")
            VStack {
                Text("John Doe")
                Text("Software Engineer")
            }
        }
        .accessibilityElement(children: \(combineChildren ? ".combine" : ".contain"))

        // Hide decorative elements
        Image(systemName: "star.fill")
            .accessibilityHidden(\(isHidden))
        """
    }
}

#Preview {
    NavigationStack {
        VoiceOverPlayground()
    }
}
