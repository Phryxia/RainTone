/**
  ScaleMapper is a simple midi pitch generator.
*/
import ddf.minim.*;
import ddf.minim.ugens.*;
class ScaleMap
{
  public int octavePerCycle;
  public int[] idxToTone;
  public ScaleMap(int ... offsets)
  {
    idxToTone = new int[offsets.length + 1];
    idxToTone[0] = 0;
    for(int i = 0; i < offsets.length; ++i)
    {
      idxToTone[i + 1] = idxToTone[i] + offsets[i];
    }
    octavePerCycle = (int)Math.ceil(idxToTone[idxToTone.length - 1] / 12.0);
  }
  
  public int indexToTone(int index)
  {
    int cycle = index / idxToTone.length;
    int localTone = index % idxToTone.length;
    return cycle * octavePerCycle * 12 + idxToTone[localTone];
  }
}

ScaleMap SCALE_MAJOR = new ScaleMap(2, 2, 1, 2, 2, 2);
ScaleMap SCALE_DORIAN = new ScaleMap(2, 1, 2, 2, 2, 1);
ScaleMap SCALE_MIXOLYDIAN = new ScaleMap(2, 2, 1, 2, 2, 1);

float toneToFreq(int tone, float base)
{
  return (float)(base * Math.pow(2, tone/12.0));
}

class KkyuSynthesizer implements AudioListener
{
  Oscil[] osc;
  ADSR[]  oscEnv;
  Gain[]  oscGain;
  Summer  oscSum;
  Gain    mstGain;
  
  public KkyuSynthesizer(
    int polysize,
    float baseFreq,
    ScaleMap scaleMap,
    UGen outNode)
  {
    oscSum = new Summer();
    mstGain = new Gain(-8);
    osc = new Oscil[polysize];
    for(int i = 0; i < polysize; ++i)
    {
      osc[i] = new Oscil(toneToFreq(scaleMap.indexToTone(i), baseFreq), 1);
    }
    oscEnv = new ADSR[polysize];
    for(int i = 0; i < polysize; ++i)
    {
      oscEnv[i] = new ADSR(1, 0.01, 3, 0);
      osc[i].patch(oscEnv[i]);
    }
    oscGain = new Gain[polysize];
    for(int i = 0; i < polysize; ++i)
    {
      oscGain[i] = new Gain(-16);
      oscEnv[i].patch(oscGain[i]);
      oscGain[i].patch(oscSum);
    }
    oscSum.patch(mstGain);
    mstGain.patch(outNode);
  }
  
  public void trigger(int tone)
  {
    if(0 <= tone & tone < osc.length)
    {
      oscEnv[tone].noteOn();
    }
  }
  
  private void audioLoop()
  {
    for(ADSR env : oscEnv)
    {
      if(env.getLastValues()[0] < 0.0001)
      {
        env.noteOff();
      }
    }
  }
  
  public synchronized void samples(float[] samp)
  {
    audioLoop();
  }
  
  public synchronized void samples(float[] sampL, float[] sampR)
  {
    audioLoop();
  }
}