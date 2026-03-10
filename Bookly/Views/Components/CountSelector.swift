//
//  CountSelector.swift
//  Bookly
//
//  Created by user938962 on 3/8/26.
//

import SwiftUI

struct CountSelector: View {

    let title: String
    let range: ClosedRange<Int>

    @Binding var count: Int
    @Environment(\.dismiss) private var dismiss

    init(
        title: String,
        count: Binding<Int>,
        range: ClosedRange<Int> = 1...9
    ) {
        self.title = title
        self._count = count
        self.range = range
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {

                Stepper(
                    "\(title): \(count)",
                    value: $count,
                    in: range
                )
                .font(.title3)
                .padding()

                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    //CountSelector()
}
