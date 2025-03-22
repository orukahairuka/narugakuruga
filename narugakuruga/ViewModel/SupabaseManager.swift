import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    let client: SupabaseClient

    private init() {
        // 環境変数からSupabaseのURLとAPIキーを取得
        guard let supabaseURL = ProcessInfo.processInfo.environment["SUPABASE_URL"],
              let supabaseKey = ProcessInfo.processInfo.environment["SUPABASE_API_KEY"] else {
            fatalError("環境変数にSUPABASE_URLとSUPABASE_API_KEYが設定されていません")
        }
        client = SupabaseClient(supabaseURL: URL(string: supabaseURL)!, supabaseKey: supabaseKey)
    }
}
