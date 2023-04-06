---
layout: post
title: C++ Perceptron
category: Demo
---
This is a quick implimentation of the Perceptron machine learning algorithm in C++. 
This is a very basic neural network. It can learn how to simulate
basic logic gates through training that updates the weights of links between 
neurons.

<!-- more -->

```C++
#include <iostream>


class perceptron
{
    double r = 1; //learning rate
    double bias = 1;
    double weights[3]{ 0, 0, 0 };
public:
    void train(double x, double y, double expOutput)
    {
        double output = (x * weights[0]) + (y * weights[1]) + (bias * weights[2]);
        if (output > 0)
        {
            output = 1;
        }
        else
        {
            output = 0;
        }
        int error = expOutput - output;
        weights[0] += error * x * r;
        weights[1] += error * y * r;
        weights[2] += error * bias * r;
    }
    double percieve(int x,int  y)
    {
        double output = (x * weights[0]) + (y * weights[1]) + (bias * weights[2]);
        if (output > 0)
        {
            output = 1;
        }
        else
        {
            output = 0;
        }
        return output;
    }
};


int main()
{
    perceptron nN;
    std::cout << "this is a simple neural network trained to act as an inclusive OR gate" << std::endl;
    std::cout << "training..." << std::endl;
    for (size_t i = 0; i < 5000; i++)
    {
        nN.train(0, 0, 0);
        nN.train(0, 1, 1);
        nN.train(1, 0, 1);
        nN.train(1, 1, 1);
    }
    std::cout << "training finished." << std::endl;
    while(true)
    {
        int x, y;
        std::cout << "1st value: ";
        std::cin >> x;
        std::cout << "2nd value: ";
        std::cin >> y;
        std::cout << "the function returned : " << nN.percieve(x, y) << std::endl;

    }
}
```
