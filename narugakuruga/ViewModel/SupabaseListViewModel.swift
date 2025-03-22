import Foundation
import Supabase

@MainActor
class StorageListViewModel: ObservableObject {
    @Published var imageUrls: [String] = []
    @Published var error: String?

    func fetchImages() async {
        let client = SupabaseManager.shared.client

        do {
            let files = try await client.storage
                .from("image") // ← バケット名統一
                .list(
                    path: "",
                    options: SearchOptions(limit: 100, offset: 0)
                )
            print("⭐️取得したファイル：\(files.map(\.name))")

            for file in files {
                guard !file.name.isEmpty else {
                    print("⚠️ 空のファイル名をスキップ")
                    continue
                }

                do {
                    let publicURL = try client.storage
                        .from("image") // ← ここも合わせる
                        .getPublicURL(path: "\(file.name)")

                    print("✅ 取得したURL: \(publicURL.absoluteString)")
                    self.imageUrls.append(publicURL.absoluteString)
                } catch {
                    print("❌ URL取得失敗: \(error.localizedDescription)")
                }
            }
        } catch {
            self.error = "画像取得に失敗しました: \(error.localizedDescription)"
            print("❌ 画像リスト取得失敗: \(error.localizedDescription)")
        }
    }
}
