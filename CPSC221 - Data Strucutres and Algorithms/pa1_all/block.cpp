#include "block.h"
#include <vector>
#include <iostream>
using namespace std;

int Block::width() const{
   /* your code here */
   return data[0].size();
}
int Block::height() const{
   /* your code here */
   return data.size();
}

void Block::render(PNG & im, int upLeftX, int upLeftY) const {
   /* your code here */
	int w = width();
	int h = height();
	for(int y = 0; y < h; y++){
		for(int x = 0; x < w; x++){
			
			HSLAPixel pixeldata = data[y][x];
			*im.getPixel(upLeftX+x,upLeftY+y) = pixeldata;
	

			

		}
	}


   return;
}

void Block::build(PNG & im, int upLeftX, int upLeftY, int cols, int rows) {
   /* your code here */
	for(int y = 0; y < rows; y++){
		vector < HSLAPixel> v;
		for(int x = 0; x < cols; x++){
			
			double h = im.getPixel(upLeftX+x,upLeftY+y)->h;
			double s = im.getPixel(upLeftX+x,upLeftY+y)->s;
			double l = im.getPixel(upLeftX+x,upLeftY+y)->l;
			double a = im.getPixel(upLeftX+x,upLeftY+y)->a;
			
			HSLAPixel pixel = HSLAPixel(h,s,l,a);
			v.push_back(pixel);
			
		}
		data.push_back(v);
	}
	

   return;
}
