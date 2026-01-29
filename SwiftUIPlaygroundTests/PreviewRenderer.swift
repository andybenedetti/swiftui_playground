import SwiftUI
import UIKit

@MainActor
enum PreviewRenderer {
    nonisolated static let defaultSize = CGSize(width: 393, height: 852)
    nonisolated static let defaultScale: CGFloat = 2.0
    nonisolated static let defaultOutputPath = "/tmp/swiftui_preview.png"

    @discardableResult
    static func renderToFile<V: View>(
        _ view: V,
        size: CGSize = defaultSize,
        scale: CGFloat = defaultScale,
        outputPath: String = defaultOutputPath
    ) -> Bool {
        let framedView = view
            .frame(width: size.width, height: size.height)

        let renderer = ImageRenderer(content: framedView)
        renderer.scale = scale

        guard let uiImage = renderer.uiImage else {
            return false
        }

        guard let pngData = uiImage.pngData() else {
            return false
        }

        let url = URL(fileURLWithPath: outputPath)
        do {
            try pngData.write(to: url)
            return true
        } catch {
            return false
        }
    }
}
