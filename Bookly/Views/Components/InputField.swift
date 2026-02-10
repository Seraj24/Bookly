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
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: systemImage)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Group {
                if isSecure {
                    SecureField(placeholder ?? title, text: $text)
                } else {
                    TextField(placeholder ?? title, text: $text)
                }
            }
            .textFieldStyle(.roundedBorder)
            .textContentType(textContentType)
            .keyboardType(keyboardType)
            .disableAutocorrection(disableAutoCorrection)
            .textInputAutocapitalization(autoCapitalization)
            .accessibilityLabel(Text(title))
        }
    }
}
