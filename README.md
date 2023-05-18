# MIPS89-pipeline-CPU
同济大学CS《计算机系统实验》实验一TongJi University CS computer system experiment assignment 1
## 概述

本工程为2021年同济大学计算机系计算机系统实验实验1。本次实验使用Verilog语言实现了89条MIPS指令的多周期CPU的设计、仿真和下板。支持cp0和时钟中断。

## 功能说明

CPU采用动态流水技术，内含2bit分支预测器。

## 环境

### 软件环境

开发环境Vivado 2020.2

仿真环境ModelSim PE 10.4c

测试环境MARS 4.5（小端）、notepad++

### 硬件环境

NEXYS 4 DDR Atrix-7

## 备注

带分支预测的54条指令动态流水CPU由我在2021年寒假重构完成。本学期在此基础上实现新增的指令以及中断。过程较为顺利。

如果本仓库有帮助到你，就送我一颗star吧🤗
