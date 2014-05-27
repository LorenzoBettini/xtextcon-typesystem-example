package org.example.expressions.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.example.expressions.ExpressionsInjectorProvider
import org.example.expressions.expressions.Expression
import org.example.expressions.expressions.ExpressionsModel
import org.example.expressions.expressions.Type
import org.example.expressions.typing.ExpressionsTypeProvider
import org.example.expressions.typing.ExpressionsTypeUtils
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*
import org.example.expressions.expressions.Equality
import org.example.expressions.expressions.Plus
import org.example.expressions.expressions.Comparison
import org.example.expressions.expressions.Variable

@RunWith(XtextRunner)
@InjectWith(ExpressionsInjectorProvider)
class ExpressionsTypeProviderTest {
	
	@Inject extension ParseHelper<ExpressionsModel>
	@Inject extension ExpressionsTypeProvider
	@Inject extension ExpressionsTypeUtils
	
	@Test def void intConstant() { "10".assertIntType }
	@Test def void stringConstant() { "'foo'".assertStringType }
	@Test def void boolConstant() { "true".assertBoolType }
	
	@Test def void varWithoutExpression() { "i = ".assertUnknownType }
	@Test def void varWithExpression() { "i = 0".assertIntType }
	@Test def void varWithDeclaredType() { "i : int = true".assertIntType }
	
	@Test def void varRef() { "i = 0 j = 's' i".assertIntType }
	@Test def void varRefToVarDefinedAfter() { "i = j j = i i".assertUnknownType }
	
	@Test def void notExp() { "!true".assertBoolType }
	
	@Test def void multiExp() { "1 * 2".assertIntType }
	@Test def void divExp() { "1 / 2".assertIntType }
	
	@Test def void minusExp() { "1 - 2".assertIntType }
	
	@Test def void numericPlus() { "1 + 2".assertIntType }
	@Test def void stringPlus() { "'a' + 'b'".assertStringType }
	@Test def void numAndStringPlus() { "'a' + 2".assertStringType }
	@Test def void numAndStringPlus2() { "2 + 'a'".assertStringType }
	@Test def void boolAndStringPlus() { "'a' + true".assertStringType }
	@Test def void boolAndStringPlus2() { "false + 'a'".assertStringType }
	
	@Test def void comparisonExp() { "1 < 2".assertBoolType }
	@Test def void equalityExp() { "1 == 2".assertBoolType }
	@Test def void andExp() { "true && false".assertBoolType }
	@Test def void orExp() { "true || false".assertBoolType }
	
	@Test def void testIncompleteModel() {
		"1 == ".assertBoolType
	}
	
	@Test def void mulExpectsInt() { 
		"true * false".assertExpectedType("int")
	}

	@Test def void divExpectsInt() { 
		"true / false".assertExpectedType("int")
	}

	@Test def void minusExpectsInt() { 
		"true - false".assertExpectedType("int")
	}

	@Test def void andExpectsBoolean() { 
		"true && 0".assertExpectedType("boolean")
	}

	@Test def void orExpectsBoolean() { 
		"true || 0".assertExpectedType("boolean")
	}

	@Test def void notExpectsBoolean() { 
		"!0".assertExpectedType("boolean")
	}

	@Test def void nonContainedExpressionHasNoExpectations() { 
		"0".assertExpectedType("Unknown")
	}

	@Test def void initializationExpressionExpectedType() { 
		"i : int = 's'".assertVariableDeclarationExpectedTypes("int")
		"i : string = 1".assertVariableDeclarationExpectedTypes("string")
		"i : bool = 1".assertVariableDeclarationExpectedTypes("boolean")
		"i :  = 1".assertVariableDeclarationExpectedTypes("Unknown")
		"i = 1".assertVariableDeclarationExpectedTypes("Unknown")
	}

	@Test def void plusExpectsIntOrString() {
		"1 + true".assertPlusExpectedTypes("int", "int")
		"true + 1".assertPlusExpectedTypes("int", "int")
		"'1' + true".assertPlusExpectedTypes("string", "string")
		"true + '1'".assertPlusExpectedTypes("string", "string")
	}

	@Test def void testExpectedWithIncompleteModel() {
		// when the right expression is null the expectation is
		// simply string since everything is assignable to string
		"1 == ".assertExpectTheSameType("Unknown", null)
		"true + ".assertPlusExpectedTypes("int", null)
		"'s' + ".assertPlusExpectedTypes("string", null)
		"'s' <= ".assertComparisonExpectedTypes("Unknown", null)
	}
	
	@Test def void testIsInt() { 
		(ExpressionsTypeProvider::intType).isInt.assertTrue
	}

	@Test def void testIsString() { 
		(ExpressionsTypeProvider::stringType).isString.assertTrue
	}

	@Test def void testIsBool() { 
		(ExpressionsTypeProvider::boolType).isBoolean.assertTrue
	}
	
	def assertStringType(CharSequence input) {
		input.assertType(ExpressionsTypeProvider.stringType)
	}
	
	def assertIntType(CharSequence input) {
		input.assertType(ExpressionsTypeProvider.intType)
	}

	def assertBoolType(CharSequence input) {
		input.assertType(ExpressionsTypeProvider.boolType)		
	}

	def private assertUnknownType(CharSequence input) {
		input.assertType(null)		
	}

	def private assertType(CharSequence input, Type expectedType) {
		expectedType?.eClass.assertSame
			(input.parse.elements.last.inferredType?.eClass)
	}
	
	def private assertExpectedType(CharSequence input, CharSequence expectation) {
		val lastElement = input.parse.elements.last as Expression
		val rightMostExpression = lastElement.eAllContents.filter(Expression).last ?: lastElement
		
		expectation.toString.assertEquals
			(rightMostExpression.
				expectedType.representation)
	}

	def private assertVariableDeclarationExpectedTypes(CharSequence input, CharSequence expectation) {
		val variable = input.parse.elements.last as Variable
		
		expectation.toString.assertEquals
			(variable.expression.
				expectedType.representation)
	}

	def private assertExpectTheSameType(CharSequence input, CharSequence expectedLeft, CharSequence expectedRight) {
		val equality = input.parse.elements.last as Equality
		
		expectedLeft.assertEquals(
			equality.left.expectedType.representation)
		if (expectedRight === null)
			equality.right.assertNull
		else
			expectedRight.assertEquals(
				equality.right.expectedType.representation)
	}

	def private assertPlusExpectedTypes(CharSequence input, CharSequence expectedLeft, CharSequence expectedRight) {
		val plus = input.parse.elements.last as Plus
		
		expectedLeft.assertEquals(
			plus.left.expectedType.representation)
		if (expectedRight === null)
			plus.right.assertNull
		else
			expectedRight.assertEquals(
				plus.right.expectedType.representation)
	}
	
	def private assertComparisonExpectedTypes(CharSequence input, CharSequence expectedLeft, CharSequence expectedRight) {
		val comparison = input.parse.elements.last as Comparison
		
		expectedLeft.assertEquals(
			comparison.left.expectedType.representation)
		if (expectedRight === null)
			comparison.right.assertNull
		else
			expectedRight.assertEquals(
				comparison.right.expectedType.representation)
	}
	
}