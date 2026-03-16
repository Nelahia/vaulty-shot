import SwiftUI

struct PopoverView: View {
    @ObservedObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            headerView
            Divider()
            contentView
            Divider()
            footerView
        }
        .frame(width: 320, height: 480)
    }

    private var headerView: some View {
        HStack {
            Image(systemName: "folder.fill")
                .foregroundStyle(.blue)
                .font(.title3)
            Text("VaultyShot")
                .font(.headline)
            Spacer()
            Text("\(appState.screenshots.count)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(.quaternary, in: Capsule())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var contentView: some View {
        Group {
            if appState.screenshots.isEmpty {
                EmptyStateView()
            } else {
                screenshotList
            }
        }
    }

    private var screenshotList: some View {
        ScrollView {
            LazyVStack(spacing: 1) {
                ForEach(appState.screenshots) { item in
                    ScreenshotRow(
                        item: item,
                        onOpen: { appState.openScreenshot(item) },
                        onCopy: { appState.copyToClipboard(item) },
                        onReveal: { appState.revealInFinder(item) },
                        onDelete: { appState.deleteScreenshot(item) }
                    )
                }
            }
            .padding(.vertical, 4)
        }
    }

    private var footerView: some View {
        HStack {
            Button(action: appState.openVaultFolder) {
                Label("Open Folder", systemImage: "folder")
                    .font(.caption)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)

            Spacer()

            Button(action: { NSApp.terminate(nil) }) {
                Label("Quit", systemImage: "power")
                    .font(.caption)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}
