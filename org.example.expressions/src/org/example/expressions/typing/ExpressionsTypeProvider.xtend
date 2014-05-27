package org.example.expressions.typing

import org.eclipse.emf.ecore.EObject
import org.example.expressions.expressions.And
import org.example.expressions.expressions.BoolConstant
import org.example.expressions.expressions.BoolType
import org.example.expressions.expressions.Comparison
import org.example.expressions.expressions.Equality
import org.example.expressions.expressions.Expression
import org.example.expressions.expressions.ExpressionsFactory
import org.example.expressions.expressions.ExpressionsModel
import org.example.expressions.expressions.IntConstant
import org.example.expressions.expressions.IntType
import org.example.expressions.expressions.Minus
import org.example.expressions.expressions.MulOrDiv
import org.example.expressions.expressions.Not
import org.example.expressions.expressions.Or
import org.example.expressions.expressions.Plus
import org.example.expressions.expressions.StringConstant
import org.example.expressions.expressions.StringType
import org.example.expressions.expressions.Type
import org.example.expressions.expressions.Variable
import org.example.expressions.expressions.VariableRef

import static extension org.example.expressions.typing.ExpressionsModelUtil.*
import org.example.expressions.expressions.AbstractElement

class ExpressionsTypeProvider {
	static val factory = ExpressionsFactory.eINSTANCE
	public static val stringType = factory.createStringType
	public static val intType = factory.createIntType
	public static val boolType = factory.createBoolType

	def dispatch Type inferredType(AbstractElement e) {
		null
	}
	
	def dispatch Type inferredType(Expression e) {
		switch (e) {
			StringConstant: stringType
			IntConstant: intType
			BoolConstant: boolType
			Not: boolType
			MulOrDiv: intType
			Minus: intType
			Comparison: boolType
			Equality: boolType
			And: boolType
			Or: boolType
		}
	}

	def dispatch Type inferredType(Plus e) {
		val leftType = e.left.inferredType
		val rightType = e.right?.inferredType
		if (leftType.isString || rightType.isString)
			stringType
		else
			intType
	}
	
	def dispatch Type inferredType(Variable variable) {
		if (variable.declaredType != null)
			return variable.declaredType
		// be prepared to deal with incomplete models
		return variable?.expression?.inferredType
	}
	
	def dispatch Type inferredType(VariableRef varRef) {
		if (varRef.variable == null || 
				// guard against infinite loops
				!(varRef.variablesDefinedBefore.contains(varRef.variable)))
			return null // we'll deal with that in the validator
		else
			return varRef.variable.inferredType
	}
	
	def isInt(Type type) { type instanceof IntType }
	def isString(Type type) { type instanceof StringType }
	def isBoolean(Type type) { type instanceof BoolType }
	
	def Type expectedType(Expression exp) {
		expectedType(exp.eContainer, exp)
	}

	def dispatch Type expectedType(ExpressionsModel container, Expression exp) {
		null // no expectation
	}

	def dispatch Type expectedType(EObject container, Expression exp) {
		switch (container) {
			Not: boolType
			MulOrDiv: intType
			Minus: intType
			And: boolType
			Or: boolType
			Variable: container.declaredType // if it's null then no expectation
		}
	}

	def dispatch Type expectedType(Plus container, Expression exp) {
		val leftType = container.left.inferredType;
		val rightType = container.right?.inferredType;
		if (leftType.isString || rightType.isString) {
			stringType
		} else {
			intType
		}
	}

}