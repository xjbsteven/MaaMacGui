//
//  Binding+semicolonString.swift
//  MAA
//
//  Created by hguandl on 2025/2/11.
//

import SwiftUI

extension Binding {
    /// 分号/换行分隔的列表编辑绑定。
    /// 保留尾部分隔符，避免输入 `;` / `；` 时被立刻吃掉。
    func semicolonString(for keyPath: WritableKeyPath<Value, [String]>) -> Binding<String> {
        Binding<String> {
            let items = wrappedValue[keyPath: keyPath]
            // 末尾空串表示用户正在输入分隔符之后的下一项
            if items.last == "" {
                return items.dropLast().joined(separator: "; ") + ";"
            }
            return items.joined(separator: "; ")
        } set: { newValue in
            let hasTrailingSeparator =
                newValue.range(of: #"[;；]\s*$"#, options: .regularExpression) != nil
                || newValue.hasSuffix("\n")

            var items = newValue
                .split { $0 == ";" || $0 == "；" || $0.isNewline }
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }

            if hasTrailingSeparator {
                items.append("")
            }

            wrappedValue[keyPath: keyPath] = items
        }
    }
}
