#ifndef ASHSANDHU_2018
#define ASHSANDHU_2018

class HSLAPixel{

	
	public: 
		double h;  //Hue
		double s; //saturation 
		double l; //luminence 
		double a; //transparency 
		HSLAPixel();
		HSLAPixel(double hue, double sat, double lum);
		HSLAPixel(double hue, double sat, double lum, double ta);

};
#endif /* ASHSANDHU_2018 */
