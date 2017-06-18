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
