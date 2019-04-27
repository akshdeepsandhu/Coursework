#include "stack.h"
#include <vector>
#include "point.h"


//note that st is the stack, made up of a vetor containing points

Point Stack::peek(){
	
	if(st.empty()){
		return Point(0,0);
	}
	else return st.back(); 
}
int Stack::size(){ return st.size();}
bool Stack::isEmpty(){return st.empty();}
void Stack::push(Point p){st.push_back(p);}
Point Stack::pop(){

	if(st.empty()){
		return Point(0,0);
	}

	else{
		Point p = st.back();
		st.pop_back();
		return p;
	}
}
