import SwiftUI

// Minimal SwiftUI app reproducing https://github.com/mobile-dev-inc/Maestro/issues/1924:
// a sheet presented on top of a `.fullScreenCover` is not interactable via Maestro.
// The root view presents a fullScreenCover; that cover presents a sheet; the sheet
// contains a button + a counter that proves the tap was received by the right view.
// If Maestro can tap "Tap Me In Sheet", the counter increments and the flow passes.

@main
struct CoverSheetReproApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    @State private var coverShown = false

    var body: some View {
        VStack(spacing: 24) {
            Text("Cover-Sheet Repro")
                .font(.title)
            Button("Show Cover") {
                coverShown = true
            }
        }
        .fullScreenCover(isPresented: $coverShown) {
            CoverView(coverShown: $coverShown)
        }
    }
}

struct CoverView: View {
    @Binding var coverShown: Bool
    @State private var sheetShown = false
    @State private var sheetTapCount = 0

    var body: some View {
        VStack(spacing: 24) {
            Text("Cover Content")
                .font(.title2)
            Button("Show Sheet") {
                sheetShown = true
            }
            Button("Close Cover") {
                coverShown = false
            }
            Text("Sheet taps: \(sheetTapCount)")
        }
        .sheet(isPresented: $sheetShown) {
            SheetView(sheetShown: $sheetShown, sheetTapCount: $sheetTapCount)
        }
    }
}

struct SheetView: View {
    @Binding var sheetShown: Bool
    @Binding var sheetTapCount: Int

    var body: some View {
        VStack(spacing: 24) {
            Text("Sheet Content")
                .font(.title2)
            Button("Tap Me In Sheet") {
                sheetTapCount += 1
            }
            Button("Dismiss Sheet") {
                sheetShown = false
            }
        }
        .padding()
        // Issue #1924 only reproduces when the sheet detent is below ~90% of
        // screen height. The default `.large` detent is in the working range
        // and would mask the bug.
        .presentationDetents([.fraction(0.5)])
    }
}
