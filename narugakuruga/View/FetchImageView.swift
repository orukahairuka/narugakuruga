import SwiftUI

import SwiftUI

struct FetchImageView: View {
    @StateObject private var viewModel = StorageListViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text("📸 撮影された写真")
                .font(.headline)
                .padding(.horizontal)

            if let error = viewModel.error {
                Text("エラー: \(error)")
                    .foregroundColor(.red)
            } else if viewModel.imageUrls.isEmpty {
                ProgressView("読み込み中...")
                    .padding()
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.imageUrls, id: \.self) { urlString in
                            if let url = URL(string: urlString) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(8)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 100, height: 100)
                                }
                            } else {
                                Text("❌ 無効なURL")
                                    .font(.caption)
                            }
                        }
                    }
                    .padding(.horizontal)
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
