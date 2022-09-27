# Installation

pip install awslocal-cli

    awslocal s3api list-buckets --region us-east-1

# AWD GET LIST OF EC2

    awslocal ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,InstanceType,PublicIpAddress,Tags[?Key==`Name`]| [0].Value]' --output table --region us-east-1
