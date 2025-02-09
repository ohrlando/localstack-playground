AWS_PROFILE=localstack
export AWS_PROFILE

role_name=lbd-test-lambda-execution-role
function_name=lbd-test-lambda

echo "DEPLOYING LAMBDA"
cd ../
zip -r infra/lambda-deploy.zip handler.py requirements.txt

cd infra

function_arn=$(awslocal lambda get-function --function-name $function_name)
if [ -n "$function_arn" ]; then
    awslocal lambda update-function-code \
    --function-name $function_name \
    --zip-file fileb://lambda-deploy.zip \
else
    echo "criando role"
    ROLE_ARN=$(awslocal iam create-role \
        --role-name $role_name \
        --assume-role-policy-document file://trust-policy.json \
        --query Role.Arn \
        --output text)
    awslocal iam attach-role-policy \
        --role-name $role_name \
        --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole


    echo "criando lambda"
    awslocal lambda create-function \
        --function-name $function_name \
        --runtime python3.12 \
        --role $ROLE_ARN \
        --handler handler.lambda_handler \
        --zip-file fileb://lambda-deploy.zip \
fi
