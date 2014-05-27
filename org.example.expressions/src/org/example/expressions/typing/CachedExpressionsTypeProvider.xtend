package org.example.expressions.typing

import com.google.inject.Inject
import org.eclipse.xtext.util.IResourceScopeCache
import org.example.expressions.expressions.AbstractElement

class CachedExpressionsTypeProvider extends ExpressionsTypeProvider {
	@Inject IResourceScopeCache cache
	
	override inferredType(AbstractElement e) {
		cache.get('inferredType'->e, e.eResource) [|
			super.inferredType(e)
		]
	}
	
}