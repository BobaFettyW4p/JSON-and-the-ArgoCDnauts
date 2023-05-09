resource "aws_security_group" "publicSG" {
    name = "${var.project}-public-sg"
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.project}-public-sg"
    }
}

resource "aws_security_group_rule" "sg_ingress_public_443" {
    security_group_id = aws_security_group.publicSG.id
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   
}

resource "aws_security_group_rule" "sg_ingress_public_80" {
    security_group_id = aws_security_group.publicSG.id
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sg_egress_public" {
    security_group_id = aws_security_group.publicSG.id
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_security_group" "dataPlane" {
    name = "${var.project}-worker-sg"
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.project}-dataPlane-sg"
    }


resource "aws_security_group_rule" "nodes" {
    description = "Allow nodes to communicate with each other"
    security_group_id = aws_security_group.dataPlane.id
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    cidr_blocks       = flatten([cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 0), cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 1), cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 2), cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 3)])
}

resource "aws_security_group_rule" "nodes_inbound" {
    description = "Allows worker Kubelets and pods to receive communication from the cluster"
    security_group_id = aws_security_group.dataPlane.id
    type = "ingress"
    from_port = 1025
    to_port = 65535
    protocol = "tcp"
    cidr_blocks       = flatten([cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 2), cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 3)])
}

resource "aws_security_group_rule" "node_outbound" {
    security_group_id = aws_security_group.dataPlane.id
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "controlPlane" {
    name = "${var.project}-controlPlane-sg"
    vpc_id = aws_vpc.vpc.id

    tags = {
        name     = "${var.project}-controlPlane-sg"
    }
}

resource "aws_security_group_rule" "control_plane_inbound" {
    security_group_id = aws_security_group.controlPlane.id
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks       = flatten([cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 0), cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 1), cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 2), cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 3)])
}

resource "aws_security_group_rule" "control_plane_outbound" {
    security_group_id = aws_security_group.control_Plane.id
    type              = "egress"
    from_port         = 0
    to_port           = 65535
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "eks" {
    name = "${var.project}-eks-sg"
    description = "Security group for EKS cluster communication with worker nodes"
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.project}-eks-sg"
    }
}

resource "aws_security_group_rule" "cluster_inbound" {
    description = "Allow worker nodes to communicate with the cluster API Server"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_group_id = aws_security_group.eks.id
    type = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
    description = "Allow the cluster API server to communicate with the worker nodes"
    from_port = 1024
    to_port = 65535
    protocol = "tcp"
    security_group_id = aws_security_group.eks.id
    type = "egress"
}

