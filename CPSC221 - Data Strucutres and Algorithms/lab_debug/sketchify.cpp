#include <cstdlib>
#include <cmath>
#include <iostream>
#include "cs221util/PNG.h"
#include "cs221util/HSLAPixel.h"

using namespace cs221util;
using namespace std;

// sets up the output image
PNG* setupOutput(unsigned w, unsigned h) {
    PNG* image = new PNG(w, h);
    return image;
}

// Returns my favorite color
HSLAPixel* myFavoriteColor(double saturation) {
    HSLAPixel pixel(27, saturation, 0.5);
    return &pixel;
}

void sketchify(std::string inputFile, std::string outputFile) {
    // Load in.png
    PNG* original = new PNG();
    cout << "Reached line 25" << endl;
    original->readFromFile(inputFile);
    unsigned width = original->width();
    unsigned height = original->height();
    cout << "Reached line 29" << endl;

    // Create out.png
    PNG* output;
    output = setupOutput(width, height);
    

    // Load our favorite color to color the outline
    HSLAPixel* myPixel = myFavoriteColor(0.5);

    // Go over the whole image, and if a pixel differs from that to its upper
    // left, color it my favorite color in the output
    for (unsigned y = 1; y < height; y++) {
        for (unsigned x = 1; x < width; x++) {
            
            // Calculate the pixel difference
            HSLAPixel* prev = original->getPixel(x - 1, y - 1);
            HSLAPixel* curr = original->getPixel(x, y);
            double diff = std::fabs(curr->h - prev->h);

            // If the pixel is an edge pixel,
            // color the output pixel with my favorite color
            HSLAPixel* currOutPixel = output->getPixel(x,y);
            if (diff > 20) {
                *currOutPixel = *myPixel; //You need  * to change the actual value of currOutPixel
            }
            
        }
        
    }
    cout << "Reached line 59" << endl;

    // Save the output file
    output->writeToFile(outputFile);

    // Clean up memory
    //delete myPixel; --> You must delete when you create a new pointer (it creates space in memory for the pointer ont in the stack)
    delete output;
    delete original;
}
