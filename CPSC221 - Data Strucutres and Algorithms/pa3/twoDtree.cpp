
/**
 *
 * twoDtree (pa3)
 * slight modification of a Kd tree of dimension 2.
 * twoDtree.cpp
 * This file will be used for grading.
 *
 */

#include "twoDtree.h"

/* given */
twoDtree::Node::Node(pair<int,int> ul, pair<int,int> lr, RGBAPixel a)
	:upLeft(ul),lowRight(lr),avg(a),left(NULL),right(NULL)
	{}

/* given */
twoDtree::~twoDtree(){
	clear();
}

/* given */
twoDtree::twoDtree(const twoDtree & other) {
	copy(other);
}

/* given */
twoDtree & twoDtree::operator=(const twoDtree & rhs){
	if (this != &rhs) {
		clear();
		copy(rhs);
	}
	return *this;
}

/* Constructor that builds a twoDtree out of the given PNG.
* Every leaf in the tree corresponds to a pixel in the PNG.
* Every non-leaf node corresponds to a rectangle of pixels
* in the original PNG, represented by an (x,y) pair for the
		* upper left corner of the rectangle and an (x,y) pair for
* lower right corner of the rectangle. In addition, the Node
		* stores a pixel representing the average color over the
* rectangle.
*
* Every node's left and right children correspond to a partition
* of the node's rectangle into two smaller rectangles. The node's
* rectangle is split by the horizontal or vertical line that
		* results in the two smaller rectangles whose sum of squared
		* differences from their mean is as small as possible.
*
* The left child of the node will contain the upper left corner
* of the node's rectangle, and the right child will contain the
* lower right corner.
*
* This function will build the stats object used to score the
		* splitting lines. It will also call helper function buildTree.
*/
twoDtree::twoDtree(PNG & imIn){
	stats stat = stats(imIn);
	height = imIn.height();
	width = imIn.width(); /*Create a stats object used to score the splitting lines*/
	if((imIn.height() != 0 && imIn.width() != 0)){
		pair<int,int> p(0,0);
		pair<int,int> p2(imIn.width()-1 ,imIn.height()-1);
		root = buildTree(stat, p, p2);
	}
	else root = NULL;
}

/**
   * Private helper function for the constructor. Recursively builds
   * the tree according to the specification of the constructor.
   * @param s Contains the data used to split the rectangles
   * @param ul upper left point of current node's rectangle.
   * @param lr lower right point of current node's rectangle.
   */
twoDtree::Node * twoDtree::buildTree(stats & s, pair<int,int> ul, pair<int,int> lr) {

	
	if(lr.first == ul.first && ul.second == lr.second){
		/*means you have reached final pixel*/
		
		return new Node(ul,lr,s.getAvg(ul,lr));
	}

	if ((ul.first == lr.first && lr.second == ul.second + 1) || (ul.second == lr.second && lr.first == ul.first + 1)) {
      Node* node = new Node(ul, lr, s.getAvg(ul, lr));
      node->left = new Node(ul, ul, s.getAvg(ul, ul));
      node->right = new Node(lr, lr, s.getAvg(lr, lr));
      return node;
   }


	pair<int,int> best_ulX, best_lrX;
	long bestScoreX = -1;
	long bestScoreY = -1;
	pair<int,int> best_ulY, best_lrY;
	pair<int,int> childlr, childul;
	Node* newNode;



	if(ul.first < lr.first){

		pair<int,int> new_ul(ul.first+1,ul.second);
		pair<int,int> new_lr(ul.first,lr.second);
		bestScoreX = s.getScore(ul,new_lr)+s.getScore(new_ul,lr);
		best_ulX = new_ul;
		best_lrX = new_lr;

	for(int i = ul.first +1; i < lr.first ; i++ ){
		/*go over all possible vertical slits*/
		new_ul.first = i +1;
		new_ul.second = ul.second;
		new_lr.first = i;
		new_lr.second = lr.second;
		long temp = s.getScore(ul,new_lr) + s.getScore(new_ul,lr);
		if(temp <= bestScoreX){
			/*if current partiton is better than previous, store score value and ul,lr*/
			bestScoreX = temp;
			best_ulX  = new_ul;
			best_lrX = new_lr;
			/*at the end of the for loop, best_ulX and best_lrX store best parition 
			split along X-axis and bestScoreX stores their respect scores */ 
			}
		
		}
	}

	
	if(ul.second < lr.second){
		pair<int,int> new_ul(ul.first,ul.second+1);
		pair<int,int> new_lr(lr.first,ul.second);
		bestScoreY = s.getScore(ul,new_lr) + s.getScore(new_ul,lr);
		best_ulY = new_ul;
		best_lrY = new_lr;


		for(int j = ul.second+1; j < lr.second; j++){
			new_lr.first = lr.first;
			new_lr.second = j;
			new_ul.first = ul.first;
			new_ul.second = j+1;
			long temp = s.getScore(ul,new_lr) + s.getScore(new_ul,lr);
			if(temp <= bestScoreY){
			/*if current partiton is better than previous, store score value and ul,lr*/
				bestScoreY = temp;
				best_ulY = new_ul;
				best_lrY = new_lr;
			/*at the end of the for loop, best_ulY and best_lrY store best parition 
			split along Y-axis and bestScoreY stores their respect scores */ 
		}
	}

}



if(bestScoreY != -1 && bestScoreX != -1 ){
	if(bestScoreY <=  bestScoreX){
		childlr =best_lrY;
		childul = best_ulY; 
	}
	else if(bestScoreX < bestScoreY){
		childlr = best_lrX;
		childul = best_ulX;
	}
}
else if(bestScoreY == -1){
	childlr = best_lrX;
	childul = best_ulX;
}
else if(bestScoreX == -1){

	childlr = best_lrY;
	childul = best_ulY;
}
//cout<<"found best splits" << endl;


newNode = new Node(ul,lr,s.getAvg(ul,lr));
newNode->left = buildTree(s,ul,childlr);
newNode->right = buildTree(s,childul,lr);
return newNode;

}

