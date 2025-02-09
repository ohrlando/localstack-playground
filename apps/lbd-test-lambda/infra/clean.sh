# verificando se existe
function_arn=$(awslocal lambda get-function --function-name $function_name)
if [ -n "$function_arn" ]; then
    awslocal lambda delete-function --function-name=$function_name
fi

role_arn=$(awslocal iam get-role --role-name=$role_name --query Role.Arn --output text)
if [ -n "$role_arn" ]; then
  awslocal iam detach-role-policy \
    --role-name $role_name \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
  awslocal iam delete-role --role-name $role_name
fi
