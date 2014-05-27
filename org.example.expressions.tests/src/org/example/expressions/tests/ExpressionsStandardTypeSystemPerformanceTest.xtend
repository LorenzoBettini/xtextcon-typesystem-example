package org.example.expressions.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.example.expressions.ExpressionsInjectorProvider
import org.junit.runner.RunWith
import org.junit.Test

@RunWith(XtextRunner)
@InjectWith(ExpressionsInjectorProvider)
class ExpressionsStandardTypeSystemPerformanceTest extends AbstractExpressionsPerformanceTest {
	@Test def testPerformance10() {
		testPerformance(10)
	}
	
	@Test def testPerformance12() {
		testPerformance(12)
	}

	@Test def testPerformance14() {
		testPerformance(14)
	}

	@Test def testPerformance16() {
		testPerformance(16)
	}

	@Test def testPerformance18() {
		testPerformance(18)
	}

//	@Test def testPerformance20() {
//		testPerformance(20)
//	}
		
}