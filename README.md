## IPBES Sustainable Use of Wild Species Assessment - Chapter 3 - Data management report for the figures 3.6

[![Copyright](https://img.shields.io/badge/Copyright-UNESCO%20WHC-red.svg)](https://whc.unesco.org/en/syndication)

This repository contains the code to reproduce the Figure 3.6 of 
the Chapter 3 of the **IPBES Sustainable Use of Wild Species Assessment**. 

For more information: https://zenodo.org/record/7009684

![](figures/ipbes-su-chap3-world_heritage.png)


## System Requirements

This project handles spatial objects with the R package
[`sf`](https://cran.r-project.org/web/packages/sf/index.html). This
package requires some system dependencies (GDAL, PROJ and GEOS). Please
visit [this page](https://github.com/r-spatial/sf/#installing) to
correctly install these tools.


## Usage

First clone this repository, then open the R script `make.R` and run it.
This script will read data stored in the folder `data/` and export the figure
in the folder `figures/`.


## Copyright notice

All material on this page is placed under: 
Copyright © 1992 - 2022 UNESCO/World Heritage Centre. All rights reserved.

Please cite this work as:

> Sonia Carvalho Ribeiro, & Nicolas Casajus. (2022). IPBES Sustainable Use of Wild Species Assessment - Chapter 3 - Data management report for the figures 3.6. Zenodo. https://doi.org/10.5281/zenodo.7009684
