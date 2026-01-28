import SwiftUI

struct AppStoragePlayground: View {
    @AppStorage("username") private var username = "Guest"
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("fontSize") private var fontSize = 16.0
    @AppStorage("selectedTheme") private var selectedTheme = "System"

    @State private var showPersistenceNote = true

    private let themeOptions = ["System", "Light", "Dark"]

    var body: some View {
        ComponentPage(
            title: "@AppStorage",
            description: "A property wrapper that reads and writes to UserDefaults, persisting across app launches. iOS 14+",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/appstorage")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 20) {
            // Current values display
            VStack(spacing: 12) {
                Label("Persisted Values", systemImage: "externaldrive")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Username:")
                            .foregroundStyle(.secondary)
                        Text(username)
                            .fontWeight(.medium)
                    }

                    HStack {
                        Text("Notifications:")
                            .foregroundStyle(.secondary)
                        Image(systemName: notificationsEnabled ? "bell.fill" : "bell.slash")
                            .foregroundStyle(notificationsEnabled ? .blue : .gray)
                        Text(notificationsEnabled ? "Enabled" : "Disabled")
                            .fontWeight(.medium)
                    }

                    HStack {
                        Text("Font Size:")
                            .foregroundStyle(.secondary)
                        Text("\(Int(fontSize))pt")
                            .fontWeight(.medium)
                    }

                    HStack {
                        Text("Theme:")
                            .foregroundStyle(.secondary)
                        Text(selectedTheme)
                            .fontWeight(.medium)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(12)

            // Edit controls
            VStack(spacing: 16) {
                Label("Edit & Persist", systemImage: "pencil")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)

                Toggle("Notifications", isOn: $notificationsEnabled)

                VStack(alignment: .leading) {
                    Text("Font Size: \(Int(fontSize))pt")
                        .font(.caption)
                    Slider(value: $fontSize, in: 12...24, step: 1)
                }

                Picker("Theme", selection: $selectedTheme) {
                    ForEach(themeOptions, id: \.self) { theme in
                        Text(theme).tag(theme)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)

            if showPersistenceNote {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.orange)
                    Text("Changes persist in UserDefaults. Quit and reopen the app to verify!")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Show Persistence Note", isOn: $showPersistenceNote)

            Button("Reset to Defaults") {
                username = "Guest"
                notificationsEnabled = true
                fontSize = 16.0
                selectedTheme = "System"
            }
            .buttonStyle(.bordered)
        }
    }

    private var generatedCode: String {
        """
        struct SettingsView: View {
            // Each key maps to UserDefaults
            @AppStorage("username") private var username = "Guest"
            @AppStorage("notificationsEnabled") private var notificationsEnabled = true
            @AppStorage("fontSize") private var fontSize = 16.0
            @AppStorage("selectedTheme") private var selectedTheme = "System"

            var body: some View {
                Form {
                    // Values auto-persist when changed
                    TextField("Username", text: $username)
                    Toggle("Notifications", isOn: $notificationsEnabled)
                    Slider(value: $fontSize, in: 12...24)

                    Picker("Theme", selection: $selectedTheme) {
                        Text("System").tag("System")
                        Text("Light").tag("Light")
                        Text("Dark").tag("Dark")
                    }
                }
            }
        }

        // Access same key from anywhere:
        // @AppStorage("username") var username
        // UserDefaults.standard.string(forKey: "username")
        """
    }
}

#Preview {
    NavigationStack {
        AppStoragePlayground()
    }
}
