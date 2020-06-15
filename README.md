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
- Route Tables

These items do not cost any money by themselves.   Adding a NAT Gateway or resources to the VPC, however, will cost money.  **Spin up those resources at your cost.**

### Public, Private, Protected?

This subnet breakout is based upon the NIST standard subnet breakout.  See [AWS Docs](https://docs.aws.amazon.com/quickstart/latest/compliance-nist/overview.html) for more info.

## What in an example folder

Each example folder will container the following:

- One or more .tf files
- A README explaining the particular example

## What this isn't covering

- Network security
- Network design
- The hows and whys of NACLS
- NACLS vs. Security Groups

To be clear, this is intended to teach others about principles of IaC, Terraform, a clean code.  These should not be used in any production setting.

There are many great places to find more information including Youtube video, Course sites (acloud.guru, linuxacademy, etc), AWS documentation, and many books. 

## Pull request and issues welcome 

I will do my best to keep this update to date.  PR and issue are more the welcome.

Happy Coding.