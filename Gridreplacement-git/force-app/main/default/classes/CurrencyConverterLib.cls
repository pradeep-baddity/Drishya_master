public class CurrencyConverterLib{

	private static CurrencyConverterLib instance = null;
	
	@testVisible
	private Map<String, Double> rateMap = null;
	
	private CurrencyConverterLib() {
		
		rateMap = new Map<String, Double>();
		
		List<CurrencyType> ctypeList = [	SELECT
											Id
											,IsoCode
											,ConversionRate
											,DecimalPlaces
										FROM CurrencyType];
		
		for (CurrencyType ctype :ctypeList) {
			rateMap.put(ctype.IsoCode, ctype.ConversionRate);
		}
	}
	
	public static CurrencyConverterLib getInstance() {
		if (instance == null) {
			instance = new CurrencyConverterLib();
		}
		return instance;
	}
	
	public Double Convert(Double input, String srcType, String dstType) {
		
		Double srcRate = rateMap.get(srcType);
		Double dstRate = rateMap.get(dstType);
		
		Double resultVal = input*(dstRate/srcRate);
		return resultVal;

	}
	
}