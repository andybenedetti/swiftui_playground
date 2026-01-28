import SwiftUI

struct SubmitActionsPlayground: View {
    @State private var searchText = ""
    @State private var username = ""
    @State private var password = ""
    @State private var submittedValues: [String] = []
    @State private var submitLabel = SubmitLabelOption.done
    @State private var showSubmitScope = false

    @FocusState private var focusedField: FormField?

    enum FormField: Hashable {
        case search
        case username
        case password
    }

    enum SubmitLabelOption: String, CaseIterable {
        case done = "Done"
        case go = "Go"
        case send = "Send"
        case search = "Search"
        case next = "Next"
        case continuee = "Continue"
        case join = "Join"
        case route = "Route"
        case returnKey = "Return"

        var submitLabel: SubmitLabel {
            switch self {
            case .done: .done
            case .go: .go
            case .send: .send
            case .search: .search
            case .next: .next
            case .continuee: .continue
            case .join: .join
            case .route: .route
            case .returnKey: .return
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "Submit Actions",
            description: "Handle keyboard submit with onSubmit and customize the return key with submitLabel. iOS 15+",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/view/onsubmit(of:_:)")!,
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
            // Search example
            VStack(alignment: .leading, spacing: 8) {
                Label("Search Field", systemImage: "magnifyingglass")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextField("Search...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .search)
                    .submitLabel(.search)
                    .onSubmit {
                        submitValue("Search: \(searchText)")
                        searchText = ""
                    }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            // Login form example
            VStack(alignment: .leading, spacing: 12) {
                Label("Login Form", systemImage: "person.badge.key")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .username)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .password)
                    .submitLabel(submitLabel.submitLabel)
                    .onSubmit {
                        submitValue("Login: \(username)")
                        username = ""
                        password = ""
                        focusedField = nil
                    }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            // Submitted values log
            if !submittedValues.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Submitted:")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ForEach(submittedValues.suffix(3), id: \.self) { value in
                        Text("• \(value)")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }

    private func submitValue(_ value: String) {
        submittedValues.append(value)
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Password Submit Label",
                selection: $submitLabel,
                options: SubmitLabelOption.allCases,
                optionLabel: { $0.rawValue }
            )

            if !submittedValues.isEmpty {
                Button("Clear History") {
                    submittedValues.removeAll()
                }
                .buttonStyle(.bordered)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Try typing and pressing return/submit to see onSubmit in action.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var generatedCode: String {
        """
        struct SearchView: View {
            @State private var query = ""
            @State private var username = ""
            @State private var password = ""
            @FocusState private var focused: Field?

            var body: some View {
                VStack {
                    // Search with .search submit label
                    TextField("Search...", text: $query)
                        .submitLabel(.search)
                        .onSubmit {
                            performSearch(query)
                        }

                    // Form with field navigation
                    TextField("Username", text: $username)
                        .focused($focused, equals: .username)
                        .submitLabel(.next)
                        .onSubmit { focused = .password }

                    SecureField("Password", text: $password)
                        .focused($focused, equals: .password)
                        .submitLabel(.\(submitLabel.rawValue.lowercased()))
                        .onSubmit { login() }
                }
            }
        }

        // Available submit labels:
        // .done, .go, .send, .search
        // .next, .continue, .join, .route, .return
        """
    }
}

#Preview {
    NavigationStack {
        SubmitActionsPlayground()
    }
}
