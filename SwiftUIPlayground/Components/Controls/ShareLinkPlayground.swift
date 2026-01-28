import SwiftUI

struct ShareLinkPlayground: View {
    @State private var shareText = "Check out SwiftUI Playground!"
    @State private var shareURL = "https://apple.com/swiftui"
    @State private var shareType = ShareType.url
    @State private var useCustomLabel = false
    @State private var customLabelText = "Share This"
    @State private var useSubjectMessage = false
    @State private var subject = "Cool Link"
    @State private var message = "I thought you might like this!"

    enum ShareType: String, CaseIterable {
        case url = "URL"
        case text = "Text"
    }

    var body: some View {
        ComponentPage(
            title: "ShareLink",
            description: "A view that controls a sharing presentation.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/sharelink")!,
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
            shareLinkView

            Text("Tapping opens the system share sheet")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var shareLinkView: some View {
        switch shareType {
        case .url:
            if let url = URL(string: shareURL) {
                if useCustomLabel {
                    if useSubjectMessage {
                        ShareLink(item: url, subject: Text(subject), message: Text(message)) {
                            Label(customLabelText, systemImage: "square.and.arrow.up")
                        }
                    } else {
                        ShareLink(item: url) {
                            Label(customLabelText, systemImage: "square.and.arrow.up")
                        }
                    }
                } else {
                    if useSubjectMessage {
                        ShareLink(item: url, subject: Text(subject), message: Text(message))
                    } else {
                        ShareLink(item: url)
                    }
                }
            } else {
                Text("Invalid URL")
                    .foregroundStyle(.secondary)
            }
        case .text:
            if useCustomLabel {
                if useSubjectMessage {
                    ShareLink(item: shareText, subject: Text(subject), message: Text(message)) {
                        Label(customLabelText, systemImage: "square.and.arrow.up")
                    }
                } else {
                    ShareLink(item: shareText) {
                        Label(customLabelText, systemImage: "square.and.arrow.up")
                    }
                }
            } else {
                if useSubjectMessage {
                    ShareLink(item: shareText, subject: Text(subject), message: Text(message))
                } else {
                    ShareLink(item: shareText)
                }
            }
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Share Type",
                selection: $shareType,
                options: ShareType.allCases,
                optionLabel: { $0.rawValue }
            )

            if shareType == .url {
                TextFieldControl(label: "URL", text: $shareURL)
            } else {
                TextFieldControl(label: "Text", text: $shareText)
            }

            ToggleControl(label: "Custom Label", isOn: $useCustomLabel)

            if useCustomLabel {
                TextFieldControl(label: "Label Text", text: $customLabelText)
            }

            ToggleControl(label: "Subject & Message", isOn: $useSubjectMessage)

            if useSubjectMessage {
                TextFieldControl(label: "Subject", text: $subject)
                TextFieldControl(label: "Message", text: $message)
            }
        }
    }

    private var generatedCode: String {
        var code = ""

        let itemCode = shareType == .url ? "URL(string: \"\(shareURL)\")!" : "\"\(shareText)\""

        if useCustomLabel {
            if useSubjectMessage {
                code += """
                ShareLink(
                    item: \(itemCode),
                    subject: Text("\(subject)"),
                    message: Text("\(message)")
                ) {
                    Label("\(customLabelText)", systemImage: "square.and.arrow.up")
                }
                """
            } else {
                code += """
                ShareLink(item: \(itemCode)) {
                    Label("\(customLabelText)", systemImage: "square.and.arrow.up")
                }
                """
            }
        } else {
            if useSubjectMessage {
                code += """
                ShareLink(
                    item: \(itemCode),
                    subject: Text("\(subject)"),
                    message: Text("\(message)")
                )
                """
            } else {
                code += "ShareLink(item: \(itemCode))"
            }
        }

        return code
    }
}

#Preview {
    NavigationStack {
        ShareLinkPlayground()
    }
}
