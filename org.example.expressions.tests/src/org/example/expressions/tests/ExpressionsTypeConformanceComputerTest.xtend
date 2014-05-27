package org.example.expressions.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.example.expressions.ExpressionsInjectorProvider
import org.junit.Test
import org.junit.runner.RunWith

import static org.example.expressions.typing.ExpressionsTypeProvider.*

import static extension org.junit.Assert.*
import org.example.expressions.typing.ExpressionsTypeConformanceComputer

@RunWith(XtextRunner)
@InjectWith(ExpressionsInjectorProvider)
class ExpressionsTypeConformanceComputerTest {
	
	@Inject extension ExpressionsTypeConformanceComputer
	
	@Test def void testEverythingIsAssignableToString() {
		intType.isAssignableTo(stringType).assertTrue
		boolType.isAssignableTo(stringType).assertTrue
		stringType.isAssignableTo(stringType).assertTrue
	}

	@Test def void testOnlyIntIsAssignableToInt() {
		intType.isAssignableTo(intType).assertTrue
		boolType.isAssignableTo(intType).assertFalse
		stringType.isAssignableTo(intType).assertFalse
	}

	@Test def void testOnlyBooleanIsAssignableToBoolean() {
		intType.isAssignableTo(boolType).assertFalse
		boolType.isAssignableTo(boolType).assertTrue
		stringType.isAssignableTo(boolType).assertFalse
	}
}