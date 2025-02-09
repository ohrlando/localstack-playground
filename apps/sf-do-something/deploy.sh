AWS_PROFILE=localstack
export AWS_PROFILE;

sf_name=sf-do-something
role_name=StepFunctionExecutionRole

role_arn=$(awslocal iam get-role --role-name $role_name --query Role.Arn)
sf_arn=$(awslocal stepfunctions list-state-machines|jq '.stateMachines[] | select(.name == "'$sf_name'") | .stateMachineArn' -r)
echo "sf: "$sf_arn", role_arn:"$role_arn

if [ -n "$role_arn" ]; then
  awslocal stepfunctions update-state-machine \
    --state-machine-arn $sf_arn \
    --definition file://step-function-definition.json \
    --role-arn $role_arn
else
  arn=$(awslocal iam create-role \
    --role-name $role_name \
    --assume-role-policy-document file://trust-policy.json \
    --query 'Role.Arn' \
    --output text)

  awslocal stepfunctions create-state-machine \
    --name "sf-do-something" \
    --definition file://step-function-definition.json \
    --role-arn $arn \
    --type EXPRESS
  fi
