interface Function
{
  public double compute(double x);
}

Function FUNC_IDENTITY = new Function() {
  public double compute(double x)
  {
    return x;
  }
};

Function FUNC_SIGMOID = new Function() {
  public double compute(double x)
  {
    return 1.0 / (1.0 + Math.exp(-x));
  }
};
  
Function FUNC_CHAOTIC = new Function() {
  public double compute(double x)
  {
    return 2 * x * Math.exp(-x*x);
  }
};
  
Function FUNC_RELU = new Function() {
  public double compute(double x)
  {
    return Math.max(x, 0);
  }
};