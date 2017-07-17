# aws manage tools 

## ami2sync

automated share ami to VPC list

### Features

- launch instance permission

- create volume permission

### HowTo

The first you must have an aws account list with same profile account

```
echo "your cross account id" >> "your_account".list
```

You need add profile to `~/.aws/{config,credentials}`

```
$ ./ami2sync your_account ami-57464e30
```

## CloudWatch tools

- ec2-publish-metrics-cloudwatch.sh
Auto get Instance-id/Instance-type pubish cloudwatch.

- asg-publish-metrics-cloudwatch.sh
Auto get AutoScalingGroupName pubish cloudwatch.

### Features

- Publish Custom Metrics

### HowTo

I want to monitor 3128 port connection.

class for instance.
```
$ ./ec2-publish-metrics-cloudwatch.sh --metric-name ConnectUsage-3128 --namespace Tinyproxy --unit Count --data $(ss|grep 3128|wc -l)
```

class for autoscaling group name.
```
$ ./asg-publish-metrics-cloudwatch.sh --metric-name ConnectUsage-3128 --namespace Tinyproxy --unit Count --data $(ss|grep 3128|wc -l)
```













