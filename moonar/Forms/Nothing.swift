//
//  Nothing.swift
//  moonar
//
//  Created by Владислав Калиниченко on 17.08.2022.
//

import SwiftUI

struct Nothing: View {
	var action: () -> Void
	
    var body: some View {
		Color(.clear)
			.onAppear() {
				action()
			}
    }
}
