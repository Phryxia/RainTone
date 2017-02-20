int CHORD_VARIETY = 16;
int CHAOS_VARIETY = 64;

double CHORD_RANGE = 1;
double CHAOS_RANGE = 1.3;
double DECODE_RANGE = 1;

float runDynamic = 1;
int level = 5;
class RBMSelector
{
  int polySize;
  int depth;
  public DreamNode[][]   nodes;
  public DreamEdge[][][] edges;
  
  public RBMSelector(int polySize, int depth)
  {
    this.polySize = polySize;
    this.depth    = depth;
    nodes = new DreamNode[depth][];
    edges = new DreamEdge[depth - 1][][];
    
    // Create Nodes
    // L0: Input Node
    nodes[0] = new DreamNode[polySize];
    for(int n = 0; n < polySize; ++n)
    {
      nodes[0][n] = new DreamNode(FUNC_IDENTITY, runDynamic);
    }
    
    // L1: Code Recognition Node
    nodes[1] = new DreamNode[CHORD_VARIETY];
    for(int n = 0; n < CHORD_VARIETY; ++n)
    {
      nodes[1][n] = new DreamNode(FUNC_SIGMOID, 0.3);
    }
    edges[0] = connect(nodes[0], nodes[1], CHORD_RANGE);
    
    // L2  ~ L[d-2]: Chaotic
    for(int d = 2; d <= depth - 2; ++d)
    {
      nodes[d] = new DreamNode[CHAOS_VARIETY];
      for(int n = 0; n < CHAOS_VARIETY; ++n)
      {
        nodes[d][n] = new DreamNode(FUNC_CHAOTIC, 0);
      }
      edges[d - 1] = connect(nodes[d - 1], nodes[d], CHAOS_RANGE);
    }
    
    // L[d-1]: Decoder
    nodes[depth - 1] = new DreamNode[polySize];
    for(int n = 0; n < polySize; ++n)
    {
      nodes[depth - 1][n] = new DreamNode(FUNC_SIGMOID, 0);
    }
    edges[depth - 2] = connect(nodes[depth - 2], nodes[depth - 1], DECODE_RANGE);
  }
  
  public void step()
  {
    shift();
    doTransition();
  }
  
  private void shift()
  {
    // Copy last level's output to the first level's state
    for(int n = 0; n < polySize; ++n)
    {
      nodes[0][n].setInput(nodes[depth - 1][n].oValue);
    }
  }
  
  private void doTransition()
  {
    for(int d = 0; d < depth - 1; ++d)
    {
      for(int m = 0; m < nodes[d + 1].length; ++m)
      {
        double temp = 0.0;
        for(int n = 0; n < nodes[d].length; ++n)
        {
          temp += nodes[d][n].oValue * edges[d][n][m].weight;
        }
        nodes[d + 1][m].setInput(temp);
      }
    }
  }
  
  public int[] getSelections(int from, int to, int count)
  {
    int[] result = new int[count];
    ArrayList <Dictionary> pairs = new ArrayList <Dictionary> (to - from + 1);
    for(int i = from; i <= to; ++i)
    {
      Dictionary candidate = new Dictionary();
      candidate.put("index", i);
      candidate.put("value", nodes[depth - 1][i].oValue);
      pairs.add(candidate);
    }
    selectionSort(pairs, new DictComp("value"));
    for(int i = 0; i < count; ++i)
    {
      result[i] = (int)pairs.get(i).get("index");
    }
    
    return result;
  }
  
  public double tFunction(double x)
  {
    return 2 * x * exp((float)(-x*x));
    //return 1.0 / (1.0 + exp((float)-x));
  }
}