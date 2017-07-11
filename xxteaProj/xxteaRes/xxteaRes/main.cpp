//
//  main.cpp
//  xxteaRes
//
//  Created by yexiao on 16/5/23.
//  Copyright © 2016年 yexiao. All rights reserved.
//

#include <iostream>
#include "Package.hpp"

int main(int argc, const char * argv[]) {
    // insert code here...
//    std::cout << "Hello, World!\n";
    if (argc == 3) {
        Package::getInstance()->resFile(argv[1],argv[2]);
    }
    return 0;
}
