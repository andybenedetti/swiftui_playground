import SwiftUI

struct DisclosureGroupPlayground: View {
    @State private var isExpanded = true
    @State private var labelText = "Settings"
    @State private var useSystemImage = true
    @State private var systemImageName = "gear"
    @State private var showNestedGroup = false
    @State private var nestedExpanded = false
    @State private var tintColor = Color.blue

    var body: some View {
        ComponentPage(
            title: "DisclosureGroup",
            description: "A view that shows or hides content based on a disclosure control.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            DisclosureGroup(isExpanded: $isExpanded) {
                VStack(alignment: .leading, spacing: 12) {
                    Label("Profile", systemImage: "person")
                    Label("Notifications", systemImage: "bell")
                    Label("Privacy", systemImage: "lock")

                    if showNestedGroup {
                        DisclosureGroup("Advanced", isExpanded: $nestedExpanded) {
                            Label("Developer Mode", systemImage: "hammer")
                            Label("Debug Options", systemImage: "ant")
                        }
                        .tint(tintColor)
                    }
                }
                .padding(.leading, 4)
            } label: {
                if useSystemImage {
                    Label(labelText, systemImage: systemImageName)
                } else {
                    Text(labelText)
                }
            }
            .tint(tintColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Expanded", isOn: $isExpanded)

            TextFieldControl(label: "Label", text: $labelText)

            ToggleControl(label: "Show Icon", isOn: $useSystemImage)

            if useSystemImage {
                TextFieldControl(label: "SF Symbol", text: $systemImageName)
            }

            ToggleControl(label: "Nested Group", isOn: $showNestedGroup)

            ColorControl(label: "Tint Color", color: $tintColor)
        }
    }

    private var generatedCode: String {
        var code = """
        // DisclosureGroup with controlled expansion
        @State private var isExpanded = \(isExpanded)

        DisclosureGroup(isExpanded: $isExpanded) {
            // Content shown when expanded
        """

        if showNestedGroup {
            code += """

            Label("Profile", systemImage: "person")
            Label("Notifications", systemImage: "bell")

            // Nested disclosure group
            DisclosureGroup("Advanced", isExpanded: $nestedExpanded) {
                Label("Developer Mode", systemImage: "hammer")
            }
        """
        } else {
            code += """

            Label("Profile", systemImage: "person")
            Label("Notifications", systemImage: "bell")
            Label("Privacy", systemImage: "lock")
        """
        }

        code += "\n} label: {\n"

        if useSystemImage {
            code += "    Label(\"\(labelText)\", systemImage: \"\(systemImageName)\")\n}"
        } else {
            code += "    Text(\"\(labelText)\")\n}"
        }

        if tintColor != .blue {
            code += "\n.tint(\(colorToCode(tintColor)))"
        }

        return code
    }

    private func colorToCode(_ color: Color) -> String {
        if color == .blue { return ".blue" }
        if color == .red { return ".red" }
        if color == .green { return ".green" }
        if color == .orange { return ".orange" }
        if color == .purple { return ".purple" }
        if color == .pink { return ".pink" }
        return "Color(...)"
    }
}

#Preview {
    NavigationStack {
        DisclosureGroupPlayground()
    }
}
