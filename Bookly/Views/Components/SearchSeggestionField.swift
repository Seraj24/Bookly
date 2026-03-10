//
//  SearchSeggestionField.swift
//  Bookly
//
//  Created by user938962 on 3/8/26.
//

import SwiftUI

struct SearchSuggestionField<Field: Hashable>: View {
    let placeholder: String
    let icon: String
    @Binding var text: String

    let field: Field
    let focusedField: FocusState<Field?>.Binding
    let suggestions: [String]
    let rowIcon: String
    let onSelect: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)

                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(.words)
                    .focused(focusedField, equals: field)

                Spacer()
            }

            if focusedField.wrappedValue == field,
               !text.isEmpty,
               !suggestions.isEmpty {
                VStack(spacing: 0) {
                    ForEach(suggestions.prefix(5), id: \.self) { item in
                        Button {
                            onSelect(item)
                        } label: {
                            HStack {
                                Image(systemName: rowIcon)
                                    .foregroundStyle(.secondary)

                                Text(item)
                                    .foregroundStyle(.primary)

                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                        }

                        if item != suggestions.prefix(5).last {
                            Divider()
                        }
                    }
                }
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}
