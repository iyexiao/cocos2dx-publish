//
//  Package.hpp
//  makePng
//
//  Created by welove on 16/5/5.
//  Copyright © 2016年 hoospo. All rights reserved.
//

#ifndef Package_hpp
#define Package_hpp

#include <stdio.h>
#include <fstream>
#include <vector>
#include <iostream>

class Package
{
public:
    static Package *getInstance();
    bool resFile(const std::string fname,const std::string key);
    Package(){};
    ~Package();
private:
};
#endif /* Package_hpp */
