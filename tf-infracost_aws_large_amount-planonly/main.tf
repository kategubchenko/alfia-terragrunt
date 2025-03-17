provider "aws" {
  region     = "us-east-1"

}
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}
resource "aws_instance" "ubuntu" {
  count = 149
  provisioner "local-exec" {
    command = "env"
  }
  #ami                         = var.win_ami
  ami           = data.aws_ami.ubuntu.id
  #instance_type = var.instance_type1
  instance_type = sensitive("t2.nano")
  subnet_id     = var.subnet
  tags          = merge({ "Name" = format("k.kotov-test -> %s -> %s", substr("🤔🤷", 0, 1), data.aws_ami.ubuntu.name) }, var.tags)
  timeouts {
    create = "9m"
    delete = "15m"
  }
}



resource "aws_ebs_volume" "ebs-volume" {
  availability_zone = "us-east-1a"
  size = 1000000
  type = "gp2"
}



data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid       = "AllowFullS3Access"
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["*"]
  }
}


resource "aws_iam_role" "demo-node" {
  name = "terraform-eks-demo-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.demo-node.name
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.demo-node.name
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.demo-node.name
}

resource "aws_iam_instance_profile" "demo-node" {
  name = "terraform-eks-demo"
  role = aws_iam_role.demo-node.name
}

resource "aws_security_group" "demo-node" {
  name        = "terraform-eks-demo-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "vpc-596aa03e"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #tags = "${
  # map(
  # "Name", "terraform-eks-demo-node",
  #"kubernetes.io/cluster/${var.cluster-name}", "owned",
  # )
  #}"
}



resource "aws_security_group_rule" "demo-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.demo-node.id
  source_security_group_id = aws_security_group.demo-node.id
  to_port                  = 65535
  type                     = "ingress"
}
/*
resource "aws_security_group_rule" "demo-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "sg-708acb07"
  source_security_group_id = aws_security_group.demo-cluster.id
  to_port                  = 65535
  type                     = "ingress"
}
*/
data "aws_ami" "eks-worker" {
  # filter {
  #   name   = "name"
  #  values = ["amazon-eks-node-1.14"]
  # }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

resource "aws_launch_configuration" "test_launch_configuration" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.demo-node.name
  image_id                    = data.aws_ami.eks-worker.id
  instance_type               = "t2.nano"
  name_prefix                 = "terraform-eks-demo"
  security_groups             = [aws_security_group.demo-node.id]
  #user_data_base64            = base64encode(local.demo-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "launch_configuration_default" {
  desired_capacity     = 7500000
  launch_configuration = aws_launch_configuration.test_launch_configuration.id
  max_size             = 1500000
  min_size             = 1000000
  name                 = "terraform-eks-demo"
  #vpc_zone_identifier  = aws_subnet.demo[*].id

  tag {
    key                 = "Name"
    value               = "terraform-eks-demo"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "launch_configuration_without_capacity" {
  launch_configuration = aws_launch_configuration.test_launch_configuration.id
  max_size             = 1320000
  min_size             = 1980000
  name                 = "terraform-eks-demo"
  #vpc_zone_identifier  = aws_subnet.demo[*].id

  tag {
    key                 = "Name"
    value               = "terraform-eks-demo"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/var.cluster-name"
    value               = "owned"
    propagate_at_launch = true
  }
}

#######################################
resource "aws_launch_template" "test_launch_template" {
  name_prefix   = "foobar"
  image_id      = "ami-04527221d7d6b83e5"
  instance_type = var.instance_type
}

resource "aws_autoscaling_group" "launch_template" {
  desired_capacity     = 3500000
  launch_template {
    id = aws_launch_template.test_launch_template.id
    version = "$Latest"
  }
  max_size             = 5000000
  min_size             = 1000000
  name                 = "terraform-eks-demo"
  vpc_zone_identifier  = aws_subnet.demo[*].id

  tag {
    key                 = "Name"
    value               = "terraform-eks-demo"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}

#######################################
# Autoscaling group with mixed policy #
#######################################

resource "aws_launch_template" "mixed_instances_policy" {
  name_prefix   = "example"
  image_id      = "ami-1a2b3c"
  instance_type = "m2.medium"
}

resource "aws_autoscaling_group" "mixed_instances_policy" {
  #availability_zones = ["us-east-1a"]
  desired_capacity     = 1000000
  max_size             = 200000
  min_size             = 100000
  name                 = "terraform-eks-demo"
  vpc_zone_identifier  = aws_subnet.demo[*].id

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.mixed_instances_policy.id
      }
    }
  }
}
