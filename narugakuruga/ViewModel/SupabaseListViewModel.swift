import Foundation
import Supabase


@MainActor
class StorageListViewModel: ObservableObject {
    @Published var imageUrls: [String] = []
    @Published var error: String?

    private var timer: Timer?

    init() {
        startAutoRefresh()
    }

    deinit {
        timer?.invalidate()
    }

    func fetchImages() async {
        let client = SupabaseManager.shared.client

        do {
            let files = try await client.storage
                .from("image")
                .list(path: "", options: SearchOptions(limit: 100, offset: 0))

            print("⭐️取得したファイル：\(files.map(\.name))")

            var newUrls: [String] = []

            for file in files where !file.name.isEmpty {
                do {
                    let publicURL = try client.storage
                        .from("image")
                        .getPublicURL(path: file.name)

                    newUrls.append(publicURL.absoluteString)
                } catch {
                    print("❌ URL取得失敗: \(error.localizedDescription)")
                }
            }

            self.imageUrls = newUrls

        } catch {
            self.error = "画像取得に失敗しました: \(error.localizedDescription)"
            print("❌ 画像リスト取得失敗: \(error.localizedDescription)")
        }
    }

    private func startAutoRefresh() {
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            Task {
                await self.fetchImages()
            }
        }
    }
}
