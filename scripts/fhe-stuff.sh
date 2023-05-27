#!/bin/bash

# clone repos 
git clone https://github.com/Janmajayamall/bfv.git
git clone https://github.com/Janmajayamall/fhe.rs.git
git clone https://github.com/openfheorg/openfhe-development.git

# checkout fhe.rs to compare branch
cd fhe.rs && git checkout compare
cd ..

# install openfhe
cd openfhe-development && git checkout v1.0.3
mkdir build && cd build
cmake .. 
make -j
sudo make install