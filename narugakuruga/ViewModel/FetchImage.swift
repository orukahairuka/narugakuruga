import SwiftUI
import Supabase

struct FetchImageView: View {
    @StateObject private var viewModel = StorageListViewModel()

    var body: some View {
        VStack {
            Text("画像一覧")
                .font(.headline)

            if let error = viewModel.error {
                Text("エラー: \(error)")
                    .foregroundColor(.red)
            } else if viewModel.imageUrls.isEmpty {
                ProgressView("読み込み中...")
            } else {
                List(viewModel.imageUrls, id: \.self) { urlString in
                    if let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Text("❌ URL不正: \(urlString)")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
            }
        }
        .onAppear {
            print("👀 FetchImageView 表示開始")
            Task {
                await viewModel.fetchImages()
            }
        }
    }
}
