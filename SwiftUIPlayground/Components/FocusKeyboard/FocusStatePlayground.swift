import SwiftUI

struct FocusStatePlayground: View {
    enum Field: Hashable {
        case username
        case email
        case password
    }

    @FocusState private var focusedField: Field?
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showFieldIndicator = true

    var body: some View {
        ComponentPage(
            title: "@FocusState",
            description: "A property wrapper that controls focus state for text fields and other focusable views. iOS 15+",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/focusstate")!,
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
            // Form fields
            VStack(spacing: 12) {
                fieldRow(title: "Username", text: $username, field: .username)
                fieldRow(title: "Email", text: $email, field: .email)
                fieldRow(title: "Password", text: $password, field: .password, isSecure: true)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            // Navigation buttons
            HStack(spacing: 16) {
                Button("Previous") {
                    moveFocus(forward: false)
                }
                .buttonStyle(.bordered)
                .disabled(focusedField == .username || focusedField == nil)

                Button("Next") {
                    moveFocus(forward: true)
                }
                .buttonStyle(.bordered)
                .disabled(focusedField == .password || focusedField == nil)

                Button("Done") {
                    focusedField = nil
                }
                .buttonStyle(.borderedProminent)
            }

            if showFieldIndicator {
                Text("Focused: \(focusedFieldName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private func fieldRow(title: String, text: Binding<String>, field: Field, isSecure: Bool = false) -> some View {
        HStack {
            Text(title)
                .frame(width: 80, alignment: .leading)

            if isSecure {
                SecureField(title, text: text)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: field)
            } else {
                TextField(title, text: text)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: field)
            }

            if focusedField == field {
                Image(systemName: "arrow.left")
                    .foregroundStyle(.blue)
            }
        }
    }

    private var focusedFieldName: String {
        switch focusedField {
        case .username: return "Username"
        case .email: return "Email"
        case .password: return "Password"
        case nil: return "None"
        }
    }

    private func moveFocus(forward: Bool) {
        switch focusedField {
        case .username:
            focusedField = forward ? .email : .username
        case .email:
            focusedField = forward ? .password : .username
        case .password:
            focusedField = forward ? .password : .email
        case nil:
            focusedField = .username
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Show Focus Indicator", isOn: $showFieldIndicator)

            VStack(alignment: .leading, spacing: 8) {
                Text("Focus Controls:")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    Button("Username") { focusedField = .username }
                    Button("Email") { focusedField = .email }
                    Button("Password") { focusedField = .password }
                }
                .buttonStyle(.bordered)
                .font(.caption)
            }
        }
    }

    private var generatedCode: String {
        """
        struct LoginForm: View {
            enum Field: Hashable {
                case username, email, password
            }

            @FocusState private var focusedField: Field?
            @State private var username = ""
            @State private var email = ""

            var body: some View {
                Form {
                    TextField("Username", text: $username)
                        .focused($focusedField, equals: .username)

                    TextField("Email", text: $email)
                        .focused($focusedField, equals: .email)

                    SecureField("Password", text: $password)
                        .focused($focusedField, equals: .password)

                    Button("Next Field") {
                        // Programmatically move focus
                        switch focusedField {
                        case .username: focusedField = .email
                        case .email: focusedField = .password
                        default: focusedField = nil
                        }
                    }
                }
            }
        }
        """
    }
}

#Preview {
    NavigationStack {
        FocusStatePlayground()
    }
}
