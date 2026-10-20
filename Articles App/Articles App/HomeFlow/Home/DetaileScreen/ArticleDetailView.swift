//
//  ArticleDetailView.swift
//  Articles App
//
//  Created by Kirit on 14/10/26.
//

import SwiftUI
import Kingfisher

struct ArticleDetailView: View {

    let article: Article

    private var formattedDate: String {
        guard let publishedAt = article.publishedAt,
              let date = ISO8601DateFormatter().date(from: publishedAt)
        else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let time = formatter.string(from: date)
        return "\(time) ago"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Sticky header: title, date and image
            VStack(alignment: .leading, spacing: 12) {

                Text(article.title)
                    .font(.robotoCondensedBlack(size: 24))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.Color969696)

                    Text(formattedDate)
                        .font(.robotoRegular(size: 14))
                        .foregroundStyle(Color.Color969696)
                }

                KFImage(URL(string: article.urlToImage ?? ""))
                    .placeholder {
                        Image("imgBook")
                            .resizable()
                            .scaledToFill()
                    }
                    .onFailure { _ in }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 10)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .background(Color.clear)

            // Scrollable article content
            ScrollView(.vertical) {
                Text(article.content ?? article.description ?? "No article content available.")
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(Color.Color8C8E98)
                    .lineSpacing(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
            }
            .background(Color.clear)
        }
        .background(Color.clear)
        .preferredColorScheme(.dark)
    }
}
