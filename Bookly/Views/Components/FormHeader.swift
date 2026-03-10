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
    var alignLeading: Bool = false
    
    var body: some View {
        VStack(alignment: alignLeading ? .leading : .center, spacing: 12) {
            
            Text(title)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .tracking(-0.5)
            
            Text(subtitle)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(alignLeading ? .leading : .center)
                .lineSpacing(3)
                .padding(.horizontal, alignLeading ? 0 : 16)
        }
        .frame(maxWidth: .infinity, alignment: alignLeading ? .leading : .center)
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .padding(.bottom, 12)
        .background(.yellow)
    }
}
