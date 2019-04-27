#include "HSLAPixel.h"

HSLAPixel::HSLAPixel(){
	h = 0;
	s = 0;
	l = 1.0;
	a = 1.0;
}

HSLAPixel::HSLAPixel(double hue, double sat, double lum){
	h = hue;
	s = sat;
	l = lum;
}

HSLAPixel::HSLAPixel(double hue, double sat, double lum, double ta){
	h = hue;
	s = sat;
	l = lum;
};

