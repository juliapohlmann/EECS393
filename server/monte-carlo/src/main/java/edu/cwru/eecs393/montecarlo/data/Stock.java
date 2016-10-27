public class Stock{
  
  private String ticker;
  private double currentPrice;
  private double prevPrice;
  privaate double allocation;
  
  public Stock(String ticker, double currentPrice, double prevPrice, double allocation){
    this.ticker = ticker;
    this.currentPrice = currentPrice;
    this.prevPrice = prevPrice;
    this.allocation = allocation;
  }
  
  public String getTicker(){
    return ticker;
  }
  
  public double getCurrentPrice(){
    return currentPrice;
  }
  
  public double getPrevPrice(){
    return prevPrice;
  }
  
}