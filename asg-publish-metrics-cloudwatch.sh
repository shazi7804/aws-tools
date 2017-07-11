#!/bin/bash
#
# Program: Automatic publish custom metrics to AWS CloudWatch.
# Author: scott.liao

helpmsg(){
  echo ""
  echo -e "Usage: $0 [parameters]"
  echo ""
  echo -e "[parameters]"
  echo -e "--data              input data."
  echo -e "--metric-name       select metric name from cloudwatch."
  echo -e "--namespace         select namespace from cloudwatch."
  echo -e "--unit              select unit from cloudwatch."
  echo -e "--region            select AWS region."
  echo ""
  echo -e "You can see AWS User Guide for CloudWatch:"
  echo -e "http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/publishingMetrics.html"
  echo ""
  exit 2
}

CheckEMV() {
  # check awscli
  which aws
  if [ $? -ne 0 ]; then
    sudo apt-get install -y awscli
  fi
}

GetMataData() {
  METADATA_BASE_URL="http://169.254.169.254/latest/dynamic/instance-identity/document"

  # get instance info
  REGION=$(curl -sS ${METADATA_BASE_URL} | grep region |awk -F'"' '{print $4}')
  INSTANCE_ID=$(curl -sS ${METADATA_BASE_URL} | grep instanceId |awk -F'"' '{print $4}')
  ASG_NAME=$(aws autoscaling describe-auto-scaling-instances --instance-ids $INSTANCE_ID --region $REGION | grep AutoScalingGroupName | awk -F'"' '{print $4}')

  if [ -z $INSTANCE_ID ] || [ -z $ASG_NAME ] || [ -z $REGION ]; then
    echo "Can not get \'instance-id\' or \'AutoScalingGroupName\' from meta-data."
    exit 1
  fi
}

PublishMetricsToCloudWatch() {
  aws cloudwatch put-metric-data --metric-name $METRIC_NAME \
                                 --namespace $NAME_SPACE \
                                 --unit $UNIT \
                                 --value $DATA \
                                 --dimensions AutoScalingGroupName=$ASG_NAME \
                                 --region $REGION
}

if [[ $# -gt 0 ]]; then
  for opt in $@
  do
    case $opt in
      --data)
        shift
        DATA=$1
        shift
        ;;
      --metric-name)
        shift
        METRIC_NAME=$1
        shift
        ;;
      --namespace)
        shift
        NAME_SPACE=$1
        shift
        ;;
      --unit)
        shift
        UNIT=$1
        shift
        ;;
    esac
  done
else
  helpmsg
fi

if [ ! -z $DATA ] && [ ! -z $METRIC_NAME ] && [ ! -z $NAME_SPACE ] && [ ! -z $UNIT ]; then

  CheckEMV
  GetMataData
  PublishMetricsToCloudWatch
else
  echo "you need have --data, --metric-name, --namespace and --unit parameters."
  exit 1
fi

