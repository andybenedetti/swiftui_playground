import SwiftUI
import LocalAuthentication

struct BiometricAuthPlayground: View {
    // MARK: - State
    @State private var authResult: AuthResult = .none
    @State private var biometryType: LABiometryType = .none
    @State private var canEvaluate = false
    @State private var evaluateError: String?
    @State private var reason = "Authenticate to continue"
    @State private var policyOption = PolicyOption.biometrics
    @State private var fallbackTitle = "Use Passcode"

    enum PolicyOption: String, CaseIterable {
        case biometrics = "Biometrics Only"
        case biometricsOrPasscode = "Biometrics + Passcode"

        var policy: LAPolicy {
            switch self {
            case .biometrics: .deviceOwnerAuthenticationWithBiometrics
            case .biometricsOrPasscode: .deviceOwnerAuthentication
            }
        }
    }

    enum AuthResult {
        case none, success, failure(String)
    }

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "Biometric Auth",
            description: "Authenticate users with Face ID or Touch ID using LocalAuthentication. Shows biometry availability, type detection, and authentication flow.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/localauthentication/lacontext")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
        .task {
            checkBiometry()
        }
    }

    // MARK: - Preview
    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 20) {
            // Biometry info
            VStack(spacing: 8) {
                Image(systemName: biometryIcon)
                    .font(.system(size: 48))
                    .foregroundStyle(canEvaluate ? .blue : .secondary)

                Text(biometryLabel)
                    .font(.headline)

                Text(canEvaluate ? "Available" : (evaluateError ?? "Not available"))
                    .font(.subheadline)
                    .foregroundStyle(canEvaluate ? .green : .red)
            }
            .padding()

            // Auth button
            Button {
                authenticate()
            } label: {
                Label("Authenticate", systemImage: biometryIcon)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!canEvaluate)
            .padding(.horizontal, 40)

            // Result
            switch authResult {
            case .none:
                EmptyView()
            case .success:
                Label("Authenticated", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.headline)
                    .transition(.scale.combined(with: .opacity))
            case .failure(let message):
                VStack(spacing: 4) {
                    Label("Failed", systemImage: "xmark.circle.fill")
                        .foregroundStyle(.red)
                        .font(.headline)
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.default, value: canEvaluate)
    }

    private var biometryIcon: String {
        switch biometryType {
        case .faceID: "faceid"
        case .touchID: "touchid"
        case .opticID: "opticid"
        default: "lock.shield"
        }
    }

    private var biometryLabel: String {
        switch biometryType {
        case .faceID: "Face ID"
        case .touchID: "Touch ID"
        case .opticID: "Optic ID"
        default: "No Biometrics"
        }
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            TextFieldControl(label: "Reason", text: $reason)

            PickerControl(
                label: "Policy",
                selection: $policyOption,
                options: PolicyOption.allCases,
                optionLabel: { $0.rawValue }
            )

            TextFieldControl(label: "Fallback Title", text: $fallbackTitle)
        }
        .onChange(of: policyOption) {
            checkBiometry()
            authResult = .none
        }
    }

    // MARK: - Auth Logic
    private func checkBiometry() {
        let context = LAContext()
        var error: NSError?
        canEvaluate = context.canEvaluatePolicy(policyOption.policy, error: &error)
        biometryType = context.biometryType
        evaluateError = error?.localizedDescription
    }

    private func authenticate() {
        let context = LAContext()
        context.localizedFallbackTitle = fallbackTitle

        Task {
            do {
                let success = try await context.evaluatePolicy(
                    policyOption.policy,
                    localizedReason: reason
                )
                await MainActor.run {
                    withAnimation {
                        authResult = success ? .success : .failure("Authentication returned false")
                    }
                }
            } catch {
                await MainActor.run {
                    withAnimation {
                        authResult = .failure(error.localizedDescription)
                    }
                }
            }
        }
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        let policyCode = policyOption == .biometrics
            ? ".deviceOwnerAuthenticationWithBiometrics"
            : ".deviceOwnerAuthentication"

        return """
        import LocalAuthentication

        let context = LAContext()
        context.localizedFallbackTitle = "\(fallbackTitle)"

        // Check availability
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(
            \(policyCode), error: &error
        )
        let biometryType = context.biometryType // .faceID, .touchID, .opticID

        // Authenticate
        do {
            let success = try await context.evaluatePolicy(
                \(policyCode),
                localizedReason: "\(reason)"
            )
            // success == true means authenticated
        } catch {
            // Handle error (cancelled, failed, etc.)
        }
        """
    }
}

#Preview {
    NavigationStack {
        BiometricAuthPlayground()
    }
}
