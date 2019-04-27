#include "stats.h"
#include "cs221util/PNG.h"
#include "cs221util/RGBAPixel.h"
#include <utility>
#include <vector>
#include "math.h"
using namespace std;
using namespace cs221util;


vector< vector< long >> sumRed;
vector< vector< long >> sumGreen;
vector< vector< long >> sumBlue;
vector< vector< long >> sumsqRed;
vector< vector< long >> sumsqGreen;
vector< vector< long >> sumsqBlue;

	/* returns the sums of all pixel values across all color channels.
	* useful in computing the score of a rectangle
	* PA3 function
	* @param channel is one of r, g, or b
	* @param ul is (x,y) of the upper left corner of the rectangle 
	* @param lr is (x,y) of the lower right corner of the rectangle */

long stats::getSumHelp(pair<int,int> ul, pair<int,int> lr, vector< vector< long >> &Sumvector){
	int lr_x = lr.first;
	int lr_y = lr.second;
	int ul_x = ul.first;
	int ul_y = ul.second;
	long result = Sumvector[lr_y][lr_x];

	if(ul_x != 0)
		result -= Sumvector[lr_y][ul_x - 1];
	if(ul_y != 0)
		result -= Sumvector[ul_y - 1][lr_x];
	if(ul_x != 0 && ul_y != 0)
		result +=  Sumvector[ul_y-1][ul_x-1];
	return result;
}


long stats::getSum(char channel, pair<int,int> ul, pair<int,int> lr){
	long sum = 0;
	if(channel == 'r'){
		sum = getSumHelp(ul,lr,sumRed); 
		
	}
	else if(channel == 'g'){
		sum = getSumHelp(ul,lr,sumGreen);
		
	}
	else if(channel == 'b'){
		 sum = getSumHelp(ul,lr,sumBlue);
		
	}
	return sum;

}

	/* returns the sums of squares of all pixel values across all color channels.
	* useful in computing the score of a rectangle
	* PA3 function
	* @param channel is one of r, g, or b
	* @param ul is (x,y) of the upper left corner of the rectangle 
	* @param lr is (x,y) of the lower right corner of the rectangle */
long stats::getSumSq(char channel, pair<int,int> ul, pair<int,int> lr){
	long sum = 0;
	if(channel == 'r'){
		sum = getSumHelp(ul,lr,sumsqRed); 
		
	}
	else if(channel == 'g'){
		sum = getSumHelp(ul,lr,sumsqGreen);
		
	}
	else if(channel == 'b'){
		sum = getSumHelp(ul,lr,sumsqBlue);
		
	}
	return sum;

}

long stats::rectArea(pair<int,int> ul, pair<int,int> lr){
	long width = lr.first - ul.first + 1;
	long height = lr.second - ul.second + 1;
	return width*height;
}


long stats::getScore(pair<int,int> ul, pair<int,int> lr){
	long area = rectArea(ul,lr);
	long r = getSum('r',ul,lr); 
	long g = getSum('g',ul,lr); 
	long b = getSum('b',ul,lr);

	long score;
	long rScore = getSumSq('r',ul,lr) - ((r*r)/area);
	long gScore = getSumSq('g',ul,lr)- ((g*g)/area);
	long bScore = getSumSq('b',ul,lr) - ((b*b)/area);
	score = rScore + gScore + bScore;
	return score;

}
	// given a rectangle, return the average color value over the 
	// rectangle as a pixel.
	/* Each color component of the pixel is the average value of that 
	* component over the rectangle.
	* @param ul is (x,y) of the upper left corner of the rectangle 
	* @param lr is (x,y) of the lower right corner of the rectangle */
RGBAPixel stats::getAvg(pair<int,int> ul, pair<int,int> lr){
	long area = rectArea(ul,lr);
	long r = (getSum('r',ul,lr))/ area;
	long g = (getSum('g',ul,lr)) / area;
	long b = (getSum('b',ul,lr))/ area ;

	
	
	return RGBAPixel((int)r,(int)g,(int)b);
}

	// given a rectangle, return the number of pixels in the rectangle
	/* @param ul is (x,y) of the upper left corner of the rectangle 
	* @param lr is (x,y) of the lower right corner of the rectangle */


// initialize the private vectors so that, for each color,  entry 
	// (x,y) is the cumulative sum of the the color values from (0,0)
	// to (x,y). Similarly, the sumSq vectors are the cumulative
	// sum of squares from (0,0) to (x,y).
stats::stats(PNG & im){
	unsigned int width = im.width();
	unsigned int height = im.height();

	/*copy of first row in the image*/
	sumRed.resize(height, vector<long> (width));
	sumGreen.resize(height, vector<long> (width));
	sumBlue.resize(height, vector<long> (width));
	sumsqRed.resize(height, vector<long> (width));
	sumsqGreen.resize(height, vector<long> (width));
	sumsqBlue.resize(height, vector<long>(width));



	/*Row Col sum*/
	for(unsigned int y = 0; y < height; y++){
			long r,g,b;
			r=0;
			g=0;
			b=0;

		for(unsigned int x = 0; x < width; x++){
			RGBAPixel * pixel = im.getPixel(x,y);
			
			r += pixel->r;
			g += pixel->g;
			b += pixel->b;

			sumRed[y][x] =  r;
			sumGreen[y][x] =  g;
			sumBlue[y][x] = b;
			sumsqRed[y][x] =  r*r ;
			sumsqGreen[y][x] = g*g ;
			sumsqBlue[y][x] = b*b ;



			if(y > 0){
			sumRed[y][x] += sumRed[y-1][x];
			sumGreen[y][x] += sumGreen[y-1][x] ;
			sumBlue[y][x] += sumBlue[y-1][x] ;
			sumsqRed[y][x] +=  sumsqRed[y-1][x] ;
			sumsqGreen[y][x] += sumGreen[y-1][x];
			sumsqBlue[y][x] +=  sumsqBlue[y-1][x];
		}



			}
		}
	}




	

	






