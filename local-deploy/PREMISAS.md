Your main goal is to cloudificate the following monolithic application into a 12-factor-app microservice using Docker and k8s (not an explicit requirement).

Keep in mind the service:

* should contain “production ready” configurations
* should scale out n times easily
* should adapt to dynamic configurations
* object storage must be deployed in AWS

After finishing your task, you should provide the following items:

* local configuration manifest for local deployment
* docker images and deployment manifests
* detailed deployment and configuration documentation
* AWS user credentials to review what have you done (Here please use free tier services)
* a few words about your solution. How does it work? Why did you choose to go that way? Why do you think this is the best approach? Would you make any changes to the application? (source code/automation), why?

Please create a GitHub/Gitlab/Bitbucket/CodeCommit public repo and share your solution with us. Repository name must follow this pattern “your-first-name-letter-surname-devops-application”. (e.g) If Nicolas Porta submits a solution, the repo name should be “nporta-devops-application”

Other tasks:

* Set a basic CI/CD flow using the tool you feel most comfortable (add configurations in your repo)
* Use a K8S cluster or another solution that contemplates running containers (add manifests)
  * Tip use a k3s or k0s kubernetes cluster.
* Deploy everything in AWS

Anything that is not specified here is up to your criteria, taking into account all of the points mentioned above. Do not forget to include clear documentation that allows us to start and test the project locally.

We highly recommend you to use AWS Free-tier for deploying everything you need.

