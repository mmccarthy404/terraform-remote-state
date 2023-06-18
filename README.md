# terraform-remote-state

Highly circular-dependent Terraform project; responsible for remote state infrastructure used accross all projects (including this one).

A number of AWS resources are provisioned through this deployment:
* S3 (w/ versioning) for storing remote state (**circular-dependency**)
* DynamoDB for state locking (**circular-dependency**)
* GitHub OIDC IAM Identity Provider for federated trust between GitHub repos (**circular-dependency**)
* IAM Role for *this* repo federated by GitHub (**circular-dependency**)
* IAM Roles for all other repos federated by GitHub