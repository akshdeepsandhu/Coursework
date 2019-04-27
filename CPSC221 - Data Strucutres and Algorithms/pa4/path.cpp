#include "path.h"
#include <queue>
#include <stack>
using namespace std;

path::path(const PNG & im, pair<int,int> s, pair<int,int> e)
   :start(s),end(e),image(im){
    BFS();
}

void path::BFS(){
	// initialize working vectors
	vector<vector<bool>>          Visited     (image.height(), vector<bool> (image.width(),false));
	vector<vector<pair<int,int>>> Predecessor (image.height(), vector<pair<int,int>> (image.width(),end));

    /* your code here */

   //mark start node as visited and enqueue
   queue<pair<int,int>> queue;
   Visited[start.second][start.first] = true;
   Predecessor[start.second][start.first]= start;
   queue.push(start);

   while(!queue.empty()) {
      pair<int,int> curr             = queue.front();
      vector<pair<int,int>> neighbor = neighbors(curr);
      queue.pop();
      //get all adjacent verticies
      for(int i = 0; i < neighbor.size(); i++){
         pair<int,int> next = neighbor[i];
         if(good(Visited,curr,next)){
            queue.push(next);
            Visited[next.second][next.first] = true;
            Predecessor[next.second][next.first] = curr;
         }
      }
   }

   pathPts = assemble(Predecessor,start,end);
   
}

PNG path::render(){
   PNG out             = PNG(image);
   RGBAPixel pathPixel = RGBAPixel(255, 0, 0);

   for (int i = 0; i < length(); i++){
       int x = pathPts[i].first;
       int y = pathPts[i].second;
       *out.getPixel((unsigned int)x, (unsigned int) y) = pathPixel;
   }

   return out;
}

vector<pair<int,int>> path::getPath() { return pathPts;}

int path::length() { return pathPts.size();}

bool path::good(vector<vector<bool>> & v, pair<int,int> curr, pair<int,int> next){

   //if next pixel out of bounds of image, return false
   if (next.first >= image.width() || next.first < 0 || next.second >= image.height() || next.second < 0)
      return false;
   //if next pixel has already been visited, return false
   if (v[next.second][next.first])
      return false;
   //if next pixel dissimilar to curr, return false, else true
   RGBAPixel currPixel = *image.getPixel((unsigned int) curr.first, (unsigned int) curr.second);
   RGBAPixel nextPixel = *image.getPixel((unsigned int) next.first, (unsigned int) next.second);
   return (closeEnough(currPixel, nextPixel));

}

vector<pair<int,int>> path::neighbors(pair<int,int> curr) {
	vector<pair<int,int>> neighbours;

   pair<int,int> above  (curr.first,curr.second - 1);
   pair<int,int> below  (curr.first, curr.second + 1);
   pair<int,int> left   (curr.first - 1, curr.second);
   pair<int,int> right  (curr.first + 1, curr.second);

   neighbours.push_back(below);
   neighbours.push_back(left);
   neighbours.push_back(above);
   neighbours.push_back(right);
   return neighbours;
}

vector<pair<int,int>> path::assemble(vector<vector<pair<int,int>>> & p,pair<int,int> s, pair<int,int> e) {

    /* hint, gold code contains the following line:
	stack<pair<int,int>> S; */

   stack<pair<int,int>> S;

   vector<pair<int,int>> shortestPath;

   if(p[e.second][e.first] == e){
      //no path exists
      shortestPath.push_back(s);
   }
   else {
      S.push(e);
      pair<int, int> pred = p[e.second][e.first];
      while (pred != s) {
         S.push(pred);
         pred = p[pred.second][pred.first];
      }
      S.push(s);
      while (!S.empty()) {
         shortestPath.push_back(S.top());
         S.pop();
      }
   }

   return shortestPath;
}

bool path::closeEnough(RGBAPixel p1, RGBAPixel p2){
   int dist = (p1.r-p2.r)*(p1.r-p2.r) + (p1.g-p2.g)*(p1.g-p2.g) +
               (p1.b-p2.b)*(p1.b-p2.b);

   return (dist <= 80);
}
