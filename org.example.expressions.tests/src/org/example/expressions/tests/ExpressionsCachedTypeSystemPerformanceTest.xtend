package org.example.expressions.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(ExpressionsInjectorProviderForCaching)
class ExpressionsCachedTypeSystemPerformanceTest extends AbstractExpressionsPerformanceTest {
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

	@Test def testPerformance50() {
		testPerformance(50)
	}

	@Test def testPerformance100() {
		testPerformance(100)
	}
		
}