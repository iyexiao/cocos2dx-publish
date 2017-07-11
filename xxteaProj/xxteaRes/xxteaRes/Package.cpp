//
//  Package.cpp
//  makePng
//
//  Created by welove on 16/5/5.
//  Copyright © 2016年 hoospo. All rights reserved.
//

#include "Package.hpp"
#include "xxtea.h"
#include <stdio.h>



Package *Package::getInstance()
{
    static Package _instance;
    return &_instance;
}
Package::~Package()
{
    
}
bool Package::resFile(const std::string fname,const std::string key)
{
    
    size_t _keyLen = strlen(key.c_str());
    
    unsigned char* buffer = nullptr;
    size_t size = 0;
    size_t readsize;
    do
    {
        FILE *fp = fopen(fname.c_str(),"rb");
        if(!fp)
        {
            break;
        }
        fseek(fp,0,SEEK_END);
        size = ftell(fp);
        fseek(fp,0,SEEK_SET);
        buffer = (unsigned char*)malloc(sizeof(unsigned char) *size);
        readsize = fread(buffer, sizeof(unsigned char), size, fp);
        fclose(fp);
    } while (0);

    xxtea_long ret_len;
    
    unsigned char* ret_data= xxtea_encrypt(buffer, (xxtea_long)readsize,(unsigned char *)key.c_str(), (xxtea_long)_keyLen, &ret_len);
    
    if (ret_data==NULL) {
        return false;
    }
    
    FILE*fpw=fopen(fname.c_str(), "wb+");
    if (fpw==NULL) {
        return false;
    }
    fwrite(ret_data, ret_len, 1, fpw);
    fflush(fpw);
    fclose(fpw);
//    printf("resFile:%s--end\n",fname.c_str());
    return true;
}

