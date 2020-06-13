# terraformed-vpc

This is an interative look at Terraform and terraforming vpcs.  There are several reasons to do this:

- To help my own understanding of Hashicorp's Terraform
- To aid others in learning Terraform
- To aid the community on various patterns and layers of sophistication in IaC

## What's in a VPC

In each example we will be building a VPC will the following elements:

- VPC
- 2 Public, 2 Private, 2 Protected Subnets
- NACLS associate with Public, Private, and Protected Subnets
- IGW

These items do not cost any money by themselves.   Adding a NAT Gateway or resources to the VPC, however, will cost money.  **Spin up those resources at your cost.**

## What in an example folder

Each example folder will container the following:

- One or more .tf files
- A README explaining the particular example
