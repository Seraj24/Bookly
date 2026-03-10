//
//  InputRow.swift
//  Bookly
//
//  Created by user938962 on 2/7/26.
//

import SwiftUI

struct InputField: View {
    let title: String
    let systemImage: String
    @Binding var text: String

    var placeholder: String? = nil
    var textContentType: UITextContentType? = nil
    var keyboardType: UIKeyboardType = .default
    var disableAutoCorrection: Bool = false
    var autoCapitalization: TextInputAutocapitalization = .sentences
    var isSecure: Bool = false

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(isFocused ? .primary: .secondary)

                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(isFocused ? .primary : .secondary)
            }
            .animation(.easeInOut(duration: 0.2), value: isFocused)

            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: isFocused
                        ? Color.accentColor.opacity(0.25)
                        : Color.black.opacity(0.05),
                        radius: isFocused ? 6 : 3
                    )

                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        isFocused
                        ? Color.accentColor
                        : Color.gray.opacity(0.2),
                        lineWidth: 1.2
                    )

                Group {
                    if isSecure {
                        SecureField(placeholder ?? title, text: $text)
                    } else {
                        TextField(placeholder ?? title, text: $text)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .focused($isFocused)
                .textContentType(textContentType)
                .keyboardType(keyboardType)
                .disableAutocorrection(disableAutoCorrection)
                .textInputAutocapitalization(autoCapitalization)
                .accessibilityLabel(Text(title))
            }
            .frame(height: 52)
        }
    }
}
