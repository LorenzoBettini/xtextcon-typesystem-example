package org.example.expressions.typing

import org.example.expressions.expressions.BoolType
import org.example.expressions.expressions.IntType
import org.example.expressions.expressions.StringType
import org.example.expressions.expressions.Type

class ExpressionsTypeUtils {
	def String representation(Type type) {
		switch (type) {
			IntType: "int"
			StringType: "string"
			BoolType: "boolean"
			default: "Unknown"
		}
	}
}