# Why Cloud?

**Difference between running application on-premises & cloud?**

- Run on-premises creates additional environment requires buying more hardwares. (Test new features in separate quality assurance environment)
- Run in cloud can replicate entire environment in seconds/minutes, instead of physically install hardware, manage physical infrastructure over internet.
- Also don't need to worry about things like installing virtual machine/storing backups.

# AWS Introduction

### Data centers

**What's availability zone?**

Consists of one or more data centers with redundant power/networking/connectivity.

**What's region?**

A cluster of AZ is called a region

**How to choose a region?**

- Compliance, regulations on data
- Latency
- Pricing, vary across regions
- Service Availability, some regions will not have new features.

### IAM

When creating your account, you created the root user. However, you want to create a IAM role, with all admin permissions.

**Best practices when working with root user?**

- Strong password
- Never share password/secret access key
- Disable/delete access keys
- Not use root user for admin/everyday tasks

**Evaluation logic for a request with a single account.**

- By default, all request are implicitly denied
- An explicit "Allow" in policies overrides this default
- If permissions boundary, i.e. Organization SCP (session policy present), overrides the allow.
- Explicit deny in all policies, overrides any allow.

### EC2

**Compute as a service (CAAS) model**

Computing resources are supplied on demand via virtual/physical resources(pay-per-use)

**On-demand Instances**

Pay for compute capacity by hour or by second. Can increase/decrease capacity based on demands.

**t2.micro**

Instance type (The blend of the resources)
Instance size (How much capacity instance has)

**Security Group**

Default configuration of secuity groups, block all the inbound traffic and allow all outbound traffic.
Want EC2 instance to accept traffic from internet, open up the inbound ports.
If have a web server, need to accept HTTP and HTTPS requests.

### S3

**What's S3?**

Standalone storage solution, not tied with the compute, enables you retrieve data from anywhere on the web.

**What's buckets in S3?**

Can't upload anything S3 without creating a bucket first. Choose the bucket name and region.
bucket name: must be unique across all the AWS accounts
region: put it where all the computes are.


**S3 use cases:**

- Backup and storage: Due to highly redundant nature
- Media Hosting: Can store unlimited number of objects (Videos/Photos/Music for customers to download)
- Software delivery: Host software applications using S3.
- Data Lakes: Virtually unlimited scabability.
- Static websites
- Static content: Blog post/news articles


**Encryption types in S3:**

Server-side encryption: Allows the S3 to encrypt the object before saving on disks in its data centers and decrypt data when downloading

Client-side encryption: Encrypt your data before uploading to S3. YOU manage the encrption process


```python

```
