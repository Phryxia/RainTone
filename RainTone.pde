import ddf.minim.*;
import ddf.minim.ugens.*;

int POLY_SIZE = 20;
float BASE_FREQ = 220.0f;
Minim minim;
AudioOutput audioOut;
Summer synthSum;
RBMSelector rbm;
KkyuSynthesizer synthHi, synthLo;

PGraphics rbmState;

int t = 0;
void setup()
{
  size(640, 360);
  colorMode(HSB, 1);
  background(0);
  
  minim = new Minim(this);
  audioOut = minim.getLineOut(Minim.STEREO, 2048);
  synthSum = new Summer();
  synthSum.patch(audioOut);
  
  synthHi = new KkyuSynthesizer(POLY_SIZE, BASE_FREQ, SCALE_MAJOR, synthSum);
  audioOut.addListener(synthHi);
  
  synthLo = new KkyuSynthesizer(POLY_SIZE, BASE_FREQ, SCALE_MAJOR, synthSum);
  audioOut.addListener(synthLo);
  
  rbm = new RBMSelector(POLY_SIZE, level);
  
  rbmState = createGraphics(100, 100);
  
  frameRate(4);
}

void draw()
{
  // RBM Test Code
  loadPixels();
  for(int x = 0; x < width; ++x)
  {
    for(int y = 0; y < height - 1; ++y)
    {
      pixels[y * width + x] = pixels[(y + 1) * width + x]; 
    }
    pixels[(height - 1) * width + x] = color(0);
  }
  updatePixels();
    
  // Plot RBM's state
  rbm.step();
  int[] result;
  if(t % 2 == 0 && random(0, 1) > 0.1)
  {
    result = rbm.getSelections(POLY_SIZE/2, POLY_SIZE - 1, (int)floor(random(1, 3)));
    for(int i = 0; i < result.length; ++i)
    {
      stroke(map(i, 0, result.length, 0, 1), 1, 1);
      synthHi.trigger(result[i]);
      line(map(result[i], 0, POLY_SIZE, 0, width), height - 1,
      map(result[i] + 1, 0, POLY_SIZE, 0, width), height - 1);
    }
  }
  if(random(0, 1) > 0.8)
  {
    if(Math.random() > 0.5) rbm.step();
    result = rbm.getSelections(0, POLY_SIZE/2 - 1, 1);
    for(int i = 0; i < result.length; ++i)
    {
      stroke(map(i, 0, result.length, 0, 1), 1, 1);
      synthLo.trigger(result[i]);
      line(map(result[i], 0, POLY_SIZE, 0, width), height - 1,
      map(result[i] + 1, 0, POLY_SIZE, 0, width), height - 1);
    }
  }
  ++t;
  
  // Draw R
  rbmState.beginDraw();
  rbmState.colorMode(HSB, 1);
  rbmState.background(0);
  
  float widthPerStage = (float)rbmState.width / rbm.depth;
  for(int k = 0; k < rbm.depth; ++k)
  {
    float heightPerBlock = (float)rbmState.height / rbm.nodes[k].length;
    for(int i = 0; i < rbm.nodes[k].length; ++i)
    {
      float y = i * heightPerBlock;
      if(rbm.nodes[k][i].function == FUNC_SIGMOID || rbm.nodes[k][i].function == FUNC_CHAOTIC)
      {
        rbmState.fill(0, (float)(-1 + 2 * rbm.nodes[k][i].oValue), 1);
      }
      else
      {
        rbmState.fill(0, atan((float)rbm.nodes[k][i].oValue) / HALF_PI, 1);
      }
      
      rbmState.rect(k * widthPerStage, y, widthPerStage * 0.8, heightPerBlock);
    }
  }
  
  rbmState.endDraw();
  image(rbmState, 10, 10);
  
  
}