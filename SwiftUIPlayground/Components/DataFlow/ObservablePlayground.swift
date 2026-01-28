import SwiftUI

@Observable
private class UserProfile {
    var name = "John"
    var age = 25
    var isVerified = false
}

struct ObservablePlayground: View {
    @State private var profile = UserProfile()
    @State private var showComparison = false

    var body: some View {
        ComponentPage(
            title: "@Observable",
            description: "A macro that makes a class observable, automatically tracking property access. iOS 17+",
            documentationURL: URL(string: "https://developer.apple.com/documentation/observation/observable()")!,
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
            // Model display
            VStack(spacing: 12) {
                Label("Observable Model", systemImage: "eye")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Name:")
                            .foregroundStyle(.secondary)
                        Text(profile.name)
                            .fontWeight(.medium)
                    }

                    HStack {
                        Text("Age:")
                            .foregroundStyle(.secondary)
                        Text("\(profile.age)")
                            .fontWeight(.medium)
                    }

                    HStack {
                        Text("Verified:")
                            .foregroundStyle(.secondary)
                        Image(systemName: profile.isVerified ? "checkmark.circle.fill" : "xmark.circle")
                            .foregroundStyle(profile.isVerified ? .green : .red)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(12)

            // Edit controls
            VStack(spacing: 12) {
                Label("Edit Model", systemImage: "pencil")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextField("Name", text: $profile.name)
                    .textFieldStyle(.roundedBorder)

                Stepper("Age: \(profile.age)", value: $profile.age, in: 0...120)

                Toggle("Verified", isOn: $profile.isVerified)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)

            if showComparison {
                VStack(alignment: .leading, spacing: 8) {
                    Text("iOS 17+ @Observable vs older @ObservableObject:")
                        .font(.caption)
                        .fontWeight(.medium)

                    Text("• No @Published needed - all properties auto-tracked")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("• Use @State instead of @StateObject")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("• More efficient - only re-renders when accessed properties change")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Show Comparison", isOn: $showComparison)

            VStack(alignment: .leading, spacing: 4) {
                Text("The view automatically updates when any accessed property changes.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var generatedCode: String {
        var code = """
        import SwiftUI

        @Observable
        class UserProfile {
            var name = "John"
            var age = 25
            var isVerified = false
        }

        struct ProfileView: View {
            @State private var profile = UserProfile()

            var body: some View {
                VStack {
                    // Reading properties
                    Text(profile.name)
                    Text("Age: \\(profile.age)")

                    // Binding to properties
                    TextField("Name", text: $profile.name)
                    Toggle("Verified", isOn: $profile.isVerified)
                }
            }
        }
        """

        if showComparison {
            code += """


        // Old way (iOS 13-16):
        // class UserProfile: ObservableObject {
        //     @Published var name = "John"
        // }
        // @StateObject private var profile = UserProfile()
        """
        }

        return code
    }
}

#Preview {
    NavigationStack {
        ObservablePlayground()
    }
}
