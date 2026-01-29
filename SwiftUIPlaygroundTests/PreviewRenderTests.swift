import XCTest
import SwiftUI
@testable import SwiftUIPlayground

final class PreviewRenderTests: XCTestCase {

    @MainActor
    func testRenderPreview() throws {
        // ========================================
        // EDIT HERE: Change to any playground view
        // ========================================
        let view = NavigationStack {
            ButtonPlayground()
        }

        let success = PreviewRenderer.renderToFile(view)
        XCTAssertTrue(success, "Failed to render preview to PNG")

        let fileExists = FileManager.default.fileExists(atPath: PreviewRenderer.defaultOutputPath)
        XCTAssertTrue(fileExists, "PNG file not found at \(PreviewRenderer.defaultOutputPath)")

        let attrs = try FileManager.default.attributesOfItem(atPath: PreviewRenderer.defaultOutputPath)
        let fileSize = attrs[.size] as? Int ?? 0
        XCTAssertGreaterThan(fileSize, 0, "PNG file is empty")
    }
}
