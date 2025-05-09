terraform {
  source = "git::ssh://git@github.com/gruntwork-io/terragrunt-infrastructure-modules-example.git//modules/asg-alb-service?ref=v0.8.1"
}

include {
  path           = find_in_parent_folders("root.hcl")
  merge_strategy = "deep"
}

inputs = {
  name           = "example-service-2"
  instance_type  = "t3.micro"
  min_size       = 1
  max_size       = 3
  server_port    = 8080
  alb_port       = 80
}