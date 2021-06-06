@isTest
private class CurrencyConverterLibTest {
	
	static testMethod void testRateConversion() {
		
		CurrencyConverterLib converter = GetMockConverter();
		
		Double USDtoCAD_input = 13.00;
		System.assertEquals(15.86, (Decimal.valueOf(converter.Convert(USDtoCAD_input, 'USD', 'CAD'))).setScale(2));
		
		Double CADtoUSD_input = 15.86;
		System.assertEquals(13.00, (Decimal.valueOf(converter.Convert(CADtoUSD_input, 'CAD', 'USD'))).setScale(2));
		
		Double USDtoCAD_input2 = 1234.567;
		System.assertEquals(1506.00, (Decimal.valueOf(converter.Convert(USDtoCAD_input2, 'USD', 'CAD'))).setScale(2));
		
		Double EURtoUSD_input = 12.44;
		System.assertEquals(13.39, (Decimal.valueOf(converter.Convert(EURtoUSD_input, 'EUR', 'USD'))).setScale(2));
		
		Double EURtoCAD_input = 8374.23;
		System.assertEquals(10999.38, (Decimal.valueOf(converter.Convert(EURtoCAD_input, 'EUR', 'CAD'))).setScale(2));
		
		Double CHFtoCAD_input = 99.99;
		System.assertEquals(127.59, (Decimal.valueOf(converter.Convert(CHFtoCAD_input, 'CHF', 'CAD'))).setScale(2));
		
		Double EURtoCHF_input = 55.00;
		System.assertEquals(56.61, (Decimal.valueOf(converter.Convert(EURtoCHF_input, 'EUR', 'CHF'))).setScale(2));
		
	}
	
	static CurrencyConverterLib GetMockConverter() {
		
		CurrencyConverterLib converter = CurrencyConverterLib.getInstance();
		
		Map<String, Double> testRates = new Map<String, Double>();
		testRates.put('USD', 1.00);
		testRates.put('CAD', 1.21986);
		testRates.put('EUR', 0.928724);
		testRates.put('CHF', 0.955969);
		
		converter.rateMap = testRates;
		return converter;
	}
}