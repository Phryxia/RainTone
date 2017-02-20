class MarkovModel
{
  int order;
  int dimension;
  DreamNode[][]   nodes; // [k][d] 
  double[][][] jointP; // [k][d][e] : [k][d] -> [0][e]
  
  public MarkovModel(int order, int dimension)
  {
    this.order = order;
    this.dimension = dimension;
    
    nodes = new DreamNode[order][dimension];
    jointP = new double[order][dimension][dimension];
    for(int n = 0; n < order; ++n)
    {
      for(int d = 0; d < dimension; ++d)
      {
        nodes[n][d] = new DreamNode(FUNC_IDENTITY, 0);
        
        for(int e = 0;  e < dimension; ++e)
        {
          jointP[n][d][e] = Math.random();
        }
      }
    }
  }
  
  public void process()
  {
    
  }
  
  private void shift()
  {
    for(int n = order - 1; n > 0; --n)
    {
      for(int d = 0; d < dimension; ++d)
      {
        nodes[n][d] = nodes[n - 1][d];
      }
    }
    for(int d = 0; d < dimension; ++d)
    {
      
    }
  }
}