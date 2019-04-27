#include "convexintersection.h"
#include <cmath>
#include <vector>
#include "point.h"

bool inside(Point p1, Point sp1, Point sp2){
	int x,y,x1,x2,y1,y2;	
	x = p1.x;
	y = p1.y;
	x1 = sp1.x;
	x2 = sp2.x;
	y1 = sp1.y;
	y2 = sp2.y;
	return (x2-x1)*(y-y2) >= (y2 - y1)*(x - x2);
}

Point computeIntersection(Point s1, Point s2, Point i1, Point i2){
	Point A,B, intersection;
	float K,L;
	float m;
	A.x = s1.x-s2.x;
	A.y = s1.y-s2.y;
	B.x = i1.x - i2.x;
	B.y = i1.y - i2.y;
	K = (s1.x * s2.y) - (s1.y * s2.x);
	L = (i1.x * i2.y) - (i1.y * i2.x);
	m = 1 /(A.x * B.y - A.y * B.x );
	intersection.x = m * (K * B.x - L * A.x);
  	intersection.y = m * (K * B.y - L * A.y);
	return intersection;}

vector<Point> getConvexIntersection(vector<Point>& poly1, vector<Point>& poly2){

	vector<Point> temp = poly2;

	for(int i = 0; i<poly1.size(); i++){
		vector<Point> clip;
		Point p2 = poly1[i];
		Point p3;

		if(i == poly1.size()-1)
			p3 = poly1[0];
		else 
			p3 = poly1[i+1];
		for(int j = 0; j < temp.size(); j++){
			Point p0 = temp[j];
			Point p1;

			if(j == temp.size() - 1){
				p1 = temp[0];

			}
			else
				p1 = temp[j+1];
			clipping(p0,p1,p2,p3,clip);
		}
		temp = clip;
	}
	return temp;
}

void clipping(Point p0, Point p1, Point p2, Point p3, vector<Point>& clip){
	if(inside(p0,p2,p3)){
		if(inside(p1,p2,p3)){
			clip.push_back(p1);
		}
		else{
			clip.push_back(computeIntersection(p0,p1,p2,p3));
		}

	}
	else{
		if(inside(p1,p2,p3)){
			clip.push_back(computeIntersection(p0,p1,p2,p3));
			clip.push_back(p1);
		}
	}





};