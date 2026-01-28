import SwiftUI

struct FormPlayground: View {
    @State private var name = ""
    @State private var email = ""
    @State private var enableNotifications = true
    @State private var volume: Double = 50
    @State private var selectedColor = "Blue"
    @State private var showSections = true

    private let colorOptions = ["Blue", "Green", "Red", "Purple"]

    var body: some View {
        ComponentPage(
            title: "Form",
            description: "A container for grouping controls used for data entry.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        Group {
            if showSections {
                formWithSections
            } else {
                simpleForm
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    @ViewBuilder
    private var simpleForm: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Email", text: $email)
            Toggle("Notifications", isOn: $enableNotifications)
            Slider(value: $volume, in: 0...100)
            Picker("Color", selection: $selectedColor) {
                ForEach(colorOptions, id: \.self) { color in
                    Text(color)
                }
            }
        }
    }

    @ViewBuilder
    private var formWithSections: some View {
        Form {
            Section("Personal Info") {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
            }

            Section("Preferences") {
                Toggle("Notifications", isOn: $enableNotifications)
                Slider(value: $volume, in: 0...100) {
                    Text("Volume")
                }
                Picker("Theme Color", selection: $selectedColor) {
                    ForEach(colorOptions, id: \.self) { color in
                        Text(color)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Show Sections", isOn: $showSections)

            Text("The form above is interactive - try the controls!")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var generatedCode: String {
        if showSections {
            return """
            // Form with sections
            @State private var name = ""
            @State private var email = ""
            @State private var enableNotifications = true
            @State private var volume = 50.0
            @State private var selectedColor = "Blue"

            Form {
                Section("Personal Info") {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                }

                Section("Preferences") {
                    Toggle("Notifications", isOn: $enableNotifications)
                    Slider(value: $volume, in: 0...100) {
                        Text("Volume")
                    }
                    Picker("Theme Color", selection: $selectedColor) {
                        ForEach(colorOptions, id: \\.self) { color in
                            Text(color)
                        }
                    }
                }
            }
            """
        } else {
            return """
            // Simple form
            @State private var name = ""
            @State private var email = ""
            @State private var enableNotifications = true

            Form {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                Toggle("Notifications", isOn: $enableNotifications)
            }
            """
        }
    }
}

#Preview {
    NavigationStack {
        FormPlayground()
    }
}
