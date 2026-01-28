import SwiftUI

struct EnvironmentPlayground: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.locale) private var locale
    @Environment(\.calendar) private var calendar
    @Environment(\.dismiss) private var dismiss

    @State private var showSystemValues = true
    @State private var showDismissExample = false

    var body: some View {
        ComponentPage(
            title: "@Environment",
            description: "A property wrapper that reads values from the SwiftUI environment. iOS 13+",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/environment")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 16) {
            if showSystemValues {
                // System environment values
                VStack(spacing: 12) {
                    Label("System Environment Values", systemImage: "gearshape")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
                        GridRow {
                            Text("Color Scheme:")
                                .foregroundStyle(.secondary)
                            Text(colorScheme == .dark ? "Dark" : "Light")
                                .fontWeight(.medium)
                            Image(systemName: colorScheme == .dark ? "moon.fill" : "sun.max.fill")
                                .foregroundStyle(colorScheme == .dark ? .purple : .orange)
                        }

                        GridRow {
                            Text("Dynamic Type:")
                                .foregroundStyle(.secondary)
                            Text(dynamicTypeSize.description)
                                .fontWeight(.medium)
                            Image(systemName: "textformat.size")
                        }

                        GridRow {
                            Text("Size Class:")
                                .foregroundStyle(.secondary)
                            Text("\(horizontalSizeClass == .compact ? "Compact" : "Regular") × \(verticalSizeClass == .compact ? "Compact" : "Regular")")
                                .fontWeight(.medium)
                            Image(systemName: "rectangle.split.2x2")
                        }

                        GridRow {
                            Text("Locale:")
                                .foregroundStyle(.secondary)
                            Text(locale.identifier)
                                .fontWeight(.medium)
                            Image(systemName: "globe")
                        }

                        GridRow {
                            Text("Calendar:")
                                .foregroundStyle(.secondary)
                            Text(calendar.identifier.debugDescription)
                                .fontWeight(.medium)
                            Image(systemName: "calendar")
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }

            if showDismissExample {
                VStack(spacing: 12) {
                    Label("Dismiss Action", systemImage: "xmark.circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("@Environment(\\.dismiss) provides a dismiss action for sheets and navigation.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Button("Dismiss (no effect here)") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Show System Values", isOn: $showSystemValues)
            ToggleControl(label: "Show Dismiss Example", isOn: $showDismissExample)

            VStack(alignment: .leading, spacing: 4) {
                Text("Environment values are injected by SwiftUI and parent views.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var generatedCode: String {
        var code = """
        struct MyView: View {
            // Read system environment values
            @Environment(\\.colorScheme) private var colorScheme
            @Environment(\\.dynamicTypeSize) private var dynamicTypeSize
            @Environment(\\.horizontalSizeClass) private var sizeClass
        """

        if showDismissExample {
            code += """

            @Environment(\\.dismiss) private var dismiss
        """
        }

        code += """


            var body: some View {
                VStack {
                    if colorScheme == .dark {
                        Text("Dark mode")
                    }

                    if sizeClass == .compact {
                        Text("Compact width")
                    }
        """

        if showDismissExample {
            code += """

                    Button("Close") { dismiss() }
        """
        }

        code += """

                }
            }
        }
        """

        return code
    }
}

extension DynamicTypeSize {
    var description: String {
        switch self {
        case .xSmall: return "xSmall"
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        case .xLarge: return "xLarge"
        case .xxLarge: return "xxLarge"
        case .xxxLarge: return "xxxLarge"
        case .accessibility1: return "accessibility1"
        case .accessibility2: return "accessibility2"
        case .accessibility3: return "accessibility3"
        case .accessibility4: return "accessibility4"
        case .accessibility5: return "accessibility5"
        @unknown default: return "Unknown"
        }
    }
}

#Preview {
    NavigationStack {
        EnvironmentPlayground()
    }
}