void twoDtree::renderHelp(PNG &im, Node* node){
	if(node == NULL) return;

	if(node->left == NULL && node->right == NULL){
		/*When you have hit a leaf node */
	
		for(int x = node->upLeft.first; x <= node->lowRight.first; x++){
			for(int y = node->upLeft.second; y <= node->lowRight.second; y++){
				RGBAPixel * pixel = im.getPixel(x,y);
				*pixel = node->avg;
				
			}
		}
		
		return;
		
	}
	else {
		renderHelp(im,node->left);
		renderHelp(im,node->right);
	}
		

}


PNG twoDtree::render(){
	//cout<<"started render" << endl;
	
	if(root == NULL){
		 /*new or no not new?? */
		return PNG();
		/*output empty PNG image when there is no tree */
	}

		/*call renderHelp*/
		PNG outImg = PNG((int) width, (int) height); 
		//cout<<"getting help with render"<<endl;
		renderHelp(outImg, root);

		return outImg;
	
	

}




void twoDtree::countLeaves(Node* subroot, int tol,double& leaves, double& tolleaves, RGBAPixel& avg){
	if(subroot == NULL) return;

	if(subroot->right != NULL ||  subroot->left != NULL){
		
		countLeaves(subroot->left, tol, leaves, tolleaves, avg);
		countLeaves(subroot->right, tol, leaves, tolleaves, avg);

		
	}

	else{
		leaves += 1;
		if(((subroot->avg.r - avg.r)*(subroot->avg.r - avg.r) +
              (subroot->avg.g - avg.g)*(subroot->avg.g - avg.g) +
              (subroot->avg.b - avg.b)*(subroot->avg.b - avg.b)) <= tol){
		
			tolleaves += 1;
			}
		}
		
	
}




void twoDtree::pruneHelp(Node* root, double pct, int tol){
	if(root->left == NULL && root->right == NULL) return;
	double leaves, tolleaves;
	leaves = 0;
	tolleaves = 0;
	countLeaves(root,tol,leaves,tolleaves,root->avg);
	/*check left subroot*/
	double inPct = tolleaves/leaves;
	if(inPct >= pct){
		clearNodes(root->right);
		clearNodes(root->left);
	}

	if(root->left != NULL){
		pruneHelp(root->left, pct,tol);

	}
	if(root->right != NULL){
		pruneHelp(root->right, pct, tol);

	}


}

void twoDtree::prune(double pct, int tol){
	//<<"started prune" << endl;
	if(root == NULL) return;

	else 
		pruneHelp(root,pct,tol);
	
	/* your code here */
}

void twoDtree::clear() {
   clearNodes(root);
}

void twoDtree::clearNodes(Node*& subroot) {
   if (subroot == NULL) return;
   clearNodes(subroot->left);
   clearNodes(subroot->right);
   delete(subroot);
   subroot = NULL;
}


void twoDtree::copy(const twoDtree & other){
   if (other.root == NULL) {
      root = NULL;
      height = 0;
      width = 0;
      return;
   }
   root = copy(other.root);
   height = other.height;
   width = other.width;
}

twoDtree::Node* twoDtree::copy(Node* other) {
   if (other == NULL) return NULL;
   Node* newNode = new Node(other->upLeft, other->lowRight, other->avg);
   newNode->left = copy(other->left);
   newNode->right = copy(other->right);
   return newNode;
}


