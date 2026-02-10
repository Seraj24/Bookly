//
//  FormHeader.swift
//  Bookly
//
//  Created by user938962 on 2/7/26.
//

import SwiftUI

struct FormHeader: View {
    let title: String
    let subtitle: String
    
    let alignLeading: Bool = false

    var body: some View {
        VStack(alignment: alignLeading ? .leading : .center, spacing: 6) {
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(alignLeading ? .leading : .center)

        }
        .frame(maxWidth: .infinity, alignment: alignLeading ? .leading : .center)
        .padding()
        .padding(.top, 10)
        .background(Color(red: 0.20, green: 0.55, blue: 0.85))    }
}
