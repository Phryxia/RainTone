class Dictionary extends HashMap <String, Object> { }
class DictComp
{
  String compKeyName;
  public DictComp(String compKeyName)
  {
    this.compKeyName = compKeyName;
  }
  
  public int comp(Dictionary d1, Dictionary d2)
  {
    return ((double)d1.get(compKeyName) > (double)d2.get(compKeyName) ? -1 :
      ((double)d1.get(compKeyName) == (double)d2.get(compKeyName) ? 0 : 1));
  }
}

void selectionSort(ArrayList <Dictionary> list, DictComp comp)
{
  for(int i = 0; i < list.size() - 1; ++i)
  {
    int swapIdx = i;
    for(int j = i + 1; j < list.size(); ++j)
    {
      if(comp.comp(list.get(swapIdx), list.get(j)) > 0)
      {
        swapIdx = j;
      }
    }
    if(swapIdx != i)
    {
      Dictionary temp = list.get(swapIdx);
      list.set(swapIdx, list.get(i));
      list.set(i, temp);
    }
  }
}