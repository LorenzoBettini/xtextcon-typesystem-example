package org.example.expressions.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.example.expressions.ExpressionsInjectorProvider
import org.example.expressions.expressions.ExpressionsModel
import org.example.expressions.expressions.ExpressionsPackage
import org.example.expressions.expressions.Type
import org.example.expressions.validation.ExpressionsValidator
import org.junit.Test
import org.junit.runner.RunWith

import static org.example.expressions.typing.ExpressionsTypeProvider.*

import static extension org.junit.Assert.*
import org.example.expressions.typing.ExpressionsTypeUtils

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(ExpressionsInjectorProvider))
class ExpressionsValidatorTest {
	
	@Inject extension ParseHelper<ExpressionsModel>
	@Inject extension ValidationTestHelper
	@Inject extension ExpressionsTypeUtils
	
	@Test
	def void testForwardReference() {
		'''i = j j = 10'''.parse.
		assertError(ExpressionsPackage::eINSTANCE.variableRef,
			ExpressionsValidator::FORWARD_REFERENCE,
			"variable forward reference not allowed: 'j'"
		)
	}

	@Test
	def void testForwardReferenceInExpression() {
		'''i = 1 j+i j = 10'''.parse => [
			assertError(ExpressionsPackage::eINSTANCE.variableRef,
				ExpressionsValidator::FORWARD_REFERENCE,
				"variable forward reference not allowed: 'j'"
			)
			
			// check that's the only error
			1.assertEquals(validate.size)
		]
	}

	@Test
	def void testWrongNotType() {
		"!10".assertTypeConformanceFailed(intType, boolType)
	}

	@Test
	def void testWrongMulOrDivType() {
		"10 * true".assertTypeConformanceFailed(boolType, intType)
		"'10' / 10".assertTypeConformanceFailed(stringType, intType)
	}

	@Test
	def void testWrongMinusType() {
		"10 - true".assertTypeConformanceFailed(boolType, intType)
		"'10' - 10".assertTypeConformanceFailed(stringType, intType)
	}

	@Test
	def void testWrongAndType() {
		"10 && true".assertTypeConformanceFailed(intType, boolType)
		"false && '10'".assertTypeConformanceFailed(stringType, boolType)
	}

	@Test
	def void testWrongOrType() {
		"10 || true".assertTypeConformanceFailed(intType, boolType)
		"false || '10'".assertTypeConformanceFailed(stringType, boolType)
	}

	@Test
	def void testWrongEqualityType() {
		"10 == true".assertSameType(intType, boolType)
		"false != '10'".assertSameType(boolType, stringType)
	}

	@Test
	def void testWrongComparisonType() {
		"10 < '1'".assertSameType(intType, stringType)
		"'10' > 10".assertSameType(stringType, intType)
	}

	@Test
	def void testWrongBooleanComparison() {
		"10 < true".assertNotBooleanType
		"false > 0".assertNotBooleanType
		"false > true".assertNotBooleanType
	}

	@Test
	def void testWrongBooleanPlus() {
		"10 + true".assertTypeConformanceFailed(boolType, intType)
		"false + 0".assertTypeConformanceFailed(boolType, intType)
		"false + true".assertTypeConformanceFailed(boolType, intType)
	}

	def void assertTypeConformanceFailed(CharSequence input, 
			Type actualType,
			Type expectedType) {
		input.parse.elements.last => [
			assertError(ExpressionsPackage::eINSTANCE.expression,
				ExpressionsValidator::WRONG_TYPE,
				"expected " + expectedType.representation
					+ ", but was " + actualType.representation)
		]
	}
	
	def void assertSameType(CharSequence input, 
			Type expectedLeft,
			Type expectedRight) {
		input.parse.elements.last => [
			assertError(ExpressionsPackage::eINSTANCE.expression,
				ExpressionsValidator::WRONG_TYPE,
				"expected the same type, but was " + expectedLeft.representation + ", " +
				expectedRight.representation)
		]
	}

	def void assertNotBooleanType(CharSequence input) {
		input.parse.elements.last => [
			assertError(ExpressionsPackage::eINSTANCE.expression,
				ExpressionsValidator::WRONG_TYPE,
				"cannot be boolean")
		]
	}
}