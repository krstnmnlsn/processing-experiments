//============================================================================
//============================================================================
// Complex numbers class so I can take (real) powers.

public class Complex {
  float a; // real
  float b; // imaginary
  Complex() {
    a = 0;
    b = 0;
  }
  Complex(float a1, float b1) {
    a = a1;
    b = b1;
  }
  float abs() {
    return sqrt(a*a + b*b);
  }
}

// calculates (a+ib)^p and puts the real part in a and the imaginary in b.
Complex complex_pow(Complex c_in, float p) {
  float a = c_in.a;
  float b = c_in.b;
  Complex c_out = new Complex();
  c_out.a = pow(a*a + b*b, p/2.0) * cos(p * atan2(b, a));
  c_out.b = pow(a*a + b*b, p/2.0) * sin(p * atan2(b, a));
  return c_out;
}

//============================================================================
//============================================================================
// Code to actually draw the multibrot set (for varying values of p) on the complex plane.

// Establish a range of values on the complex plane
// A different range will allow us to "zoom" in or out on the fractal
float xmin = -2;
float ymin = 0;
float w = 3;
float h = 1.5;

int w2 = 640;
int h2 = 360;

void setup() {
  size(w2, h2);
  background(255);
}

void draw() {
  drawM();
}

float p = 2.0;

void drawM() {
  // Make sure we can write to the pixels[] array.
  // Only need to do this once since we don't do any other drawing.
  loadPixels();
  
  // Maximum number of iterations for each point on the complex plane.
  int maxiterations = 100;
  
  // x goes from xmin to xmax
  float xmax = xmin + w;
  // y goes from ymin to ymax
  float ymax = ymin + h;
  
  // Calculate amount we increment x,y for each pixel.
  float dx = (xmax - xmin) / (width);
  float dy = (ymax - ymin) / (height);
  
  // Start y
  float y = ymin;
  for (int j = 0; j < height; j++) {
    // Start x
    float x = xmin;
    for (int i = 0;  i < width; i++) {
  
      // Now we test, as we iterate z = z^p + c does z tend towards infinity?
      Complex c = new Complex(x,y);
      int n = 0;
      while (n < maxiterations) {
          c = complex_pow(c, p);
          c.a = c.a + x;
          c.b = c.b + y;
        // Infinty in our finite world is simple, let's just consider it 100.
        if (c.abs() > 100.0) {
          break;  // Bail
        }
        n++;
      }
  
      // We color each pixel based on how long it takes to get to infinity
      // If we never got there, let's pick the color black.
      if (n == maxiterations) {
        pixels[i+j*width] = color(0);
      }
      else {
        // The slower this pixel / point in the complex plane went to
        // infinity the lighter its colour.
        pixels[i+j*width] = color(n*3 % 255);
      }
      x += dx;
    }
    y += dy;
  }
  updatePixels();
  if (p <= 6) p += 0.01;
  saveFrame("h###.gif");
}
