#include "convexhull.h"

#include <cmath>
#include <vector>
#include "point.h"
#include "stack.h"
#define _USE_MATH_DEFINES

void sortByAngle(vector<Point>& v){
	if(v.empty()) return;
	
	smallesty(v); //Criterion (i) met
	//insertion sort implementation on a vector
	int i;
	int j;
	double temp;
	Point tempPoint;

	for(i = 2; i < v.size(); i++){
		tempPoint = v[i];
		j = i;
		while(j > 1 && getAngle(v[j-1],v[0]) >= getAngle(tempPoint, v[0])){
			if(getAngle(v[j-1], v[0]) == getAngle(tempPoint, v[0])){
				if(abs(v[j-1].x - v[0].x) > abs(tempPoint.x - v[0].x) || v[j-1].y > tempPoint.y){
					v[j] = v[j-1];
				}
				else break;
			}else 
				v[j] = v[j-1];
				j--;
		}
		v[j] = tempPoint; 

	}
}

bool ccw(Point p1, Point p2, Point p3){
	double ccw = (p2.x - p1.x)*(p3.y - p1.y) - (p2.y - p1.y)*(p3.x - p1.x);
	if(ccw > 0){
		return true;
	}
	if(ccw < 0){
		return false;
	}
	if(ccw == 0){
		return false;
	}
}
vector<Point> getConvexHull(vector<Point>& v){
	vector<Point> points;


	sortByAngle(v);
	if(v.size() < 3){
		points = v;
		return points;
	}


	
	points.push_back(v[0]);
	points.push_back(v[1]);
	


	
	for(int i = 2; i < v.size(); i++){
		
		while(!(ccw(points[points.size()-2],points[points.size()-1], v[i]))){
			points.pop_back();
			
		}
	
		points.push_back(v[i]);
		
		
	}

	return points;
}



		

//Returns the index of the smallest y coord in the vector v
void smallesty(vector<Point>& v){
	double ymin = v[0].y;
	int min = 0;
	for(int i = 1; i < v.size(); i++){
		double y = v[i].y;
		if((y < ymin) || (ymin == y && v[i].x < v[min].x)){
			ymin = v[i].y;
			min = i;
		}
	}
	swap(v[0], v[min]);
}

//Returns the angle formed between v[0] and v[i]
double getAngle(Point p, Point p0){
	double xhyp = p.x - p0.x;
	double yhyp = p.y - p0.y;

	double angle = 0;

	if(sqrt(xhyp*xhyp + yhyp*yhyp) != 0){
		angle = acos(xhyp/sqrt(xhyp*xhyp + yhyp*yhyp))*(180.0/M_PI);
	}
	return angle;
}