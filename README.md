# serverless-api-with-go-and-aws-lambda
Following along Alex Edwards serverless-api-with-go-and-aws-lambda blog post.

```
env GO111MODULE=auto GOOS=linux GOARCH=amd64 go build -o ./main
zip -j terraform/main.zip ./main
cd terraform
terraform apply
```
