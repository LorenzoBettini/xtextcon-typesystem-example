package org.example.expressions.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.example.expressions.expressions.ExpressionsModel

class AbstractExpressionsPerformanceTest {
	@Inject extension ParseHelper<ExpressionsModel>
	@Inject extension ValidationTestHelper
	
	def protected testPerformance(int n) {
		/*
		 * i_0 = 0
		 * i_1 = i_0
		 * i_2 = i_0 + i_1
		 * i_3 = i_0 + i_1 + i_2
		 * etc..
		 */
		'''
			i_0 = 0
			i_1 = i_0
			«FOR i : 2..n»
			i_«i» = i_0«FOR j : 1..i-1» + i_«j»«ENDFOR»
			«ENDFOR»
		'''.parse.assertNoErrors
	}
}