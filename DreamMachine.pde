class DreamNode
{
  Function function;
  double fuzzy;
  double oValue;
  
  public DreamNode(Function function, double fuzzy)
  {
    this.function = function;
    this.fuzzy    = fuzzy;
    this.oValue   = 0.0;
  }
  
  public void setInput(double iValue)
  {
    oValue = function.compute(iValue + fuzzy * (2 * Math.random() - 1));
  }
}

class DreamEdge
{
  DreamNode iNode;
  DreamNode oNode;
  double    weight;
  
  public DreamEdge(DreamNode iNode, DreamNode oNode, double weight)
  {
    this.iNode = iNode;
    this.oNode = oNode;
    this.weight = weight;
  }
}

DreamEdge[][] connect(DreamNode[] iNodes, DreamNode[] oNodes, double fuzzy)
{
  DreamEdge[][] edges = new DreamEdge[iNodes.length][oNodes.length];
  for(int i = 0; i < iNodes.length; ++i)
  {
    for(int j = 0; j < oNodes.length; ++j)
    {
      edges[i][j] = new DreamEdge(iNodes[i], oNodes[j], fuzzy * (2 * Math.random() - 1));
    }
  }
  return edges;
}