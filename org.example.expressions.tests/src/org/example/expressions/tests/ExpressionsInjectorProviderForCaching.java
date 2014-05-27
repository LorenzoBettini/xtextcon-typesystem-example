package org.example.expressions.tests;

import org.example.expressions.ExpressionsInjectorProvider;
import org.example.expressions.ExpressionsRuntimeModule;
import org.example.expressions.ExpressionsStandaloneSetup;
import org.example.expressions.typing.CachedExpressionsTypeProvider;
import org.example.expressions.typing.ExpressionsTypeProvider;

import com.google.inject.Guice;
import com.google.inject.Injector;

public class ExpressionsInjectorProviderForCaching extends
		ExpressionsInjectorProvider {

	public Injector internalCreateInjector() {
		return new ExpressionsStandaloneSetup() {
			@Override
			public Injector createInjector() {
				return Guice.createInjector(new ExpressionsRuntimeModule() {
					@SuppressWarnings("unused")
					public Class<? extends ExpressionsTypeProvider> bindExpressionsTypeProvider() {
						return CachedExpressionsTypeProvider.class;
					}
				});
			}
		}.createInjectorAndDoEMFRegistration();
	}

}
