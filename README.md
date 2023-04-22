# OCI DevOps Challenge

## Terraform

To deploy the compute, you will need to update `terraform/variables.tf` with your tenancy, root compartment, and user IDs as well as your
SSH private key path and fingerprint for the provider. Once you've done that, deploying the compute is done as follows:

````
cd terraform/
terraform init
terraform apply
````

Feel free to check the plan output first with `terraform plan` as needed.

## Dropwizard

To run the application locally, you will need to run the following:

```
cd dropwizard/
mvn package
java -jar target/devops-service-1.0-SNAPSHOT.jar server devops.yml
```

There is also a Dockerfile as requested. For simplicity, I've made the container very simple so you will still need
to run `mvn package` before you can build the Dockerfile locally.

```
cd dropwizard/
mvn package
docker build . -t jmangs/oci-devops-challenge
```

After that just run the container as you wish. You can also do `docker pull jmangs/oci-devops-challenge` to just grab the public DockerHub image.